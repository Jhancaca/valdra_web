"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { siteConfig } from "@/config/site";
import { useCart } from "@/features/cart/components/cart-provider";
import styles from "./site-header.module.css";

export function SiteHeader() {
  const pathname = usePathname();
  const { count } = useCart();

  return <header className={styles.header}>
    <div className={styles.inner}>
      <Link className={styles.brand} href="/" aria-label="VALDRA, inicio">VALDRA STORE</Link>
      <nav className={styles.navigation} aria-label="Navegación principal">
        {siteConfig.navigation.map((item) => <Link className={pathname === item.href ? styles.active : undefined} href={item.href} key={item.href}>{item.label}</Link>)}
      </nav>
      <div className={styles.actions}>
        <Link aria-label="Buscar productos" href="/shop">⌕</Link>
        <Link aria-label="Iniciar sesión" href="/login">♙</Link>
        <Link className={styles.bag} aria-label={`Mochila${count ? `, ${count} productos` : ""}`} href="/cart">
          <svg aria-hidden="true" className={styles.bagIcon} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.7"><path d="M6.5 8.5h11l1 11h-13l1-11Z" /><path d="M9 8.5V6a3 3 0 0 1 6 0v2.5" /><path d="M8 12h8" /></svg>
          {count > 0 && <span className={styles.count}>{count}</span>}
        </Link>
      </div>
    </div>
  </header>;
}
