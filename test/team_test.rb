#!/usr/bin/env ruby

require 'minitest/unit'
require_relative '../lib/team'

class TeamTest < MiniTest::Unit::TestCase

  def test_new_sets_name
    a_team = Team.new('Ravens')
    assert_equal('Ravens', a_team.name)
  end

  def test_new_sets_won_tied_lost
    a_team = Team.new('Alphas')
    assert_equal(0, a_team.won)
    assert_equal(0, a_team.tied)
    assert_equal(0, a_team.lost)
  end

  def test_points
    a_team = Team.new('Alphas')
    assert_equal(0, a_team.points)

    a_team.won = 1
    a_team.tied = 2
    a_team.lost = 4
    assert_equal(5, a_team.points)

    a_team.won = 19
    a_team.tied = 13
    a_team.lost = 456
    assert_equal(70, a_team.points)
  end

end
