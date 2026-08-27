"use client";

import Image from "next/image";
import Link from "next/link";
import { useState } from "react";
import { SiteHeader } from "@/components/layout/site-header";
import { useCart } from "@/features/cart/components/cart-provider";
import type { ProductPreview } from "../types/product";
import styles from "./product-detail.module.css";

export function ProductDetail({ product }: { product: ProductPreview }) {
  const { addItem } = useCart();
  const [selectedSize, setSelectedSize] = useState<string | null>(null);
  const sizes = ["S", "M", "L", "XL"];

  return <main className={styles.page}><div className={styles.shell}><SiteHeader /><section className={styles.detail}><Link className={styles.back} href="/shop">← Volver a tienda</Link><div className={styles.visual}>{product.imageUrl ? <Image className={styles.photo} src={product.imageUrl} alt={product.name} fill sizes="(max-width: 719px) 100vw, 60vw" loading="eager" unoptimized /> : <span className={`${styles.garment} ${styles[product.tone]}`} />}<small>VALDRA / {product.id}</small></div><div className={styles.info}><p>{product.collection}</p><h1>{product.name}</h1><strong>{product.price}</strong><span className={styles.line} /><p className={styles.description}>Una silueta esencial creada para repetirse sin perder presencia. Producción limitada y pago contra entrega disponible en Colombia.</p><div className={styles.sizes}><span>Talla</span>{sizes.map((size) => <button aria-pressed={selectedSize === size} className={selectedSize === size ? styles.selectedSize : undefined} key={size} onClick={() => setSelectedSize(size)} type="button">{size}</button>)}</div><button className={styles.add} onClick={() => addItem(product)} type="button">Añadir al carrito</button></div></section></div></main>;
}
