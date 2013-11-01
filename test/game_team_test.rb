#!/usr/bin/env ruby

require 'minitest/autorun'
require_relative '../lib/bs_team_ranker/game_team'

class GameTeamTest < MiniTest::Test

  def test_new_sets_name
    game_team = BsTeamRanker::GameTeam.new(nil)
    assert_nil(game_team.name)

    game_team = BsTeamRanker::GameTeam.new('Ravens 12')
    assert_equal('Ravens', game_team.name)
  end

  def test_new_sets_score
    game_team = BsTeamRanker::GameTeam.new(nil)
    assert_nil(game_team.score)

    game_team = BsTeamRanker::GameTeam.new('Ravens 12')
    assert_equal(12, game_team.score)

    game_team = BsTeamRanker::GameTeam.new('FC Awesome 5')
    assert_equal(5, game_team.score)
  end

  def test_name_from_team_string
    game_team = BsTeamRanker::GameTeam.new(nil)

    assert_nil(game_team.name_from_team_string(nil))
    assert_equal('Tarantulas', game_team.name_from_team_string('Tarantulas 3'))
    assert_equal('FC Awesome', game_team.name_from_team_string('FC Awesome 0'))
    assert_equal('áƏĭö', game_team.name_from_team_string('áƏĭö 14'))
  end

  def test_score_from_team_string
  game_team = BsTeamRanker::GameTeam.new(nil)

    assert_nil(game_team.score_from_team_string(nil))
    assert_equal(3, game_team.score_from_team_string('Tarantulas 3'))
    assert_equal(0, game_team.score_from_team_string('FC Awesome 0'))
    assert_equal(14, game_team.score_from_team_string('áƏĭö 14'))
  end

end
