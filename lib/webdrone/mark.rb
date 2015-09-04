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

    def id(id, color: 'red')
      flash color, @a0.find.id(id)
    end

    def link(text, color: 'red', n: 1, all: false, visible: true)
      flash color, @a0.find.link(text, n: n, all: all, visible: visible)
    end

    def button(text, color: 'red', n: 1, all: false, visible: true)
      flash color, @a0.find.button(text, n: n, all: all, visible: visible)
    end

    def on(text, color: 'red', n: 1, all: false, visible: true)
      flash color, @a0.find.on(text, n: n, all: all, visible: visible)
    end

    protected
      def flash(color, item)
        3.times do
          border 'white', item
          sleep 0.1
          border 'blue', item
          sleep 0.1
          border color, item
          sleep 0.1
        end
        item
      end

      def border(color, item)
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
