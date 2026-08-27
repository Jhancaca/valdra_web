import { NextResponse } from "next/server";
import { clearAuthCookies, REFRESH_COOKIE, spreeApiUrl, spreeHeaders } from "@/lib/spree-bff";
import { cookies } from "next/headers";

export async function POST() {
  const store = await cookies();
  const refreshToken = store.get(REFRESH_COOKIE)?.value;
  if (refreshToken) await fetch(spreeApiUrl("/api/v3/store/auth/logout"), { method: "POST", headers: spreeHeaders(), body: JSON.stringify({ refresh_token: refreshToken }), cache: "no-store" }).catch(() => undefined);
  await clearAuthCookies();
  return NextResponse.json({ ok: true });
}
