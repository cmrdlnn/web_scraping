# frozen_string_literal: true

require "#{$lib}/helpers/log"

module WebScraping
  module API
    module REST
      # @author Алейников Максим <m.v.aleinikov@gmail.com>
      #
      # Модуль вспомогательных функций для REST-контроллера
      #
      module Helpers
        include WebScraping::Helpers::Log

        # Возвращает название сервиса в верхнем регистре без знаков
        # подчёркивания и дефисов. Необходимо для журнала событий.
        # @return [String]
        #   преобразованное название сервиса
        def app_name_upcase
          $app_name.upcase.tr('-', '_')
        end

        # Добавляет в журнал событий запись о запросе
        #
        def log_request
          log_debug(binding) { <<-LOG }
            #{app_name_upcase} #{request.request_method} REQUEST WITH URL
            #{request.url}, PARAMS #{params} AND BODY #{request.body}
          LOG
        end

        # Добавляет в журнал событий запись о возвращаемом ответе
        def log_response
          log_debug(binding) do
            parts = [app_name_upcase, 'RESPONSE WITH STATUS', response.status]
            parts.push('AND BODY', body) if body.present?
            parts.join(' ')
          end
        end

        # Формирует заголовок для контента
        # @params [String] site
        #  название ресурса
        # @params [Hash] params
        #  ассоциативнй массив с начальной и онечной датой
        # @return [String]
        #  сформированный заголовок
        def make_content_diposition(site, params)
          start = params[:start]
          finish = params[:finish]
          filename =
            site + '_' + start.tr('-', '.') +
            '_' + finish.tr('-', '.') + '.xlsx'
          "attachment; filename=#{filename}"
        end

        def action_params
          params.compact.tap { |hash| hash.delete(:captures) }
        end
      end
    end
  end
end
