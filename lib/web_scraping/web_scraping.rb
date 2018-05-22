# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'date'

require_relative 'base/report_comments_to_xlsx'
require_relative 'base/report_stat_to_xlsx'
require_relative 'base/dates'

Dir["#{__dir__}/bnk/*.rb"].each(&method(:load))
load "#{__dir__}/komiinform/scraping_comments.rb"

# Модуль реализующий парсинг web-ресурсов
module WebScraping
  # Парсит комментарии к статьям на ресурсе `bnlkomi.ru`
  # возвращает файл с отчетом в формате `xlsx`
  #  @params [Hash]
  #   параметры для парсинга
  def self.bnk_scraping_comments(params)
    Bnk::ScrapingComments.new(params).scraping
  end

  # Парсит статистику просмотров и вовлеченность на ресурсе `bnlkomi.ru`
  # возвращает файл с отчетом в формате `xlsx`
  #  @params [Hash]
  #   параметры для парсинга
  def self.bnk_scraping_stat(params)
    Bnk::ScrapingStat.new(params).scraping
  end

  # Парсит комментарии к статьям на ресурсе `komiinform.ru`
  # возвращает файл с отчетом в формате `xlsx`
  #  @params [Hash]
  #   параметры для парсинга
  def self.komiinform_scraping_comments(params)
    Komiinform::ScrapingComments.new(params).scraping
  end
end
