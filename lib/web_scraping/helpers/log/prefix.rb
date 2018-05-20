# frozen_string_literal: true

module WebScraping
  module Helpers
    module Log
      # Вспомогательный класс, объекты которого формируют префикс с
      # дополнительной информацией для строки с сообщением в журнале событий
      class Prefix
        # Контекст, из которого извлекается информация
        # @return [Binding]
        #   контекст, из которого извлекается информация
        attr_reader :context

        # Инициализирует объект класса
        # @param [Binding] context
        #   контекст, из которого извлекается информация
        def initialize(context)
          @context = context
        end

        # Возвращает строку с префиксом. Префикс состоит из блоков информации,
        # разделённых пробелами. Каждый блок информации представляется собой
        # строку, обрамлённую квадратными скобками. В начале префикса идут
        # блоки с дополнительной информацией, если таковые присутствуют в
        # аргументах метода, после чего идёт информация о классе, методе и
        # строке метода, полученной по контексту, если контекст является
        # объектом класса `Binding`. Если контекст не является объектом класса
        # `Binding`, то эта информация опускается. Кроме того, опускаются блоки
        # с пустыми строками.
        # @param [Array<#to_s>] tags
        #   список дополнительных блоков с информацией
        # @return [String]
        #   строка с префиксом
        def prefix(*tags)
          tags
            .concat(eval_strings)
            .find_all(&:present?)
            .map { |tag| "[#{tag}]" }
            .join(' ')
        end

        private

        # Список строк, вычисляемых в контексте
        EVAL_STRINGS = ['self.class', '__method__', '__LINE__']

        # Возвращает список с информацией, которая извлекается из контекста
        # @return [Array]
        #   список с информацией
        def eval_strings
          return [] unless context.is_a?(Binding)
          EVAL_STRINGS.map(&context.method(:eval))
        end
      end
    end
  end
end