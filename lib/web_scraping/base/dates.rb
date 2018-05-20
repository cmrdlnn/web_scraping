# frozen_string_literal: true

module WebScraping
  module Base
    # Базовый класс для формирования списка дат заданного диапазона
    class Dates
      # Инициализирует объект класса
      def initialize(date_start, date_finish)
        @date_start = date_start
        @date_finish = date_finish
      end

      attr_reader :date_start, :date_finish

      # Возвращает список дат заданного диапазона
      # @return [Array<String>]
      #  список дат заданного диапазона
      def dates_list
        date_start = Date.parse(@date_start)
        date_finish = Date.parse(@date_finish)
        list = []
        while date_start <= date_finish
          list << date_start.strftime("%d-%m-%Y")
          date_start += 1
        end
        list
      end
    end
  end
end
