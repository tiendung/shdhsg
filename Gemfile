source 'http://rubygems.org'

gem 'rails', '~> 3.1.0.beta' #, :git => 'https://github.com/rails/rails.git'

# Asset template engines
gem 'compass'
# gem 'compass-colors'
# gem 'compass-960-plugin'
# gem 'fancy-buttons'
gem 'sass'
gem 'coffee-script'
gem 'uglifier'
gem 'jquery-rails'

gem 'mongoid', :git => 'https://github.com/mongoid/mongoid.git'
gem 'bson_ext'
gem 'SystemTimer', :platforms => :ruby_18, :require => nil

gem 'settingslogic'
gem 'devise'
gem 'oa-oauth'
gem 'twitter'
gem 'twitter-text'

group :development, :test do
  gem 'faker'
  gem 'fabrication'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
  gem 'rspec-rails', :require => false
  gem 'mongoid-rspec'
  gem 'remarkable_mongoid', :require => 'remarkable/mongoid'
end

group :production do
  gem 'therubyracer-heroku', '0.8.1.pre3', :platforms => :ruby
end
