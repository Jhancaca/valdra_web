export type CatalogQuery = {
  q?: string;
  category?: string;
  size?: string[];
  color?: string[];
  minPrice?: number;
  maxPrice?: number;
  availability?: "in_stock" | "all";
  sort?: "relevance" | "newest" | "price_asc" | "price_desc";
  page?: number;
};

const SORTS = new Set<CatalogQuery["sort"]>(["relevance", "newest", "price_asc", "price_desc"]);
const MAX_PAGE = 500;

function values(value: string | string[] | undefined) {
  return (Array.isArray(value) ? value : value ? [value] : [])
    .flatMap((item) => item.split(","))
    .map((item) => item.trim())
    .filter((item) => item.length > 0 && item.length <= 40)
    .slice(0, 20);
}

export function parseCatalogQuery(input: Record<string, string | string[] | undefined>): CatalogQuery {
  const rawSort = Array.isArray(input.sort) ? input.sort[0] : input.sort;
  const rawPage = Number(Array.isArray(input.page) ? input.page[0] : input.page);
  const min = Number(Array.isArray(input.minPrice) ? input.minPrice[0] : input.minPrice);
  const max = Number(Array.isArray(input.maxPrice) ? input.maxPrice[0] : input.maxPrice);
  const query: CatalogQuery = {
    q: (Array.isArray(input.q) ? input.q[0] : input.q)?.trim().slice(0, 80) || undefined,
    category: (Array.isArray(input.category) ? input.category[0] : input.category)?.trim().slice(0, 80) || undefined,
    size: values(input.size),
    color: values(input.color),
    availability: input.availability === "in_stock" ? "in_stock" : "all",
    sort: SORTS.has(rawSort as CatalogQuery["sort"]) ? rawSort as CatalogQuery["sort"] : "relevance",
    page: Number.isFinite(rawPage) ? Math.min(Math.max(Math.floor(rawPage), 1), MAX_PAGE) : 1,
  };
  if (Number.isFinite(min) && min >= 0) query.minPrice = Math.min(min, 100_000_000);
  if (Number.isFinite(max) && max >= 0) query.maxPrice = Math.min(max, 100_000_000);
  return query;
}

export function catalogQueryString(query: CatalogQuery) {
  const params = new URLSearchParams();
  if (query.q) params.set("q", query.q);
  if (query.category) params.set("category", query.category);
  query.size?.forEach((value) => params.append("size", value));
  query.color?.forEach((value) => params.append("color", value));
  if (query.minPrice !== undefined) params.set("minPrice", String(query.minPrice));
  if (query.maxPrice !== undefined) params.set("maxPrice", String(query.maxPrice));
  if (query.availability === "in_stock") params.set("availability", query.availability);
  if (query.sort && query.sort !== "relevance") params.set("sort", query.sort);
  if (query.page && query.page > 1) params.set("page", String(query.page));
  return params;
}
