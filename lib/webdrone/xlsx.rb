module Webdrone
  class Browser
    def xlsx
      @xlsx ||= Xlsx.new self
    end
  end

  class Xlsx
    attr_accessor :a0, :filename, :sheet, :dict, :rows, :both

    def initialize(a0)
      @a0 = a0
      @filename = 'data.xlsx'
      @sheet = 0
    end

    def dict(sheet: nil, filename: nil)
      update_sheet_filename(sheet, filename)
      if @dict == nil
        reset
        @dict = {}
        workbook = RubyXL::Parser.parse(@filename)
        worksheet = workbook[@sheet]
        worksheet.sheet_data.rows.tap do |head, *body|
          body.each do |row|
            k, v = row[0].value, row[1].value
            @dict[k] = v
          end
        end
      end
      @dict
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def rows(sheet: nil, filename: nil)
      update_sheet_filename(sheet, filename)
      if @rows == nil
        reset
        workbook = RubyXL::Parser.parse(@filename)
        worksheet = workbook[@sheet]
        @rows = worksheet.sheet_data.rows.collect do |row|
          row.cells.collect do |cell|
            cell.value if cell != nil
          end
        end
      end
      @rows
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def both(sheet: nil, filename: nil)
      update_sheet_filename(sheet, filename)
      if @both == nil
        reset
        workbook = RubyXL::Parser.parse(@filename)
        worksheet = workbook[@sheet]
        rows = worksheet.sheet_data.rows.collect do |row|
          row.cells.collect do |cell|
            cell.value if cell != nil
          end
        end
        head = rows.shift
        @both = rows.collect do |row|
          dict = {}
          row.each_with_index do |val, i|
            dict[head[i]] = val if head[i] != nil
          end
          dict
        end
      end
      @both
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end


    def save(sheet: nil, filename: nil, dict: nil, rows: nil)
      @filename = filename if filename
      @sheet = sheet if sheet
      workbook = RubyXL::Parser.parse(@filename)
      worksheet = workbook[@sheet]
      if @dict != nil
        worksheet.sheet_data.rows.tap do |head, *body|
          body.each do |row|
            k = row[0].value
            if @dict.include?(k)
              row[1].change_contents(@dict[k])
            end
          end
        end
      elsif @rows != nil
        @rows.each_with_index do |row, rowi|
          row.each_with_index do |data, coli|
            if worksheet[rowi] == nil || worksheet[rowi][coli] == nil
              worksheet.add_cell(rowi, coli, data)
            else
              worksheet[rowi][coli].change_contents(data)
            end
          end
        end
      elsif @both != nil
        rows = worksheet.sheet_data.rows.collect do |row|
          row.cells.collect do |cell|
            cell.value if cell != nil
          end
        end
        head = rows.shift
        @both.each_with_index do |entry, i|
          entry.each do |k, v|
            index = head.index(k)
            worksheet[i + 1][index].change_contents(v) if index
          end
        end
      end
      k = workbook.write(@filename)
      reset
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def reset()
      @dict = @rows = @both = nil
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    protected
      def update_sheet_filename(sheet, filename)
        if sheet and sheet != @sheet
          @sheet = sheet
          reset
        end
        if filename and filename != @filename
          @filename = filename
          reset
        end
      end
  end
end
