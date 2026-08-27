#!/usr/bin/env python3
"""Remove a product-photo background and compose it on a catalog canvas."""

from pathlib import Path
from collections import deque
import os
import sys

import numpy as np
from PIL import Image, ImageFile
from rembg import new_session, remove


CANVAS_SIZE = 1200
MAX_SOURCE_PIXELS = 25_000_000
MAX_PRODUCT_RATIO = 0.86
MIN_REMBG_BBOX_RATIO = 0.28
BACKGROUND_DISTANCE_THRESHOLD = 58
BACKGROUND_SOFT_EDGE = 18
ALLOWED_REMBG_MODELS = {"u2net_cloth_seg", "u2net", "isnet-general-use"}

# Reject decompression bombs and truncated payloads before any pixel data is
# expanded. The byte-size limit in the Rails job is not sufficient because a
# tiny compressed image can still decode to a huge raster.
Image.MAX_IMAGE_PIXELS = MAX_SOURCE_PIXELS
ImageFile.LOAD_TRUNCATED_IMAGES = False


def _border_flood_mask(source: Image.Image) -> Image.Image:
    """Keep the connected foreground when rembg focuses on a print or face."""
    rgb = np.asarray(source.convert("RGB"), dtype=np.int16)
    height, width = rgb.shape[:2]
    border = np.concatenate((rgb[0], rgb[-1], rgb[:, 0], rgb[:, -1]), axis=0)
    background_color = np.median(border, axis=0)
    distance = np.sqrt(np.sum((rgb - background_color) ** 2, axis=2))
    candidate_background = distance <= BACKGROUND_DISTANCE_THRESHOLD

    background = np.zeros((height, width), dtype=bool)
    queue = deque()
    for x in range(width):
        queue.extend(((0, x), (height - 1, x)))
    for y in range(height):
        queue.extend(((y, 0), (y, width - 1)))

    while queue:
        y, x = queue.popleft()
        if y < 0 or y >= height or x < 0 or x >= width:
            continue
        if background[y, x] or not candidate_background[y, x]:
            continue
        background[y, x] = True
        queue.extend(((y - 1, x), (y + 1, x), (y, x - 1), (y, x + 1)))

    # Keep a small antialiased transition around the detected background edge.
    alpha = np.where(background, 0, 255).astype(np.uint8)
    soft_edge = (~background) & (distance <= BACKGROUND_DISTANCE_THRESHOLD + BACKGROUND_SOFT_EDGE)
    alpha[soft_edge] = np.clip(
        (distance[soft_edge] - BACKGROUND_DISTANCE_THRESHOLD)
        / BACKGROUND_SOFT_EDGE
        * 255,
        0,
        255,
    ).astype(np.uint8)
    rgba = np.dstack((rgb.astype(np.uint8), alpha))
    return Image.fromarray(rgba)


def _isolated_product(source: Image.Image) -> Image.Image:
    # The clothing model keeps the garment and its print together. The
    # general-purpose model can mistake a large face print for the product.
    model_name = os.environ.get("VALDRA_REMBG_MODEL", "u2net_cloth_seg")
    if model_name not in ALLOWED_REMBG_MODELS:
        raise ValueError("VALDRA_REMBG_MODEL is not an allowed pinned model")
    # Do not silently fall back to another model. In production the selected
    # model must be preloaded and verified during image-worker deployment; a
    # missing/corrupt model marks the asset failed instead of downloading an
    # unreviewed runtime dependency.
    isolated = remove(source, session=new_session(model_name)).convert("RGBA")
    alpha_bbox = isolated.getchannel("A").getbbox()
    if alpha_bbox is None:
        return _border_flood_mask(source)

    source_area = source.width * source.height
    bbox_area = (alpha_bbox[2] - alpha_bbox[0]) * (alpha_bbox[3] - alpha_bbox[1])
    if bbox_area / source_area < MIN_REMBG_BBOX_RATIO:
        return _border_flood_mask(source)
    return isolated


def normalize(input_path: Path, output_path: Path) -> None:
    with Image.open(input_path) as opened:
        width, height = opened.size
        if width < 1 or height < 1 or width * height > MAX_SOURCE_PIXELS:
            raise ValueError("source image dimensions exceed the safe limit")
        source = opened.convert("RGBA")
    isolated = _isolated_product(source)
    alpha = isolated.getchannel("A")
    bbox = alpha.getbbox()
    if bbox is None:
        raise RuntimeError("background removal returned an empty subject")

    subject = isolated.crop(bbox)
    max_dimension = int(CANVAS_SIZE * MAX_PRODUCT_RATIO)
    scale = min(max_dimension / subject.width, max_dimension / subject.height)
    resized = subject.resize(
        (max(1, round(subject.width * scale)), max(1, round(subject.height * scale))),
        Image.Resampling.LANCZOS,
    )

    canvas = Image.new("RGBA", (CANVAS_SIZE, CANVAS_SIZE), (255, 255, 255, 255))
    position = (
        (CANVAS_SIZE - resized.width) // 2,
        (CANVAS_SIZE - resized.height) // 2,
    )
    canvas.alpha_composite(resized, position)
    canvas.convert("RGB").save(output_path, "WEBP", quality=92, method=6)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        raise SystemExit("usage: image_normalizer.py INPUT OUTPUT")
    normalize(Path(sys.argv[1]), Path(sys.argv[2]))
