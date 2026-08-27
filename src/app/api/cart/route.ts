import { NextResponse } from "next/server";
import { authHeaders, cartCredentials, clearCartCredentials, saveCartCredentials, spreeApiUrl, spreeHeaders } from "@/lib/spree-bff";

export async function GET() {
  const cart = await cartCredentials();
  if (!cart.id || !cart.token) return NextResponse.json({ data: null });
  const upstream = await fetch(spreeApiUrl(`/api/v3/store/carts/${encodeURIComponent(cart.id)}`), { headers: { ...(await authHeaders()), "X-Spree-Token": cart.token }, cache: "no-store" });
  if (upstream.status === 404) return NextResponse.json({ data: null });
  const payload = await upstream.json().catch(() => ({}));
  return NextResponse.json(payload, { status: upstream.status });
}

export async function POST() {
  const upstream = await fetch(spreeApiUrl("/api/v3/store/carts"), { method: "POST", headers: await authHeaders(), body: JSON.stringify({}), cache: "no-store" });
  const payload = await upstream.json().catch(() => ({}));
  const response = NextResponse.json(payload, { status: upstream.status });
  return upstream.ok ? saveCartCredentials(response, payload) : response;
}

export async function DELETE() {
  const cart = await cartCredentials();
  if (cart.id && cart.token) await fetch(spreeApiUrl(`/api/v3/store/carts/${encodeURIComponent(cart.id)}`), { method: "DELETE", headers: { ...spreeHeaders(), "X-Spree-Token": cart.token }, cache: "no-store" }).catch(() => undefined);
  await clearCartCredentials();
  return NextResponse.json({ data: null });
}
