# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'date'

require_relative 'base/report_to_xlsx'
require_relative 'base/dates'

load "#{__dir__}/bnk/scraping.rb"
load "#{__dir__}/komiinform/scraping.rb"

# Модуль реализующий парсинг web-ресурсов
module WebScraping
  # Парсит комментарии к статьям на ресурсе `bnlkomi.ru`
  # возвращает файл с отчетом в формате `xlsx`
  #  @params [Hash]
  #   параметры для парсинга
  def self.bnk_scraping(params)
    Bnk::Scraping.new(params).scraping
  end

  # Парсит комментарии к статьям на ресурсе `komiinform.ru`
  # возвращает файл с отчетом в формате `xlsx`
  #  @params [Hash]
  #   параметры для парсинга
  def self.komiinform_scraping(params)
    Komiinform::Scraping.new(params).scraping
  end
end
