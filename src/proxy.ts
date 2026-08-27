import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

/** Per-request CSP nonce. Production scripts cannot execute from inline HTML. */
export function proxy(request: NextRequest) {
  const nonce = Buffer.from(crypto.randomUUID()).toString("base64");
  const isDevelopment = process.env.NODE_ENV !== "production";
  const imageSource = isDevelopment ? "http://localhost:3001" : "https://api.valdra.example";
  const requestHeaders = new Headers(request.headers);
  requestHeaders.set("x-nonce", nonce);

  const directives = [
    "default-src 'self'",
    "base-uri 'self'",
    "form-action 'self'",
    "frame-ancestors 'none'",
    `img-src 'self' data: blob: ${imageSource}`,
    "font-src 'self' data:",
    "style-src 'self' 'unsafe-inline'",
    `script-src 'self' 'nonce-${nonce}'${isDevelopment ? " 'unsafe-eval' 'unsafe-inline'" : ""}`,
    "connect-src 'self'",
    "object-src 'none'",
  ];
  if (!isDevelopment) directives.push("upgrade-insecure-requests");

  const response = NextResponse.next({ request: { headers: requestHeaders } });
  response.headers.set("Content-Security-Policy", directives.join("; "));
  return response;
}

export const config = {
  matcher: ["/((?!_next/static|_next/image|favicon.ico).*)"],
};
