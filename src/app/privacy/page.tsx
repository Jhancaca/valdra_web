import Link from "next/link";
import { SiteHeader } from "@/components/layout/site-header";

export default function PrivacyPage() {
  return <main className="min-h-screen bg-[var(--color-background-secondary)]"><SiteHeader /><article className="mx-auto max-w-2xl px-4 py-16"><p className="text-xs font-bold tracking-[.13em]">VALDRA / PRIVACIDAD</p><h1 className="mt-3 font-[var(--font-display)] text-5xl font-extrabold tracking-[-.08em]">Política de Privacidad</h1><p className="mt-6 leading-7 text-[var(--color-foreground-muted)]">Usamos los datos de tu cuenta únicamente para gestionar pedidos, entregas y comunicaciones que autorices. Puedes solicitar acceso, corrección o eliminación de tus datos escribiendo a soporte@valdra.store.</p><Link className="mt-8 inline-block underline underline-offset-4" href="/register">Volver al registro</Link></article></main>;
}
