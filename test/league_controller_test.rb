#!/usr/bin/env ruby

require 'minitest/unit'
require 'minitest/autorun'
require_relative '../lib/league_controller'

class LeagueControllerTest < MiniTest::Unit::TestCase

  def test_new_sets_file_encoding
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

    a_league_controller = LeagueController.new('./sample-input.txt', 'ascii')
    actual_result = a_league_controller.file_encoding
    expected_result = Encoding.find('US-ASCII')
    assert_equal(expected_result, actual_result)

    a_league_controller = LeagueController.new('./sample-input.txt', 'utf-8')
    actual_result = a_league_controller.file_encoding
    expected_result = Encoding.find('UTF-8')
    assert_equal(expected_result, actual_result)

    # this throws error
    # Encoding::InvalidByteSequenceError: "\xC3" on US-ASCII
    # a_league_controller = LeagueController.new('./sample-input-utf8.txt', 'ascii')

    a_league_controller = LeagueController.new('./sample-input-utf8.txt', 'utf-8')
    actual_result = a_league_controller.file_encoding
    expected_result = Encoding.find('UTF-8')
    assert_equal(expected_result, actual_result)
  end

  def test_new_sets_file_string

    a_league_controller = LeagueController.new('./sample-input.txt', 'utf-8')
    actual_result = a_league_controller.file_string
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

    a_league_controller = LeagueController.new('./sample-input-utf8.txt', 'utf-8')
    actual_result = a_league_controller.file_string
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

  def test_configure_games
    a_league_controller = LeagueController.new('./sample-input.txt', 'utf-8')
    a_league_controller.configure_games
    assert_equal(5, a_league_controller.games_array.count)

    test_game = a_league_controller.games_array[0]
    assert_equal('Lions', test_game.team_a_name)
    assert_equal(3, test_game.team_a_score)

    a_league_controller = LeagueController.new('./sample-input-utf8.txt', 'utf-8')
    a_league_controller.configure_games
    assert_equal(6, a_league_controller.games_array.count)

    test_game = a_league_controller.games_array[1]
    assert_equal('Tarantulas', test_game.team_a_name)
    assert_equal(1, test_game.team_a_score)

    test_game = a_league_controller.games_array[4]
    assert_equal('ƩƿƔƸȢ', test_game.team_b_name)
    assert_equal(268, test_game.team_b_score)
  end

end
