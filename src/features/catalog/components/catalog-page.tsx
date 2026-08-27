import Link from "next/link";
import { Suspense } from "react";
import { SiteHeader } from "@/components/layout/site-header";
import { ProductGrid } from "@/features/home/components/product-grid";
import { getCatalogProducts } from "../services/spree-store-api";
import { catalogQueryString, parseCatalogQuery } from "../types/catalog-query";
import { CatalogFilters } from "./catalog-filters";
import styles from "./catalog-page.module.css";

type SearchParams = Record<string, string | string[] | undefined>;

export async function CatalogPage({ title = "Tienda", intro = "Piezas limitadas para el ritmo de la ciudad.", searchParams = {} }: { title?: string; intro?: string; searchParams?: SearchParams }) {
  const query = parseCatalogQuery(searchParams);
  const result = await getCatalogProducts(query);
  const previous = query.page && query.page > 1 ? query.page - 1 : 1;
  const next = Math.min(result.totalPages, (query.page || 1) + 1);
  return <main className={styles.page}><div className={styles.shell}><SiteHeader /><section className={styles.hero}><p>VALDRA / DROP 01</p><h1>{title}</h1><span>{intro}</span></section><Suspense fallback={null}><CatalogFilters /></Suspense><div className={styles.summary}><span>{result.totalCount} productos</span>{query.q && <strong>Resultados para “{query.q}”</strong>}</div><ProductGrid products={result.products} title="Todos los productos" />{result.products.length === 0 && <p className={styles.empty}>No encontramos productos con estos filtros.</p>}<nav className={styles.pagination} aria-label="Paginación">{query.page && query.page > 1 ? <Link href={`?${catalogQueryString({ ...query, page: previous })}`}>← Anterior</Link> : <span />}<span>Página {query.page || 1} de {result.totalPages}</span>{(query.page || 1) < result.totalPages ? <Link href={`?${catalogQueryString({ ...query, page: next })}`}>Siguiente →</Link> : <span />}</nav></div></main>;
}
