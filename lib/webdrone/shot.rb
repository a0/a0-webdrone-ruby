# frozen_string_literal: true

module Webdrone
  class Browser
    def shot
      @shot ||= Shot.new self
    end
  end

  class Shot
    attr_reader :a0

    def initialize(a0)
      @a0 = a0
    end

    def screen(name)
      @counter = (@counter || 0) + 1
      filename = sprintf "screenshot-%04d-#{name}.png", @counter
      filename = File.join(@a0.conf.outdir, filename)
      ::Webdrone::MethodLogger.screenshot = filename
      @a0.driver.save_screenshot filename
    rescue StandardError => error
      Webdrone.report_error(@a0, error)
    end
  end
end
