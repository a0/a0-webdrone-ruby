# frozen_string_literal: true

module Webdrone
  class Browser
    def xlsx
      @xlsx ||= Xlsx.new self
    end
  end

  class Xlsx
    attr_accessor :filename, :sheet
    attr_reader :a0
    attr_writer :dict, :rows, :both

    def initialize(a0)
      @a0 = a0
      @filename = 'data.xlsx'
      @sheet = 0
    end

    def dict(sheet: nil, filename: nil)
      update_sheet_filename(sheet, filename)

      if @dict.nil?
        reset
        @dict = {}
        workbook = RubyXL::Parser.parse(@filename)
        worksheet = workbook[@sheet]
        worksheet.sheet_data.rows.tap do |_head, *body|
          body.each do |row|
            k, v = row[0].value, row[1].value
            @dict[k] = v
          end
        end
      end

      @dict
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    def rows(sheet: nil, filename: nil)
      update_sheet_filename(sheet, filename)

      if @rows.nil?
        reset
        workbook = RubyXL::Parser.parse(@filename)
        worksheet = workbook[@sheet]
        @rows = worksheet.sheet_data.rows.collect do |row|
          row.cells.collect do |cell|
            cell&.value
          end
        end
      end

      @rows
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    def both(sheet: nil, filename: nil)
      update_sheet_filename(sheet, filename)

      if @both.nil?
        reset
        workbook = RubyXL::Parser.parse(@filename)
        worksheet = workbook[@sheet]
        rows = worksheet.sheet_data.rows.collect do |row|
          row.cells.collect do |cell|
            cell&.value
          end
        end
        head = rows.shift
        @both = rows.collect do |row|
          dict = {}
          row.each_with_index do |val, i|
            dict[head[i]] = val if !head[i].nil?
          end
          dict
        end
      end

      @both
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    def save(sheet: nil, filename: nil, dict: nil, rows: nil)
      @sheet = sheet if sheet
      @filename = filename if filename
      @dict = dict if dict
      @rows = rows if rows
      workbook = RubyXL::Parser.parse(@filename)
      worksheet = workbook[@sheet]
      if !@dict.nil?
        worksheet.sheet_data.rows.tap do |_head, *body|
          body.each do |row|
            k = row[0].value
            if @dict.include?(k)
              row[1].change_contents(@dict[k])
            end
          end
        end
      elsif !@rows.nil?
        @rows.each_with_index do |row, rowi|
          row.each_with_index do |data, coli|
            if worksheet[rowi].nil? || worksheet[rowi][coli].nil?
              worksheet.add_cell(rowi, coli, data)
            else
              worksheet[rowi][coli].change_contents(data)
            end
          end
        end
      elsif !@both.nil?
        rows = worksheet.sheet_data.rows.collect do |row|
          row.cells.collect do |cell|
            cell&.value
          end
        end
        head = rows.shift
        @both.each_with_index do |entry, rowi|
          entry.each do |k, v|
            coli = head.index(k)
            if coli
              if worksheet[rowi + 1].nil? || worksheet[rowi + 1][coli].nil?
                worksheet.add_cell(rowi + 1, coli, v)
              else
                worksheet[rowi + 1][coli].change_contents(v)
              end
            end
          end
        end
      end
      workbook.write(@filename)
      reset
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    def reset
      @dict = @rows = @both = nil
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    protected

    def update_sheet_filename(sheet, filename)
      if sheet && sheet != @sheet
        @sheet = sheet
        reset
      end

      if filename && filename != @filename
        @filename = filename
        reset
      end

      nil
    end
  end
end
