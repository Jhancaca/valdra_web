class CreateValdraCustomerProfiles < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL
      CREATE SCHEMA IF NOT EXISTS valdra_private;
      CREATE TABLE IF NOT EXISTS valdra_private.valdra_customer_profiles (
        spree_user_id bigint PRIMARY KEY REFERENCES public.spree_users(id) ON DELETE CASCADE,
        phone varchar(20) NOT NULL CHECK (phone ~ '^\\+[1-9][0-9]{7,14}$'),
        department_code varchar(8) NOT NULL,
        municipality_code varchar(16) NOT NULL,
        gender varchar(32),
        date_of_birth date NOT NULL CHECK (date_of_birth < CURRENT_DATE),
        privacy_consent_at timestamptz NOT NULL,
        created_at timestamptz NOT NULL DEFAULT now(),
        updated_at timestamptz NOT NULL DEFAULT now(),
        CONSTRAINT valdra_customer_profiles_gender_check CHECK (gender IS NULL OR gender IN ('male', 'female', 'non_binary', 'prefer_not_to_say'))
      );
      CREATE INDEX IF NOT EXISTS idx_valdra_customer_profiles_department ON valdra_private.valdra_customer_profiles (department_code);
    SQL
  end

  def down
    execute "DROP TABLE IF EXISTS valdra_private.valdra_customer_profiles"
  end
end
