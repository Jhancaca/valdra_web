"use client";

import Link from "next/link";
import Image from "next/image";
import type { ProductPreview } from "@/features/catalog/types/product";
import { useCart } from "@/features/cart/components/cart-provider";
import styles from "./product-grid.module.css";

type ProductGridProps = { title?: string; limit?: number; products: ProductPreview[] };

export function ProductGrid({ title = "Diseños tendencia", limit, products: allProducts }: ProductGridProps) {
  const { addItem } = useCart();
  const products = limit ? allProducts.slice(0, limit) : allProducts;

  return <section className={styles.section} aria-labelledby="drop-title">
    <div className={styles.heading}><h2 id="drop-title" className={styles.title}>{title}</h2><Link className={styles.link} href="/shop">Ver todo →</Link></div>
    <div className={styles.grid}>{products.map((product, index) => <article className={styles.card} key={product.id}>
      <Link aria-label={`Ver ${product.name}`} className={`${styles.image} ${styles[product.tone]}`} href={`/products/${product.slug}`}>
        {product.imageUrl ? <Image className={styles.photo} src={product.imageUrl} alt={product.name} fill sizes="(max-width: 639px) 50vw, 25vw" loading={index === 0 ? "eager" : "lazy"} unoptimized /> : <><span className={styles.garment} /><span className={styles.mark}>VALDRA</span></>}
      </Link>
      <div className={styles.details}><Link href={`/products/${product.slug}`}><h3>{product.name}</h3></Link><p>{product.price}</p></div>
      <button className={styles.addButton} onClick={() => addItem(product)} type="button">Añadir al carrito</button>
    </article>)}</div>
  </section>;
}
