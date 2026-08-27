# frozen_string_literal: true

require "open3"
require "shellwords"
require "tempfile"

module Spree
  module Images
    class NormalizeAssetJob < ApplicationJob
      queue_as :default

      retry_on StandardError, wait: 10.seconds, attempts: 3

      MAX_SOURCE_BYTES = 12.megabytes
      ALLOWED_CONTENT_TYPES = %w[image/jpeg image/png image/webp].freeze

      def perform(asset_id, force: false)
        asset = Spree::Asset.find_by(id: asset_id)
        return unless asset

        source = asset.source_attachment
        return unless source.attached?
        return if asset.valdra_normalized? && !force

        source_blob = source.blob
        mark_status(source_blob, "pending")
        validate_source!(source_blob)

        input = Tempfile.new(["valdra-source-", source_blob.filename.extension_with_delimiter])
        output = Tempfile.new(["valdra-normalized-", ".webp"])
        input.binmode
        output.close
        input.write(source_blob.download)
        input.close

        run_normalizer!(input.path, output.path)
        validate_output!(output.path)

        asset.reload
        asset.attachment.detach if asset.attachment.attached?
        File.open(output.path, "rb") do |normalized_file|
          asset.attachment.attach(
            io: normalized_file,
            filename: "#{asset.id}-normalized.webp",
            content_type: "image/webp"
          )
        end
        asset.attachment.blob.update!(metadata: asset.attachment.blob.metadata.merge(
          "valdra_normalization_status" => "ready",
          "valdra_normalization_version" => 1
        ))
        source_blob.update!(metadata: source_blob.metadata.merge(
          "valdra_normalization_status" => "ready",
          "valdra_normalization_version" => 1
        ))
        asset.touch
      rescue StandardError => error
        mark_status(source_blob, "failed", error.message) if source_blob
        Rails.logger.error("VALDRA image normalization failed for asset #{asset_id}: #{error.class}: #{error.message}")
        raise
      ensure
        input&.close!
        output&.close!
      end

      private

      def validate_source!(blob)
        raise "unsupported image type" unless ALLOWED_CONTENT_TYPES.include?(blob.content_type)
        raise "image exceeds #{MAX_SOURCE_BYTES / 1.megabyte} MB" if blob.byte_size > MAX_SOURCE_BYTES
      end

      def run_normalizer!(input_path, output_path)
        command = Shellwords.split(ENV.fetch("VALDRA_IMAGE_NORMALIZER_COMMAND", "python3"))
        script = Rails.root.join("lib", "valdra", "image_normalizer.py").to_s
        stdout, stderr, status = Open3.capture3(*command, script, input_path, output_path)
        return if status.success?

        detail = [stderr, stdout].reject(&:blank?).join(" | ")
        raise "normalizer exited with #{status.exitstatus}: #{detail.presence || 'unknown error'}"
      end

      def validate_output!(path)
        raise "normalizer produced no file" unless File.file?(path) && File.size?(path)
        raise "normalized image exceeds 5 MB" if File.size(path) > 5.megabytes
      end

      def mark_status(blob, status, error = nil)
        return unless blob

        metadata = blob.metadata.merge("valdra_normalization_status" => status)
        metadata["valdra_normalization_error"] = error.to_s.first(500) if error.present?
        blob.update!(metadata: metadata)
      rescue StandardError => metadata_error
        Rails.logger.warn("VALDRA could not persist image status: #{metadata_error.message}")
      end
    end
  end
end
