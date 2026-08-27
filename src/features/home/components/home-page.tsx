import Link from "next/link";
import Image from "next/image";
import { SiteHeader } from "@/components/layout/site-header";
import { ProductGrid } from "./product-grid";
import { getCatalogProducts } from "@/features/catalog/services/spree-store-api";
import styles from "./home-page.module.css";

export async function HomePage() {
  const { products } = await getCatalogProducts();
  return <main className={styles.page}>
    <div className={styles.shell}>
      <SiteHeader />
      <section className={styles.hero} aria-label="Nueva colección VALDRA">
        <Image className={styles.heroImage} src="/images/hero/valdra-hoodie-stack.png" alt="Hoodies VALDRA apilados sobre una base de concreto" fill priority sizes="(max-width: 1184px) 100vw, 1184px" />
        <button className={styles.arrow} type="button" aria-label="Anterior">‹</button>
        <div className={styles.heroCopy}><h1>VALDRA STORE</h1><p>Premium streetwear para la ciudad que no se detiene.<br />Diseña tu propia visión.</p><Link href="/shop">Comprar ahora</Link></div>
        <button className={styles.arrow} type="button" aria-label="Siguiente">›</button>
      </section>
      <ProductGrid products={products} limit={4} />
      <section className={styles.promos}>
        <Link className={styles.personalize} href="/collections"><strong>Vístete<br />diferente.</strong><span>Drop 01 / Valdra →</span></Link>
        <Link className={styles.collection} href="/shop"><strong>Essentials<br />para todos los días</strong><span>Ver colección →</span></Link>
      </section>
      <ProductGrid products={products} title="Novedades" limit={4} />
      <section className={styles.value}><h2>Viste diferente,<br />viste Valdra</h2><ul><li>Producciones limitadas.</li><li>Diseños exclusivos.</li><li>Pago contra entrega disponible.</li></ul><span aria-hidden="true" /></section>
      <footer className={styles.footer}><strong>VALDRA</strong><p>Streetwear urbano creado en Bogotá.</p><nav><Link href="/shop">Tienda</Link><Link href="/login">Iniciar sesión</Link><Link href="/register">Crear cuenta</Link></nav><small>© 2026 VALDRA</small></footer>
    </div>
  </main>;
}
