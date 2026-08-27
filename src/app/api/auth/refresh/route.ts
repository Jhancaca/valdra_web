import { NextResponse } from "next/server";
import { cookies } from "next/headers";
import { clearAuthCookies, setAuthCookies, spreeApiUrl, spreeHeaders, REFRESH_COOKIE } from "@/lib/spree-bff";

/** Renueva la sesión sin exponer el refresh token al navegador. */
export async function POST() {
  const refreshToken = (await cookies()).get(REFRESH_COOKIE)?.value;
  if (!refreshToken) return NextResponse.json({ error: "Sesión expirada." }, { status: 401 });

  const upstream = await fetch(spreeApiUrl("/api/v3/store/auth/refresh"), {
    method: "POST",
    headers: spreeHeaders(),
    body: JSON.stringify({ refresh_token: refreshToken }),
    cache: "no-store",
  });
  const payload = await upstream.json().catch(() => ({}));
  if (!upstream.ok) {
    await clearAuthCookies();
    return NextResponse.json({ error: "Sesión expirada." }, { status: 401 });
  }

  return setAuthCookies(NextResponse.json({ user: payload.user }), payload);
}
