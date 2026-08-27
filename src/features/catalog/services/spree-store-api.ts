import "server-only";

import { productPreviews } from "../data/product-previews";
import type { CatalogQuery } from "../types/catalog-query";
import type { ProductPreview } from "../types/product";

type SpreePrice = { currency?: string; display_amount?: string; amount_in_cents?: number };
type SpreeMedia = { large_url?: string; original_url?: string; thumbnail_url?: string };
type SpreeProduct = { id?: number | string; slug?: string; name?: string; price?: SpreePrice; thumbnail_url?: string; available?: boolean; in_stock?: boolean; purchasable?: boolean; default_variant_id?: string; media?: SpreeMedia[] };
type SpreeProductsResponse = { data?: SpreeProduct[]; meta?: { count?: number; total_count?: number; total_pages?: number; current_page?: number } };
export type CatalogResult = { products: ProductPreview[]; totalCount: number; totalPages: number; page: number };

const fallbackProducts = productPreviews.map((product) => ({ ...product, source: "fallback" as const }));
function apiBaseUrl() { return (process.env.SPREE_API_URL || "http://localhost:3001").replace(/\/$/, ""); }
function normalizeImageUrl(value: string | undefined, baseUrl: string) {
  if (!value) return undefined;
  try { const imageUrl = new URL(value, baseUrl); const backendUrl = new URL(baseUrl); if (imageUrl.hostname === "localhost" && imageUrl.port === "3000") { imageUrl.protocol = backendUrl.protocol; imageUrl.host = backendUrl.host; } return imageUrl.toString(); } catch { return undefined; }
}
function formatPrice(price: SpreePrice | undefined) {
  if (price?.display_amount) return price.display_amount;
  if (typeof price?.amount_in_cents !== "number") return "Consultar precio";
  return new Intl.NumberFormat("es-CO", { style: "currency", currency: price.currency || "COP", maximumFractionDigits: 0 }).format(price.amount_in_cents / 100);
}
function toneFor(name: string) { const value = name.toLowerCase(); if (value.includes("white") || value.includes("blanc") || value.includes("concrete") || value.includes("blanco")) return "concrete" as const; if (value.includes("black") || value.includes("void") || value.includes("negro")) return "void" as const; return "graphite" as const; }
function mapProduct(product: SpreeProduct, baseUrl: string): ProductPreview | null {
  if (!product.id || !product.slug || !product.name) return null;
  const image = product.media?.[0];
  return { id: String(product.id), variantId: product.default_variant_id, slug: product.slug, name: product.name, collection: "DROP 01 / CORE", price: formatPrice(product.price), tone: toneFor(product.name), imageUrl: normalizeImageUrl(image?.original_url || image?.large_url || image?.thumbnail_url || product.thumbnail_url, baseUrl), inStock: product.in_stock ?? product.available ?? product.purchasable };
}

function spreeQuery(query: CatalogQuery) {
  const params = new URLSearchParams({ per_page: "12", page: String(query.page || 1), expand: "variants,media" });
  if (query.q) params.set("q[search]", query.q);
  if (query.category) params.set("q[in_category]", query.category);
  if (query.minPrice !== undefined) params.set("q[price_gte]", String(query.minPrice));
  if (query.maxPrice !== undefined) params.set("q[price_lte]", String(query.maxPrice));
  if (query.availability === "in_stock") params.set("q[in_stock]", "true");
  const optionValues = [...(query.size || []), ...(query.color || [])];
  if (optionValues.length) optionValues.forEach((value) => params.append("q[variants_option_values_name_in][]", value));
  const sort = query.sort === "newest" ? "-available_on" : query.sort === "price_asc" ? "price" : query.sort === "price_desc" ? "-price" : undefined;
  if (sort) params.set("sort", sort);
  return params;
}

export async function getCatalogProducts(query: CatalogQuery = {}): Promise<CatalogResult> {
  const baseUrl = apiBaseUrl();
  const publishableKey = process.env.SPREE_PUBLISHABLE_KEY;
  if (!publishableKey) return { products: query.page && query.page > 1 ? [] : fallbackProducts, totalCount: fallbackProducts.length, totalPages: 1, page: query.page || 1 };
  try {
    const response = await fetch(`${baseUrl}/api/v3/store/products?${spreeQuery(query)}`, { headers: { Accept: "application/json", "X-Spree-Api-Key": publishableKey }, next: { revalidate: 30, tags: ["catalog-products"] } });
    if (!response.ok) throw new Error(`Spree Store API respondió ${response.status}`);
    const payload = (await response.json()) as SpreeProductsResponse;
    const products = (payload.data || []).map((item) => mapProduct(item, baseUrl)).filter((item): item is ProductPreview => Boolean(item));
    const totalCount = payload.meta?.total_count ?? payload.meta?.count ?? products.length;
    return { products, totalCount, totalPages: Math.max(1, Math.ceil(totalCount / 12)), page: query.page || 1 };
  } catch (error) {
    console.error("No se pudo cargar el catálogo desde Spree:", error instanceof Error ? error.message : "error desconocido");
    return { products: query.page && query.page > 1 ? [] : fallbackProducts, totalCount: fallbackProducts.length, totalPages: 1, page: query.page || 1 };
  }
}

export async function getProductBySlug(slug: string) { return (await getCatalogProducts()).products.find((product) => product.slug === slug); }
