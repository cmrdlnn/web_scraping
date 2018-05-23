# frozen_string_literal: true

require 'json'

require "#{$lib}/helpers/log"

module WebScraping
  module API
    module REST
      # Обработка ошибок
      module Errors
        include WebScraping::Helpers::Log

        # Модуль вспомогательных методов
        module Helpers
          # Возвращает объект, связанный с ошибкой
          # @return [Exception]
          #   объект-исключение
          def error
            env['sinatra.error']
          end
        end

        # Отображение классов ошибок в коды ошибок
        ERRORS_MAP = {
          ArgumentError => 422,
          RuntimeError  => 422,
        }.freeze

        # Регистрация в контроллере обработчиков ошибок
        #
        # @param [WebScraping::API::REST::Controller] controller
        #   контроллер
        #
        def self.registered(controller)
          controller.helpers Helpers

          # Регистрирация обработчиков ошибок
          #
          ERRORS_MAP.each do |error_class, error_code|
            controller.error error_class do
              message = error.message
              log_error { <<~LOG }
                #{app_name_upcase} ERROR #{error.class} WITH MESSAGE #{message}
              LOG

              status error_code
              content = { message: message, error: error.class }
              body content.to_json
            end
          end

          # Обработчик всех остальных ошибок
          # @return [Status]
          #   код ошибки
          # @return [Hash]
          #   ассоциативный массив
          controller.error 500 do
            log_error { <<~LOG }
              #{app_name_upcase} ERROR #{error.class} WITH MESSAGE
              #{error.message} AT #{error.backtrace.first(3)}
            LOG

            status 500
            content = { message: error.message, error: error.class }
            body content.to_json
          end
        end
      end

      Controller.register Errors
    end
  end
end
