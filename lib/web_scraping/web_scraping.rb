# frozen_string_literal: true

load "#{__dir__}/bnk/comments.rb"
load "#{__dir__}/komiinform/comments.rb"

# Модуль реализующий парсинг web-ресурсов
module WebScraping

  # Парсит комментарии к статьям на ресурсе `bnlkomi.ru`
  # возвращает файл с отчетом в формате `xlsx`
  #  @params [Hash]
  #   параметры для парсинга
  def self.bnk_comments(params)
    Bnk::Comments.new(params).comments
  end

  # Парсит комментарии к статьям на ресурсе `komiinform.ru`
  # возвращает файл с отчетом в формате `xlsx`
  #  @params [Hash]
  #   параметры для парсинга
  def self.komiinform_comments(params)
    Bnk::Comments.new(params).comments
  end
end
