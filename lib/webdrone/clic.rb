module Webdrone
  class Browser
    def clic
      @clic ||= Clic.new self
    end
  end

  class Clic
    attr_accessor :a0

    def initialize(a0)
      @a0 = a0
    end

    def id(text, n: 1, all: false, visible: true)
      @a0.find.id(text, n: n, all: all, visible: visible).click
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def css(text, n: 1, all: false, visible: true)
      @a0.find.css(text, n: n, all: all, visible: visible).click
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def link(text, n: 1, all: false, visible: true)
      @a0.find.link(text, n: n, all: all, visible: visible).click
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def button(text, n: 1, all: false, visible: true)
      @a0.find.button(text, n: n, all: all, visible: visible).click
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def on(text, n: 1, all: false, visible: true)
      @a0.find.on(text, n: n, all: all, visible: visible).click
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def option(text, n: 1, all: false, visible: true)
      @a0.find.option(text, n: n, all: all, visible: visible).click
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def xpath(text, n: 1, all: false, visible: true)
      @a0.find.xpath(text, n: n, all: all, visible: visible).click
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end
  end
end
