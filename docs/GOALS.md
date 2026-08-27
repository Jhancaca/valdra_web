# VALDRA — metas de implementación

Este documento registra objetivos verificables. Un hito no se considera terminado
por tener código: debe cumplir su criterio de aceptación.

## M0 — Fundaciones

- [x] Storefront Next.js 16, TypeScript y pnpm.
- [x] Sistema visual centralizado en `src/styles/tokens.css`.
- [x] Cabeceras de seguridad base y CSP de producción.
- [x] Backend Rails creado en `commerce/` y dependencias Spree resueltas.

**Aceptación:** `pnpm typecheck`, `pnpm lint` y `pnpm build` pasan; Bundler
resuelve versiones en `commerce/Gemfile.lock`.

## M1 — Commerce y Supabase

- [ ] Ejecutar el template oficial de Spree hasta instalar Admin Dashboard y Store API.
- [ ] Conectar Rails a PostgreSQL de Supabase mediante `DATABASE_URL` con TLS.
- [ ] Ejecutar y verificar todas las migraciones de Spree.
- [ ] Configurar Active Storage contra el bucket `catalog-public` de Supabase Storage.
- [ ] Volver a ejecutar los asesores de seguridad y rendimiento de Supabase.

**Aceptación:** `/up` responde sano, `/admin` está disponible, las tablas de
Spree existen en Supabase y ningún secreto aparece en el repositorio.

## M2 — Comercio mínimo viable

- [ ] Catálogo y Product Detail alimentados por Store API v3.
- [ ] Carrito creado y recalculado exclusivamente por Spree.
- [ ] Pago contra entrega como único método inicial.
- [ ] Inventario, descuentos, total y estados de pedido validados en servidor.
- [ ] Administración de productos, stock, precios y pedidos con Spree Admin.

**Aceptación:** un pedido COD completo nunca acepta precio, stock, permisos ni
estado enviados por el navegador.

## M3 — Calidad y lanzamiento controlado

- [ ] Tests de integración para catálogo, carrito, COD y autorización de pedidos.
- [ ] Sentry y logs estructurados en storefront y backend.
- [ ] SEO técnico: metadata, sitemap, robots, canonical y JSON-LD de producto.
- [ ] Staging separado, backups/capacidad de Supabase revisados y checklist de seguridad aprobado.

**Aceptación:** pruebas críticas verdes, errores observables y revisión visual
contra Stitch aprobada antes de publicar.

## Fuera de alcance actual

- Custom Lab, subida de diseños y pedidos personalizados.
- Stripe y otros pagos en línea.
- Meilisearch, Cloudflare R2 y Redis dedicado.

Estos elementos permanecen previstos por la arquitectura, pero no se implementan
hasta que M2 esté estable y haya una decisión explícita para iniciar cada uno.
