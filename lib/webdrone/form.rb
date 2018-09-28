# frozen_string_literal: true

module Webdrone
  class Browser
    def form
      @form ||= Form.new self
    end
  end

  class Form
    attr_accessor :data
    attr_reader :a0

    def initialize(a0)
      @a0 = a0
      @data = nil
    end

    def with_xpath(xpath = nil, &block)
      old_xpath, @xpath = @xpath, xpath
      instance_eval(&block)
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    ensure
      @xpath = old_xpath
    end

    def save(filename:, sheet:, item:, name: 'ITEM')
      prev = @data
      data = {}
      @data = data

      yield
    ensure
      File.open(".#{filename}.lock", File::RDWR | File::CREAT, 0o644) do
        items = {}
        items[item] = data

        begin
          workbook = RubyXL::Parser.parse(filename)
          worksheet = workbook[sheet]
          worksheet ||= workbook.add_worksheet sheet
        rescue StandardError
          workbook = RubyXL::Workbook.new
          worksheet = workbook[0]
          worksheet.sheet_name = sheet
        end

        rows = worksheet.sheet_data.rows.collect do |row|
          row.cells.collect do |cell|
            cell&.value
          end
        end
        heads = rows.shift || []
        rows.each do |row|
          item = {}
          key = nil
          row.each_with_index do |val, i|
            val = val.to_s if val
            if i.zero?
              key = val
            elsif key
              items[key] = {} unless items[key]
              items[key][heads[i]] = val if !heads[i].nil? && items[key][heads[i]].nil?
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

    def set(key, val, n: 1, visible: true, scroll: false, parent: nil, mark: false)
      item = find_item(key, n: n, visible: visible, scroll: scroll, parent: parent)
      @a0.mark.mark_item item if mark
      if item.tag_name == 'select'
        option = item.find_element :xpath, Webdrone::XPath.option(val).to_s
        option.click
      else
        item.clear
        item.send_keys(val)
      end
      @data[key] = val if @data
      nil
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    def get(key, n: 1, visible: true, scroll: false, parent: nil, mark: false)
      item = find_item(key, n: n, visible: visible, scroll: scroll, parent: parent)
      @a0.mark.mark_item item if mark
      item[:value]
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    def clic(key, n: 1, visible: true, scroll: false, parent: nil, mark: false)
      item = find_item(key, n: n, visible: visible, scroll: scroll, parent: parent)
      @a0.mark.mark_item item if mark
      item.click
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    def selected?(key, n: 1, visible: true, scroll: false, parent: nil, mark: false)
      item = find_item(key, n: n, visible: visible, scroll: scroll, parent: parent)
      @a0.mark.mark_item item if mark
      item.selected?
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    def mark(key, n: 1, visible: true, scroll: false, parent: nil, color: '#af1616', times: nil, delay: nil, shot: nil)
      @a0.mark.mark_item find_item(key, n: n, visible: visible, scroll: scroll, parent: parent), color: color, times: times, delay: delay, shot: shot
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    def submit(key = nil, n: 1, visible: true, scroll: false, parent: nil, mark: false)
      item = find_item(key, n: n, visible: visible, scroll: scroll, parent: parent) if key
      @a0.mark.mark_item item if mark
      @lastitem.submit
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    def xlsx(sheet: nil, filename: nil)
      @a0.xlsx.dict(sheet: sheet, filename: filename).each do |k, v|
        set k, v
      end
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    def find_item(key, n: 1, visible: true, scroll: false, parent: nil)
      @lastitem = \
        if @xpath.respond_to? :call
          @a0.find.xpath @xpath.call(key).to_s, n: n, visible: visible, scroll: scroll, parent: parent
        elsif @xpath.is_a?(String) && @xpath.include?('%s')
          @a0.find.xpath sprintf(@xpath, key), n: n, visible: visible, scroll: scroll, parent: parent
        else
          @a0.find.xpath Webdrone::XPath.field(key).to_s, n: n, visible: visible, scroll: scroll, parent: parent
        end
    end
  end
end
