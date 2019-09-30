# frozen_string_literal: true

module Webdrone
  class Browser
    def vrfy
      @vrfy ||= Vrfy.new self
    end
  end

  class Vrfy
    attr_reader :a0

    def initialize(a0)
      @a0 = a0
    end

    def vrfy(text, n: 1, all: false, visible: true, scroll: false, parent: nil, attr: nil, eq: nil, contains: nil, mark: false)
      item = @a0.find.send __callee__, text, n: n, all: all, visible: visible, scroll: scroll, parent: parent
      @a0.mark.mark_item item if mark
      if item.is_a? Array
        item.each { |x| vrfy_item x, text: text, callee: __callee__, attr: attr, eq: eq, contains: contains }
      else
        vrfy_item item, text: text, callee: __callee__, attr: attr, eq: eq, contains: contains
      end
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    def vrfy_item(item, text: nil, callee: nil, attr: nil, eq: nil, contains: nil)
      if !attr.nil?
        r = item.attribute(attr) == eq if !eq.nil?
        r = item.attribute(attr).include? contains if !contains.nil?
      elsif !eq.nil?
        r = item.text == eq
      elsif !contains.nil?
        r = item.text.include? contains
      end

      return unless r == false

      targ = "eq: [#{eq}]" if eq
      targ = "contains: [#{contains}]" if contains

      raise "VRFY: #{callee} [#{text}] text value [#{item.text}] does not comply #{targ}" if attr.nil?

      raise "VRFY: #{callee} [#{text}] attr [#{attr}] value [#{item.attribute(attr)}] does not comply #{targ}"
    end

    alias_method :id,     :vrfy
    alias_method :css,    :vrfy
    alias_method :link,   :vrfy
    alias_method :button, :vrfy
    alias_method :on,     :vrfy
    alias_method :option, :vrfy
    alias_method :xpath,  :vrfy

    protected :vrfy, :vrfy_item
  end
end
