import { NextResponse } from "next/server";
import { setAuthCookies, spreeApiUrl, spreeHeaders } from "@/lib/spree-bff";

export async function POST(request: Request) {
  const body = await request.json().catch(() => null) as { email?: unknown; password?: unknown } | null;
  const email = typeof body?.email === "string" ? body.email.trim().toLowerCase() : "";
  const password = typeof body?.password === "string" ? body.password : "";
  if (!/^\S+@\S+\.\S+$/.test(email) || password.length < 8) return NextResponse.json({ error: "Correo o contraseña inválidos." }, { status: 400 });

  const upstream = await fetch(spreeApiUrl("/api/v3/store/auth/login"), { method: "POST", headers: spreeHeaders(), body: JSON.stringify({ provider: "email", email, password }), cache: "no-store" });
  const payload = await upstream.json().catch(() => ({}));
  const response = NextResponse.json(upstream.ok ? { user: payload.user } : { error: payload.error || payload.message || "No se pudo iniciar sesión." }, { status: upstream.status });
  return upstream.ok ? setAuthCookies(response, payload) : response;
}
