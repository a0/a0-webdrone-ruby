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

    def id(text)
      @a0.find.id(text).click
    end

    def link(text, n: 1, all: false, visible: true)
      @a0.find.link(text, n: n, all: all, visible: visible).click
    end

    def button(text, n: 1, all: false, visible: true)
      @a0.find.button(text, n: n, all: all, visible: visible).click
    end

    def on(text, n: 1, all: false, visible: true)
      @a0.find.on(text, n: n, all: all, visible: visible).click
    end

    def option(text, n: 1, all: false, visible: true)
      @a0.find.option(text, n: n, all: all, visible: visible).click
    end

    def xpath(text, n: 1, all: false, visible: true)
      @a0.find.xpath(text, n: n, all: all, visible: visible).click
    end
  end
end
