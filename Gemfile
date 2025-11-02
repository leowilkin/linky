source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '>= 3.3.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.5'
# Use Puma as the app server
gem 'puma', '~> 6.4'
# Use Sprockets for assets
gem 'sprockets-rails', '~> 3.5'
# Use SCSS for stylesheets
gem 'sassc-rails', '~> 2.1'
# Use Terser as compressor for JavaScript assets
gem 'terser', '>= 1.1'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 5.0'

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.6'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.2'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.12'

gem 'bootstrap-sass', '~> 3.4.1'
gem 'simple_form', '~> 5.3'
gem 'font-awesome-rails', '~> 4.7.0.8'
gem 'will_paginate', '~> 3.3'
gem 'data-confirm-modal', '~> 1.2.0'

# Reduces boot times through caching
gem 'bootsnap', '>= 1.16.0', require: false

# OAuth authentication
gem 'omniauth', '~> 2.1'
gem 'omniauth-oauth2', '~> 1.8'
gem 'omniauth-rails_csrf_protection', '~> 1.0'

group :development, :test do
  # Call 'debug' anywhere in the code to stop execution and get a debugger console
  gem 'debug', platforms: :mri
  # Load environment variables from .env file
  gem 'dotenv-rails'
  # Linting and security tools
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '~> 4.2'
  gem 'listen', '~> 3.8'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:windows, :jruby]
