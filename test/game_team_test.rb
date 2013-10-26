#!/usr/bin/env ruby

require 'minitest/unit'
require_relative '../lib/game_team'

class GameTeamTest < MiniTest::Unit::TestCase

  def test_new_sets_name
    a_game_team = GameTeam.new('Ravens')
    assert_equal('Ravens', a_game_team.name)
  end

  def test_new_sets_score
    a_game_team = GameTeam.new('Alphas')
    assert_equal(0, a_game_team.score)
  end

end
