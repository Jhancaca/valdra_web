"use client";

import Link from "next/link";
import { FormEvent, useState } from "react";
import { SiteHeader } from "@/components/layout/site-header";
import styles from "./checkout-form.module.css";

export function CheckoutForm() {
  const [message, setMessage] = useState(""); const [busy, setBusy] = useState(false); const [success, setSuccess] = useState(false);
  async function submit(event: FormEvent<HTMLFormElement>) { event.preventDefault(); setBusy(true); setMessage(""); try { const response = await fetch("/api/checkout", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(Object.fromEntries(new FormData(event.currentTarget).entries())) }); const payload = await response.json().catch(() => ({})); if (!response.ok) { setMessage(payload.error || "No se pudo confirmar el pedido."); return; } setSuccess(true); } catch { setMessage("No se pudo conectar con el servidor. Inténtalo de nuevo."); } finally { setBusy(false); } }
  return <main className={styles.page}><div className={styles.shell}><SiteHeader /><section className={styles.content}><Link className={styles.back} href="/cart">← Volver al carrito</Link><p className={styles.eyebrow}>CHECKOUT / CONTRA ENTREGA</p><h1>Recibe tu pedido</h1>{success ? <div className={styles.success}><h2>Pedido recibido</h2><p>Te contactaremos para confirmar la entrega y el pago en Colombia.</p><Link href="/">Volver al inicio</Link></div> : <form className={styles.form} onSubmit={submit}><label>Correo<input name="email" type="email" required autoComplete="email" /></label><label>Nombre<input name="firstName" required autoComplete="given-name" /></label><label>Apellidos<input name="lastName" required autoComplete="family-name" /></label><label>Dirección<input name="address1" required autoComplete="street-address" /></label><label>Ciudad<input name="city" required autoComplete="address-level2" /></label><label>Código postal<input name="postalCode" required autoComplete="postal-code" /></label><label>Teléfono<input name="phone" required autoComplete="tel" /></label><button disabled={busy} type="submit">{busy ? "Confirmando…" : "Confirmar pedido contra entrega"}</button>{message && <output role="alert">{message}</output>}</form>}</section></div></main>;
}
