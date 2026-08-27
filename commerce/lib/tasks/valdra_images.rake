# frozen_string_literal: true

namespace :valdra do
  namespace :images do
    desc "Queue normalization for every existing Spree product image"
    task normalize: :environment do
      queued = 0
      skipped = 0
      inline = ENV["VALDRA_IMAGE_NORMALIZE_INLINE"] == "1"

      Spree::Asset.where(media_type: "image").find_each do |asset|
        if asset.valdra_normalized?
          skipped += 1
          next
        end

        if asset.source_attachment.attached?
          next unless asset.valdra_normalization_status == "failed"

          inline ? Spree::Images::NormalizeAssetJob.perform_now(asset.id) : Spree::Images::NormalizeAssetJob.perform_later(asset.id)
          queued += 1
          next
        end

        next unless asset.attachment.attached?

        asset.source_attachment.attach(asset.attachment.blob)
        asset.attachment.detach
        inline ? Spree::Images::NormalizeAssetJob.perform_now(asset.id) : Spree::Images::NormalizeAssetJob.perform_later(asset.id)
        queued += 1
      end

      puts "VALDRA image normalization queued=#{queued} skipped=#{skipped}"
    end
  end
end
