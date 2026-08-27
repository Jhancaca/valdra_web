# frozen_string_literal: true

# VALDRA stores one canonical, already-normalized 1200x1200 WebP per product
# image. Spree's default named variants are preprocessed with Active Storage's
# image processor, which requires a native libvips/ImageMagick installation.
# That processor is not available in the Windows development environment, and
# its background jobs otherwise fail with `undefined method `new' for nil`.
#
# The storefront and admin use the canonical attachment directly, so disable
# eager preprocessing for Spree's optional variants. The API serializer is
# decorated separately to return the canonical URL for those fields as well.
Rails.application.config.after_initialize do
  next unless defined?(Spree::Asset)

  reflection = Spree::Asset.attachment_reflections["attachment"]
  reflection&.named_variants&.each_value do |variant|
    variant.instance_variable_set(:@preprocessed, false)
  end
end
