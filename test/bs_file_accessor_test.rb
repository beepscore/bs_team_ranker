#!/usr/bin/env ruby

require 'minitest/unit'
require 'minitest/autorun'
require_relative '../lib/bs_file_accessor'

class BSFileAccessorTest < MiniTest::Unit::TestCase

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

    file_accessor = BSFileAccessor.new
    file_accessor.string_from_file('./sample-input.txt', 'ascii')
    actual_result = file_accessor.file_encoding
    expected_result = Encoding.find('US-ASCII')
    assert_equal(expected_result, actual_result)

    file_accessor = BSFileAccessor.new
    file_accessor.string_from_file('./sample-input.txt', 'utf-8')
    actual_result = file_accessor.file_encoding
    expected_result = Encoding.find('UTF-8')
    assert_equal(expected_result, actual_result)

    # this throws error
    # Encoding::InvalidByteSequenceError: "\xC3" on US-ASCII
    # file_accessor = BSFileAccessor.new
    # file_accessor.string_from_file('./sample-input-utf8.txt', 'ascii')

    file_accessor = BSFileAccessor.new
    file_accessor.string_from_file('./sample-input-utf8.txt', 'utf-8')
    expected_result = Encoding.find('UTF-8')
    assert_equal(expected_result, actual_result)
  end

  def test_string_from_file_returns_string

    file_accessor = BSFileAccessor.new
    actual_result = file_accessor.string_from_file('./sample-input.txt', 'utf-8')
    puts
    puts "file_string: #{actual_result}"
    expected_result = <<END
Lions 3, Snakes 3
Tarantulas 1, FC Awesome 0
Lions 1, FC Awesome 1
Tarantulas 3, Snakes 1
Lions 4, Grouches 0
END
    assert_equal(expected_result, actual_result)

    file_accessor = BSFileAccessor.new
    actual_result = file_accessor.string_from_file('./sample-input-utf8.txt', 'utf-8')
    puts
    puts "file_string: #{actual_result}"
    expected_result = <<END
Lions 3, Snakes 3
Tarantulas 1, FC Awesome 0
Lions 1, FC Awesome 1
Tarantulas 3, Snakes 1
áƏĭö 14, ƩƿƔƸȢ 268, Furry Bears 98
Lions 4, Grouches 0
END
    assert_equal(expected_result, actual_result)
  end

  def test_write
    test_games_string = <<END
Lions 3, Snakes 3
Tarantulas 1, FC Awesome 0
Lions 1, FC Awesome 1
Tarantulas 3, Snakes 1
Lions 4, Grouches 0
END

    # clean up before opening file
    if File.exists?('./junk.txt')
      File.delete('./junk.txt')
    end
    assert(!File.exists?('./junk.txt'))

    file_accessor = BSFileAccessor.new
    file_accessor.write(test_games_string, './junk.txt')

    assert(File.exists?('./junk.txt'))

    # On OS X in terminal, output file shows as us-ascii
    # $ file -I junk.txt
    # junk.txt: text/plain; charset=us-ascii

  end

  def test_write_utf8
    test_games_string = <<END
Lions 3, Snakes 3
Tarantulas 1, FC Awesome 0
Lions 1, FC Awesome 1
Tarantulas 3, Snakes 1
áƏĭö 14, ƩƿƔƸȢ 268, Furry Bears 98
Lions 4, Grouches 0
END
    # clean up before opening file
    if File.exists?('./junk_utf8.txt')
      File.delete('./junk_utf8.txt')
    end
    assert(!File.exists?('./junk_utf8.txt'))

    file_accessor = BSFileAccessor.new
    file_accessor.write(test_games_string, './junk_utf8.txt')

    assert(File.exists?('./junk_utf8.txt'))

    # On OS X in terminal, output file shows as utf-8
    # $ file -I junk_utf8.txt
    # junk_utf8.txt: text/plain; charset=utf-8
  end
end
