# Seguridad VALDRA

## Reporte responsable

No publiques credenciales, tokens ni datos de clientes en issues. Reporta vulnerabilidades al propietario del repositorio con pasos mínimos de reproducción y sin exfiltrar información.

## Reglas de desarrollo

- Los secretos viven únicamente en el gestor de secretos o en archivos `.env` locales ignorados por Git.
- Las claves de Spree y Supabase de servidor nunca usan prefijo `NEXT_PUBLIC_`.
- Precios, inventario, descuentos, permisos y estados de pedidos se validan en Rails/Spree.
- El navegador solo usa el BFF de Next.js para autenticación, carrito y checkout.
- Los originales de imágenes no se sirven al storefront; se conserva la copia normalizada.

## Antes de publicar

Ejecuta `pnpm lint`, `pnpm typecheck`, `pnpm build`, `bundle exec brakeman` y `bundle exec bundler-audit`.
