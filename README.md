# VALDRA

Ecommerce premium de ropa urbana con una identidad visual minimalista,
tecnológica y urbana. El proyecto está dividido en un storefront Next.js y un
backend Rails con Spree Commerce.

## Estado del proyecto

Esta es la base funcional del MVP. Ya están preparados:

- Storefront Next.js con App Router, React, TypeScript y Server Components.
- Backend Rails 8.1 con Spree Commerce 5.6.
- Catálogo consumido desde Spree Store API.
- Imágenes de productos normalizadas a WebP y servidas mediante Active Storage.
- Registro y login con identidad gestionada por Spree.
- Perfil privado de cliente en Supabase.
- Carrito server-side.
- Checkout con pago contra entrega.
- Administración de productos mediante Spree Admin.
- Filtros de catálogo, búsqueda, orden y paginación.
- RLS y esquema privado `valdra_private` en Supabase.

Todavía quedan como fases posteriores: Stripe, wishlist, historial de pedidos
para clientes, Meilisearch, Custom Lab y operaciones administrativas avanzadas.

## Arquitectura

```text
Navegador
   │
   ▼
Next.js storefront (puerto 3000)
   │  Route Handlers / BFF
   │  cookies httpOnly
   ▼
Rails + Spree Commerce (puerto 3001)
   │
   ├── Supabase PostgreSQL
   ├── Supabase Storage privado
   └── Active Storage / workers de imágenes
```

El navegador nunca decide el precio final, el stock, los descuentos, los
permisos administrativos ni el resultado de un pago. Next.js actúa como BFF y
mantiene los tokens de Spree en cookies `httpOnly`.

## Estructura principal

```text
src/                       Storefront Next.js
  app/                     Rutas, páginas y Route Handlers
  components/              Componentes compartidos
  features/                Catálogo, cuenta, carrito y checkout
  lib/                     Integraciones server-only
  styles/                  Tokens y estilos globales

commerce/                  Backend Rails + Spree
  app/controllers/         Endpoints y controladores
  app/models/              Modelos y decoradores de Spree
  app/jobs/                Procesamiento asíncrono de imágenes
  config/                  Rutas, DB, Storage y seguridad
  db/migrate/              Migraciones Rails

supabase/migrations/       Migraciones de seguridad y RLS
docs/                      Documentación técnica
```

## Requisitos

- Node.js 22 o superior.
- pnpm 11 o superior.
- Ruby 3.3 o superior.
- PostgreSQL mediante Supabase.
- Python, Pillow y el procesador de imágenes configurado para normalización.

## Configuración local

### Storefront

```powershell
Copy-Item .env.example .env.local
```

Configura en `.env.local` únicamente las variables necesarias para Next.js:

```env
SPREE_API_URL=http://localhost:3001
SPREE_PUBLISHABLE_KEY=tu_clave_publicable_de_spree
```

### Backend

```powershell
cd commerce
Copy-Item .env.example .env
bundle install
```

Completa `commerce/.env` con `DATABASE_URL`, `RAILS_MASTER_KEY` y las
credenciales server-only de Supabase Storage. Nunca subas estos archivos a Git.

El rol `valdra_app` está creado en Supabase con `LOGIN`, `NOSUPERUSER` y
`NOBYPASSRLS`. Su contraseña debe configurarse fuera del repositorio y después
usarse en `DATABASE_URL` en staging o producción. Durante el desarrollo puede
seguirse usando la conexión actual de Rails hasta completar ese cambio.

## Ejecutar el proyecto

Terminal 1, backend:

```powershell
cd commerce
C:\Ruby33-x64\bin\ruby.exe bin\rails server -p 3001
```

Terminal 2, storefront:

```powershell
pnpm install
pnpm dev
```

Abre `http://localhost:3000`.

Rutas útiles:

- `/` — inicio.
- `/shop` — catálogo con filtros.
- `/products/:slug` — detalle de producto.
- `/register` — registro completo.
- `/login` — inicio de sesión.
- `/cart` — carrito.
- `/checkout` — checkout contra entrega.
- `/admin/login` — administración Spree.

## Imágenes de productos

Cuando se sube una imagen desde Spree Admin:

1. Se conserva el original en un bucket privado.
2. Un job ejecuta la normalización server-side.
3. Se genera un lienzo cuadrado con fondo blanco.
4. La prenda se centra y se exporta como WebP.
5. El storefront utiliza únicamente la versión normalizada.

Los estados son `pending`, `ready` y `failed`. Si el procesamiento falla, se
muestra un placeholder y no se expone una imagen sin normalizar.

## Supabase y seguridad

La migración [20260826090000_valdra_security.sql](supabase/migrations/20260826090000_valdra_security.sql):

- Crea `valdra_private.valdra_customer_profiles`.
- Activa RLS en el perfil.
- Deniega acceso a `anon` y `authenticated`.
- Concede acceso backend al rol `valdra_app`.
- Mantiene políticas internas para que Spree funcione con RLS activo.
- Mueve `pg_trgm` al esquema `extensions`.
- Mantiene privados los buckets de catálogo.

No se usa Supabase Auth en esta etapa. Spree continúa gestionando identidad,
sesiones, carritos y pedidos.

## Flujo de ramas

Las ramas son ramas de Git, no instalaciones separadas del backend:

```text
main                  versión estable
develop               integración de cambios
feature/backend-core  trabajo activo del backend
```

El backend siempre está en `commerce`, independientemente de la rama en la que
se trabaje.

## Calidad antes de publicar

Desde la raíz:

```powershell
pnpm lint
pnpm typecheck
pnpm build
```

Desde `commerce`:

```powershell
bundle exec brakeman
bundle exec bundler-audit check
```

Antes de producción también deben ejecutarse pruebas E2E de registro, login,
carrito, checkout, administración e imágenes, además de revisar los advisors
de Supabase.

## Reglas de contribución

- No subir `.env`, `.env.local`, `commerce/.env`, claves S3 ni `master.key`.
- No exponer claves privadas en variables `NEXT_PUBLIC_*`.
- No confiar en precios, stock o permisos enviados por el cliente.
- Validar y autorizar siempre en Rails/server-side.
- No aplicar cambios destructivos en producción sin backup y staging.
- Mantener `pnpm-lock.yaml` y `commerce/Gemfile.lock` actualizados.
