require 'spec_helper'

describe Webdrone do
  it 'can update form from xlsx' do
    filename = File.join(File.dirname(__FILE__), 'data.xlsx')
    a0 = Webdrone.create create_outdir: true do |a0|
      a0.open.url 'http://getbootstrap.com/css/?#forms'
      a0.form.with_xpath '//label[contains(.,"%s")]/following-sibling::*[1][self::input | self::textarea | self::select]' do
        xlsx sheet: 'sample data', filename: filename
      end
      a0.shot.screen 'ya'
    end
  end

  it 'can read and write an xlsx' do
    filename = File.join(File.dirname(__FILE__), 'data.xlsx')
    FileUtils.cp(filename, Dir.tmpdir())
    filename = File.join(Dir.tmpdir(), 'data.xlsx')
    puts "output: #{filename}"
    a0 = Webdrone.create create_outdir: true do |a0|
      dict = a0.xlsx.dict filename: filename
      puts "dict: #{dict}"
      dict['name'] = "#{dict['name']} d"
      a0.xlsx.save
      dict = a0.xlsx.dict filename: filename
      puts "dict: #{dict}"

      rows = a0.xlsx.rows filename: filename
      puts "rows: #{rows}"
      rows[1][1] = "#{rows[1][1]} r"
      a0.xlsx.save
      rows = a0.xlsx.rows filename: filename
      puts "rows: #{rows}"

      both = a0.xlsx.both filename: filename
      puts "both: #{both}"
      both[1]['VALUE'] = "#{both[1]['VALUE']} rd"
      a0.xlsx.save
      both = a0.xlsx.both filename: filename
      puts "both: #{both}"
    end
  end

  it 'can create an output directory' do
    a0 = Webdrone.create create_outdir: true do |a0|
      a0.conf.timeout = 10
      a0.open.url     'http://www.google.cl/'
      a0.shot.screen  'homepage'      # screenshot is saved in output directory
      a0.form.set     'q', "Download sample file filetype:xls\n"
      a0.wait.time    5
      a0.clic.xpath   '//h3'          # xls file is saved in output directory
      a0.wait.time    5
    end
  end

  it 'can exec javascript' do
    Webdrone.create do |a0|
      a0.exec.script    'alert("HELLO");'
    end
  end

  it 'can find a link and clic on it' do
    Webdrone.create do |a0|
      a0.open.url     'http://www.microsoft.com/en-us'
      expect(a0.find.link('Download Center')).not_to be nil
      expect(a0.find.link('Download Centers')).to be nil
      a0.clic.link 'Download Center'
    end
  end

  it 'can take a screenshot' do
    Webdrone.create do |a0|
      a0.open.url     'http://www.google.com'
      a0.shot.screen  'home_page'
    end
  end

  it 'can create a browser with a block and open google' do
    Webdrone.create do |a0|
      a0.open.url   'http://www.google.com'
    end
  end

  it 'can create a browser and open yahoo' do
    a0 = Webdrone.create
    a0.open.url   'http://www.yahoo.com'
    a0.quit
  end

  it 'has a version number' do
    expect(Webdrone::VERSION).not_to be nil
  end
end
