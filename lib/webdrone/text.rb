# frozen_string_literal: true

module Webdrone
  class Browser
    def text
      @text ||= Text.new self
    end
  end

  class Text
    attr_reader :a0

    def initialize(a0)
      @a0 = a0
    end

    def text(text, n: 1, all: false, visible: true, scroll: false, parent: a0.conf.parent)
      item = @a0.find.send __callee__, text, n: n, all: all, visible: visible, scroll: scroll, parent: parent
      if item.is_a? Array
        item.collect(&:text)
      else
        item.text
      end
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    alias_method :id,     :text
    alias_method :css,    :text
    alias_method :link,   :text
    alias_method :button, :text
    alias_method :on,     :text
    alias_method :option, :text
    alias_method :xpath,  :text

    def page_title
      @a0.driver.title
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    protected :text
  end
end
