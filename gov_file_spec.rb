# coding: utf-8

$:.unshift File.dirname(__FILE__)
require 'gov_file'
require 'fileutils'

describe GovFile, "normal" do

  let(:gov_file) { GovFile.new }

  it 'csv_to_flat は CSVレコードからフラットファイルレコードを作成すること' do
    str_src = ['a','b','c','d','e']
    str_dst = ' abcde'
    
    gov_file.set_layout("layout1.txt")

    gov_file.csv_to_flat(str_src).should eq(str_dst)
  end

  it 'csv_to_flat は 数値の項目については左０埋めすること' do
    str_src = ['1','2000' ]
    str_dst = '00000000010000002000'

    gov_file.set_layout("layout2.txt")

    gov_file.csv_to_flat(str_src).should eq(str_dst)
  end

  it 'csv_to_flat は 文字の項目については左半角SPACE埋めすること' do
    str_src = ['ab','c']
    str_dst = '        ab         c'

    gov_file.set_layout("layout3.txt")

    gov_file.csv_to_flat(str_src).should eq(str_dst)
  end

  it 'csv_file_to_flat_file は CSVファイルからフラットファイルを作成すること' do
    gov_file.set_layout("layout1.txt")
    gov_file.csv_file_to_flat_file("csv1.txt", "flat1.txt")
    FileUtils.cmp("flat1.txt", "flat1_ans.txt").should eq(true)
  end

  it 'flat_file_to_csv_file は フラットファイルからCSVファイルを作成すること' do
    gov_file.set_layout("layout1.txt")
    gov_file.flat_file_to_csv_file("flat2.txt", "csv2.txt")
    FileUtils.cmp("csv2.txt", "csv2_ans.txt").should eq(true)
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

  it 'check_layout は レイアウト定義ファイルが１行の項目が２ではない場合エラーとすること' do
    gov_file.set_layout("layout1_error.txt")
    gov_file.check_layout(false).should eq(false)
  end

  it 'check_layout は レイアウト定義ファイルの型が"C"/"I"以外の場合エラーとすること' do
    gov_file.set_layout("layout2_error.txt")
    gov_file.check_layout(false).should eq(false)
  end

  it 'record_length は レコード長を返す' do
    gov_file.set_layout("layout1.txt")
    gov_file.record_length.should eq(6)
    gov_file.set_layout("layout2.txt")
    gov_file.record_length.should eq(20)
  end

end
