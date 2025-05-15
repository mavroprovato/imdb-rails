# frozen_string_literal: true

source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.2"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use sqlite3 as the database for Active Record
gem "sqlite3", ">= 2.1"
# Use Postgres as the database for Active Record
gem "pg", "~> 1.5"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cable"
gem "solid_cache"
gem "solid_queue"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Add Faraday for HTTP requests
gem "faraday", "~> 2.13"

# A library for bulk insertion of data into your database using ActiveRecord [https://github.com/zdennis/activerecord-import]
gem "activerecord-import", "~> 2.1"

group :development do
  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Rubocop for static analysis [https://github.com/rubocop/rubocop]
  gem "rubocop"

  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"

  # Factory bot for generating test data [https://github.com/thoughtbot/factory_bot_rails]
  gem "factory_bot_rails"

  # Rspec for testing [https://rspec.info/]
  gem "rspec-rails"

  # An extension of RuboCop focused on code performance checks [https://github.com/rubocop/rubocop-performance]
  gem "rubocop-performance", "~> 1.25"

  # Code style checking for factory_bot files [https://github.com/rubocop/rubocop-factory_bot]
  gem "rubocop-factory_bot", "~> 2.27"

  # A RuboCop extension focused on enforcing Rails best practices and coding conventions [https://github.com/rubocop/rubocop-rails]
  gem "rubocop-rails", "~> 2.31"

  # Code style checking for RSpec files [https://github.com/rubocop/rubocop-rspec]
  gem "rubocop-rspec", "~> 3.6"

  # Code style checking for Rails-related RSpec files [https://github.com/rubocop/rubocop-rspec_rails]
  gem "rubocop-rspec_rails", "~> 2.31"

  # One-liners to test common Rails functionality
  gem "shoulda-matchers", "~> 6.0"
end
