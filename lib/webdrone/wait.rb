module Webdrone
  class Browser
    def wait
      @wait ||= Wait.new self
    end
  end

  class Wait
    attr_accessor :a0, :ignore

    def initialize(a0)
      @a0 = a0
      @ignore = []
      @ignore << Selenium::WebDriver::Error::StaleElementReferenceError
      @ignore << Selenium::WebDriver::Error::NoSuchElementError
      @ignore << Selenium::WebDriver::Error::NoSuchFrameError
      @ignore << Selenium::WebDriver::Error::InvalidSelectorError
    end

    def for
      if @a0.conf.timeout
        Selenium::WebDriver::Wait.new(timeout: @a0.conf.timeout, ignore: @ignore).until do
          yield
        end
      else
        yield
      end
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def time(val)
      sleep val
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end
  end
end
