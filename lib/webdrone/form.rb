module Webdrone
  class Browser
    def form
      @form ||= Form.new self
    end
  end

  class Form
    attr_accessor :a0

    def initialize(a0)
      @a0 = a0
    end

    def with_xpath(xpath = nil, &block)
      old_xpath, @xpath = @xpath, xpath
      instance_eval &block
    rescue => exception
      Webdrone.report_error(@a0, exception)
    ensure
      @xpath = old_xpath
    end

    def set(key, val, n: 1, visible: true)
      item = self.find_item(key, n: n, visible: visible)
      if item.tag_name == 'select'
        option = item.find_element :xpath, XPath::HTML.option(val).to_s
        option.click
      else
        item.clear
        item.send_keys(val)
      end
    rescue => exception
      Webdrone.report_error(@a0, exception)
    end

    def get(key, n: 1, visible: true)
      self.find_item(key, n: n, visible: visible)[:value]
    rescue => exception
      Webdrone.report_error(@a0, exception)
    end

    def clic(key, n: 1, visible: true)
      self.find_item(key, n: n, visible: visible).click
    rescue => exception
      Webdrone.report_error(@a0, exception)
    end

    def mark(key, n: 1, visible: true, color: '#af1616', times: 3, sleep: 0.05)
      @a0.mark.mark_item self.find_item(key, n: n, visible: visible), color: color, times: times, sleep: sleep
    rescue => exception
      Webdrone.report_error(@a0, exception)
    end

    def submit(key = nil, n: 1, visible: true)
      self.find_item(key, n: n, visible: visible) if key
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
      def find_item(key, n: 1, visible: true)
        if @xpath.respond_to? :call
          @lastitem = @a0.find.xpath @xpath.call(key).to_s, n: n, visible: visible
        elsif @xpath.is_a? String and @xpath.include? '%s'
          @lastitem = @a0.find.xpath sprintf(@xpath, key), n: n, visible: visible
        else
          @lastitem = @a0.find.xpath XPath::HTML.field(key).to_s, n: n, visible: visible
        end
      end
  end
end
