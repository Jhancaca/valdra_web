import { notFound } from "next/navigation";
import { ProductDetail } from "@/features/catalog/components/product-detail";
import { getProductBySlug } from "@/features/catalog/services/spree-store-api";

export default async function Page({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params;
  const product = await getProductBySlug(slug);
  if (!product) notFound();
  return <ProductDetail product={product} />;
}
