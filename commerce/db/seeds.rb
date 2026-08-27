# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Bootstrap idempotente de VALDRA. No contiene credenciales, productos ni datos
# de demostración: puede ejecutarse tantas veces como sea necesario.

colombia = Spree::Country.find_or_create_by!(iso: "CO") do |country|
  country.name = "Colombia"
  country.iso_name = "COLOMBIA"
  country.iso3 = "COL"
  country.numcode = 170
end

store = Spree::Store.find_or_initialize_by(code: "valdra")
store.assign_attributes(
  name: "VALDRA",
  url: ENV.fetch("SPREE_STORE_URL", "localhost:3001"),
  default_currency: "COP",
  default_locale: "es",
  supported_currencies: "COP",
  supported_locales: "es",
  default_country: colombia,
  customer_support_email: ENV.fetch("CUSTOMER_SUPPORT_EMAIL", "soporte@valdra.test"),
  mail_from_address: ENV.fetch("MAIL_FROM_ADDRESS", "noreply@valdra.test")
)
store.default = true
store.save!

# Staff authorization is explicit and scoped to the VALDRA store. A valid
# login without this role must not grant access to administrative resources.
admin_role = Spree::Role.default_admin_role
admin_email = ENV.fetch("VALDRA_ADMIN_EMAIL", "admin@valdra.test")
if (admin_user = Spree.admin_user_class.find_by(email: admin_email))
  admin_user.add_role(admin_role.name, store)
end

stock_location = Spree::StockLocation.find_or_initialize_by(name: "Bodega principal")
stock_location.assign_attributes(
  default: true,
  active: true,
  country: colombia,
  city: ENV.fetch("WAREHOUSE_CITY", "Bogotá"),
  kind: "warehouse"
)
stock_location.save!

colombia_zone = Spree::Zone.find_or_initialize_by(name: "Colombia")
colombia_zone.assign_attributes(kind: "country", default_tax: false)
colombia_zone.save!
colombia_zone.zone_members.find_or_create_by!(zoneable: colombia)

# COD no se captura automáticamente: la confirmación de pago pertenece al
# administrador después de la entrega, nunca al navegador del cliente.
cash_on_delivery = Spree::PaymentMethod::Check.find_or_initialize_by(
  store: store,
  name: "Pago contra entrega"
)
cash_on_delivery.assign_attributes(
  description: "Paga al recibir tu pedido.",
  active: true,
  display_on: "both",
  auto_capture: false,
  position: 1
)
cash_on_delivery.save!
