module Valdra
  class CustomerProfile < ApplicationRecord
    self.table_name = "valdra_private.valdra_customer_profiles"

    GENDERS = %w[male female non_binary prefer_not_to_say].freeze

    belongs_to :spree_user, class_name: "Spree::LegacyUser", foreign_key: :spree_user_id

    validates :phone, presence: true, format: { with: /\A\+[1-9]\d{7,14}\z/ }
    validates :department_code, :municipality_code, :date_of_birth, :privacy_consent_at, presence: true
    validates :gender, inclusion: { in: GENDERS }, allow_nil: true
    validate :date_of_birth_is_past

    private

    def date_of_birth_is_past
      errors.add(:date_of_birth, "debe ser una fecha pasada") if date_of_birth.present? && date_of_birth >= Date.current
    end
  end
end
