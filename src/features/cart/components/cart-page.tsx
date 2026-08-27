"use client";

import Link from "next/link";
import { SiteHeader } from "@/components/layout/site-header";
import { useCart } from "./cart-provider";
import styles from "./cart-page.module.css";

export function CartPage() {
  const { items, removeItem, updateQuantity, total, busy } = useCart();

  return <main className={styles.page}><div className={styles.shell}><SiteHeader /><section className={styles.content}>
    <p className={styles.eyebrow}>BOLSA / VALDRA</p><h1>Tu carrito</h1>
    {items.length === 0 ? <div className={styles.empty}><p>Aún no has añadido piezas a tu bolsa.</p><Link href="/shop">Explorar tienda →</Link></div> : <>
      <div className={styles.items}>{items.map((item) => <article className={styles.item} key={item.id}><span className={`${styles.thumb} ${styles[item.tone]}`} /><div><h2>{item.name}</h2><p>{item.price}</p><label>Cantidad <select aria-label={`Cantidad de ${item.name}`} disabled={busy} value={item.quantity} onChange={(event) => void updateQuantity(item.id, Number(event.target.value))}><option value="1">1</option><option value="2">2</option><option value="3">3</option></select></label></div><button disabled={busy} onClick={() => void removeItem(item.id)} type="button">Eliminar</button></article>)}</div>
      <aside className={styles.summary}><div><span>Total</span><strong>{total || "—"}</strong></div><p>Precio, disponibilidad, descuentos y envío son calculados por Spree en el servidor.</p><Link href="/checkout">Continuar al checkout</Link></aside>
    </>}
  </section></div></main>;
}
