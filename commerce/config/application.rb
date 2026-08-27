require_relative "boot"

require "rails"
require_relative "../app/middleware/admin_login_rate_limit"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Commerce
  class Application < Rails::Application

    config.to_prepare do
      # Load application's model / class decorators
      # Pathname#glob is used instead of a string glob containing `..`. Ruby's
      # Windows globber does not reliably expand that form, which meant the
      # decorators were silently skipped after a Rails restart.
      Rails.root.glob("app/**/*_decorator*.rb").sort.each do |path|
        decorator_path = path.to_s
        Rails.configuration.cache_classes ? require(decorator_path) : load(decorator_path)
      end
    end
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])
    config.middleware.insert_before 0, AdminLoginRateLimit

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end
