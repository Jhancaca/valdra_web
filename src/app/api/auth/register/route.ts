import { NextResponse } from "next/server";
import { setAuthCookies, spreeApiUrl, spreeHeaders } from "@/lib/spree-bff";
import { COLOMBIA_LOCATIONS, municipalityIsValid } from "@/features/account/data/colombia-locations";

const EMAIL = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const ISO_DATE = /^\d{4}-\d{2}-\d{2}$/;
const GENDERS = new Set(["", "female", "male", "non_binary", "prefer_not_to_say"]);
const DEPARTMENTS = new Set(COLOMBIA_LOCATIONS.map((item) => item.code));

function normalizePhone(value: string) {
  const compact = value.replace(/[\s().-]/g, "");
  if (/^\d{10}$/.test(compact)) return `+57${compact}`;
  if (/^57\d{10}$/.test(compact)) return `+${compact}`;
  if (/^\+[1-9]\d{7,14}$/.test(compact)) return compact;
  return null;
}

export async function POST(request: Request) {
  const body = await request.json().catch(() => null) as Record<string, unknown> | null;
  const firstName = typeof body?.first_name === "string" ? body.first_name.trim() : "";
  const lastName = typeof body?.last_name === "string" ? body.last_name.trim() : "";
  const email = typeof body?.email === "string" ? body.email.trim().toLowerCase() : "";
  const password = typeof body?.password === "string" ? body.password : "";
  const phone = typeof body?.phone === "string" ? normalizePhone(body.phone) : null;
  const departmentCode = typeof body?.department_code === "string" ? body.department_code : "";
  const municipalityCode = typeof body?.municipality_code === "string" ? body.municipality_code : "";
  const gender = typeof body?.gender === "string" ? body.gender : "";
  const dateOfBirth = typeof body?.date_of_birth === "string" ? body.date_of_birth : "";
  const consent = body?.privacy_consent === true || body?.privacy_consent === "true";
  const date = ISO_DATE.test(dateOfBirth) ? new Date(`${dateOfBirth}T00:00:00.000Z`) : null;
  const unknown = Object.keys(body ?? {}).filter((key) => !new Set(["first_name", "last_name", "email", "password", "phone", "department_code", "municipality_code", "gender", "date_of_birth", "privacy_consent"]).has(key));

  const today = new Date();
  today.setUTCHours(0, 0, 0, 0);
  if (unknown.length || firstName.length < 2 || lastName.length < 2 || !EMAIL.test(email) || password.length < 12 || !phone || !DEPARTMENTS.has(departmentCode) || !municipalityIsValid(departmentCode, municipalityCode) || !GENDERS.has(gender) || !date || Number.isNaN(date.valueOf()) || date >= today || !consent) {
    return NextResponse.json({ error: "Revisa los campos obligatorios, el teléfono, la ubicación y el consentimiento." }, { status: 400 });
  }

  const upstream = await fetch(spreeApiUrl("/api/v3/store/customer_registrations"), {
    method: "POST",
    headers: spreeHeaders(),
    body: JSON.stringify({ first_name: firstName, last_name: lastName, email, password, password_confirmation: password, profile: { phone, department_code: departmentCode, municipality_code: municipalityCode, gender: gender || null, date_of_birth: dateOfBirth, privacy_consent: true } }),
    cache: "no-store",
  });
  const payload = await upstream.json().catch(() => ({}));
  const response = NextResponse.json(upstream.ok ? { user: payload.user } : { error: payload.error || payload.message || "No se pudo crear la cuenta." }, { status: upstream.status });
  return upstream.ok ? setAuthCookies(response, payload) : response;
}
