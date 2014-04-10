# coding: utf-8
$:.unshift File.dirname(__FILE__)
require 'csv'

class String
 
  def mb_ljust(width, padding=' ')
    output_width = each_char.map{|c| c.bytesize}.reduce(0, &:+)
    padding_size = [0, width - output_width].max
    self + padding * padding_size
  end
 
  def mb_rjust(width, padding=' ')
    output_width = each_char.map{|c| c.bytesize}.reduce(0, &:+)
    padding_size = [0, width - output_width].max
    padding * padding_size + self
  end
 
end


#
# ファイルアクセス
#
class GovFile

  # レイアウト（配列）
  @layout

  #
  # コンストラクタ
  #
  #返り値:: 
  def initialize
    super
    @layout = []
  end

  #
  # レイアウトファイルを解析して変数に格納
  #
  #file :: レイアウトファイル（CSV）
  #
  #返り値:: true : エラーなし
  #         false ：エラーあり
  def set_layout(file)
    @layout = []
    CSV.foreach(file) do |row|
      @layout << row
    end
    self.check_layout(false)
  end

  #
  # レイアウトのエラーチェック
  #
  #message :: メッセージの出力有無
  #
  #返り値:: true : エラーなし
  #         false ：エラーあり
  def check_layout(message)
    error = false
    @layout.each_with_index do |item, index|
      if item.size != 2
        if message
          p (index + 1).to_s + "行目：" + '要素数異常 : ' + item.to_s
        end
        error = true
      end
      if item[0] && item[0] != "C" && item[0] != "I" && item[0] != "Z" && item[0] != "P"
        if message
          p (index + 1).to_s + "行目：" + '型異常 : ' + item.to_s
        end
        error = true
      end
    end
    return !error
  end
  
  #
  # レコード長（バイト数）を返す
  #
  #返り値:: レコード長（数値）
  def record_length
    length = 0
    @layout.each do |item|
      length += item[1].to_i
    end
    return length
  end
  
  #
  # CSVファイルをフラットファイルに変更
  #
  #file_csv :: CSVファイル（入力）
  #file_flat :: フラットファイル（出力）
  #
  #返り値:: 
  def csv_file_to_flat_file(file_csv, file_flat)
    open(file_flat, "w", encoding: 'cp932') do |f|
      CSV.foreach(file_csv, encoding: 'cp932') do |row|
        f.write csv_to_flat(row)
      end
    end
  end

  #
  # フラットファイルをCSVファイルに変更
  #
  #file_flat :: フラットファイル（入力）
  #file_csv :: CSVファイル（出力）
  #
  #返り値:: 
  def flat_file_to_csv_file(file_flat, file_csv)
    outbuf = ""
    CSV.open(file_csv, "wb", row_sep: "\r\n") do |csv|
      open(file_flat, encoding: 'cp932') do |file_in|
        ret = true
        while true
          csv_items = []
          @layout.each do |item|
            ret = file_in.read(item[1].to_i,outbuf)
            if ret.nil?
              break
            else
              outbuf.force_encoding("cp932")
              csv_items << outbuf.clone
            end
          end
          if csv_items.size > 0
            csv << csv_items
          end
          if ret.nil?
            break
          end
        end
      end
    end
  end

  #
  # CSVレコードをフラットレコードに変更
  #
  #str :: CSVレコード（String）
  #
  #返り値:: 
  def csv_to_flat(array_src = [])
    ans = ""
    @layout.each_with_index do |item, index|
      if item[0] == "C"
        ans += array_src[index].mb_rjust(item[1].to_i," ")
      else
        ans += array_src[index].mb_rjust(item[1].to_i,"0")
      end
    end
    ans
  end

  #
  # フラットレコードをCSVレコードに変更
  #
  #str :: CSVレコード（String）
  #
  #返り値:: 
  def pack_to_hex_str(file)
    str = ""
    open(file) do |f|
      f.each_byte do |b|
        str += "%02X" % b
      end
    end
    str
  end

  def hex_str_to_pack(file, str)
    array = []
    index = 0
    while true
      array << str[index, 2]
      index += 2
      if index > str.length
        break
      end
    end
    msg = []
    msg << array.join
    open(file, "w") do |f|
      f.write msg.pack("H*")
    end
  end


end
