# frozen_string_literal: true

module Webdrone
  class Browser
    def conf
      @conf ||= Conf.new self
    end
  end

  class Conf
    attr_accessor :developer, :logger
    attr_reader :a0, :timeout, :outdir, :error

    def initialize(a0)
      @a0 = a0
      @outdir = '.'
      @error = :raise_report
    end

    def timeout=(val)
      @timeout = val
      @a0.driver.manage.timeouts.implicit_wait = val
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    def outdir=(val)
      @outdir = val
      FileUtils.mkdir_p val
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    def error=(val)
      raise "Invalid value '#{val}' for error" if !%i[raise_report raise ignore].include? val
      @error = val
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end
  end
end
