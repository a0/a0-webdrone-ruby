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

    def id(id)
      @a0.find.id(id).text
    end

    def link(text, n: 1, all: false, visible: true)
      @a0.find.link(text, n: n, all: all, visible: visible).text
    end

    def button(text, n: 1, all: false, visible: true)
      @a0.find.button(text, n: n, all: all, visible: visible).text
    end

    def on(text, n: 1, all: false, visible: true)
      @a0.find.on(text, n: n, all: all, visible: visible).text
    end

    def xpath(text, n: 1, all: false, visible: true)
      @a0.find.xpath(text, n: n, all: all, visible: visible).text
    end
  end
end
