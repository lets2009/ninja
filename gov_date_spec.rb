# coding: utf-8

$:.unshift File.dirname(__FILE__)
require 'gov_date'

describe GovDate, "standard" do
  before do
    @gov_date = GovDate.new
  end

  it "first should be 1" do
    @gov_date.first.should == 1
  end

  it "2014-04-01 to_jdate should be " do
    date = Date.new(2014, 4 ,1)
    @gov_date.to_jdate(date).should == "平成26年04月01日"
  end

  it "H24.10.1 to_date should be 2012-10-01" do
    jdate = "H24.10.1"
    @gov_date.to_date(jdate).should == "2012-10-01"
  end

  after do
  end
end
