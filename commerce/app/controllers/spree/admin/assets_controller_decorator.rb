# frozen_string_literal: true

module Valdra
  module SpreeAdminAssetsControllerDecorator
    extend ActiveSupport::Concern

    included do
      after_action :valdra_store_unassigned_asset, only: :create
    end

    private

    # The normalizer moves the original upload to `source_attachment` before
    # Spree finishes the product form. Spree's default helper uses
    # `asset.update`, which runs the image validation and rejects that
    # temporary state because the public `attachment` is intentionally empty.
    # The session UUID is generated server-side and is only a staging pointer,
    # so persist it without validations. This keeps the normalizer asynchronous
    # while allowing ProductsController#assign_session_uploaded_assets to find
    # the asset reliably.
    def store_uploaded_asset_in_session(asset, viewable_type)
      ensure_session_uploaded_assets_uuid(viewable_type)
      asset.update_columns(
        session_id: session[session_uploaded_assets_uuid_key(viewable_type)],
        updated_at: Time.current
      )
    end

    # Spree stages product uploads before the product exists. Some Turbo/direct
    # upload paths skip the stock controller's session assignment, leaving a
    # perfectly valid asset orphaned with a NULL viewable_id. Keep it in the
    # same session bucket so ProductsController can attach it after create.
    def valdra_store_unassigned_asset
      return unless defined?(@asset) && @asset&.persisted?
      return if @asset.viewable_id.present? || @asset.viewable_type.blank?

      store_uploaded_asset_in_session(@asset, @asset.viewable_type)
    rescue StandardError => error
      Rails.logger.warn("VALDRA could not stage uploaded asset #{@asset&.id}: #{error.message}")
    end
  end
end

Spree::Admin::AssetsController.include(Valdra::SpreeAdminAssetsControllerDecorator)
