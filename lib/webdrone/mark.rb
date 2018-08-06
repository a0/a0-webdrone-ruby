# frozen_string_literal: true

module Webdrone
  class Browser
    def mark
      @mark ||= Mark.new self
    end
  end

  class Mark
    attr_accessor :default_times, :default_delay, :clear
    attr_reader :a0

    def initialize(a0)
      @a0 = a0
      @default_times = ENV['WEBDRONE_MARK_TIMES'] || 3
      @default_delay = ENV['WEBDRONE_MARK_DELAY'] || 0.05
      @clear = ENV['WEBDRONE_MARK_CLEAR'] == 'true' || false
    end

    def mark(text, n: 1, all: false, visible: true, scroll: false, parent: nil, color: '#af1616', times: nil, delay: nil, shot: nil)
      item = @a0.find.send __callee__, text, n: n, all: all, visible: visible, scroll: scroll, parent: parent
      mark_item item, color: color, times: times, delay: delay, shot: shot, text: text
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    alias_method :id,     :mark
    alias_method :css,    :mark
    alias_method :link,   :mark
    alias_method :button, :mark
    alias_method :on,     :mark
    alias_method :option, :mark
    alias_method :xpath,  :mark

    def mark_item(item, color: '#af1616', times: nil, delay: nil, shot: nil, text: nil)
      times ||= @default_times
      delay ||= @default_delay
      times.times do
        mark_item_border item, 'white'
        sleep delay
        mark_item_border item, 'black'
        sleep delay
        mark_item_border item, color
        sleep delay
      end
      @a0.shot.screen shot.is_a?(String) ? shot : text if shot
      mark_clear item if @clear
      item
    end

    def mark_clear(item)
      mark_item_border item, nil
    end

    def mark_item_border(item, color)
      style = color ? "'2px solid #{color}'" : "null"
      set_outline = "arguments[0].style.outline = #{style}"
      if item.is_a? Array
        item.each do |subitem|
          @a0.exec.script(set_outline, subitem)
        end
      else
        @a0.exec.script(set_outline, item)
      end
    end

    protected :mark, :mark_item_border
  end
end
