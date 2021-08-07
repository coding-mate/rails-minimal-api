source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.1"

gem "rails", "~> 6.1.4"
gem "sqlite3", "~> 1.4"
gem "puma", "~> 5.0"
# gem 'bcrypt', '~> 3.1.7'

gem "bootsnap", ">= 1.4.4", require: false

# gem 'rack-cors'

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "brakeman", require: false
  gem "bullet"
  gem "bundle-audit", require: false
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "letter_opener"
  gem "rails_best_practices"
  gem "rspec-rails"
  gem "standardrb"
  gem "webmock"
end

group :development do
  gem "listen", "~> 3.3"
  gem "spring"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
