# VALDRA — guía para ejecutar el proyecto

## Bienvenido al proyecto

VALDRA es un ecommerce de ropa urbana compuesto por:

- Storefront en Next.js, React y TypeScript.
- Backend Rails 8.1 con Spree Commerce 5.6.
- PostgreSQL y Storage administrados mediante Supabase.
- Procesamiento server-side de imágenes de productos a WebP.

El backend está dentro de la carpeta `commerce/`. Las ramas principales son:

```text
main                  versión estable
develop               integración de cambios
feature/backend-core  desarrollo activo del backend
```

El trabajo diario debe comenzar desde `develop`, creando una rama propia para
cada cambio.

## Acceso al código

El repositorio es privado. Después de recibir acceso como colaborador, clona el
proyecto y cambia a `develop`:

```powershell
git clone https://github.com/Jhancaca/valdra_web.git
cd valdra
git switch develop
```

No cambies la visibilidad del repositorio ni compartas su contenido fuera del
equipo.

## Herramientas necesarias

Instala estas versiones o superiores compatibles:

- Git.
- Node.js 22.
- pnpm 11.
- Ruby 3.3.
- Bundler.
- Python 3.11 o superior.
- Docker Desktop (recomendado, aunque la ejecución nativa también está soportada).

Comprueba las versiones:

```powershell
node --version
pnpm --version
ruby --version
bundle --version
python --version
docker --version
```

## Instalación del storefront

Desde la raíz del repositorio:

```powershell
corepack enable
pnpm install
Copy-Item .env.example .env.local
```

Completa `.env.local` con estas variables:

```env
SPREE_API_URL=http://localhost:3001
SPREE_PUBLISHABLE_KEY=clave_publicable_de_spree
```

Las claves de desarrollo serán entregadas por el propietario del proyecto por
WhatsApp. No las subas a GitHub, no las pegues en issues y no las incluyas en
capturas de pantalla.

## Instalación del backend

```powershell
cd commerce
bundle install
Copy-Item .env.example .env
```

El archivo `commerce/.env` requiere las credenciales del entorno de desarrollo:

- `DATABASE_URL` de Supabase.
- `RAILS_MASTER_KEY` de desarrollo.
- `SUPABASE_STORAGE_ENDPOINT`.
- `SUPABASE_STORAGE_ACCESS_KEY_ID`.
- `SUPABASE_STORAGE_SECRET_ACCESS_KEY`.
- `STOREFRONT_ORIGIN=http://localhost:3000`.

Estas credenciales también serán entregadas por el propietario por WhatsApp.
Utiliza exclusivamente credenciales de desarrollo. Nunca solicites ni uses
credenciales de producción para pruebas locales.

No se debe compartir ni almacenar en el repositorio:

- `service_role` de Supabase.
- Contraseñas del usuario propietario de PostgreSQL.
- Claves de producción.
- `commerce/config/master.key`.
- Ningún archivo `.env`.

## Preparar la base de datos

Con `DATABASE_URL` apuntando al entorno de desarrollo:

```powershell
cd commerce
bundle exec rails db:migrate
bundle exec rails db:seed
```

No ejecutes migraciones sobre producción sin backup, revisión y autorización
explícita.

## Procesamiento de imágenes

Para probar la subida y normalización de imágenes desde Spree Admin, prepara el
entorno Python:

```powershell
cd commerce
py -3 -m venv .venv
.\.venv\Scripts\python.exe -m pip install --upgrade pip
.\.venv\Scripts\python.exe -m pip install pillow numpy rembg onnxruntime
```

Configura en `commerce/.env`:

```env
VALDRA_IMAGE_NORMALIZER_COMMAND=C:\ruta\al\proyecto\commerce\.venv\Scripts\python.exe
VALDRA_REMBG_MODEL=u2net_cloth_seg
```

La primera ejecución puede descargar el modelo de segmentación. Las imágenes
normalizadas se generan en WebP con lienzo blanco y se sirven mediante Active
Storage.

## Ejecutar el proyecto sin Docker

Abre dos terminales.

### Terminal 1 — backend Rails

```powershell
cd commerce
bundle exec rails server -p 3001
```

### Terminal 2 — storefront Next.js

```powershell
pnpm dev
```

URLs locales:

- Storefront: <http://localhost:3000>
- Catálogo: <http://localhost:3000/shop>
- Registro: <http://localhost:3000/register>
- Login: <http://localhost:3000/login>
- Carrito: <http://localhost:3000/cart>
- Checkout: <http://localhost:3000/checkout>
- Administración Spree: <http://localhost:3001/admin/login>

## Usuario administrador de desarrollo

Solicita un usuario administrador de desarrollo al propietario. No uses
credenciales reales de producción.

Si se necesita crear uno localmente:

```powershell
cd commerce
bundle exec rails console
```

```ruby
admin = Spree.admin_user_class.create!(
  email: "dev-admin@valdra.test",
  password: "una-clave-local-larga",
  password_confirmation: "una-clave-local-larga"
)

admin.add_role(
  Spree::Role.default_admin_role.name,
  Spree::Store.default
)
```

## Flujo de trabajo Git

Antes de comenzar:

```powershell
git switch develop
git pull --ff-only origin develop
git switch -c feature/nombre-del-cambio
```

Antes de abrir un Pull Request:

```powershell
pnpm lint
pnpm typecheck
pnpm build

cd commerce
bundle exec brakeman
bundle exec bundler-audit check
```

No hagas `git push --force` sobre `main` o `develop`.

## Docker: recomendación

El backend ya incluye `commerce/Dockerfile`, preparado para una imagen de
producción con Ruby 3.3, libvips, Python y las dependencias del normalizador de
imágenes WebP. Ese archivo no debe usarse como entorno de desarrollo con datos
reales.

VALDRA tiene dos aplicaciones independientes:

1. Next.js.
2. Rails/Spree, más el procesamiento de imágenes.

Para completar un entorno reproducible de desarrollo todavía será conveniente
añadir:

- Un Dockerfile para el storefront.
- Un `docker-compose.yml` para coordinar storefront, Rails y workers.
- Variables de entorno mediante archivos locales no versionados.

Supabase continuará siendo un servicio externo. Docker no debe contener claves
ni sustituye las políticas RLS de Supabase.

Hasta que exista ese `docker-compose.yml`, utiliza la ejecución nativa descrita
arriba. No descargues ni inventes imágenes Docker no aprobadas para el proyecto.

## Reglas de seguridad obligatorias

- Nunca subas `.env`, `.env.local`, `master.key` o credenciales.
- Nunca uses `NEXT_PUBLIC_` para secretos.
- Nunca confíes en precio, stock o permisos enviados por el navegador.
- No desactives RLS para solucionar errores locales.
- No compartas claves de producción por WhatsApp.
- Si una clave se expone, avisa inmediatamente para rotarla.
- Usa datos de prueba y una base Supabase separada.

Si tienes problemas para iniciar el proyecto, comparte el mensaje de error y
los comandos ejecutados, pero elimina previamente URLs, contraseñas, tokens y
valores de variables de entorno.
