# encoding: utf-8

namespace :web_scraping do
  desc 'Запускает контроллер REST API'
  task :run_rest_controller do
    require_relative 'config/app_init'

    WebScraping::API::REST::Controller.run!
  end
end
