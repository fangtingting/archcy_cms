source 'https://gems.ruby-china.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
gem 'sqlite3'
gem 'mysql2', '~> 0.3.18'
# 连接oracle
# gem 'ruby-oci8'
# gem 'activerecord-oracle_enhanced-adapter'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc


gem 'mini_magick'
gem 'radius'
# 分页
gem 'will_paginate'
# gem 'will_paginate-bootstrap'
# gem 'ckeditor'
gem 'ckeditor'
gem 'aliyun-oss'
# gem 'oneapm_rpm'

# 搜索表单
gem 'ransack'

# 全文搜索
gem 'sunspot'
gem 'sunspot_rails'
gem 'redis'

# 操作excel
gem 'spreadsheet', '~> 1.0.3'

gem 'rest-client'
# gem 'aliyun-oss'

gem  "minitest"
gem  "zip"
# 定时执行
gem 'sidekiq'
gem 'sidekiq-scheduler', '~> 2.0'

# 邮件提醒报错
gem 'exception_notification', '~> 4.0.1'

gem 'haml-rails'

# 日历
gem 'fullcalendar-rails'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

# 加载vendor下面的gems
rails_root = File.expand_path(File.dirname(__FILE__))
vendor_gems = File.join(rails_root, 'vendor/gems')
glob = File.join(vendor_gems, '*')

Dir.glob(glob) do |gemdir|
  gemname, version = File.basename(gemdir).split('-')
  gem(gemname, :path => "#{ rails_root }/vendor/gems/#{ gemname }-#{ version }")
end