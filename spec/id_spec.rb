require 'spec_helper'

shared_examples ".id on all browsers" do |browser|
  it "can find/mark/text/vrfy/clic an element by .id on #{browser}" do
    iii = 'id_001'
    ttt = 'This is a P with an id of #id_001'

    Webdrone.create browser: browser, timeout: 10, error: :raise do |a0|
      a0.open.url     'http://webdrone.io/sandbox/bootstrap'

      a0.find.id      iii

      a0.mark.id      iii

      r=a0.text.id    iii
      expect(r).to eq(ttt)

      a0.vrfy.id      iii, eq: ttt

      a0.vrfy.id      iii, contains: iii

      a0.clic.id      iii
    end
  end

  it "can find/mark/text/vrfy/clic multiple elements by .id on #{browser}" do
    iii = 'id_002'
    ttt = ['This is a P with an id of #id_002', 'This is a P with the same id of #id_002']

    Webdrone.create browser: browser, timeout: 10, error: :raise do |a0|
      a0.open.url     'http://webdrone.io/sandbox/bootstrap'

      r = a0.find.id    iii, all: true
      expect(r.size).to be == ttt.size

      r = a0.mark.id    iii, all: true
      expect(r.size).to be == ttt.size

      r = a0.text.id    iii, all: true
      expect(r).to eq(ttt)

      r = a0.vrfy.id    iii, all: true, contains: iii
      expect(r.size).to be == ttt.size

      r = a0.clic.id    iii, all: true
      expect(r.size).to be == ttt.size
    end
  end
end

describe Webdrone do
  it_behaves_like ".id on all browsers", :chrome
  it_behaves_like ".id on all browsers", :firefox
  it_behaves_like ".id on all browsers", :safari   if OS.mac?
  it_behaves_like ".id on all browsers", :ie       if OS.windows?
end
