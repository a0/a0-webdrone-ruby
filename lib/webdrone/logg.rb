module Webdrone
  class MethodLogger < Module
    def initialize(methods = nil)
      @methods = methods
    end

    def included(base)
      @methods ||= base.instance_methods(false)
      methods = @methods
      base.class_eval do
        methods.each do |method_name|
          original_method = instance_method(method_name)
          define_method method_name do |*args, &block|
            caller_location_path = Kernel.caller_locations.first.path
            puts "Invoking #{method_name} from #{caller_location_path}"
            if @a0.conf.logger and Gem.path.none? { |path| caller_location_path.include? path }
              $a0_webdrone_logger_last_time = Time.new unless $a0_webdrone_logger_last_time
              ini = $a0_webdrone_logger_last_time
              result = original_method.bind(self).call(*args, &block)
              fin = $a0_webdrone_logger_last_time = Time.new
              @a0.logg.write_log(ini, fin, base, method_name, args, result)
              result
            else
              original_method.bind(self).call(*args, &block)
            end
          end
        end
      end
    end
  end

  class Browser
    def logg
      @logg ||= Logg.new self
    end
  end

  class Logg
    attr_accessor :a0

    def initialize(a0)
      @a0 = a0
      setup_format
      @path = File.join(a0.conf.outdir, 'a0-webdrone-log.csv')
      CSV.open(@path, "a+") do |csv|
        os = "Windows #{OS.bits} b" if OS.windows?
        os = "Linux #{OS.bits} b" if OS.linux?
        os = "OS X #{OS.bits} b" if OS.osx?
        hostname = Socket.gethostname
        browser = "#{a0.driver.capabilites['browser']} #{a0.driver.capabilites['version']}"

        csv << %w.OS HOSTNAME BROWSER.
        csv << [os, hostname, browser]
      end
    end

    def write(ini, fin, base, method_name, args, result)
      printf @format, (fin-ini), base, method_name, args, result
      CSV.open("")
    end

    def setup_format
      cols, line = HighLine::SystemExtensions.terminal_size
      total = 6 + 15 + 11 + 5
      w = cols - total
      w /= 2
      w = 20 if w < 20
      w1 = w
      w2 = cols - total - w1
      @format = "%5.3f %14.14s %10s %#{w1}.#{w1}s => %#{w2}.#{w2}s\n"
    end
  end

  class Clic
    include MethodLogger.new
  end
  
  class Find
    include MethodLogger.new
  end
end
