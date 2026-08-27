import { NextResponse } from "next/server";
import { authHeaders, cartCredentials, spreeApiUrl } from "@/lib/spree-bff";

type CheckoutInput = { email?: unknown; firstName?: unknown; lastName?: unknown; address1?: unknown; city?: unknown; postalCode?: unknown; phone?: unknown };
const text = (value: unknown) => typeof value === "string" ? value.trim() : "";

export async function POST(request: Request) {
  const body = await request.json().catch(() => null) as CheckoutInput | null;
  const email = text(body?.email).toLowerCase(); const firstName = text(body?.firstName); const lastName = text(body?.lastName); const address1 = text(body?.address1); const city = text(body?.city); const postalCode = text(body?.postalCode); const phone = text(body?.phone);
  if (!/^\S+@\S+\.\S+$/.test(email) || [firstName, lastName, address1, city, postalCode, phone].some((value) => value.length < 2)) return NextResponse.json({ error: "Completa todos los datos de entrega." }, { status: 400 });
  const cart = await cartCredentials(); if (!cart.id || !cart.token) return NextResponse.json({ error: "Tu carrito está vacío." }, { status: 400 });
  const headers = { ...(await authHeaders()), "X-Spree-Token": cart.token };
  const address = { first_name: firstName, last_name: lastName, address1, city, postal_code: postalCode, phone, country_iso: "CO" };
  const update = await fetch(spreeApiUrl(`/api/v3/store/carts/${encodeURIComponent(cart.id)}`), { method: "PATCH", headers, body: JSON.stringify({ email, shipping_address: address, billing_address: address, use_shipping: true }), cache: "no-store" });
  const updated = await update.json().catch(() => ({})); if (!update.ok) return NextResponse.json({ error: updated.error || "No se pudo validar la dirección." }, { status: update.status });
  const paymentMethods = updated.data?.payment_methods || [];
  const cod = paymentMethods.find((method: { id?: string; name?: string; type?: string }) => /cash|delivery|contra|check/i.test(`${method.name || ""} ${method.type || ""}`));
  if (!cod?.id) return NextResponse.json({ error: "Pago contra entrega no está configurado en Spree todavía." }, { status: 409 });
  const payment = await fetch(spreeApiUrl(`/api/v3/store/carts/${encodeURIComponent(cart.id)}/payments`), { method: "POST", headers, body: JSON.stringify({ payment_method_id: cod.id }), cache: "no-store" });
  if (!payment.ok) return NextResponse.json({ error: "No se pudo registrar el pago contra entrega." }, { status: payment.status });
  const complete = await fetch(spreeApiUrl(`/api/v3/store/carts/${encodeURIComponent(cart.id)}/complete`), { method: "POST", headers, body: JSON.stringify({}), cache: "no-store" });
  const result = await complete.json().catch(() => ({})); return NextResponse.json(complete.ok ? { order: result } : { error: result.error || "No se pudo confirmar el pedido." }, { status: complete.status });
}
