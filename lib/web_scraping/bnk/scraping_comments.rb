# frozen_string_literal: true

require 'thwait'

module WebScraping
  # Пространство имен для класса предоставляющего методы для скрапинга ресурса
  # bnkomi.ru
  module Bnk
    # Класс предоставляющий методы для скрапинга ресурса
    # bnkomi.ru
    class ScrapingComments < WebScraping::Base::Dates
      # Инициализирует объект класса
      def initialize(params)
        super(params)
        @base_url = 'http://bnkomi.ru'
      end

      attr_reader :base_url

      # Парсит страницы со статьями по заданным датам и формирует отчет в xlsx
      def scraping
        Base::ReportCommentsToXLSX.new.create_report(scraping_articles)
      end

      private

      # Парсит лист со статьями
      def scraping_articles
        threads = []
        dates_list.each_with_object([]) do |date, memo|
          threads << Thread.new do
            url = base_url + '/data/news/curdate/' + date
            html = open(url)
            doc = Nokogiri::HTML(html)
            list = doc.css('.b-news-list').css('.item')
            list.each do |item|
              item.css('.date').children.each { |c| c.remove if c.name == 'span' }
              date = item.css('.date').children.text.strip
              title = item.css('.title').text.strip
              href = item.css('.title').at_css('a')['href']
              link = base_url + href
              comments_count = item
                               .css('.utils')
                               .css('.comments')
                               .text.strip.to_i
              if comments_count.zero?
                comments = []
              else
                comments = scraping_comments(href)
              end
              memo << [date, title, comments, link]
            end
          end
          ThreadsWait.all_waits(*threads)
        end
      end

      # Парсит комментарии к статье
      def scraping_comments(href)
        url = base_url + href
        html = open(url)
        doc = Nokogiri::HTML(html)
        comments_list = doc.css('.mCommentList').css('.author')
        comments_list.each_with_object([]) do |comment, memo|
          author = comment.css('.commentauthor').css('b').text.strip
          date = comment.css('.date').text.strip
          comment_text = comment.at_css("[class='comment txt']").text.strip
          memo << [author, date, comment_text]
        end
      end
    end
  end
end
