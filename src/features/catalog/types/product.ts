export type ProductPreview = {
  collection: string;
  id: string;
  variantId?: string;
  imageUrl?: string;
  inStock?: boolean;
  name: string;
  price: string;
  slug: string;
  tone: "graphite" | "concrete" | "void";
};
