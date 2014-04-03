# coding: sjis
require 'date'
$:.unshift File.dirname(__FILE__)
require 'jyear'

class GovDate
  def first
    1
  end
  def to_jdate(date)
    date.to_time.strftime("%K�N%m��%d��")
  end
  def to_date(jdate)
    Date.parse(jdate).to_s
  end
end
