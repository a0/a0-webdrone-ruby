# frozen_string_literal: true

module Webdrone
  class Browser
    def html
      @html ||= Html.new self
    end
  end

  class Html
    attr_reader :a0

    def initialize(a0)
      @a0 = a0
    end

    def find_html(text, n: 1, all: false, visible: true, scroll: false, parent: a0.conf.parent)
      item = @a0.find.send __callee__, text, n: n, all: all, visible: visible, scroll: scroll, parent: parent
      if item.is_a? Array
        item.collect { |x| x.attribute 'innerHTML' }
      else
        item.attribute 'innerHTML'
      end
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    alias_method :id,     :find_html
    alias_method :css,    :find_html
    alias_method :link,   :find_html
    alias_method :button, :find_html
    alias_method :on,     :find_html
    alias_method :option, :find_html
    alias_method :xpath,  :find_html

    protected :find_html
  end
end
