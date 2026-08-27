# Normalización de imágenes de productos

Las imágenes de producto se normalizan en el backend antes de exponerse al storefront.

## Desarrollo local

Instala Python 3.11+ y las dependencias del worker:

```powershell
python -m pip install -r commerce/requirements-image.txt
```

Si el ejecutable no se llama `python3`, define en `commerce/.env`:

```dotenv
VALDRA_IMAGE_NORMALIZER_COMMAND=python
```

El modelo de `rembg` se descarga la primera vez que se procesa una imagen.
El normalizador usa `u2net_cloth_seg` para conservar la prenda y su estampado;
si ese modelo no está disponible, utiliza el modelo general como respaldo.

## Imágenes existentes

Desde `commerce` ejecuta:

```powershell
bundle exec rake valdra:images:normalize
```

La tarea es idempotente: conserva las imágenes ya normalizadas y solo encola las que aún no tienen una versión procesada.

## Resultado

- Original: se conserva en `source_attachment`.
- Público: `1200x1200`, fondo blanco y WebP optimizado.
- Estado: `pending`, `ready` o `failed` en los metadatos del blob original.
- Mientras se procesa o falla, Spree no expone una imagen pública para el storefront.
