# frozen_string_literal: true

module Webdrone
  class Browser
    def clic
      @clic ||= Clic.new self
    end
  end

  class Clic
    attr_reader :a0

    def initialize(a0)
      @a0 = a0
    end

    def clic(text, n: 1, all: false, visible: true, scroll: false, parent: nil, color: '#af1616', times: nil, delay: nil, shot: nil, mark: false)
      item = @a0.find.send __callee__, text, n: n, all: all, visible: visible, scroll: scroll, parent: parent
      @a0.mark.mark_item(item, color: color, times: times, delay: delay, shot: shot, text: text) if mark
      @a0.shot.screen shot.is_a?(String) ? shot : text if shot
      if item.is_a? Array
        item.each(&:click)
      else
        item.click
      end
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
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
