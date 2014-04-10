# coding: utf-8

$:.unshift File.dirname(__FILE__)
require 'gov_file'

describe GovFile, "normal" do

  let(:gov_file) { GovFile.new }

  it 'csv_to_flat は CSVレコードからフラットファイルレコードを作成すること' do
    layout = [
               [ "C", "1" ],
               [ "C", "1" ],
               [ "C", "1" ],
               [ "C", "1" ],
               [ "C", "1" ]
             ]
    str_src = 'a,b,c,d,e'
    str_dst = 'abcde'

    gov_file.csv_to_flat(str_src, layout).should eq(str_dst)
  end

  it 'csv_to_flat は 数値の項目については左０埋めすること' do
    layout = [
               [ "I","10" ],
               [ "I","10" ]
             ]
    str_src = '1,2000'
    str_dst = '00000000010000002000'

    gov_file.csv_to_flat(str_src, layout).should eq(str_dst)
  end

  it 'csv_to_flat は 文字の項目については左半角SPACE埋めすること' do
    layout = [
               [ "C","10" ],
               [ "C","10" ]
             ]
    str_src = 'ab,c'
    str_dst = '        ab         c'

    gov_file.csv_to_flat(str_src, layout).should eq(str_dst)
  end

  it 'pack_to_hex_str は ファイルを読み込み１６進数イメージのテキストにすること' do
    str_dst = '000010000C'
    gov_file.pack_to_hex_str("bin.txt").should eq(str_dst)
  end

  it 'hex_str_to_pack は １６進数イメージのテキストをバイナリファイルに書き込むこと' do
    str_dst = '00112233'
    gov_file.hex_str_to_pack("bin2.txt", str_dst)
    gov_file.pack_to_hex_str("bin2.txt").should eq(str_dst)
  end

  it '元ファイルのa が bに置き換わったファイルが作成されること' do
    path_src = 'src.tsv'
    path_dst = 'dst.tsv'
    data_src = [
                ['a11', 'a12'],
                ['a21', 'a22']
               ]
    data_dst = [
                ['b11', 'b12'],
                ['b21', 'b22']
               ]
    contents_src_file = (data_src.map {|x| x.join("\t")}).join("\n") + "\n"

    File.stub(:open)
      .with(path_src, 'r')
      .and_return(StringIO.new((contents_src_file), 'r'))

    file_dst = StringIO.new('', 'w')

    File.stub(:open)
      .with(path_dst, 'w')
      .and_return(file_dst)

    ans = (data_dst.map {|x| x.join("\t")}).join("\n") + "\n"
    subject.run(path_src, path_dst)
    file_dst.string.should eq(ans)
  end

end
