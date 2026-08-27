# frozen_string_literal: true

class AdminLoginRateLimit
  WINDOW = 60
  MAX_REQUESTS = 5

  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    return @app.call(env) unless request.post? && request.path == "/admin/login"

    key = "valdra:admin-login:#{request.ip}"
    count = Rails.cache.increment(key, 1, expires_in: WINDOW.seconds)
    return [429, { "content-type" => "text/plain", "retry-after" => WINDOW.to_s }, ["Too many login attempts"]] if count && count > MAX_REQUESTS

    @app.call(env)
  end
end
