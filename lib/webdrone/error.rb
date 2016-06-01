module Webdrone
  class WebdroneError < StandardError
    attr_reader :original, :a0, :caller_locations, :consoled
    def initialize(msg, original = $!, a0, caller_locations)
      super(msg)
      @original = original
      @a0 = a0
      @caller_locations = caller_locations
      @buffer = []

      begin
        # find location of user error
        @caller_locations[0..-1].each do |location|
          if Gem.path.none? { |path| location.path.include? path }
            @location = location
            break
          end
        end

        report if a0.conf.error == :raise_report
      rescue
      end
    end

    def write_line(line)
      line = "#{line.chomp}\r\n"
      @buffer << line
      puts line
    end

    def write_title(title)
      title = "#{title} " if title.length % 2 != 0
      title = "== #{title} =="
      filler = "="
      length = (80 - title.length) / 2
      title = "#{filler*length}#{title}#{filler*length}\n" if length > 1
      write_line title
    end

    def dump_error_report
      File.open(File.join(@a0.conf.outdir, "a0_webdrone_error_report.txt"), "a") do |file|
        file.write(@buffer.join)
      end
      @buffer = []
    end

    def report
      report_script
      report_screenshot
      report_os
      report_exception
      report_time
    end

    def report_script
      begin
        ini, fin = [@location.lineno - 10 - 1, @location.lineno + 10 - 1]
        ini = 0 if ini < 0

        write_title "LOCATION OF ERROR"
        write_line "#{@location.path} AT LINE #{sprintf '%3d', @location.lineno}"
        File.readlines(@location.path)[ini..fin].each_with_index do |line, index|
          lno = index + ini + 1
          if lno == @location.lineno
            write_line sprintf "%3d ==> %s", lno, line
          else
            write_line sprintf "%3d     %s", lno, line
          end
        end

        dump_error_report
      rescue
      end
    end

    def report_screenshot
      begin
        write_title "AUTOMATIC SCREENSHOT"
        begin
          @a0.ctxt.with_conf error: :raise do
            file = @a0.shot.screen 'a0_webdrone_error_report'
            write_line "Screenshot saved succesfully filename:"
            write_line "#{File.expand_path(file.path)}"
          end
        rescue => exception
          write_line "Error Saving screenshot, exception:"
          write_line "#{exception}"
        end

        dump_error_report
      rescue
      end
    end

    def report_exception
      begin
        write_title "EXCEPTION DUMP"

        write_line "#{@original.class}: #{@original.message}"
        @original.backtrace_locations.each_with_index do |location, index|
          if location.path == @location.path and location.lineno == @location.lineno
            write_line sprintf "%02d: ==> from %s", index, location
            @caller_index = index
          else
            write_line sprintf "%02d:     from %s", index, location
          end
        end

        dump_error_report
      rescue
      end
    end

    def report_os
      write_title "SYSTEM INFO"

      write_line "A0 WEBDRONE VERSION: #{Webdrone::VERSION}"
      write_line OS.report

      dump_error_report
    end

    def report_time
      write_title "#{Time.new}"

      dump_error_report
    end

    def start_console
      return if @consoled
      @consoled = true
      while true do
        write_title "DEVELOPER CONSOLE"
        print "Enter stack index [#{@caller_index}] or 'exit': "
        input = gets.chomp
        break if input.include? 'exit'
        begin
          @caller_index = input.to_i if not input.empty?
          location = @original.backtrace_locations[@caller_index]
          raise '' if location == nil
        rescue => e
          puts "** INVALID STACK NUMBER **"
          next
        end

        @a0.ctxt.with_conf error: :raise, developer: false do
          begin            
            index = Kernel.caller_locations.index do |item|
              item.path == location.path and item.lineno == location.lineno
            end
            Webdrone.irb_console Kernel.binding.of_caller(index + 1) if index != nil
          rescue => e
            puts "** INVALID STACK NUMBER #{e} **"
          end
        end
        report_exception
      end
    end
  end

  def self.report_error(a0, exception, caller_locations)
    return if a0.conf.error == :ignore
    exception = WebdroneError.new(exception.message, exception, a0, caller_locations) if exception.class != WebdroneError

    exception.start_console if a0.conf.developer
    raise exception if a0.conf.error == :raise or a0.conf.error == :raise_report
  end
end
