import { NextResponse } from "next/server";
import { authHeaders, cartCredentials, saveCartCredentials, spreeApiUrl } from "@/lib/spree-bff";

async function proxy(request: Request, id: string, method: "PATCH" | "DELETE") {
  const cart = await cartCredentials();
  if (!cart.id || !cart.token) return NextResponse.json({ error: "Carrito no encontrado." }, { status: 404 });
  const body = method === "PATCH" ? await request.json().catch(() => null) : undefined;
  const quantity = body && Number.isInteger(body.quantity) ? Number(body.quantity) : 0;
  if (method === "PATCH" && (quantity < 1 || quantity > 20)) return NextResponse.json({ error: "Cantidad inválida." }, { status: 400 });
  const upstream = await fetch(spreeApiUrl(`/api/v3/store/carts/${encodeURIComponent(cart.id)}/items/${encodeURIComponent(id)}`), { method, headers: { ...(await authHeaders()), "X-Spree-Token": cart.token }, body: body ? JSON.stringify({ quantity }) : undefined, cache: "no-store" });
  const payload = upstream.status === 204 ? { data: null } : await upstream.json().catch(() => ({}));
  const response = NextResponse.json(payload, { status: upstream.status });
  return upstream.ok ? saveCartCredentials(response, payload) : response;
}

export async function PATCH(request: Request, context: { params: Promise<{ id: string }> }) { return proxy(request, (await context.params).id, "PATCH"); }
export async function DELETE(request: Request, context: { params: Promise<{ id: string }> }) { return proxy(request, (await context.params).id, "DELETE"); }
