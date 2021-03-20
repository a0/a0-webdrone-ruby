# frozen_string_literal: true

module Webdrone
  class WebdroneError < RuntimeError
    attr_reader :original, :a0, :binding

    def initialize(msg, original, a0, bindings)
      super(msg)
      @original = original || $!
      @a0 = a0
      @buffer = []
      @binding = nil
      @location = nil

      begin
        # find location of user error
        bindings[0..-1].each do |binding|
          location = { path: binding.eval('__FILE__'), lineno: binding.eval('__LINE__') }
          next unless Gem.path.none? { |path| location[:path].include? path }

          @location = location
          @binding = binding
          break
        end

        report if a0.conf.error == :raise_report
      rescue StandardError
        nil
      end
    end

    def write_line(line)
      line = "#{line.chomp}\r\n"
      @buffer << line
      puts line
    end

    def write_title(title)
      title = "#{title} " if title.length.odd?
      title = "== #{title} =="
      filler = "="
      length = (80 - title.length) / 2
      filler_length = filler * length
      title = "#{filler_length}#{title}#{filler_length}\n" if length > 1
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
      ini, fin = [@location[:lineno] - 10 - 1, @location[:lineno] + 10 - 1]
      ini = 0 if ini.negative?

      write_title "LOCATION OF ERROR"
      write_line "#{@location[:path]} AT LINE #{sprintf '%<location>3d', location: @location[:lineno]}"
      File.readlines(@location[:path])[ini..fin].each_with_index do |line, index|
        lno = index + ini + 1
        if lno == @location[:lineno]
          write_line sprintf "%3d ==> #{line}", lno
        else
          write_line sprintf "%3d     #{line}", lno
        end
      end

      dump_error_report
    rescue StandardError
      nil
    end

    def report_screenshot
      write_title "AUTOMATIC SCREENSHOT"
      begin
        @a0.ctxt.with_conf error: :raise do
          file = @a0.shot.screen 'a0_webdrone_error_report'
          write_line "Screenshot saved succesfully filename:"
          write_line File.expand_path(file.path).to_s
        end
      rescue StandardError => error
        write_line "Error Saving screenshot, exception:"
        write_line error.to_s
      end

      dump_error_report
    rescue StandardError
      nil
    end

    def report_exception
      write_title "EXCEPTION DUMP"

      write_line "#{@original.class}: #{@original.message}"
      @original.backtrace_locations.each_with_index do |location, index|
        if location.path == @location[:path] && location.lineno == @location[:lineno]
          write_line sprintf "%02d: ==> from #{location}", index
        else
          write_line sprintf "%02d:     from #{location}", index
        end
      end

      dump_error_report
    rescue StandardError
      nil
    end

    def report_os
      write_title "SYSTEM INFO"

      write_line "A0 WEBDRONE VERSION: #{Webdrone::VERSION}"
      write_line OS.report

      dump_error_report
    end

    def report_time
      write_title Time.new.to_s

      dump_error_report
    end
  end

  def self.report_error(a0, exception)
    return if a0.conf.error == :ignore

    if exception.class != WebdroneError
      exception = WebdroneError.new(exception.message, exception, a0, Kernel.binding.callers)
      if a0.conf.developer && exception.binding && %i[raise_report].include?(a0.conf.error)
        exception.write_title "STARTING DEVELOPER CONSOLE ON ERROR"
        exception.dump_error_report
        a0.console exception.binding
      end
    end

    raise exception if %i[raise raise_report].include? a0.conf.error
  end
end
