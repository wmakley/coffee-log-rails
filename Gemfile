# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.8"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem "rails", "~> 7.2.2"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Enable more effecient bulk queries
gem "postgresql_cursor"
# Full-text search
gem "pg_search"

# Support CORS requests from CDN
gem "rack-cors", ">= 2.0.2"

# Use Puma as the app server
gem "puma", ">= 6.4.2"

# use import maps for JS
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '>= 4.0.1'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

# Custom stuff
gem "dotenv-rails", groups: %i[development test]

# image uploads
gem "aws-sdk-s3", require: false
# email sending
gem "aws-sdk-sesv2"

# auditing of certain tables
# gem 'paper_trail'

# authorization
gem "action_policy"

# additional security on login and forgot password
gem "recaptcha", "~> 5.15"

# exception monitoring
gem "sentry-ruby"
gem "sentry-rails"

group :development, :test do
  gem "rubocop", require: false
  gem "rubocop-minitest", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-performance", require: false
  gem "standard", require: false
  gem "standard-rails", require: false

  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false
end

group :development do
  gem "annotate", "~> 3.2.0"

  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  # gem "rubocop-rails-omakase", require: false
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  # gem 'webdrivers'
  gem "timecop"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
