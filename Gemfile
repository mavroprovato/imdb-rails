# frozen_string_literal: true

source 'https://rubygems.org'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 8.0.2'
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem 'propshaft'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '>= 2.1'
# Use Postgres as the database for Active Record
gem 'pg', '~> 1.5'
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem 'solid_cable', '~> 3.0'
gem 'solid_cache', '~> 1.0'
gem 'solid_queue', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.18', require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem 'kamal', '~> 2.7', require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem 'thruster', '~> 0.1.15', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Add Faraday for HTTP requests
gem 'faraday', '~> 2.14'

# A library for bulk insertion of data into your database using ActiveRecord [https://github.com/zdennis/activerecord-import]
gem 'activerecord-import', '~> 2.1'

# Simple, Fast, and Declarative Serialization Library for Ruby [https://github.com/procore-oss/blueprinter]
gem 'blueprinter', '~> 1.1.2'

# Ruby gem with ISO 639-1 and ISO 639-2 language code entries and convenience methods. [https://github.com/xwmx/iso-639]
gem 'iso-639', '~> 0.3.8'

# All sorts of useful information about every country packaged as convenient little country objects. [https://github.com/countries/countries].
gem 'countries', '~> 8.0.2'

group :development do
  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem 'brakeman', '~> 7.1', require: false

  # Rubocop for static analysis [https://github.com/rubocop/rubocop]
  gem 'rubocop', '~> 1.81'

  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console', '~> 4.2.0'
end

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'

  # Factory bot for generating test data [https://github.com/thoughtbot/factory_bot_rails]
  gem 'factory_bot_rails', '~> 6.5'

  # Rspec for testing [https://rspec.info/]
  gem 'rspec-rails', '~> 8.0'

  # An extension of RuboCop focused on code performance checks [https://github.com/rubocop/rubocop-performance]
  gem 'rubocop-performance', '~> 1.25'

  # Code style checking for factory_bot files [https://github.com/rubocop/rubocop-factory_bot]
  gem 'rubocop-factory_bot', '~> 2.27'

  # A RuboCop extension focused on enforcing Rails best practices and coding conventions [https://github.com/rubocop/rubocop-rails]
  gem 'rubocop-rails', '~> 2.33'

  # Code style checking for RSpec files [https://github.com/rubocop/rubocop-rspec]
  gem 'rubocop-rspec', '~> 3.6'

  # Code style checking for Rails-related RSpec files [https://github.com/rubocop/rubocop-rspec_rails]
  gem 'rubocop-rspec_rails', '~> 2.31'

  # One-liners to test common Rails functionality
  gem 'shoulda-matchers', '~> 6.5'

  # Code coverage for Ruby [https://github.com/simplecov-ruby/simplecov]
  gem 'simplecov', '~> 0.21'
end
