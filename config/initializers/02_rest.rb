# frozen_string_literal: true

# Файл настройки REST-контроллера

# Загрузка REST-контроллера
require "#{$lib}/api/rest/controller.rb"
# Загрузка поддержки исключений
require "#{$lib}/api/rest/errors.rb"

# Установка конфигурации REST-контроллера
WebScraping::API::REST::Controller.configure do |settings|
  settings.set    :bind, ENV['WS_BIND']
  settings.set    :port, ENV['WS_PORT']

  settings.disable :show_exceptions
  settings.enable  :dump_errors
  settings.enable  :raise_errors

  settings.use    Rack::CommonLogger, $logger

  settings.enable :static
  settings.set    :root, $root
  settings.set    :public_folder, "#{$root}/dist"
end
