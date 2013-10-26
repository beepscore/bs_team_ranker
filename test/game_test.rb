#!/usr/bin/env ruby

require 'minitest/unit'
require_relative '../lib/game'

class GameTest < MiniTest::Unit::TestCase

  # this test scope involves multiple methods, more than a single unit
  def test_new_sets_teams
    a_game = Game.new('Tarantulas 3, Snakes 1')
    assert_equal('Tarantulas', a_game.team_a_name)
    assert_equal('Snakes', a_game.team_b_name)

    a_game = Game.new('Tarantulas 1, FC Awesome 0')
    assert_equal('Tarantulas', a_game.team_a_name)
    assert_equal('FC Awesome', a_game.team_b_name)

    a_game = Game.new('áƏĭö 14, ƩƿƔƸȢ 268')
    assert_equal('áƏĭö', a_game.team_a_name)
    assert_equal('ƩƿƔƸȢ', a_game.team_b_name)
  end

  def test_new_sets_scores
    a_game = Game.new('Tarantulas 3, Snakes 1')
    assert_equal(3, a_game.team_a_score)
    assert_equal(1, a_game.team_b_score)

    a_game = Game.new('Tarantulas 1, FC Awesome 0')
    assert_equal(1, a_game.team_a_score)
    assert_equal(0, a_game.team_b_score)

    a_game = Game.new('áƏĭö 14, ƩƿƔƸȢ 268')
    assert_equal(14, a_game.team_a_score)
    assert_equal(268, a_game.team_b_score)
  end

  def test_name
    a_game = Game.new(nil)

    assert_equal('Tarantulas', a_game.name('Tarantulas 3'))
    assert_equal('FC Awesome', a_game.name('FC Awesome 0'))
    assert_equal('áƏĭö', a_game.name('áƏĭö 14'))
  end

  def test_score
    a_game = Game.new(nil)

    assert_equal(3, a_game.score('Tarantulas 3'))
    assert_equal(0, a_game.score('FC Awesome 0'))
    assert_equal(14, a_game.score('áƏĭö 14'))
  end

end
