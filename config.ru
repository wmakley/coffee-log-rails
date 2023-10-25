# This file is used by Rack-based servers to start the application.
require "rack/cors"

use Rack::Cors do
  allow do
    origins "*"
    resource "/assets/*", headers: :any, methods: [:get]
  end
end

require_relative "config/environment"

run Rails.application
Rails.application.load_server
