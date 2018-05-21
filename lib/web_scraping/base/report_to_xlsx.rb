# frozen_string_literal: true

require 'rubyXL'

module WebScraping
  module Base
    class ReportToXLSX
      # Дефолтные высоты строк
      WIDTH = [12, 60, 20, 20, 70].freeze

      # Инициализирует объект класса
      def initialize
        @workbook = RubyXL::Workbook.new
        @sheet = @workbook[0]
      end

      attr_accessor :workbook, :sheet

      # Генерирует отчет по статьям
      # @params [Array<String, String, Array>] scraping_info
      #  результат скрапинга ресурса, массив
      # @return [RubyXL::Workbook]
      #  отчет в формате xlsx
      def create_report(scraping_info)
        row = generate_sheet(scraping_info)
        change_width_height(row)
        change_column_alignment
        sheet.change_column_font_color(1, '000080')
        border_and_wrap
        workbook
      end

      private

      # Генерирует таблицу с отчетом
      # @params [Array<String, String, Array>] scraping_info
      #  результат скрапинга ресурса, массив
      def generate_sheet(scraping_info)
        scraping_info.reduce(0) do |memo, article|
          link = %Q{HYPERLINK("#{article[3]}", "#{article[1]}")}
          sheet.add_cell(memo, 0, article[0]).change_font_bold(true)
          sheet.add_cell(memo, 1, '', link).change_font_bold(true)
          sheet.add_cell(memo, 2, 'Автор комментария').change_font_bold(true)
          sheet.add_cell(memo, 3, 'Дата комментария').change_font_bold(true)
          sheet.add_cell(memo, 4, 'Комментарий').change_font_bold(true)
          memo = generate_comments_report(article[2], memo + 1)
          separating_line(memo)
          memo + 1
        end
      end

      # Генерирует часть таблицы в которой отображаются комментарии к статье
      # @params [Array] comments
      #  массив с комметариями
      # @params [Integer] row
      #  номер ряда с которого начинать заполнение таблицы
      # @return [Integer]
      #  номер ряда для заполнения отчета по комментариям следующей статьи
      def generate_comments_report(comments, row)
        row_total = comments.reduce(row) do |memo, comment|
          sheet.add_cell(memo, 0)
          sheet.add_cell(memo, 1)
          sheet.add_cell(memo, 2, comment[0])
          sheet.add_cell(memo, 3, comment[1])
          sheet.add_cell(memo, 4, comment[2])
          memo += 1
        end
        sheet.merge_cells(row - 1, 0, row_total - 1, 0)
        sheet.merge_cells(row - 1, 1, row_total - 1, 1)
        row_total
      end

      # Генерирует границы ячеек таблицы отчета и выставляет перенос слов
      def border_and_wrap
        sheet.each do |row|
          row.cells.each do |cell|
            next cell unless cell
            cell.change_border(:top, 'thin')
            cell.change_border(:bottom, 'thin')
            cell.change_border(:left, 'thin')
            cell.change_border(:right, 'thin')
            cell.change_text_wrap(true)
          end
        end
      end

      # Генерирует разделительную линию между статьями
      # @params [Integer] row
      #  номер ряда
      def separating_line(row)
        0.upto(4) do |column|
          sheet.add_cell(row, column).change_fill('696969')
        end
        sheet.merge_cells(row, 0, row, 4)
      end

      # Устанавливает высоту и ширину колонок и столбцов
      # @param [Integer] row
      #  номер последнего ряда
      def change_width_height(row)
        WIDTH.each_with_index do |width, i|
          sheet.change_column_width(i, width)
        end
        0.upto(row) do |i|
          sheet.change_row_height(i, 20)
        end
      end

      # Устанавливает выравнивание колонок по вертикали и горизонтали
      def change_column_alignment
        0.upto(4) do |column|
          sheet.change_column_vertical_alignment(column, 'center')
        end
        0.upto(4) do |column|
          sheet.change_column_horizontal_alignment(column, 'center')
        end
      end
    end
  end
end
