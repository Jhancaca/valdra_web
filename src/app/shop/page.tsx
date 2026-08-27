import { CatalogPage } from "@/features/catalog/components/catalog-page";
export default async function Page({ searchParams }: { searchParams: Promise<Record<string, string | string[] | undefined>> }) {
  return <CatalogPage searchParams={await searchParams} />;
}
