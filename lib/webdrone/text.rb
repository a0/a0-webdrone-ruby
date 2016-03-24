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

    def find_text(text, n: 1, all: false, visible: true)
      item = @a0.find.send __callee__, text, n: n, all: all, visible: visible
      if item.is_a? Array
        item.collect(&:text)
      else
        item.text
      end
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    alias_method :id,     :find_text
    alias_method :css,    :find_text
    alias_method :link,   :find_text
    alias_method :button, :find_text
    alias_method :on,     :find_text
    alias_method :option, :find_text
    alias_method :xpath,  :find_text
    
    def page_title
      @a0.driver.title
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    protected :find_text
  end
end
