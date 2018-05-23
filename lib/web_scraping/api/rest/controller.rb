# frozen_string_literal: true

require 'sinatra/base'

require "#{$lib}/web_scraping"

require_relative 'helpers'

module WebScraping
  # Пространство имён для API
  module API
    # Пространство имён для REST API
    module REST
      # Класс контроллера REST API, основанный на Sinatra
      class Controller < Sinatra::Base
        helpers Helpers

        # Значение заголовка `Content-Type`
        CONTENT_TYPE =
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
          .freeze

        # Возвращает результат скрапинга коментариев с ресурса bnkomi
        # @param [Hash] params
        #  параметры запроса
        # @return [Status]
        #   200
        get '/api/bnk/comments' do
          slice_params = params.slice(:start, :finish)
          content = WebScraping.bnk_scraping_comments(slice_params)
          content_type CONTENT_TYPE
          headers 'Content-Disposition' =>
            make_content_diposition('bnk', slice_params)
          status :ok
          body content.stream.read
        end

        # Возвращает результат скрапинга статистики просмотров
        # и вовлеченности с ресурса bnkomi
        # @param [Hash] params
        #  параметры запроса
        # @return [Status]
        #   200
        get '/api/bnk/stat' do
          slice_params = params.slice(:start, :finish)
          content = WebScraping.bnk_scraping_stat(slice_params)
          content_type CONTENT_TYPE
          headers 'Content-Disposition' =>
            make_content_diposition('bnkstat', slice_params)
          status :ok
          body content.stream.read
        end

        # Возвращает результат скрапинга коментариев с ресурса komiinform
        # @param [Hash] params
        #  параметры запроса
        # @return [Status]
        #  200
        get '/api/komiinform/comments' do
          slice_params = params.slice(:start, :finish)
          content = WebScraping.komiinform_scraping_comments(slice_params)
          content_type CONTENT_TYPE
          headers 'Content-Disposition' =>
            make_content_diposition('komiinform', slice_params)
          status :ok
          body content.stream.read
        end

        # Задаёт index.erb view по умолчанию для всех get запросов
        get '/*' do
          erb :index
        end
      end
    end
  end
end
