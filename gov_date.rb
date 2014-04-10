# coding: utf-8
require 'date'
$:.unshift File.dirname(__FILE__)
require 'jyear'

#
# 日付関係
#
class GovDate
  #
  # 西暦⇒和暦変換
  #
  #date :: 西暦年月日
  #
  #返り値:: 和暦年月日
  def to_jdate(date)
    date.to_time.strftime("%K年%m月%d日")
  end

  #
  # 和暦⇒西暦変換
  #
  #jdate :: 和暦年月日
  #
  #返り値:: 西暦年月日
  def to_date(jdate)
    Date.parse(jdate).to_s
  end
end
