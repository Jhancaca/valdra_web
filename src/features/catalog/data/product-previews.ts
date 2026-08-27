import type { ProductPreview } from "../types/product";

// Datos temporales de presentación. Spree reemplazará esta fuente, no el componente visual.
export const productPreviews: ProductPreview[] = [
  { id: "01", slug: "void-signal-tee", name: "VOID SIGNAL TEE", collection: "DROP 01 / CORE", price: "COP $180.000", tone: "void" },
  { id: "02", slug: "frequency-hoodie", name: "FREQUENCY HOODIE", collection: "DROP 01 / CORE", price: "COP $320.000", tone: "graphite" },
  { id: "03", slug: "system-cargo", name: "SYSTEM CARGO", collection: "DROP 01 / CORE", price: "COP $290.000", tone: "concrete" },
  { id: "04", slug: "transmission-overshirt", name: "TRANSMISSION OVERSHIRT", collection: "DROP 01 / LIMITED", price: "COP $360.000", tone: "graphite" },
];
