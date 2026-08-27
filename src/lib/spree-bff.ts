import "server-only";

import { cookies } from "next/headers";

const ACCESS_COOKIE = "valdra_access_token";
const REFRESH_COOKIE = "valdra_refresh_token";
const CART_ID_COOKIE = "valdra_cart_id";
const CART_TOKEN_COOKIE = "valdra_cart_token";

export type SpreeAuthPayload = { token?: string; refresh_token?: string; user?: unknown };

export function spreeApiUrl(path: string) {
  const base = (process.env.SPREE_API_URL || "http://localhost:3001").replace(/\/$/, "");
  return `${base}${path}`;
}

export function spreeHeaders(extra: HeadersInit = {}) {
  const key = process.env.SPREE_PUBLISHABLE_KEY;
  if (!key) throw new Error("SPREE_PUBLISHABLE_KEY no está configurada en el servidor");
  return { Accept: "application/json", "Content-Type": "application/json", "X-Spree-Api-Key": key, ...extra };
}

export async function authHeaders() {
  const store = await cookies();
  const token = store.get(ACCESS_COOKIE)?.value;
  return token ? spreeHeaders({ Authorization: `Bearer ${token}` }) : spreeHeaders();
}

export async function setAuthCookies(response: Response, payload: SpreeAuthPayload) {
  const store = await cookies();
  if (payload.token) store.set(ACCESS_COOKIE, payload.token, { httpOnly: true, secure: process.env.NODE_ENV === "production", sameSite: "strict", path: "/", maxAge: 15 * 60 });
  if (payload.refresh_token) store.set(REFRESH_COOKIE, payload.refresh_token, { httpOnly: true, secure: process.env.NODE_ENV === "production", sameSite: "strict", path: "/", maxAge: 30 * 24 * 60 * 60 });
  return response;
}

export async function clearAuthCookies() {
  const store = await cookies();
  store.delete(ACCESS_COOKIE);
  store.delete(REFRESH_COOKIE);
}

export async function cartCredentials() {
  const store = await cookies();
  return { id: store.get(CART_ID_COOKIE)?.value, token: store.get(CART_TOKEN_COOKIE)?.value };
}

export async function saveCartCredentials(response: Response, payload: { data?: { id?: string; token?: string } }) {
  const cart = payload.data;
  const store = await cookies();
  if (cart?.id) store.set(CART_ID_COOKIE, cart.id, { httpOnly: true, secure: process.env.NODE_ENV === "production", sameSite: "strict", path: "/", maxAge: 30 * 24 * 60 * 60 });
  if (cart?.token) store.set(CART_TOKEN_COOKIE, cart.token, { httpOnly: true, secure: process.env.NODE_ENV === "production", sameSite: "strict", path: "/", maxAge: 30 * 24 * 60 * 60 });
  return response;
}

export async function clearCartCredentials() {
  const store = await cookies();
  store.delete(CART_ID_COOKIE);
  store.delete(CART_TOKEN_COOKIE);
}

export { ACCESS_COOKIE, REFRESH_COOKIE };
