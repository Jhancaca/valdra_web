"use client";

import { createContext, useCallback, useContext, useEffect, useMemo, useState } from "react";
import type { ReactNode } from "react";
import type { ProductPreview } from "@/features/catalog/types/product";
import type { CartItem } from "../types/cart";

type ServerCart = { data?: { total_quantity?: number; display_total?: string; items?: Array<{ id: string; name: string; slug?: string; quantity: number; variant_id?: string; display_price?: string }> } };
type CartContextValue = { addItem: (product: ProductPreview) => Promise<void>; count: number; items: CartItem[]; total?: string; removeItem: (id: string) => Promise<void>; updateQuantity: (id: string, quantity: number) => Promise<void>; busy: boolean };
const CartContext = createContext<CartContextValue | null>(null);

function mapItems(cart: ServerCart | null): CartItem[] {
  return (cart?.data?.items || []).map((item) => ({ id: item.id, name: item.name, slug: item.slug || "", price: item.display_price || "", tone: "graphite", variantId: item.variant_id, quantity: item.quantity }));
}

export function CartProvider({ children }: { children: ReactNode }) {
  const [items, setItems] = useState<CartItem[]>([]); const [total, setTotal] = useState<string>(); const [count, setCount] = useState(0); const [busy, setBusy] = useState(false);
  const applyPayload = useCallback((payload: ServerCart) => { setItems(mapItems(payload)); setTotal(payload.data?.display_total); setCount(payload.data?.total_quantity || 0); }, []);
  const refresh = useCallback(async () => { const response = await fetch("/api/cart", { cache: "no-store" }); if (response.ok) applyPayload(await response.json() as ServerCart); }, [applyPayload]);
  useEffect(() => { let mounted = true; fetch("/api/cart", { cache: "no-store" }).then(async (response) => { if (mounted && response.ok) applyPayload(await response.json() as ServerCart); }).catch(() => undefined); return () => { mounted = false; }; }, [applyPayload]);
  const addItem = useCallback(async (product: ProductPreview) => { if (!product.variantId) return; setBusy(true); try { const response = await fetch("/api/cart/items", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ variantId: product.variantId }) }); if (response.ok) applyPayload(await response.json() as ServerCart); } finally { setBusy(false); } }, [applyPayload]);
  const updateQuantity = useCallback(async (id: string, quantity: number) => { setBusy(true); try { const response = await fetch(`/api/cart/items/${encodeURIComponent(id)}`, { method: "PATCH", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ quantity }) }); if (response.ok) applyPayload(await response.json() as ServerCart); } finally { setBusy(false); } }, [applyPayload]);
  const removeItem = useCallback(async (id: string) => { setBusy(true); try { const response = await fetch(`/api/cart/items/${encodeURIComponent(id)}`, { method: "DELETE" }); if (response.ok) await refresh(); } finally { setBusy(false); } }, [refresh]);
  const value = useMemo(() => ({ items, total, count, busy, addItem, removeItem, updateQuantity }), [items, total, count, busy, addItem, removeItem, updateQuantity]);
  return <CartContext.Provider value={value}>{children}</CartContext.Provider>;
}
export function useCart() { const context = useContext(CartContext); if (!context) throw new Error("useCart debe usarse dentro de CartProvider"); return context; }
