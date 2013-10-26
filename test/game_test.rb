#!/usr/bin/env ruby

require 'minitest/unit'
require_relative '../lib/game'

class GameTest < MiniTest::Unit::TestCase

  def test_new_sets_game_teams
    a_game = Game.new('Tarantulas 3, Snakes 1')
    assert_equal(2, a_game.game_teams.count)

    # test more than 2 teams
    a_game = Game.new('Tarantulas 1, FC Awesome 0, Invaders 3')
    assert_equal(3, a_game.game_teams.count)
  end

  # this test scope involves multiple methods, more than a single unit
  def test_new_sets_game_teams_names
    a_game = Game.new('Tarantulas 3, Snakes 1')
    assert_equal('Tarantulas', a_game.game_teams[0].name)
    assert_equal('Snakes', a_game.game_teams[1].name)

    a_game = Game.new('Tarantulas 1, FC Awesome 0')
    assert_equal('Tarantulas', a_game.game_teams[0].name)
    assert_equal('FC Awesome', a_game.game_teams[1].name)

    a_game = Game.new('áƏĭö 14, ƩƿƔƸȢ 268')
    assert_equal('áƏĭö', a_game.game_teams[0].name)
    assert_equal('ƩƿƔƸȢ', a_game.game_teams[1].name)
  end

  def test_new_sets_game_teams_scores
    a_game = Game.new('Tarantulas 3, Snakes 1')
    assert_equal(3, a_game.game_teams[0].score)
    assert_equal(1, a_game.game_teams[1].score)

    a_game = Game.new('Tarantulas 1, FC Awesome 0')
    assert_equal(1, a_game.game_teams[0].score)
    assert_equal(0, a_game.game_teams[1].score)

    a_game = Game.new('áƏĭö 14, ƩƿƔƸȢ 268')
    assert_equal(14, a_game.game_teams[0].score)
    assert_equal(268, a_game.game_teams[1].score)
  end

end
