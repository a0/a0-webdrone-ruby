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
      @framestack = []
    end
    
    def create_tab
      @a0.exec.script "function a0_ctx_create_tab() { var w = window.open(); w.document.open(); w.document.write('A0 CTXT CREATE TAB'); w.document.close(); } a0_ctx_create_tab();"
      @a0.driver.switch_to.window @a0.driver.window_handles.last
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end
    
    def close_tab
      @a0.driver.close
      @a0.driver.switch_to.window @a0.driver.window_handles.last
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def with_frame(name)
      @framestack << name      
      @a0.driver.switch_to.frame name
      if block_given?
        begin
          yield
        ensure
          @framestack.pop
          @a0.driver.switch_to.default_content
          @framestack.each { |frame| @a0.driver.switch_to.frame frame}
        end
      end
      name
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end
    
    def reset
      @a0.driver.switch_to.default_content
      @ramestack = []
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end
    
    def with_alert
      @a0.wait.for do
        yield @a0.driver.switch_to.alert
      end
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end

    def ignore_alert
      @a0.exec.script 'alert = function(message){return true;};'
    rescue => exception
      Webdrone.report_error(@a0, exception, Kernel.caller_locations)
    end
  end
end
