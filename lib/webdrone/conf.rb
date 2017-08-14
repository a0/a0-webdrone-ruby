module Webdrone
  class Browser
    def conf
      @conf ||= Conf.new self
    end
  end

  class Conf
    attr_accessor :a0, :timeout, :outdir, :error, :developer, :logger, :mark_clear

    def initialize(a0)
      @a0 = a0
      @outdir = "."
      @error = :raise_report
    end

    def timeout=(val)
      @timeout = val
      @a0.driver.manage.timeouts.implicit_wait = val
    rescue => exception
      Webdrone.report_error(@a0, exception)
    end

    def outdir=(val)
      @outdir = val
      FileUtils.mkdir_p val
    rescue => exception
      Webdrone.report_error(@a0, exception)
    end

    def error=(val)
      raise "Invalid value '#{val}' for error" if not [:raise_report, :raise, :ignore].include? val
      @error = val
    rescue => exception
      Webdrone.report_error(@a0, exception)
    end
  end
end
