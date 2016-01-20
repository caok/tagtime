source 'https://rubygems.org'

ruby '2.2.0'

gem 'rails', '4.2.5'
gem 'sass-rails', '~> 5.0.4'
gem 'uglifier', '>= 2.7.2'
gem 'pg'

gem 'jquery-rails'
gem 'jbuilder', '~> 2.3.2'
gem 'cancancan'
gem 'meta-tags'
gem 'figaro'
gem 'activeadmin', github: 'activeadmin'
gem 'active_admin_theme'
gem 'active_skin'
gem 'active_admin_datetimepicker'
gem 'kaminari'
gem 'devise', '3.5.3'
gem 'react-rails', '~> 1.5.0'
gem 'aasm'
gem 'chartkick'

# Picture manage
gem 'carrierwave'
gem 'mini_magick'

# Css framework
gem 'nprogress-rails'
gem 'normalize-rails'
gem 'neat'
gem 'font-awesome-rails'
gem 'select2-rails'

group :development, :test do
  gem 'thin'
  gem 'quiet_assets'
  gem 'better_errors' 
  gem 'annotate'
  gem 'ffaker'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'brakeman', require: false
end

group :production do
  gem 'unicorn' 
end

# deploy
group :development, :production do
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
end 
