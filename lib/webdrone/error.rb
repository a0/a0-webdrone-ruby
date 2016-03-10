module Webdrone
  class WebdroneError < StandardError
    attr_reader :original, :a0, :caller_locations
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
      report_exception
      report_time
    end

    def report_script
      begin
        ini, fin = [@location.lineno - 10 - 1, @location.lineno + 10 - 1]
        ini = 0 if ini < 0

        write_title "#{@location.path} AT LINE #{sprintf '%3d', @location.lineno}"
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
        file = @a0.shot.screen 'a0_webdrone_error_report'
        write_line "Saved: #{file.path}"

        dump_error_report
      rescue
      end
    end

    def report_exception
      begin
        write_title "EXCEPTION DUMP"

        write_line "#{@original.class}: #{@original.message}"
        @original.backtrace_locations.each do |location|
          if location.path == @location.path and location.lineno == @location.lineno
            write_line sprintf " ==> from %s", location
          else
            write_line sprintf "     from %s", location
          end
        end

        dump_error_report
      rescue
      end
    end

    def report_time
      write_title "#{Time.new}"

      dump_error_report
    end
  end

  def self.report_error(a0, exception, caller_locations)
    exception = WebdroneError.new(exception.message, exception, a0, caller_locations) if exception.class != WebdroneError
    
    raise exception if a0.conf.error == :raise or a0.conf.error == :raise_report
  end
end
