module Webdrone
  class Browser
    def text
      @text ||= Text.new self
    end
  end

  class Text
    attr_accessor :a0

    def initialize(a0)
      @a0 = a0
    end

    def id(text, n: 1, all: false, visible: true)
      @a0.find.send __method__, text
      @a0.find.id(text).text
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def css(text, n: 1, all: false, visible: true)
      @a0.find.css(text).text
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def link(text, n: 1, all: false, visible: true)
      @a0.find.link(text, n: n, all: all, visible: visible).text
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def button(text, n: 1, all: false, visible: true)
      @a0.find.button(text, n: n, all: all, visible: visible).text
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def on(text, n: 1, all: false, visible: true)
      @a0.find.on(text, n: n, all: all, visible: visible).text
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def option(text, n: 1, all: false, visible: true)
      @a0.find.option(text, n: n, all: all, visible: visible).text
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def xpath(text, n: 1, all: false, visible: true)
      @a0.find.xpath(text, n: n, all: all, visible: visible).text
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end
    
    def page_title
      @a0.driver.title
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end
  end
end
