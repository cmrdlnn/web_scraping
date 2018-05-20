# frozen_string_literal: true

require 'sinatra/base'

require_relative 'helpers'

module WebScraping
  # Пространство имён для API
  module API
    # Пространство имён для REST API
    module REST
      # Класс контроллера REST API, основанный на Sinatra
      class Controller < Sinatra::Base
        helpers Helpers

        # Значение заголовка `Content-Disposition`
        CONTENT_DISPOSITION = 'attachment; filename="presence_report.xlsx"'

        # Значение заголовка `Content-Type`
        CONTENT_TYPE = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'

        # Возвращает результат скрапинга коментариев с ресурса bnkomi
        # @param [Hash] params
        #  параметры запроса
        # @return [Status]
        #   200
        get '/api/bnk/comments' do
          slice_params = params.slice(:date_start, :date_finish)
          content = WebScraping.bnk_scraping(slice_params)
          content_type CONTENT_TYPE
          headers 'Content-Disposition' => CONTENT_DISPOSITION
          status :ok
          body content.stream.read
        end

        # Возвращает результат скрапинга коментариев с ресурса komiinform
        # @param [Hash] params
        #  параметры запроса
        # @return [Status]
        #  200
        get '/api/komiinform/comments' do
          slice_params = params.slice(:date_start, :date_finish)
          content = WebScraping.komiinform_scraping(slice_params)
          content_type CONTENT_TYPE
          headers 'Content-Disposition' => CONTENT_DISPOSITION
          status :ok
          body content.stream.read
        end

        # Задаёт index.erb view по умолчанию для всех get запросов
        #
        get '/*' do
          erb :index
        end
      end
    end
  end
end
