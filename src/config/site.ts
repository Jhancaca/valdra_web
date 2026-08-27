import type { NavigationItem } from "@/types/navigation";

export const siteConfig = {
  description: "Indumentaria urbana para quienes construyen su propia frecuencia.",
  locale: "es-CO",
  name: "VALDRA",
  navigation: [
    { label: "Novedades", href: "/#drop-title" },
    { label: "Tienda", href: "/shop" },
    { label: "Colecciones", href: "/collections" },
    { label: "Manifiesto", href: "/manifesto" },
  ] satisfies NavigationItem[],
} as const;
