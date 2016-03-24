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

    def id(text, color: 'red', n: 1, all: false, visible: true)
      flash @a0.find.id(text, n: n, all: all, visible: visible), color: color
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def css(text, color: 'red', n: 1, all: false, visible: true)
      flash @a0.find.css(text, n: n, all: all, visible: visible), color: color
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def link(text, color: 'red', n: 1, all: false, visible: true)
      flash @a0.find.link(text, n: n, all: all, visible: visible), color: color
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def button(text, color: 'red', n: 1, all: false, visible: true)
      flash @a0.find.button(text, n: n, all: all, visible: visible), color: color
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def on(text, color: 'red', n: 1, all: false, visible: true)
      flash @a0.find.on(text, n: n, all: all, visible: visible), color: color
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def option(text, color: 'red', n: 1, all: false, visible: true)
      flash @a0.find.option(text, n: n, all: all, visible: visible), color: color
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def xpath(text, color: 'red', n: 1, all: false, visible: true)
      flash @a0.find.xpath(text, n: n, all: all, visible: visible), color: color
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def flash(item, color: 'red')
      3.times do
        border item, 'white'
        sleep 0.05
        border item, 'black'
        sleep 0.05
        border item, color
        sleep 0.05
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
