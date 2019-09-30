# frozen_string_literal: true

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
  class << self
    attr_accessor :running_pry, :irb_setup_done

    def create(*args)
      a0 = Webdrone::Browser.new(*args)
      if block_given?
        begin
          yield a0
        rescue StandardError => error
          Webdrone.report_error(a0, error)
        ensure
          a0.quit
        end
      else
        a0
      end
    end
  end

  def self.irb_console(binding = nil)
    puts 'Webdrone: Webdrone.irb_console IS DEPRECATED, please use a0.console instead.'
    return if IRB.CurrentContext && !binding

    binding ||= Kernel.binding.of_caller(1)
    IRB.start_session(binding)
  end

  Webdrone.running_pry = false
  def self.pry_console(binding = nil)
    if Webdrone.running_pry
      puts 'Webdrone: pry console already running.'
    else
      Webdrone.running_pry = true
      binding ||= Kernel.binding.of_caller(1)
      binding.pry
      Webdrone.running_pry = false
    end
  end
end

module IRB
  def self.start_session(binding)
    unless Webdrone.irb_setup_done
      IRB.setup(nil)
      Webdrone.irb_setup_done = true
    end

    workspace = WorkSpace.new(binding)

    irb = \
      if @CONF[:SCRIPT]
        Irb.new(workspace, @CONF[:SCRIPT])
      else
        Irb.new(workspace)
      end

    @CONF[:IRB_RC]&.call(irb.context)
    @CONF[:MAIN_CONTEXT] = irb.context

    trap('SIGINT') do
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
