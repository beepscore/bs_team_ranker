#!/usr/bin/env ruby

require 'test/unit'
require 'minitest/autorun'

require_relative '../lib/game_results'

class GameResultsTest < MiniTest::Unit::TestCase

  def setup()
  end

  def teardown()
  end

  def test_new_sets_file_encoding()
    # Terminal file command shows
    # $ file sample-input.txt
    # sample-input.txt: ASCII text
    #
    # sample-input.txt team names don't have accented characters, but don't assume they can't.
    # In other words, don't assume file encoding will always be ASCII instead of UTF-8.
    # On Mac I used character viewer to drag accented characters into new file in MacVim
    # $ file sample-input-utf8.txt
    # sample-input-utf8.txt: UTF-8 Unicode text

    a_game_results = GameResults.new('./sample-input.txt', 'ascii')
    actual_result = a_game_results.file_encoding
    expected_result = Encoding.find('US-ASCII')
    assert_equal(expected_result, actual_result)

    a_game_results = GameResults.new('./sample-input.txt', 'utf-8')
    actual_result = a_game_results.file_encoding
    expected_result = Encoding.find('UTF-8')
    assert_equal(expected_result, actual_result)

    # this throws error
    # Encoding::InvalidByteSequenceError: "\xC3" on US-ASCII
    # a_game_results = GameResults.new('./sample-input-utf8.txt', 'ascii')

    a_game_results = GameResults.new('./sample-input-utf8.txt', 'utf-8')
    actual_result = a_game_results.file_encoding
    expected_result = Encoding.find('UTF-8')
    assert_equal(expected_result, actual_result)
  end

  def test_new_sets_file_string()

    a_game_results = GameResults.new('./sample-input.txt', 'utf-8')
    actual_result = a_game_results.file_string
    puts ''
    puts 'file_string:' + actual_result
    expected_result = <<END
Lions 3, Snakes 3
Tarantulas 1, FC Awesome 0
Lions 1, FC Awesome 1
Tarantulas 3, Snakes 1
Lions 4, Grouches 0
END
    assert_equal(expected_result, actual_result)

    a_game_results = GameResults.new('./sample-input-utf8.txt', 'utf-8')
    actual_result = a_game_results.file_string
    puts ''
    puts 'file_string:' + actual_result
    expected_result = <<END
Lions 3, Snakes 3
Tarantulas 1, FC Awesome 0
Lions 1, FC Awesome 1
Tarantulas 3, Snakes 1
áƏĭö 14, ƩƿƔƸȢ 268
Lions 4, Grouches 0
END
    assert_equal(expected_result, actual_result)
  end

  def test_configure_games()
    a_game_results = GameResults.new('./sample-input.txt', 'utf-8')
    a_game_results.configure_games
    actual_count = a_game_results.games_array.count
    expected_count = 5
    assert_equal(expected_count, actual_count)

    actual_result = a_game_results.games_array
    expected_result = ["Lions 3, Snakes 3",
                       "Tarantulas 1, FC Awesome 0",
                       "Lions 1, FC Awesome 1",
                       "Tarantulas 3, Snakes 1",
                       "Lions 4, Grouches 0"]
    assert_equal(expected_result, actual_result)

    a_game_results = GameResults.new('./sample-input-utf8.txt', 'utf-8')
    a_game_results.configure_games
    actual_count = a_game_results.games_array.count
    expected_count = 6
    assert_equal(expected_count, actual_count)

    actual_result = a_game_results.games_array
    assert_equal("Tarantulas 1, FC Awesome 0", a_game_results.games_array[1])
    assert_equal("áƏĭö 14, ƩƿƔƸȢ 268", a_game_results.games_array[4])
  end

end
