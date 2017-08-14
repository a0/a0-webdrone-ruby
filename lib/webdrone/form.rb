module Webdrone
  class Browser
    def form
      @form ||= Form.new self
    end
  end

  class Form
    attr_accessor :a0, :data

    def initialize(a0)
      @a0 = a0
      @data = nil
    end

    def with_xpath(xpath = nil, &block)
      old_xpath, @xpath = @xpath, xpath
      instance_eval &block
    rescue => exception
      Webdrone.report_error(@a0, exception)
    ensure
      @xpath = old_xpath
    end

    def save(filename:, sheet:, item:, name: 'ITEM')
      prev = @data
      data = {}
      @data = data

      yield
    ensure
      File.open(".#{filename}.lock", File::RDWR | File::CREAT, 0644) do |file|
        items = {}
        items[item] = data

        begin
          workbook = RubyXL::Parser.parse(filename)
          worksheet = workbook[sheet]
          worksheet = workbook.add_worksheet sheet unless worksheet
        rescue
          workbook = RubyXL::Workbook.new
          worksheet = workbook[0]
          worksheet.sheet_name = sheet
        end

        rows = worksheet.sheet_data.rows.collect do |row|
          row.cells.collect do |cell|
            cell.value if cell != nil
          end
        end
        heads = rows.shift || []
        rows.each do |row|
          item = {}
          key = nil
          row.each_with_index do |val, i|
            val = val.to_s if val
            if i == 0
              key = val
            elsif key
              items[key] = {} unless items[key]
              items[key][heads[i]] = val if heads[i] != nil and items[key][heads[i]] == nil
            end
          end
        end
        x = heads.shift
        x ||= name
        worksheet.add_cell 0, 0, x

        heads += data.keys.sort
        heads = heads.uniq

        heads.each_with_index do |field, coli|
          worksheet.add_cell 0, coli + 1, field
        end
        worksheet.change_row_bold 0, true
        items.each_with_index do |elem, rowi|
          key, item = elem
          worksheet.add_cell rowi + 1, 0, key
          heads.each_with_index do |field, coli|
            worksheet.add_cell rowi + 1, coli + 1, item[field]
          end
        end

        workbook.write filename
      end

      @data = prev
    end

    def set(key, val, n: 1, visible: true, scroll: false, parent: nil)
      item = self.find_item(key, n: n, visible: visible, scroll: scroll, parent: parent)
      if item.tag_name == 'select'
        option = item.find_element :xpath, XPath::HTML.option(val).to_s
        option.click
      else
        item.clear
        item.send_keys(val)
      end
      @data[key] = val if @data
      nil
    rescue => exception
      Webdrone.report_error(@a0, exception)
    end

    def get(key, n: 1, visible: true, scroll: false, parent: nil)
      self.find_item(key, n: n, visible: visible, scroll: scroll, parent: parent)[:value]
    rescue => exception
      Webdrone.report_error(@a0, exception)
    end

    def clic(key, n: 1, visible: true, scroll: false, parent: nil)
      self.find_item(key, n: n, visible: visible, scroll: scroll, parent: parent).click
    rescue => exception
      Webdrone.report_error(@a0, exception)
    end

    def mark(key, n: 1, visible: true, scroll: false, parent: nil, color: '#af1616', times: nil, delay: nil, shot: nil)
      @a0.mark.mark_item self.find_item(key, n: n, visible: visible, scroll: scroll, parent: parent), color: color, times: times, delay: delay, shot: shot
    rescue => exception
      Webdrone.report_error(@a0, exception)
    end

    def submit(key = nil, n: 1, visible: true, scroll: false, parent: nil)
      self.find_item(key, n: n, visible: visible, scroll: scroll, parent: parent) if key
      @lastitem.submit
    rescue => exception
      Webdrone.report_error(@a0, exception)
    end

    def xlsx(sheet: nil, filename: nil)
      @a0.xlsx.dict(sheet: sheet, filename: filename).each do |k, v|
        self.set k, v
      end
    rescue => exception
      Webdrone.report_error(@a0, exception)
    end

    protected
      def find_item(key, n: 1, visible: true, scroll: false, parent: nil)
        if @xpath.respond_to? :call
          @lastitem = @a0.find.xpath @xpath.call(key).to_s, n: n, visible: visible, scroll: scroll, parent: parent
        elsif @xpath.is_a? String and @xpath.include? '%s'
          @lastitem = @a0.find.xpath sprintf(@xpath, key), n: n, visible: visible, scroll: scroll, parent: parent
        else
          @lastitem = @a0.find.xpath XPath::HTML.field(key).to_s, n: n, visible: visible, scroll: scroll, parent: parent
        end
      end
  end
end
