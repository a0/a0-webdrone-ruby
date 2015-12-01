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
    end

    def get(key)
      self.find_item(key)[:value]
    end

    def clic(key)
      self.find_item(key).click
    end

    def mark(key, color: 'red')
      @a0.mark.flash self.find_item(key), color: color
    end

    def submit(key = nil)
      self.find_item(key) if key
      @lastitem.submit
    end

    def xlsx(sheet: nil, filename: nil)
      @a0.xlsx.dict(sheet: sheet, filename: filename).each do |k, v|
        self.set k, v
      end
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
