class Admin::BaseController < ApplicationController
  http_basic_authenticate_with(
    name: ENV.fetch("ADMIN_USERNAME", "admin"),
    password: ENV.fetch("ADMIN_PASSWORD", SecureRandom.hex(16))
  )

  layout "admin"
end
