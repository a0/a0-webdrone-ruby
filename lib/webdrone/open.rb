# frozen_string_literal: true

module Webdrone
  class Browser
    def open
      @open ||= Open.new self
    end
  end

  class Open
    attr_reader :a0

    def initialize(a0)
      @a0 = a0
    end

    def url(url)
      @a0.driver.get url
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end

    def reload
      @a0.driver.navigate.refresh
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end
  end
end
