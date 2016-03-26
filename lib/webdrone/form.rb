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

    def with_xpath(xpath, &block)
      @xpath = xpath
      instance_eval &block
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def set(key, val)
      item = self.find_item(key)
      if item.tag_name == 'select'
        option = item.find_element :xpath, XPath::HTML.option(val).to_s
        option.click
      else
        item.clear
        item.send_keys(val)
      end
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def get(key)
      self.find_item(key)[:value]
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def clic(key)
      self.find_item(key).click
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def mark(key, color: '#af1616', times: 3, sleep: 0.05)
      @a0.mark.mark_item self.find_item(key), color: color, times: times, sleep: sleep
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def submit(key = nil)
      self.find_item(key) if key
      @lastitem.submit
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def xlsx(sheet: nil, filename: nil)
      @a0.xlsx.dict(sheet: sheet, filename: filename).each do |k, v|
        self.set k, v
      end
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    protected
      def find_item(key)
        if @xpath
          @lastitem = @a0.driver.find_element :xpath, sprintf(@xpath, key)
        else
          @lastitem = @a0.find.xpath XPath::HTML.field(key).to_s
        end
      end
  end
end
