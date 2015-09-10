module Webdrone
  class Browser
    def mark
      @mark ||= Mark.new self
    end
  end

  class Mark
    attr_accessor :a0

    def initialize(a0)
      @a0 = a0
    end

    def id(text, color: 'red')
      flash @a0.find.id(text), color: color
    end

    def link(text, color: 'red', n: 1, all: false, visible: true)
      flash @a0.find.link(text, n: n, all: all, visible: visible), color: color
    end

    def button(text, color: 'red', n: 1, all: false, visible: true)
      flash @a0.find.button(text, n: n, all: all, visible: visible), color: color
    end

    def on(text, color: 'red', n: 1, all: false, visible: true)
      flash @a0.find.on(text, n: n, all: all, visible: visible), color: color
    end

    def option(text, color: 'red', n: 1, all: false, visible: true)
      flash @a0.find.option(text, n: n, all: all, visible: visible), color: color
    end

    def xpath(text, color: 'red', n: 1, all: false, visible: true)
      flash @a0.find.xpath(text, n: n, all: all, visible: visible), color: color
    end

    def flash(item, color: 'red')
      3.times do
        border item, 'white'
        sleep 0.1
        border item, 'blue'
        sleep 0.1
        border item, color
        sleep 0.1
      end
      item
    end

    protected
      def border(item, color)
        if item.is_a? Array
          item.each do |item|
            @a0.exec.script("arguments[0].style.border = '2px solid #{color}'", item)
          end
        else
          @a0.exec.script("arguments[0].style.border = '2px solid #{color}'", item)
        end
      end
  end
end
