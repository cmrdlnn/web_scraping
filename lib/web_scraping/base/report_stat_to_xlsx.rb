# frozen_string_literal: true

require 'rubyXL'

module WebScraping
  module Base
    class ReportStatToXLSX
      # Дефолтные высоты строк
      WIDTH = [14, 90, 16, 16, 16].freeze

      # Дефолтные значения ячеек
      DEFAULT_CELLS = %w[
        Дата
        Зоголовок
        Просмотров
        Комментариев
        Вовлечённость(коэффициент)
      ].freeze

      # Инициализирует объект класса
      def initialize
        @workbook = RubyXL::Workbook.new
        @sheet = @workbook[0]
      end

      attr_accessor :workbook, :sheet

      # Генерирует отчет по статьям
      # @params [Array<Array>] scraping_info
      #  результат скрапинга ресурса, массив
      # @return [RubyXL::Workbook]
      #  отчет в формате xlsx
      def create_report(scraping_info)
        sheet.change_column_font_color(1, '000080')
        generate_default_cells
        row = generate_sheet(scraping_info)
        change_width_height(row)
        change_column_alignment
        border_and_wrap
        workbook
      end

      private

      # Генерирует дефолтные ячейки с заголовками таблицы
      def generate_default_cells
        DEFAULT_CELLS.each_with_index do |value, i|
          sheet.add_cell(0, i, value).change_font_bold(true)
          sheet[0][i].change_fill('4169E1')
          sheet[0][i].change_font_color('FFFFFF')
        end
      end

      # Генерирует таблицу с отчетом
      # @params [Array<Array>] scraping_info
      #  результат скрапинга ресурса, массив
      # @return [Integer]
      #  номер последнего ряда
      def generate_sheet(scraping_info)
        scraping_info.reduce(1) do |row, info|
          line = info.reduce(row) do |memo, article|
            link = %Q{HYPERLINK("#{article[5]}", "#{article[1]}")}
            sheet.add_cell(memo, 0, article[0]).change_font_bold(true)
            sheet.add_cell(memo, 1, '', link).change_font_bold(true)
            sheet.add_cell(memo, 2, article[2]).change_font_bold(true)
            sheet.add_cell(memo, 3, article[3]).change_font_bold(true)
            sheet.add_cell(memo, 4, article[4]).change_font_bold(true)
            memo + 1
          end
          separating_line(line)
          row + line
        end
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
          sheet.add_cell(row, column).change_fill('808080')
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
        sheet.change_row_height(0, 55)
        1.upto(row) do |i|
          sheet.change_row_height(i, 25)
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
