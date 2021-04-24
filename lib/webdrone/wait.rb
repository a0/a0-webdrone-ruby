# frozen_string_literal: true

module Webdrone
  class Browser
    def wait
      @wait ||= Wait.new self
    end
  end

  class Wait
    attr_accessor :ignore
    attr_reader :a0

    def initialize(a0)
      @a0 = a0
      @ignore = []
      @ignore << Selenium::WebDriver::Error::StaleElementReferenceError
      @ignore << Selenium::WebDriver::Error::NoSuchElementError
      @ignore << Selenium::WebDriver::Error::NoSuchFrameError
      @ignore << Selenium::WebDriver::Error::InvalidSelectorError
    end

    def for(&block)
      if @a0.conf.timeout
        Selenium::WebDriver::Wait.new(timeout: @a0.conf.timeout, ignore: @ignore).until(&block)
      else
        yield
      end
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    def time(val)
      sleep val
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end
  end
end
