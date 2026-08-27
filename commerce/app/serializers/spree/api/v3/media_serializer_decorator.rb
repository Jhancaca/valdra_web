# frozen_string_literal: true

module Valdra
  module SpreeApiMediaSerializerDecorator
    private

    # Product media is normalized once at upload time. Returning that
    # attachment for every optional Spree variant keeps the API useful without
    # triggering a runtime Active Storage transformation on every request.
    def variant_url(asset, _variant_name)
      image_url_for(asset)
    end
  end
end

Spree::Api::V3::MediaSerializer.prepend(Valdra::SpreeApiMediaSerializerDecorator)
