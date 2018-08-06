# frozen_string_literal: true

module Webdrone
  class Browser
    def find
      @find ||= Find.new self
    end
  end

  class Find
    attr_reader :a0

    def initialize(a0)
      @a0 = a0
    end

    def id(text, n: 1, all: false, visible: true, scroll: false, parent: nil)
      @a0.wait.for do
        items = (parent || @a0.driver).find_elements :id, text
        choose(items, n, all, visible, scroll)
      end
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    def css(text, n: 1, all: false, visible: true, scroll: false, parent: nil)
      @a0.wait.for do
        items = (parent || @a0.driver).find_elements :css, text
        choose(items, n, all, visible, scroll)
      end
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    def link(text, n: 1, all: false, visible: true, scroll: false, parent: nil)
      xpath Webdrone::XPath.link(text).to_s, n: n, all: all, visible: visible, scroll: scroll, parent: parent
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    def button(text, n: 1, all: false, visible: true, scroll: false, parent: nil)
      xpath Webdrone::XPath.button(text).to_s, n: n, all: all, visible: visible, scroll: scroll, parent: parent
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    def on(text, n: 1, all: false, visible: true, scroll: false, parent: nil)
      xpath Webdrone::XPath.link_or_button(text).to_s, n: n, all: all, visible: visible, scroll: scroll, parent: parent
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    def option(text, n: 1, all: false, visible: true, scroll: false, parent: nil)
      xpath Webdrone::XPath.option(text).to_s, n: n, all: all, visible: visible, scroll: scroll, parent: parent
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    def xpath(text, n: 1, all: false, visible: true, scroll: false, parent: nil)
      @a0.wait.for do
        items = (parent || @a0.driver).find_elements :xpath, text
        choose(items, n, all, visible, scroll)
      end
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    protected

    def choose(list, n, all, visible, scroll)
      list = list.select do |x|
        if visible == true
          x.displayed?
        elsif visible == false
          !x.displayed?
        else
          true
        end
      end

      if scroll && list.length.positive?
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
