# coding: utf-8
$:.unshift File.dirname(__FILE__)

#
# ファイルアクセス
#
class GovFile

  #
  # CSVレコードをフラットレコードに変更
  #
  #str :: CSVレコード（String）
  #layout :: CSVのレイアウト
  #
  #返り値:: 
  def csv_to_flat(str = "", layout = [])
    ans = ""
    array_src = str.split(",")
    layout.each_with_index do |item, index|
      if item[0] == "C"
        ans += array_src[index].rjust(item[1].to_i," ")
      else
        ans += array_src[index].rjust(item[1].to_i,"0")
      end
    end
    ans
  end
  
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

  def run(path_src, path_dst)
    x = load(path_src)
    y = transform(x)
    save(y, path_dst)
  end

  def load(path)
    fp = ::File.open(path, 'r')
    data = []
    fp.each do |line|
      line.chop!
      data.push(line.split("\t"))
    end
    fp.close

    data
  end

  def transform(x)
    x.map {|t| t.map {|s| s.gsub(/a/, 'b')}}
  end

  def save(y, path)
    fp = ::File.open(path, 'w')
    y.each do |x|
      fp.write(x.join("\t") + "\n")
    end
    fp.close
  end

end
