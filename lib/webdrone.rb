require 'webdrone/version'
require 'webdrone/browser'
require 'webdrone/open'
require 'webdrone/shot'
require 'webdrone/find'
require 'webdrone/clic'
require 'webdrone/exec'
require 'webdrone/mark'
require 'webdrone/form'
require 'webdrone/xlsx'
require 'webdrone/conf'
require 'webdrone/ctxt'
require 'webdrone/wait'
require 'webdrone/text'
require 'webdrone/vrfy'
require 'selenium-webdriver'
require 'xpath'
require 'rubyXL'
require 'irb'

module Webdrone
  def self.create(*args)
    a0 = Webdrone::Browser.new *args
    if block_given?
      begin
        yield a0
      ensure
        a0.quit
      end    
    else
      a0
    end
  end

  def self.irb_console(*args)
    return if IRB.CurrentContext
    IRB.start_session(Kernel.binding)
  end
end

module IRB
  def self.start_session(binding)
    IRB.setup(nil)

    workspace = WorkSpace.new(binding)

    if @CONF[:SCRIPT]
      irb = Irb.new(workspace, @CONF[:SCRIPT])
    else
      irb = Irb.new(workspace)
    end

    @CONF[:IRB_RC].call(irb.context) if @CONF[:IRB_RC]
    @CONF[:MAIN_CONTEXT] = irb.context

    trap("SIGINT") do
      irb.signal_handle
    end

    catch(:IRB_EXIT) do
      irb.eval_input
    end
  end
end