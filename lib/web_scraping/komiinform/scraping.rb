# frozen_string_literal: true

module WebScraping
  # Пространство имен для класса предоставляющего методы для скрапинга ресурса
  # komiinform.ru
  module Komiinform
    # Класс предоставляющий методы для скрапинга ресурса
    # komiinform.ru
    class Scraping < WebScraping::Base::Dates
      # Инициализирует объект класса
      def initialize(params)
        super(params)
        @base_url = 'http://komiinform.ru'
        @comments_url = 'http://service.komiinform.ru/commentservice/'
      end

      attr_reader :base_url, :comments_url

      # Парсит страницы со статьями по заданным датам и формирует отчет в xlsx
      def scraping
        Base::ReportToXLSX.new.create_report(scraping_articles)
      end

      private

      # Парсит лист со статьями WebScraping::Komiinform::Scraping.new('10.04.2018', '10.04.2018').scraping
      def scraping_articles
        dates_list.each_with_object([]) do |date, memo|
          url = base_url + '/curdate/' + date
          html = open(url)
          doc = Nokogiri::HTML(html)
          list = doc.at_css("[class=' b-news']").css('.smallHeader2')
          list.each do |item|
            date = date.gsub('-', '.')
            title = item.children.text.strip
            href = item['href']
            link = base_url + href
            comments = scraping_comments(href)
            memo << [date, title, comments, link]
          end
        end
      end

      # Парсит комментарии к статье
      def scraping_comments(href)
        url = comments_url + href.gsub(/[^0-9]/, '')
        html = open(url)
        doc = Nokogiri::HTML(html)
        comments_list = doc.css('.mCommentList').css('li')
        comments_list.each_with_object([]) do |comment, memo|
          author = comment.css('.name').first.text.strip
          date = comment.css('.date').first.text.strip
          comment_text = comment.css('.txt').first.text.strip
          memo << [author, date, comment_text]
        end
      end
    end
  end
end
