# Cuenta y seguridad de VALDRA

## Registro

El storefront envía el formulario a `src/app/api/auth/register`, que valida
los campos y delega en `POST /api/v3/store/customer_registrations`. Rails crea
el usuario Spree y `valdra_private.valdra_customer_profiles` dentro de una
transacción. El teléfono se normaliza a E.164 (`10` dígitos colombianos se
convierten a `+57`) y las ubicaciones se validan contra el catálogo versionado.

## Rol de base de datos

La migración `supabase/migrations/20260826090000_valdra_security.sql` crea
`valdra_app` con `LOGIN`, `NOSUPERUSER` y `NOBYPASSRLS`, y deja los secretos fuera
del repositorio. Antes de cambiar `DATABASE_URL` en staging:

1. Genera una contraseña fuerte en un gestor de secretos.
2. En el SQL Editor de Supabase ejecuta `ALTER ROLE valdra_app PASSWORD '…';`
   sin guardar la contraseña en Git ni en logs.
3. Configura `DATABASE_URL` del backend con ese usuario y prueba `/up`, Store API,
   registro, carrito y administración.
4. Revoca y rota la credencial anterior después del smoke test.

El schema `valdra_private` no está expuesto al Data API y no tiene políticas
para `anon` ni `authenticated`. Los buckets `catalog-public` y
`catalog-private` están marcados como privados; las claves S3 solo deben existir
en Rails.

## Catálogo

`/shop` usa `searchParams` y una lista cerrada de filtros. Los parámetros se
convierten a filtros nativos de Spree en el servidor; nunca se acepta una
expresión Ransack enviada directamente por el navegador.
