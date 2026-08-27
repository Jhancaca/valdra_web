# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_26_090000) do
  create_schema "extensions"

  # These are extensions that must be enabled in order to support this database
  enable_extension "extensions.pg_stat_statements"
  enable_extension "extensions.pg_trgm"
  enable_extension "extensions.pgcrypto"
  enable_extension "extensions.uuid-ossp"
  enable_extension "pg_catalog.plpgsql"
  enable_extension "vault.supabase_vault"

  create_table "public.action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "locale", default: "en", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name", "locale"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "public.action_text_video_embeds", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "raw_html", null: false
    t.string "thumbnail_url", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
  end

  create_table "public.active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "public.active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "public.active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "public.friendly_id_slugs", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "locale"
    t.string "scope"
    t.string "slug", null: false
    t.bigint "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.index ["deleted_at"], name: "index_friendly_id_slugs_on_deleted_at"
    t.index ["locale"], name: "index_friendly_id_slugs_on_locale"
    t.index ["slug", "sluggable_type", "locale"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_locale"
    t.index ["slug", "sluggable_type", "scope", "locale"], name: "index_friendly_id_slugs_unique", unique: true
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "public.spree_addresses", force: :cascade do |t|
    t.string "address1"
    t.string "address2"
    t.string "alternative_phone"
    t.string "city"
    t.string "company"
    t.bigint "country_id"
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.string "firstname"
    t.string "label"
    t.string "lastname"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "phone"
    t.jsonb "private_metadata"
    t.jsonb "public_metadata"
    t.boolean "quick_checkout", default: false
    t.bigint "state_id"
    t.string "state_name"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "zipcode"
    t.index ["country_id"], name: "index_spree_addresses_on_country_id"
    t.index ["deleted_at"], name: "index_spree_addresses_on_deleted_at"
    t.index ["firstname"], name: "index_addresses_on_firstname"
    t.index ["lastname"], name: "index_addresses_on_lastname"
    t.index ["quick_checkout"], name: "index_spree_addresses_on_quick_checkout"
    t.index ["state_id"], name: "index_spree_addresses_on_state_id"
    t.index ["user_id"], name: "index_spree_addresses_on_user_id"
  end

  create_table "public.spree_adjustments", force: :cascade do |t|
    t.bigint "adjustable_id"
    t.string "adjustable_type"
    t.decimal "amount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.boolean "eligible", default: true
    t.boolean "included", default: false
    t.string "label"
    t.boolean "mandatory"
    t.bigint "order_id", null: false
    t.bigint "source_id"
    t.string "source_type"
    t.string "state"
    t.datetime "updated_at", null: false
    t.index ["adjustable_id", "adjustable_type"], name: "index_spree_adjustments_on_adjustable_id_and_adjustable_type"
    t.index ["adjustable_type", "adjustable_id", "source_type"], name: "index_spree_adjustments_on_adjustable_and_source_type"
    t.index ["amount"], name: "index_spree_adjustments_on_amount"
    t.index ["eligible"], name: "index_spree_adjustments_on_eligible"
    t.index ["order_id", "eligible", "source_type"], name: "index_spree_adjustments_on_order_eligible_source_type"
    t.index ["order_id", "state"], name: "index_spree_adjustments_on_order_id_and_state"
    t.index ["order_id"], name: "index_spree_adjustments_on_order_id"
    t.index ["source_id", "source_type"], name: "index_spree_adjustments_on_source_id_and_source_type"
    t.index ["source_type"], name: "index_spree_adjustments_on_source_type"
  end

  create_table "public.spree_admin_users", force: :cascade do |t|
    t.string "authentication_token"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email"
    t.string "encrypted_password", limit: 128
    t.integer "failed_attempts", default: 0, null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "last_request_at"
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.datetime "locked_at"
    t.string "login"
    t.string "perishable_token"
    t.string "persistence_token"
    t.jsonb "private_metadata"
    t.jsonb "public_metadata"
    t.datetime "remember_created_at"
    t.string "remember_token"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "selected_locale"
    t.integer "sign_in_count", default: 0, null: false
    t.string "unlock_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_spree_admin_users_on_email", unique: true
  end

  create_table "public.spree_allowed_origins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "origin", null: false
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id", "origin"], name: "index_spree_allowed_origins_on_store_id_and_origin", unique: true
    t.index ["store_id"], name: "index_spree_allowed_origins_on_store_id"
  end

  create_table "public.spree_api_keys", force: :cascade do |t|
    t.bigint "channel_id"
    t.datetime "created_at", null: false
    t.bigint "created_by_id"
    t.string "created_by_type"
    t.string "key_type", null: false
    t.datetime "last_used_at"
    t.string "name", null: false
    t.datetime "revoked_at"
    t.bigint "revoked_by_id"
    t.string "revoked_by_type"
    t.jsonb "scopes"
    t.bigint "store_id", null: false
    t.string "token"
    t.string "token_digest"
    t.string "token_prefix"
    t.datetime "updated_at", null: false
    t.index ["channel_id"], name: "index_spree_api_keys_on_channel_id"
    t.index ["created_by_type", "created_by_id"], name: "index_spree_api_keys_on_created_by"
    t.index ["key_type"], name: "index_spree_api_keys_on_key_type"
    t.index ["revoked_by_type", "revoked_by_id"], name: "index_spree_api_keys_on_revoked_by"
    t.index ["store_id", "key_type"], name: "index_spree_api_keys_on_store_id_and_key_type"
    t.index ["store_id"], name: "index_spree_api_keys_on_store_id"
    t.index ["token"], name: "index_spree_api_keys_on_token", unique: true, where: "(token IS NOT NULL)"
    t.index ["token_digest"], name: "index_spree_api_keys_on_token_digest", unique: true
  end

  create_table "public.spree_assets", force: :cascade do |t|
    t.text "alt"
    t.string "attachment_content_type"
    t.string "attachment_file_name"
    t.integer "attachment_file_size"
    t.integer "attachment_height"
    t.datetime "attachment_updated_at", precision: nil
    t.integer "attachment_width"
    t.datetime "created_at", precision: nil
    t.string "external_video_url"
    t.decimal "focal_point_x", precision: 5, scale: 4
    t.decimal "focal_point_y", precision: 5, scale: 4
    t.string "media_type"
    t.integer "position"
    t.jsonb "private_metadata"
    t.jsonb "public_metadata"
    t.string "session_id"
    t.string "type", limit: 75
    t.datetime "updated_at", precision: nil
    t.bigint "viewable_id"
    t.string "viewable_type"
    t.index ["media_type"], name: "index_spree_assets_on_media_type"
    t.index ["position"], name: "index_spree_assets_on_position"
    t.index ["viewable_id"], name: "index_assets_on_viewable_id"
    t.index ["viewable_type", "type"], name: "index_assets_on_viewable_type_and_type"
  end

  create_table "public.spree_calculators", force: :cascade do |t|
    t.bigint "calculable_id"
    t.string "calculable_type"
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.text "preferences"
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["calculable_id", "calculable_type"], name: "index_spree_calculators_on_calculable_id_and_calculable_type"
    t.index ["deleted_at"], name: "index_spree_calculators_on_deleted_at"
    t.index ["id", "type"], name: "index_spree_calculators_on_id_and_type"
  end

  create_table "public.spree_channels", force: :cascade do |t|
    t.boolean "active", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.boolean "default", default: false, null: false
    t.string "name", null: false
    t.text "preferences"
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id", "code"], name: "index_spree_channels_on_store_id_and_code", unique: true
    t.index ["store_id"], name: "index_spree_channels_default_per_store", unique: true, where: "(\"default\" = true)"
    t.index ["store_id"], name: "index_spree_channels_on_store_id"
  end

  create_table "public.spree_countries", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "iso", null: false
    t.string "iso3", null: false
    t.string "iso_name"
    t.string "name"
    t.integer "numcode"
    t.boolean "states_required", default: false
    t.datetime "updated_at", precision: nil
    t.boolean "zipcode_required", default: true
    t.index ["iso"], name: "index_spree_countries_on_iso", unique: true
    t.index ["iso3"], name: "index_spree_countries_on_iso3", unique: true
    t.index ["iso_name"], name: "index_spree_countries_on_iso_name", unique: true
    t.index ["name"], name: "index_spree_countries_on_name", unique: true
  end

  create_table "public.spree_coupon_codes", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.bigint "order_id"
    t.bigint "promotion_id"
    t.integer "state", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_spree_coupon_codes_on_code", unique: true
    t.index ["deleted_at"], name: "index_spree_coupon_codes_on_deleted_at"
    t.index ["order_id"], name: "index_spree_coupon_codes_on_order_id"
    t.index ["promotion_id"], name: "index_spree_coupon_codes_on_promotion_id"
    t.index ["state"], name: "index_spree_coupon_codes_on_state"
  end

  create_table "public.spree_credit_cards", force: :cascade do |t|
    t.bigint "address_id"
    t.string "cc_type"
    t.datetime "created_at", null: false
    t.boolean "default", default: false, null: false
    t.datetime "deleted_at", precision: nil
    t.string "fingerprint"
    t.bigint "gateway_customer_id"
    t.string "gateway_customer_profile_id"
    t.string "gateway_payment_profile_id"
    t.string "last_digits"
    t.string "month"
    t.string "name"
    t.bigint "payment_method_id"
    t.jsonb "private_metadata"
    t.jsonb "public_metadata"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "year"
    t.index ["address_id"], name: "index_spree_credit_cards_on_address_id"
    t.index ["deleted_at"], name: "index_spree_credit_cards_on_deleted_at"
    t.index ["gateway_customer_id"], name: "index_spree_credit_cards_on_gateway_customer_id"
    t.index ["payment_method_id"], name: "index_spree_credit_cards_on_payment_method_id"
    t.index ["user_id", "payment_method_id", "fingerprint", "month", "year"], name: "index_spree_credit_cards_unique_fingerprint", unique: true, where: "((fingerprint IS NOT NULL) AND (deleted_at IS NULL))"
    t.index ["user_id"], name: "index_spree_credit_cards_on_user_id"
  end

  create_table "public.spree_custom_domains", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "default", default: false, null: false
    t.jsonb "private_metadata"
    t.jsonb "public_metadata"
    t.boolean "status", default: false
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.index ["store_id"], name: "index_spree_custom_domains_on_store_id"
    t.index ["url"], name: "index_spree_custom_domains_on_url", unique: true
  end

  create_table "public.spree_customer_group_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "customer_group_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "user_type", null: false
    t.index ["customer_group_id", "user_id", "user_type"], name: "index_spree_customer_group_users_unique", unique: true
    t.index ["customer_group_id"], name: "index_spree_customer_group_users_on_customer_group_id"
    t.index ["user_type", "user_id"], name: "index_spree_customer_group_users_on_user"
  end

  create_table "public.spree_customer_groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.text "description"
    t.string "name", null: false
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_spree_customer_groups_on_deleted_at"
    t.index ["store_id", "name"], name: "index_spree_customer_groups_on_store_id_and_name", unique: true, where: "(deleted_at IS NULL)"
    t.index ["store_id"], name: "index_spree_customer_groups_on_store_id"
  end

  create_table "public.spree_customer_returns", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "number"
    t.jsonb "private_metadata"
    t.jsonb "public_metadata"
    t.bigint "stock_location_id"
    t.bigint "store_id"
    t.datetime "updated_at", null: false
    t.index ["number"], name: "index_spree_customer_returns_on_number", unique: true
    t.index ["stock_location_id"], name: "index_spree_customer_returns_on_stock_location_id"
    t.index ["store_id"], name: "index_spree_customer_returns_on_store_id"
  end

  create_table "public.spree_data_feeds", force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.string "name"
    t.string "slug"
    t.bigint "store_id"
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["store_id", "slug", "type"], name: "index_spree_data_feeds_on_store_id_and_slug_and_type"
    t.index ["store_id"], name: "index_spree_data_feeds_on_store_id"
  end

  create_table "public.spree_digital_links", force: :cascade do |t|
    t.integer "access_counter"
    t.datetime "created_at", precision: nil, null: false
    t.bigint "digital_id"
    t.bigint "line_item_id"
    t.string "token"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["digital_id"], name: "index_spree_digital_links_on_digital_id"
    t.index ["line_item_id"], name: "index_spree_digital_links_on_line_item_id"
    t.index ["token"], name: "index_spree_digital_links_on_token", unique: true
  end

  create_table "public.spree_digitals", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "variant_id"
    t.index ["variant_id"], name: "index_spree_digitals_on_variant_id"
  end

  create_table "public.spree_exports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "format", null: false
    t.string "number", limit: 32, null: false
    t.text "preferences"
    t.jsonb "search_params"
    t.bigint "store_id", null: false
    t.string "type", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["format"], name: "index_spree_exports_on_format"
    t.index ["number"], name: "index_spree_exports_on_number", unique: true
    t.index ["store_id"], name: "index_spree_exports_on_store_id"
    t.index ["user_id"], name: "index_spree_exports_on_user_id"
  end

  create_table "public.spree_gateway_customers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "payment_method_id", null: false
    t.string "profile_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["payment_method_id"], name: "index_spree_gateway_customers_on_payment_method_id"
    t.index ["user_id", "payment_method_id"], name: "index_spree_gateway_customers_on_user_id_and_payment_method_id", unique: true
    t.index ["user_id"], name: "index_spree_gateway_customers_on_user_id"
  end

  create_table "public.spree_gateways", force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.text "description"
    t.string "environment", default: "development"
    t.string "name"
    t.text "preferences"
    t.string "server", default: "test"
    t.boolean "test_mode", default: true
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_spree_gateways_on_active"
    t.index ["test_mode"], name: "index_spree_gateways_on_test_mode"
  end

  create_table "public.spree_gift_card_batches", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.integer "codes_count", default: 1, null: false
    t.datetime "created_at", null: false
    t.bigint "created_by_id"
    t.string "currency", null: false
    t.date "expires_at"
    t.string "prefix"
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_spree_gift_card_batches_on_created_by_id"
    t.index ["store_id"], name: "index_spree_gift_card_batches_on_store_id"
  end

  create_table "public.spree_gift_cards", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.decimal "amount_authorized", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "amount_used", precision: 10, scale: 2, default: "0.0", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.bigint "created_by_id"
    t.string "currency", null: false
    t.date "expires_at"
    t.bigint "gift_card_batch_id"
    t.datetime "redeemed_at"
    t.string "state", null: false
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["code"], name: "index_spree_gift_cards_on_code", unique: true
    t.index ["created_by_id"], name: "index_spree_gift_cards_on_created_by_id"
    t.index ["expires_at"], name: "index_spree_gift_cards_on_expires_at"
    t.index ["gift_card_batch_id"], name: "index_spree_gift_cards_on_gift_card_batch_id"
    t.index ["redeemed_at"], name: "index_spree_gift_cards_on_redeemed_at"
    t.index ["state"], name: "index_spree_gift_cards_on_state"
    t.index ["store_id"], name: "index_spree_gift_cards_on_store_id"
    t.index ["user_id"], name: "index_spree_gift_cards_on_user_id"
  end

  create_table "public.spree_import_mappings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "file_column"
    t.bigint "import_id", null: false
    t.string "schema_field", null: false
    t.datetime "updated_at", null: false
    t.index ["file_column"], name: "index_spree_import_mappings_on_file_column"
    t.index ["import_id", "schema_field"], name: "index_spree_import_mappings_on_import_id_and_schema_field", unique: true
    t.index ["import_id"], name: "index_spree_import_mappings_on_import_id"
  end

  create_table "public.spree_import_rows", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "data", null: false
    t.bigint "import_id", null: false
    t.bigint "item_id"
    t.string "item_type"
    t.integer "row_number", null: false
    t.string "status", null: false
    t.datetime "updated_at", null: false
    t.text "validation_errors"
    t.index ["import_id", "row_number"], name: "index_spree_import_rows_on_import_id_and_row_number", unique: true
    t.index ["import_id", "status"], name: "index_spree_import_rows_on_import_id_and_status"
    t.index ["import_id"], name: "index_spree_import_rows_on_import_id"
    t.index ["item_type", "item_id"], name: "index_spree_import_rows_on_item"
    t.index ["status"], name: "index_spree_import_rows_on_status"
  end

  create_table "public.spree_imports", force: :cascade do |t|
    t.integer "completed_groups_count", default: 0
    t.datetime "created_at", null: false
    t.string "number", limit: 32, null: false
    t.bigint "owner_id", null: false
    t.string "owner_type", null: false
    t.text "preferences"
    t.text "processing_errors"
    t.integer "processing_groups_count", default: 0
    t.integer "rows_count", default: 0, null: false
    t.string "status", null: false
    t.string "type", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["number"], name: "index_spree_imports_on_number", unique: true
    t.index ["owner_type", "owner_id"], name: "index_spree_imports_on_owner"
    t.index ["status"], name: "index_spree_imports_on_status"
    t.index ["type"], name: "index_spree_imports_on_type"
    t.index ["user_id"], name: "index_spree_imports_on_user_id"
  end

  create_table "public.spree_integrations", force: :cascade do |t|
    t.boolean "active", default: false, null: false
    t.datetime "created_at", null: false
    t.text "preferences"
    t.bigint "store_id", null: false
    t.string "type", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_spree_integrations_on_active"
    t.index ["store_id"], name: "index_spree_integrations_on_store_id"
    t.index ["type"], name: "index_spree_integrations_on_type"
  end

  create_table "public.spree_inventory_units", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "line_item_id"
    t.bigint "order_id"
    t.bigint "original_return_item_id"
    t.boolean "pending", default: true
    t.integer "quantity", default: 1
    t.bigint "shipment_id"
    t.string "state"
    t.datetime "updated_at", null: false
    t.bigint "variant_id"
    t.index ["line_item_id"], name: "index_spree_inventory_units_on_line_item_id"
    t.index ["order_id"], name: "index_inventory_units_on_order_id"
    t.index ["original_return_item_id"], name: "index_spree_inventory_units_on_original_return_item_id"
    t.index ["shipment_id"], name: "index_inventory_units_on_shipment_id"
    t.index ["variant_id"], name: "index_inventory_units_on_variant_id"
  end

  create_table "public.spree_invitations", force: :cascade do |t|
    t.datetime "accepted_at"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "email", null: false
    t.datetime "expires_at"
    t.bigint "invitee_id"
    t.string "invitee_type"
    t.bigint "inviter_id", null: false
    t.string "inviter_type", null: false
    t.bigint "resource_id", null: false
    t.string "resource_type", null: false
    t.bigint "role_id", null: false
    t.string "status", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_spree_invitations_on_deleted_at"
    t.index ["email"], name: "index_spree_invitations_on_email"
    t.index ["expires_at"], name: "index_spree_invitations_on_expires_at"
    t.index ["invitee_type", "invitee_id"], name: "index_spree_invitations_on_invitee"
    t.index ["inviter_type", "inviter_id"], name: "index_spree_invitations_on_inviter"
    t.index ["resource_type", "resource_id"], name: "index_spree_invitations_on_resource"
    t.index ["role_id"], name: "index_spree_invitations_on_role_id"
    t.index ["status"], name: "index_spree_invitations_on_status"
    t.index ["token"], name: "index_spree_invitations_on_token", unique: true
  end

  create_table "public.spree_line_items", force: :cascade do |t|
    t.decimal "additional_tax_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "adjustment_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "cost_price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.string "currency"
    t.decimal "included_tax_total", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "non_taxable_adjustment_total", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "order_id"
    t.decimal "pre_tax_amount", precision: 12, scale: 4, default: "0.0", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.bigint "price_list_id"
    t.jsonb "private_metadata"
    t.decimal "promo_total", precision: 10, scale: 2, default: "0.0"
    t.jsonb "public_metadata"
    t.integer "quantity", null: false
    t.bigint "tax_category_id"
    t.decimal "taxable_adjustment_total", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.bigint "variant_id"
    t.index ["order_id"], name: "index_spree_line_items_on_order_id"
    t.index ["price_list_id"], name: "index_spree_line_items_on_price_list_id"
    t.index ["tax_category_id"], name: "index_spree_line_items_on_tax_category_id"
    t.index ["variant_id"], name: "index_spree_line_items_on_variant_id"
  end

  create_table "public.spree_log_entries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "details"
    t.bigint "source_id"
    t.string "source_type"
    t.datetime "updated_at", null: false
    t.index ["source_id", "source_type"], name: "index_spree_log_entries_on_source_id_and_source_type"
  end

  create_table "public.spree_market_countries", force: :cascade do |t|
    t.bigint "country_id", null: false
    t.datetime "created_at", null: false
    t.bigint "market_id", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_spree_market_countries_on_country_id"
    t.index ["market_id", "country_id"], name: "index_spree_market_countries_on_market_id_and_country_id", unique: true
    t.index ["market_id"], name: "index_spree_market_countries_on_market_id"
  end

  create_table "public.spree_markets", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "currency", null: false
    t.boolean "default", default: false, null: false
    t.string "default_locale", null: false
    t.datetime "deleted_at"
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.bigint "store_id", null: false
    t.string "supported_locales"
    t.boolean "tax_inclusive", default: false, null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_spree_markets_on_deleted_at"
    t.index ["store_id", "default"], name: "index_spree_markets_on_store_id_and_default", where: "(deleted_at IS NULL)"
    t.index ["store_id", "name"], name: "index_spree_markets_on_store_id_and_name", unique: true, where: "(deleted_at IS NULL)"
    t.index ["store_id", "position"], name: "index_spree_markets_on_store_id_and_position"
    t.index ["store_id"], name: "index_spree_markets_on_store_id"
  end

  create_table "public.spree_metafield_definitions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "display_on", default: "both", null: false
    t.string "key", null: false
    t.string "metafield_type", null: false
    t.string "name", null: false
    t.string "namespace", null: false
    t.string "resource_type", null: false
    t.boolean "searchable"
    t.boolean "sortable"
    t.datetime "updated_at", null: false
    t.index ["display_on"], name: "index_spree_metafield_definitions_on_display_on"
    t.index ["namespace", "key"], name: "index_spree_metafield_definitions_on_namespace_and_key"
    t.index ["resource_type", "namespace", "key"], name: "idx_on_resource_type_namespace_key_60c784bc3e", unique: true
    t.index ["resource_type"], name: "index_spree_metafield_definitions_on_resource_type"
  end

  create_table "public.spree_metafields", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "metafield_definition_id", null: false
    t.bigint "resource_id", null: false
    t.string "resource_type", null: false
    t.string "type", null: false
    t.datetime "updated_at", null: false
    t.text "value"
    t.index ["metafield_definition_id"], name: "index_spree_metafields_on_metafield_definition_id"
    t.index ["resource_type", "resource_id", "metafield_definition_id"], name: "index_metafields_on_resource_and_definition", unique: true
    t.index ["resource_type", "resource_id"], name: "index_spree_metafields_on_resource"
    t.index ["type"], name: "index_spree_metafields_on_type"
  end

  create_table "public.spree_newsletter_subscribers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.jsonb "private_metadata"
    t.jsonb "public_metadata"
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "verification_token"
    t.datetime "verified_at"
    t.index ["email", "store_id"], name: "index_spree_newsletter_subscribers_on_email_and_store_id", unique: true
    t.index ["store_id"], name: "index_spree_newsletter_subscribers_on_store_id"
    t.index ["user_id"], name: "index_spree_newsletter_subscribers_on_user_id"
    t.index ["verification_token"], name: "index_spree_newsletter_subscribers_on_verification_token", unique: true
    t.index ["verified_at"], name: "index_spree_newsletter_subscribers_on_verified_at"
  end

  create_table "public.spree_option_type_prototypes", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.bigint "option_type_id"
    t.bigint "prototype_id"
    t.datetime "updated_at", precision: nil
    t.index ["option_type_id"], name: "index_spree_option_type_prototypes_on_option_type_id"
    t.index ["prototype_id", "option_type_id"], name: "spree_option_type_prototypes_prototype_id_option_type_id", unique: true
    t.index ["prototype_id"], name: "index_spree_option_type_prototypes_on_prototype_id"
  end

  create_table "public.spree_option_type_translations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "locale", null: false
    t.string "presentation"
    t.bigint "spree_option_type_id", null: false
    t.datetime "updated_at", null: false
    t.index ["locale"], name: "index_spree_option_type_translations_on_locale"
    t.index ["spree_option_type_id", "locale"], name: "unique_option_type_id_per_locale", unique: true
  end

  create_table "public.spree_option_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "filterable", default: true, null: false
    t.string "kind", default: "dropdown", null: false
    t.string "name", limit: 100
    t.integer "position", default: 0, null: false
    t.string "presentation", limit: 100
    t.jsonb "private_metadata"
    t.jsonb "public_metadata"
    t.datetime "updated_at", null: false
    t.index ["filterable"], name: "index_spree_option_types_on_filterable"
    t.index ["kind"], name: "index_spree_option_types_on_kind"
    t.index ["name"], name: "index_spree_option_types_on_name", unique: true
    t.index ["position"], name: "index_spree_option_types_on_position"
  end

  create_table "public.spree_option_value_translations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "locale", null: false
    t.string "presentation"
    t.bigint "spree_option_value_id", null: false
    t.datetime "updated_at", null: false
    t.index ["locale"], name: "index_spree_option_value_translations_on_locale"
    t.index ["spree_option_value_id", "locale"], name: "unique_option_value_id_per_locale", unique: true
  end

  create_table "public.spree_option_value_variants", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.bigint "option_value_id"
    t.datetime "updated_at", precision: nil
    t.bigint "variant_id"
    t.index ["option_value_id"], name: "index_spree_option_value_variants_on_option_value_id"
    t.index ["variant_id", "option_value_id"], name: "index_option_values_variants_on_variant_id_and_option_value_id", unique: true
    t.index ["variant_id"], name: "index_spree_option_value_variants_on_variant_id"
  end
