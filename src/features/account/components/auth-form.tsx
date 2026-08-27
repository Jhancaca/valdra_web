"use client";

import Link from "next/link";
import { FormEvent, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import { SiteHeader } from "@/components/layout/site-header";
import { COLOMBIA_LOCATIONS, departmentByCode } from "../data/colombia-locations";
import styles from "./auth-form.module.css";

export function AuthForm({ mode }: { mode: "login" | "register" }) {
  const router = useRouter();
  const [message, setMessage] = useState("");
  const [busy, setBusy] = useState(false);
  const [department, setDepartment] = useState("");
  const isRegister = mode === "register";
  const municipalities = useMemo(() => departmentByCode(department)?.municipalities ?? [], [department]);

  const submit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault(); setBusy(true); setMessage("");
    try {
      const response = await fetch(`/api/auth/${isRegister ? "register" : "login"}`, { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(Object.fromEntries(new FormData(event.currentTarget).entries())) });
      const payload = await response.json().catch(() => ({}));
      if (!response.ok) { setMessage(payload.error || "No se pudo completar la operación."); return; }
      router.push("/"); router.refresh();
    } catch { setMessage("No se pudo conectar con el servidor. Inténtalo de nuevo."); }
    finally { setBusy(false); }
  };

  return <main className={styles.page}><div className={styles.shell}><SiteHeader /><section className={styles.content}><p className={styles.eyebrow}>CUENTA VALDRA</p><h1>{isRegister ? "Crear cuenta" : "Iniciar sesión"}</h1><p className={styles.intro}>{isRegister ? "Únete a la comunidad VALDRA." : "Accede a tus pedidos y favoritos."}</p><form className={styles.form} onSubmit={submit}>
    {isRegister && <>
      <div className={styles.row}><label className={styles.field}>Nombres*<input name="first_name" autoComplete="given-name" placeholder="Escribe tus nombres" required minLength={2} /></label><label className={styles.field}>Apellidos*<input name="last_name" autoComplete="family-name" placeholder="Escribe tus apellidos" required minLength={2} /></label></div>
      <label className={styles.field}>Teléfono*<input name="phone" type="tel" inputMode="tel" autoComplete="tel" placeholder="+57 300 000 0000" required /></label>
      <div className={styles.row}><label className={styles.field}>Departamento*<select name="department_code" value={department} onChange={(event) => setDepartment(event.target.value)} required><option value="">Selecciona una opción</option>{COLOMBIA_LOCATIONS.map((item) => <option value={item.code} key={item.code}>{item.name}</option>)}</select></label><label className={styles.field}>Municipio*<select name="municipality_code" disabled={!department} required><option value="">Selecciona una opción</option>{municipalities.map((item) => <option value={item.code} key={item.code}>{item.name}</option>)}</select></label></div>
      <div className={styles.row}><label className={styles.field}>Género (opcional)<select name="gender" defaultValue="prefer_not_to_say"><option value="prefer_not_to_say">Prefiero no decirlo</option><option value="female">Mujer</option><option value="male">Hombre</option><option value="non_binary">No binario</option><option value="">Omitir</option></select></label><label className={styles.field}>Fecha de nacimiento*<input name="date_of_birth" type="date" autoComplete="bday" required /></label></div>
    </>}
    <label className={styles.field}>Correo electrónico*<input name="email" type="email" autoComplete="email" placeholder="tu@correo.com" required /></label><label className={styles.field}>Contraseña*<input name="password" type="password" autoComplete={isRegister ? "new-password" : "current-password"} minLength={isRegister ? 12 : 8} required /></label>
    {isRegister && <label className={styles.consent}><input name="privacy_consent" type="checkbox" value="true" required /> <span>Acepto el tratamiento de mis datos personales según la <Link href="/privacy">Política de Privacidad</Link>.</span></label>}
    <button className={styles.submit} disabled={busy} type="submit">{busy ? "Procesando…" : isRegister ? "Crear cuenta" : "Iniciar sesión"}</button>{message && <output className={styles.message} role="alert">{message}</output>}
  </form><p className={styles.switch}>{isRegister ? "¿Ya tienes cuenta?" : "¿Aún no tienes cuenta?"} <Link href={isRegister ? "/login" : "/register"}>{isRegister ? "Inicia sesión" : "Regístrate"}</Link></p></section></div></main>;
}
