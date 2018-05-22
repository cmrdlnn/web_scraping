# frozen_string_literal: true

module WebScraping
  module Bnk
    # Класс объектов для скрапинга ресурса bnkomi.ru и создающего отчет
    # по статистике просмотров и вовлеченности
    class ScrapingStat < WebScraping::Base::Dates
      # Инициализирует объект класса
      def initialize(params)
        super(params)
        @base_url = 'http://bnkomi.ru'
      end

      attr_reader :base_url

      # Парсит страницы со статьями по заданным датам и формирует отчет в xlsx
      def scraping
        Base::ReportStatToXLSX.new.create_report(scraping_articles)
      end

      private

      # Парсит лист со статьями
      def scraping_articles
        dates_list.each_with_object([]) do |date, memo|
          url = base_url + '/data/news/curdate/' + date
          html = open(url)
          doc = Nokogiri::HTML(html)
          list = doc.css('.b-news-list').css('.item')
          articles = list.each_with_object([]) do |item, news|
            item.css('.date').children.each { |c| c.remove if c.name == 'span' }
            date = item.css('.date').children.text.strip
            title = item.css('.title').text.strip
            href = item.css('.title').at_css('a')['href']
            link = base_url + href
            comments_number = item
                              .css('.utils')
                              .css('.comments')
                              .text.strip.to_i
            views = item.css('.utils').css('.views').text.strip.to_i
            involvement = coefficient_of_involvement(views, comments_number)
            news << [date, title, views, comments_number, involvement, link]
          end
          memo << articles
        end
      end

      # Вычисляет коэффициент вовлеченности
      # @params [Integer] views
      #  количество просмотров
      # @params [Integer] comments_number
      #  количество комментариев
      # @return [Float]
      #  коэффициент вовлеченности
      def coefficient_of_involvement(views, comments_number)
        return 0 if views.zero? || comments_number.zero?
        coeff = (25_329 / views.to_f) / (1047 / comments_number.to_f)
        coeff.ceil(2)
      end
    end
  end
end
