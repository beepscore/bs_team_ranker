#!/usr/bin/env ruby

require 'minitest/unit'
require_relative '../lib/game_team'

class GameTeamTest < MiniTest::Unit::TestCase

  def test_new_sets_name
    a_game_team = GameTeam.new(nil)
    assert_nil(a_game_team.name)

    a_game_team = GameTeam.new('Ravens 12')
    assert_equal('Ravens', a_game_team.name)
  end

  def test_new_sets_score
    a_game_team = GameTeam.new(nil)
    assert_nil(a_game_team.score)

    a_game_team = GameTeam.new('Ravens 12')
    assert_equal(12, a_game_team.score)

    a_game_team = GameTeam.new('FC Awesome 5')
    assert_equal(5, a_game_team.score)
  end

  def test_name_from_team_string
    a_game_team = GameTeam.new(nil)

    assert_nil(a_game_team.name_from_team_string(nil))
    assert_equal('Tarantulas', a_game_team.name_from_team_string('Tarantulas 3'))
    assert_equal('FC Awesome', a_game_team.name_from_team_string('FC Awesome 0'))
    assert_equal('áƏĭö', a_game_team.name_from_team_string('áƏĭö 14'))
  end

  def test_score_from_team_string
    a_game_team = GameTeam.new(nil)

    assert_nil(a_game_team.score_from_team_string(nil))
    assert_equal(3, a_game_team.score_from_team_string('Tarantulas 3'))
    assert_equal(0, a_game_team.score_from_team_string('FC Awesome 0'))
    assert_equal(14, a_game_team.score_from_team_string('áƏĭö 14'))
  end

end
