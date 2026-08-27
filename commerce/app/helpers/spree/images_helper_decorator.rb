# frozen_string_literal: true

module Valdra
  module SpreeImagesHelperDecorator
    # VALDRA product images are already a 1200x1200 WebP. Do not ask Active
    # Storage to create a second variant for admin previews or product forms.
    # This also keeps those screens independent from native libvips on Windows.
    def spree_image_tag(image, options = {})
      return super unless valdra_product_attachment?(image)

      image_tag(valdra_canonical_image_url(image), options.except(:variant, :format))
    end

    def spree_image_url(image, options = {})
      return valdra_canonical_image_url(image) if valdra_product_attachment?(image)

      super
    end

    private

    def valdra_product_attachment?(image)
      record = image.respond_to?(:record) ? image.record : nil
      record.is_a?(Spree::Asset) && record.media_type == "image" && record.attachment.attached?
    end

    def valdra_canonical_image_url(image)
      url_helpers = respond_to?(:main_app) ? main_app : Rails.application.routes.url_helpers
      url_helpers.cdn_image_url(image)
    end
  end
end

Spree::ImagesHelper.prepend(Valdra::SpreeImagesHelperDecorator)
