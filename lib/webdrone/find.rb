module Webdrone
  class Browser
    def find
      @find ||= Find.new self
    end
  end

  class Find
    attr_accessor :a0

    def initialize(a0)
      @a0 = a0
    end

    def id(id)
      @a0.wait.for do
        @a0.driver.find_element :id, id
      end
    end

    def link(text, n: 1, all: false, visible: true)
      self.xpath XPath::HTML.link(text).to_s, n: n, all: all, visible: visible
    end

    def button(text, n: 1, all: false, visible: true)
      self.xpath XPath::HTML.button(text).to_s, n: n, all: all, visible: visible
    end

    def on(text, n: 1, all: false, visible: true)
      self.xpath XPath::HTML.link_or_button(text).to_s, n: n, all: all, visible: visible
    end

    def option(text, n: 1, all: false, visible: true)
      self.xpath XPath::HTML.option(text).to_s, n: n, all: all, visible: visible
    end

    def xpath(text, n: 1, all: false, visible: true)
      @a0.wait.for do
        items = @a0.driver.find_elements :xpath, text
        choose(items, n, all, visible)
      end
    end

    protected
      def choose(list, n, all, visible)
        list = list.select do |x|
          if visible == true
            x.displayed?
          elsif visible == false
            not x.displayed?
          else
            true
          end
        end
        if all
          list
        elsif n == 1
          list.first
        else
          list[n - 1]
        end
      end
  end
end
