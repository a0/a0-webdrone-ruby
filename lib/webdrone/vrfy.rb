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

    def id(text, attr: nil, eq: nil, contains: nil)
      vrfy @a0.find.id(text), attr: attr, eq: eq, contains: contains
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def css(text, attr: nil, eq: nil, contains: nil)
      vrfy @a0.find.css(text), attr: attr, eq: eq, contains: contains
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def link(text, n: 1, visible: true, attr: nil, eq: nil, contains: nil)
      vrfy @a0.find.link(text, n: n, visible: visible), attr: attr, eq: eq, contains: contains
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def button(text, n: 1, visible: true, attr: nil, eq: nil, contains: nil)
      vrfy @a0.find.button(text, n: n, visible: visible), attr: attr, eq: eq, contains: contains
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def on(text, n: 1, visible: true, attr: nil, eq: nil, contains: nil)
      vrfy @a0.find.on(text, n: n, visible: visible), attr: attr, eq: eq, contains: contains
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def option(text, n: 1, visible: true, attr: nil, eq: nil, contains: nil)
      vrfy @a0.find.option(text, n: n, visible: visible), attr: attr, eq: eq, contains: contains
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def xpath(text, n: 1, visible: true, attr: nil, eq: nil, contains: nil)
      vrfy @a0.find.xpath(text, n: n, visible: visible), attr: attr, eq: eq, contains: contains
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def vrfy(item, attr: nil, eq: nil, contains: nil)
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
          raise Exception.new "ERROR: Attribute [#{attr}] value [#{item.attribute(attr)}] does not comply #{targ}"
        else
          raise Exception.new "ERROR: Value [#{item.text}] does not comply #{targ}"
        end
      end
    end
  end
end
