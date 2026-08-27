import { NextResponse } from "next/server";
import { authHeaders, cartCredentials, saveCartCredentials, spreeApiUrl } from "@/lib/spree-bff";

export async function POST(request: Request) {
  const body = await request.json().catch(() => null) as { variantId?: unknown; quantity?: unknown } | null;
  const variantId = typeof body?.variantId === "string" ? body.variantId : "";
  const quantity = Number.isInteger(body?.quantity) ? Number(body?.quantity) : 1;
  if (!variantId || quantity < 1 || quantity > 20) return NextResponse.json({ error: "Producto o cantidad inválida." }, { status: 400 });
  let cart = await cartCredentials();
  if (!cart.id || !cart.token) {
    const created = await fetch(spreeApiUrl("/api/v3/store/carts"), { method: "POST", headers: await authHeaders(), body: JSON.stringify({}), cache: "no-store" });
    const createdPayload = await created.json().catch(() => ({}));
    if (!created.ok) return NextResponse.json({ error: "No se pudo crear el carrito." }, { status: created.status });
    cart = { id: createdPayload.data?.id, token: createdPayload.data?.token };
  }
  if (!cart.id || !cart.token) return NextResponse.json({ error: "No se pudo crear el carrito." }, { status: 502 });
  const upstream = await fetch(spreeApiUrl(`/api/v3/store/carts/${encodeURIComponent(cart.id)}/items`), { method: "POST", headers: { ...(await authHeaders()), "X-Spree-Token": cart.token }, body: JSON.stringify({ variant_id: variantId, quantity }), cache: "no-store" });
  const payload = await upstream.json().catch(() => ({}));
  const response = NextResponse.json(payload, { status: upstream.status });
  return upstream.ok ? saveCartCredentials(response, payload) : response;
}
