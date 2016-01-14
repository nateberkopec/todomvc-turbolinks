source 'https://rubygems.org'

ruby '2.3.0'

gem 'rails', github: "rails/rails"

gem 'pg'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem "jquery-rails"
gem 'turbolinks', github: 'rails/turbolinks'
gem 'puma'

group :development, :test do
  gem 'spring'
  gem 'stackprof'
  gem 'rack-mini-profiler'
  gem 'flamegraph'
  gem 'pry'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end

group :production do
  gem 'rails_12factor'
end
