module Spree
  module Api
    module V3
      module Store
        class CustomerRegistrationsController < CustomersController
          allow_guest_storefront_access!
          rate_limit to: Spree::Api::Config[:rate_limit_register], within: Spree::Api::Config[:rate_limit_window].seconds, store: Rails.cache, only: :create, with: RATE_LIMIT_RESPONSE
          skip_before_action :authenticate_user, only: :create

          DEPARTMENTS = {
            "AMA" => %w[AMA-LET], "ANT" => %w[ANT-MED ANT-BEL ANT-ENV ANT-ITA ANT-RIO], "ARA" => %w[ARA-ARA],
            "ATL" => %w[ATL-BAQ ATL-SOL ATL-MAL], "BOL" => %w[BOL-CTG BOL-MOM], "BOY" => %w[BOY-TUN BOY-DUI BOY-SOG],
            "CAL" => %w[CAL-MAN CAL-CHI], "CAQ" => %w[CAQ-FLO], "CAS" => %w[CAS-YOP], "CAU" => %w[CAU-POP],
            "CES" => %w[CES-VAL CES-AGU], "CHO" => %w[CHO-QUI], "COR" => %w[COR-MON COR-LOR],
            "CUN" => %w[CUN-BOG CUN-GIR CUN-SOI CUN-ZIP CUN-FAC], "GUA" => %w[GUA-INO], "GUV" => %w[GUV-SJG],
            "HUI" => %w[HUI-NEI HUI-PIT], "LAG" => %w[LAG-RIO LAG-MAI], "MAG" => %w[MAG-SMR MAG-CIE],
            "MET" => %w[MET-VIL MET-ACA], "NAR" => %w[NAR-PSO NAR-IPO], "NSA" => %w[NSA-CUC NSA-OCA],
            "PUT" => %w[PUT-MOC], "QUI" => %w[QUI-ARM QUI-CAL], "RIS" => %w[RIS-PER RIS-DOS], "SAP" => %w[SAP-SAN],
            "SAN" => %w[SAN-BUC SAN-FLO SAN-BAR], "SUC" => %w[SUC-SIN SUC-COR], "TOL" => %w[TOL-IBA TOL-ESP],
            "VAC" => %w[VAC-CAL VAC-BUE VAC-PAL VAC-TUL], "VAU" => %w[VAU-MIT], "VIC" => %w[VIC-PTO]
          }.freeze
          GENDERS = %w[male female non_binary prefer_not_to_say].freeze
          TOP_LEVEL_KEYS = %w[email password password_confirmation first_name last_name profile].freeze
          PROFILE_KEYS = %w[phone department_code municipality_code gender date_of_birth privacy_consent].freeze

          def create
            return render_error(code: "invalid_parameters", message: "Se enviaron campos no permitidos.", status: :bad_request) unless allowed_keys?

            user_params = params.permit(:email, :password, :password_confirmation, :first_name, :last_name)
            profile = normalized_profile
            return render_error(code: "invalid_profile", message: profile[:error], status: :unprocessable_content) if profile[:error]

            user = Spree.user_class.new(user_params.except(:current_password).merge(phone: profile[:phone]))
            ActiveRecord::Base.transaction do
              user.save!
              Valdra::CustomerProfile.create!(profile.except(:error).merge(spree_user_id: user.id, privacy_consent_at: Time.current))
              link_matching_newsletter_subscriber!(user)
            end
            refresh_token = Spree::RefreshToken.create_for(user, request_env: { ip_address: request.remote_ip, user_agent: request.user_agent&.truncate(255) })
            render json: { token: generate_jwt(user), refresh_token: refresh_token.token, user: user_serializer.new(user, params: serializer_params).to_h }, status: :created
          rescue ActiveRecord::RecordInvalid => error
            render_errors(error.record.errors)
          end

          private

          def allowed_keys?
            top = params.keys.map(&:to_s) - %w[controller action]
            profile_keys = params[:profile].respond_to?(:keys) ? params[:profile].keys.map(&:to_s) : []
            (top - TOP_LEVEL_KEYS).empty? && params[:profile].respond_to?(:permit) && (profile_keys - PROFILE_KEYS).empty?
          end

          def normalized_profile
            values = params.require(:profile).permit(*PROFILE_KEYS)
            raw_phone = values[:phone].to_s.gsub(/[\s().-]/, "")
            phone = if raw_phone.match?(/\A\d{10}\z/)
                      "+57#{raw_phone}"
                    elsif raw_phone.match?(/\A57\d{10}\z/)
                      "+#{raw_phone}"
                    elsif raw_phone.match?(/\A\+[1-9]\d{7,14}\z/)
                      raw_phone
                    end
            department = values[:department_code].to_s
            municipality = values[:municipality_code].to_s
            date = Date.iso8601(values[:date_of_birth].to_s) rescue nil
            valid = phone.present? && DEPARTMENTS.key?(department) && DEPARTMENTS[department].include?(municipality) && (values[:gender].blank? || GENDERS.include?(values[:gender].to_s))
            valid &&= date.present? && date < Date.current && values[:privacy_consent].to_s == "true"
            return { error: "Revisa teléfono, ubicación, fecha de nacimiento y consentimiento." } unless valid

            { phone: phone, department_code: department, municipality_code: municipality, gender: values[:gender].presence, date_of_birth: date }
          end
        end
      end
    end
  end
end
