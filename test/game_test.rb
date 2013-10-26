#!/usr/bin/env ruby

require 'minitest/unit'
require_relative '../lib/game'

class GameTest < MiniTest::Unit::TestCase

  def test_new_sets_teams
    a_game = Game.new('Tarantulas 3, Snakes 1')
    assert_equal('Tarantulas', a_game.team_a)
    assert_equal('Snakes', a_game.team_b)

    a_game = Game.new('Tarantulas 1, FC Awesome 0')
    assert_equal('Tarantulas', a_game.team_a)
    assert_equal('FC Awesome', a_game.team_b)

    a_game = Game.new('áƏĭö 14, ƩƿƔƸȢ 268')
    assert_equal('áƏĭö', a_game.team_a)
    assert_equal('ƩƿƔƸȢ', a_game.team_b)
  end

end
