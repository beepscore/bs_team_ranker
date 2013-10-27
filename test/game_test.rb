#!/usr/bin/env ruby

require 'minitest/unit'
require_relative '../lib/game'

class GameTest < MiniTest::Unit::TestCase

  def test_new_sets_game_teams
    # test 0 teams
    a_game = Game.new(nil)
    assert_equal(0, a_game.game_teams.length)

    # test 1 team
    # Not useful for soccer, but could be useful for a single player game
    a_game = Game.new('Tarantulas 3')
    assert_equal(1, a_game.game_teams.length)

    # test 2 teams
    a_game = Game.new('Tarantulas 3, Snakes 1')
    assert_equal(2, a_game.game_teams.length)

    # test more than 2 teams
    a_game = Game.new('Tarantulas 1, FC Awesome 0, Invaders 3')
    assert_equal(3, a_game.game_teams.length)
  end

  # this test scope involves multiple methods, more than a single unit
  def test_new_sets_game_teams_names
    a_game = Game.new('Tarantulas 3, Snakes 1')
    assert_equal('Tarantulas', a_game.game_teams[0].name)
    assert_equal('Snakes', a_game.game_teams[1].name)


    # test more than 2 teams
    a_game = Game.new('Tarantulas 1, FC Awesome 0, Sammys 5')
    assert_equal('Tarantulas', a_game.game_teams[0].name)
    assert_equal('FC Awesome', a_game.game_teams[1].name)
    assert_equal('Sammys', a_game.game_teams[2].name)

    a_game = Game.new('áƏĭö 14, ƩƿƔƸȢ 268')
    assert_equal('áƏĭö', a_game.game_teams[0].name)
    assert_equal('ƩƿƔƸȢ', a_game.game_teams[1].name)
  end

  # this test scope involves multiple methods, more than a single unit
  def test_new_sets_game_teams_scores
    a_game = Game.new('Tarantulas 3, Snakes 1')
    assert_equal(3, a_game.game_teams[0].score)
    assert_equal(1, a_game.game_teams[1].score)

    # test more than 2 teams
    a_game = Game.new('Tarantulas 1, FC Awesome 0, Sammys 5')
    assert_equal(1, a_game.game_teams[0].score)
    assert_equal(0, a_game.game_teams[1].score)
    assert_equal(5, a_game.game_teams[2].score)

    a_game = Game.new('áƏĭö 14, ƩƿƔƸȢ 268')
    assert_equal(14, a_game.game_teams[0].score)
    assert_equal(268, a_game.game_teams[1].score)
  end

  def test_scores
    a_game = Game.new('Tarantulas 3, Snakes 1')
    assert_equal([3, 1], a_game.scores(a_game.game_teams))

    a_game = Game.new('Aardvarks 5, Tarantulas 1, FC Awesome 0, Sammys 5')
    assert_equal([5, 1, 0, 5], a_game.scores(a_game.game_teams))
  end

  def test_score_max
    a_game = Game.new(nil)
    assert_equal(nil, a_game.score_max(a_game.game_teams))

    a_game = Game.new('Tarantulas 3, Snakes 1')
    assert_equal(3, a_game.score_max(a_game.game_teams))

    a_game = Game.new('Aardvarks 5, Tarantulas 1, FC Awesome 0, Sammys 5')
    assert_equal(5, a_game.score_max(a_game.game_teams))
  end

  def test_teams_with_score
    # Don't create an array of expected teams and assert_equal arrays
    # array equality requires overriding == for elements and appears finicky
    # Instead check attributes individually
    # Reference
    # http://stackoverflow.com/questions/5265621/ruby-assert-equal-of-two-arrays-of-objects
    a_game = Game.new(nil)
    actual_teams = a_game.teams_with_score(a_game.game_teams, 3)
    assert_equal(0, actual_teams.length)

    a_game = Game.new('Aardvarks 5, Tarantulas 1, FC Awesome 0, Sammys 5')
    actual_teams = a_game.teams_with_score(a_game.game_teams, 3)
    assert_equal(0, actual_teams.length)

    actual_teams = a_game.teams_with_score(a_game.game_teams, 5)
    assert_equal(2, actual_teams.length)
    assert_equal('Aardvarks', actual_teams[0].name)
    assert_equal('Sammys', actual_teams[1].name)

    a_game = Game.new('Tarantulas 3, Snakes 1')
    actual_teams = a_game.teams_with_score(a_game.game_teams, 1)
    assert_equal(1, actual_teams.length)
  end

  def test_teams_with_score_max
    a_game = Game.new(nil)
    actual_teams = a_game.teams_with_score_max(a_game.game_teams)
    assert_equal(0, actual_teams.length)

    a_game = Game.new('Tarantulas 3, Snakes 1')
    actual_teams = a_game.teams_with_score_max(a_game.game_teams)
    assert_equal(1, actual_teams.length)
    assert_equal('Tarantulas', actual_teams[0].name)

    a_game = Game.new('Aardvarks 5, Tarantulas 1, FC Awesome 0, Sammys 5')
    actual_teams = a_game.teams_with_score_max(a_game.game_teams)
    assert_equal(2, actual_teams.length)
    assert_equal('Aardvarks', actual_teams[0].name)
    assert_equal('Sammys', actual_teams[1].name)
  end

end
