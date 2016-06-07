module Webdrone
  class Browser
    def vrfy
      @vrfy ||= Vrfy.new self
    end
  end

  class Vrfy
    attr_accessor :a0

    def initialize(a0)
      @a0 = a0
    end

    def vrfy(text, n: 1, all: false, visible: true, attr: nil, eq: nil, contains: nil)
      item = @a0.find.send __callee__, text, n: n, all: all, visible: visible
      if item.is_a? Array
        item.each { |x| vrfy_item x, text: text, callee: __callee__, attr: attr, eq: eq, contains: contains }
      else
        vrfy_item item, text: text, callee: __callee__, attr: attr, eq: eq, contains: contains
      end
    rescue => exception
      Webdrone.report_error(@a0, exception)
    end

    def vrfy_item(item, text: nil, callee: nil, attr: nil, eq: nil, contains: nil)
      if attr != nil
        r = item.attribute(attr) == eq if eq != nil
        r = item.attribute(attr).include? contains if contains != nil
      elsif eq != nil
        r = item.text == eq
      elsif contains != nil
        r = item.text.include? contains
      end
      if r == false
        targ = "eq: [#{eq}]" if eq
        targ = "contains: [#{contains}]" if contains
        if attr != nil
          raise "VRFY: #{callee} [#{text}] attr [#{attr}] value [#{item.attribute(attr)}] does not comply #{targ}"
        else
          raise "VRFY: #{callee} [#{text}] text value [#{item.text}] does not comply #{targ}"
        end
      end
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
