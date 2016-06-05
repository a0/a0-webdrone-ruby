module Webdrone
  class Browser
    def shot
      @shot ||= Shot.new self
    end
  end

  class Shot
    attr_accessor :a0

    def initialize(a0)
      @a0 = a0
    end

    def screen(name)
      @counter = (@counter || 0) + 1
      filename = sprintf "screenshot-%04d-%s.png", @counter, name
      filename = File.join(@a0.conf.outdir, filename)
      @a0.driver.save_screenshot filename
    rescue => exception
      Webdrone.report_error(@a0, exception)
    end
  end
end
