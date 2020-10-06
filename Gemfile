source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.7'
gem 'rails', '~> 6.0.3', '>= 6.0.3.1'
gem 'bootsnap', '>= 1.4.2', :require => false

# トークン認証
gem 'jwt'
gem 'url_safe_base64'

#サーバ
gem 'puma', '~> 4.1'

#CORS
gem 'rack-cors'


#DB
group :development, :test do
  gem 'sqlite3', '~> 1.4'
end
group :production do
  gem 'pg'
end

group :development do
  gem 'byebug', :platforms => [:mri, :mingw, :x64_mingw]
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rubocop', :require => false
  gem 'rubocop-performance', :require => false
  gem 'rubocop-rails', :require => false
  gem 'rubocop-rspec'
  gem 'bullet'
  gem 'rspec-rails', '~> 4.0.1'
end

group :test do
  gem 'byebug', :platforms => [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 4.0.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', :platforms => [:mingw, :mswin, :x64_mingw, :jruby]
