module Webdrone
  class Browser
    def conf
      @conf ||= Conf.new self
    end
  end

  class Conf
    attr_accessor :a0, :timeout, :outdir

    def initialize(a0)
      @a0 = a0
      @outdir = "."
    end

    def timeout=(val)
      @timeout = val
      @a0.driver.manage.timeouts.implicit_wait = val
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def outdir=(val)
      @outdir = val
      FileUtils.mkdir_p val
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end
  end
end
