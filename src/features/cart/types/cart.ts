import type { ProductPreview } from "@/features/catalog/types/product";

export type CartItem = Pick<ProductPreview, "id" | "name" | "price" | "slug" | "tone" | "variantId"> & {
  quantity: number;
};
