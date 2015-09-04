module Webdrone
  class Browser
    def ctxt
      @ctxt ||= Ctxt.new self
    end
  end

  class Ctxt
    attr_accessor :a0, :current_frame

    def initialize(a0)
      @a0 = a0
    end

    def with_frame(name)
      old_frame = @current_frame
      @a0.driver.switch_to.frame name
      @current_frame = name
      if block_given?
        yield
        @a0.driver.switch_to.parent_frame
        @current_frame = old_frame
      end
      @current_frame
    end
    
    def with_alert
      @a0.wait.for do
        yield @a0.driver.switch_to.alert
      end
    end

    def ignore_alert
      @a0.exec.script 'alert = function(message){return true;};'
    end
  end
end
