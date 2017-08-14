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

    def id(text, n: 1, all: false, visible: true, scroll: false, parent: nil)
      @a0.wait.for do
        items = (parent || @a0.driver).find_elements :id, text
        choose(items, n, all, visible, scroll)
      end
    rescue => exception
      Webdrone.report_error(@a0, exception)
    end

    def css(text, n: 1, all: false, visible: true, scroll: false, parent: nil)
      @a0.wait.for do
        items = (parent || @a0.driver).find_elements :css, text
        choose(items, n, all, visible, scroll)
      end
    rescue => exception
      Webdrone.report_error(@a0, exception)
    end

    def link(text, n: 1, all: false, visible: true, scroll: false, parent: nil)
      self.xpath XPath::HTML.link(text).to_s, n: n, all: all, visible: visible, scroll: scroll, parent: parent
    rescue => exception
      Webdrone.report_error(@a0, exception)
    end

    def button(text, n: 1, all: false, visible: true, scroll: false, parent: nil)
      self.xpath XPath::HTML.button(text).to_s, n: n, all: all, visible: visible, scroll: scroll, parent: parent
    rescue => exception
      Webdrone.report_error(@a0, exception)
    end

    def on(text, n: 1, all: false, visible: true, scroll: false, parent: nil)
      self.xpath XPath::HTML.link_or_button(text).to_s, n: n, all: all, visible: visible, scroll: scroll, parent: parent
    rescue => exception
      Webdrone.report_error(@a0, exception)
    end

    def option(text, n: 1, all: false, visible: true, scroll: false, parent: nil)
      self.xpath XPath::HTML.option(text).to_s, n: n, all: all, visible: visible, scroll: scroll, parent: parent
    rescue => exception
      Webdrone.report_error(@a0, exception)
    end

    def xpath(text, n: 1, all: false, visible: true, scroll: false, parent: nil)
      @a0.wait.for do
        items = (parent || @a0.driver).find_elements :xpath, text
        choose(items, n, all, visible, scroll)
      end
    rescue => exception
      Webdrone.report_error(@a0, exception)
    end

    protected
      def choose(list, n, all, visible, scroll)
        list = list.select do |x|
          if visible == true
            x.displayed?
          elsif visible == false
            not x.displayed?
          else
            true
          end
        end

        if scroll and list.length > 0
          @a0.exec.script 'arguments[0].scrollIntoView()', list.first
        end

        if all
          list
        else
          list[n - 1]
        end
      end
  end
end
