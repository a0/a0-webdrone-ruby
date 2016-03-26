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

    def clic(text, n: 1, all: false, visible: true)
      item = @a0.find.send __callee__, text, n: n, all: all, visible: visible
      if item.is_a? Array
        item.each(&:click)
      else
        item.click
      end
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    alias_method :id,     :clic
    alias_method :css,    :clic
    alias_method :link,   :clic
    alias_method :button, :clic
    alias_method :on,     :clic
    alias_method :option, :clic
    alias_method :xpath,  :clic

    protected :clic
  end
end
