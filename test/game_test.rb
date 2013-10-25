#!/usr/bin/env ruby

require 'minitest/unit'
require_relative '../lib/game'

class GameTest < MiniTest::Unit::TestCase

  def test_new_sets_teams
    a_game = Game.new('Tarantulas 3, Snakes 1')
    assert_equal('Tarantulas', a_game.team_a)
  end

end
