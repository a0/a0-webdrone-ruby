module Webdrone
  class Browser
    def conf
      @conf ||= Conf.new self
    end
  end

  class Conf
    attr_accessor :a0, :timeout

    def initialize(a0)
      @a0 = a0
    end

    def timeout=(val)
      @timeout = val
      @a0.driver.manage.timeouts.implicit_wait = val
    end
  end
end
