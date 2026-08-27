# frozen_string_literal: true

module Valdra
  module SpreeAssetDecorator
    extend ActiveSupport::Concern

    included do
      # Keep local development compatible with the existing public bucket. In
      # production, setting SUPABASE_PRIVATE_BUCKET moves originals to a
      # private service while normalized derivatives remain public.
      source_service = ENV["SUPABASE_PRIVATE_BUCKET"].to_s.empty? ? Spree.public_storage_service_name : :supabase_private
      has_one_attached :source_attachment, service: source_service

      after_commit :prepare_valdra_image_normalization, on: :create
    end

    def valdra_normalization_status
      return "missing" unless source_attachment.attached? || attachment.attached?

      blobs = []
      blobs << attachment.blob if attachment.attached?
      blobs << source_attachment.blob if source_attachment.attached?
      blob = blobs.find { |candidate| candidate.metadata["valdra_normalization_status"] == "ready" } || blobs.first
      blob.metadata.fetch("valdra_normalization_status", "pending")
    end

    def valdra_normalized?
      valdra_normalization_status == "ready"
    end

    private

    def prepare_valdra_image_normalization
      return unless media_type == "image" && attachment.attached?
      return if valdra_normalized? || source_attachment.attached?

      source_attachment.attach(attachment.blob)
      attachment.detach
      Spree::Images::NormalizeAssetJob.perform_later(id)
    rescue StandardError => error
      Rails.logger.error("VALDRA image normalization could not be queued for asset #{id}: #{error.message}")
    end
  end
end

Spree::Asset.include(Valdra::SpreeAssetDecorator) unless Spree::Asset < Valdra::SpreeAssetDecorator
