#!/usr/bin/env ruby

require 'minitest/autorun'
require_relative '../lib/bs_team_ranker/team'

class TeamTest < MiniTest::Test

  def test_new_sets_name
    team = BsTeamRanker::Team.new('Ravens')
    assert_equal('Ravens', team.name)
  end

  def test_new_sets_won_tied_lost
    team = BsTeamRanker::Team.new('Alphas')
    assert_equal(0, team.won)
    assert_equal(0, team.tied)
    assert_equal(0, team.lost)
  end

  def test_points
    team = BsTeamRanker::Team.new('Alphas')
    assert_equal(0, team.points)

    team.won = 1
    team.tied = 2
    team.lost = 4
    assert_equal(5, team.points)

    team.won = 19
    team.tied = 13
    team.lost = 456
    assert_equal(70, team.points)
  end

end
