"use client";

import { FormEvent, useState } from "react";
import { usePathname, useRouter, useSearchParams } from "next/navigation";
import styles from "./catalog-filters.module.css";

const SIZES = ["S", "M", "L", "XL"];
const COLORS = ["Negro", "Blanco", "Gris"];

export function CatalogFilters() {
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const [open, setOpen] = useState(false);
  const apply = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    const next = new URLSearchParams();
    new FormData(event.currentTarget).forEach((value, key) => next.append(key, String(value)));
    next.delete("page");
    router.push(`${pathname}?${next.toString()}`);
    setOpen(false);
  };
  const clear = () => router.push(pathname);
  return <div className={styles.wrapper}><button className={styles.mobileToggle} type="button" onClick={() => setOpen((value) => !value)} aria-expanded={open}>Filtrar productos</button><form className={`${styles.form} ${open ? styles.open : ""}`} onSubmit={apply}>
    <label>Buscar<input name="q" defaultValue={searchParams.get("q") || ""} placeholder="Buscar" maxLength={80} /></label>
    <label>Categoría<select name="category" defaultValue={searchParams.get("category") || ""}><option value="">Todas</option><option value="DROP 01 / CORE">Drop 01 / Core</option><option value="Essentials">Essentials</option></select></label>
    <fieldset><legend>Talla</legend>{SIZES.map((size) => <label className={styles.check} key={size}><input type="checkbox" name="size" value={size} defaultChecked={searchParams.getAll("size").includes(size)} />{size}</label>)}</fieldset>
    <fieldset><legend>Color</legend>{COLORS.map((color) => <label className={styles.check} key={color}><input type="checkbox" name="color" value={color} defaultChecked={searchParams.getAll("color").includes(color)} />{color}</label>)}</fieldset>
    <div className={styles.price}><label>Precio mínimo<input name="minPrice" type="number" min="0" step="1000" defaultValue={searchParams.get("minPrice") || ""} /></label><label>Precio máximo<input name="maxPrice" type="number" min="0" step="1000" defaultValue={searchParams.get("maxPrice") || ""} /></label></div>
    <label>Ordenar<select name="sort" defaultValue={searchParams.get("sort") || "relevance"}><option value="relevance">Relevancia</option><option value="newest">Novedades</option><option value="price_asc">Precio: menor a mayor</option><option value="price_desc">Precio: mayor a menor</option></select></label>
    <label className={styles.check}><input type="checkbox" name="availability" value="in_stock" defaultChecked={searchParams.get("availability") === "in_stock"} />Solo disponibles</label>
    <div className={styles.actions}><button type="submit">Aplicar filtros</button><button type="button" onClick={clear}>Limpiar</button></div>
  </form></div>;
}
