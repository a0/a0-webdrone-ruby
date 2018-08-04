require 'os'
require 'selenium-webdriver'
require 'xpath'
require 'rubyXL'
require 'irb'
require 'fileutils'
require 'binding_of_caller'
require 'pathname'
require 'pry'
require 'highline'
require 'csv'

require 'webdrone/version'
require 'webdrone/error'
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
require 'webdrone/html'
require 'webdrone/logg'
require 'webdrone/xpath'

module Webdrone
  def self.create(*args)
    a0 = Webdrone::Browser.new *args
    if block_given?
      begin
        yield a0
      rescue => exception
        Webdrone.report_error(a0, exception)
      ensure
        a0.quit
      end
    else
      a0
    end
  end

  def self.irb_console(binding = nil)
    puts "Webdrone: Webdrone.irb_console IS DEPRECATED, please use a0.console instead."
    return if IRB.CurrentContext and not binding
    binding = Kernel.binding.of_caller(1) if binding == nil
    IRB.start_session(binding)
  end

  @@running_pry = false
  def self.pry_console(binding = nil)
    if @@running_pry
      puts "Webdrone: pry console already running."
    else
      @@running_pry = true
      binding = Kernel.binding.of_caller(1) unless binding
      binding.pry
      @@running_pry = false
    end
  end
end

module IRB
  def self.start_session(binding)
    unless $a0_irb_setup_done
      IRB.setup(nil)
      $a0_irb_setup_done = true
    end

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

    begin
      catch(:IRB_EXIT) do
        irb.eval_input
      end
    ensure
      IRB.irb_at_exit
    end
  end
end