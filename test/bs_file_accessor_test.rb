#!/usr/bin/env ruby

require 'minitest/unit'
require 'minitest/autorun'
require_relative '../lib/bs_team_ranker/bs_file_accessor'
require_relative 'bs_test_constants'

class BsFileAccessorTest < MiniTest::Unit::TestCase

  def test_string_from_file_sets_file_encoding
    # Terminal file command shows
    # $ file sample-input.txt
    # sample-input.txt: ASCII text
    # $ file -I sample-input.txt
    # sample-input.txt: text/plain; charset=us-ascii

    # sample-input.txt team names don't have accented characters, but don't assume they can't.
    # In other words, don't assume file encoding will always be ASCII instead of UTF-8.
    # On Mac I used character viewer to drag accented characters into new file in MacVim
    # $ file sample-input-utf8.txt
    # sample-input-utf8.txt: UTF-8 Unicode text

    file_accessor = BsTeamRanker::BsFileAccessor.new
    file_accessor.string_from_file('./sample-input.txt', 'ascii')
    actual_result = file_accessor.file_encoding
    expected_result = Encoding.find('US-ASCII')
    assert_equal(expected_result, actual_result)

    file_accessor = BsTeamRanker::BsFileAccessor.new
    file_accessor.string_from_file('./sample-input.txt', 'utf-8')
    actual_result = file_accessor.file_encoding
    expected_result = Encoding.find('UTF-8')
    assert_equal(expected_result, actual_result)

    # this throws error
    # Encoding::InvalidByteSequenceError: "\xC3" on US-ASCII
    # file_accessor = BsTeamRanker::BsFileAccessor.new
    # file_accessor.string_from_file('./sample-input-utf8.txt', 'ascii')

    file_accessor = BsTeamRanker::BsFileAccessor.new
    file_accessor.string_from_file('./sample-input-utf8.txt', 'utf-8')
    expected_result = Encoding.find('UTF-8')
    assert_equal(expected_result, actual_result)
  end

  def test_string_from_file_returns_string

    file_accessor = BsTeamRanker::BsFileAccessor.new
    actual_result = file_accessor.string_from_file('./sample-input.txt', 'utf-8')
    puts
    puts "file_string: #{actual_result}"
    assert_equal(GAMES_STRING_ASCII, actual_result)

    file_accessor = BsTeamRanker::BsFileAccessor.new
    actual_result = file_accessor.string_from_file('./sample-input-utf8.txt', 'utf-8')
    puts
    puts "file_string: #{actual_result}"
    assert_equal(GAMES_STRING_UTF8, actual_result)
  end

  def test_write
    # clean up before opening file
    if File.exists?('./junk.txt')
      File.delete('./junk.txt')
    end
    assert(!File.exists?('./junk.txt'))

    file_accessor = BsTeamRanker::BsFileAccessor.new
    file_accessor.write(GAMES_STRING_ASCII, './junk.txt')

    assert(File.exists?('./junk.txt'))

    # On OS X in terminal, output file shows as us-ascii
    # $ file -I junk.txt
    # junk.txt: text/plain; charset=us-ascii
  end

  def test_write_utf8
    # clean up before opening file
    if File.exists?('./junk-utf8.txt')
      File.delete('./junk-utf8.txt')
    end
    assert(!File.exists?('./junk-utf8.txt'))

    file_accessor = BsTeamRanker::BsFileAccessor.new
    file_accessor.write(GAMES_STRING_UTF8, './junk-utf8.txt')

    assert(File.exists?('./junk-utf8.txt'))

    # On OS X in terminal, output file shows as utf-8
    # $ file -I junk-utf8.txt
    # junk-utf8.txt: text/plain; charset=utf-8
  end

end
