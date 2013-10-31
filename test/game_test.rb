#!/usr/bin/env ruby

require 'minitest/unit'
require_relative '../lib/bs_team_ranker/game'

class GameTest < MiniTest::Unit::TestCase

  def test_new_sets_game_teams
    # test 0 teams
    game = BsTeamRanker::Game.new(nil)
    assert_equal(0, game.game_teams.length)

    # test 1 team
    # Not useful for soccer, but could be useful for a single player game
    game = BsTeamRanker::Game.new('Tarantulas 3')
    assert_equal(1, game.game_teams.length)

    # test 2 teams
    game = BsTeamRanker::Game.new('Tarantulas 3, Snakes 1')
    assert_equal(2, game.game_teams.length)

    # test more than 2 teams
    game = BsTeamRanker::Game.new('Tarantulas 1, FC Awesome 0, Invaders 3')
    assert_equal(3, game.game_teams.length)
  end

  # this test scope involves multiple methods, more than a single unit
  def test_new_sets_game_teams_names
    game = BsTeamRanker::Game.new('Tarantulas 3, Snakes 1')
    assert_equal('Tarantulas', game.game_teams[0].name)
    assert_equal('Snakes', game.game_teams[1].name)


    # test more than 2 teams
    game = BsTeamRanker::Game.new('Tarantulas 1, FC Awesome 0, Sammys 5')
    assert_equal('Tarantulas', game.game_teams[0].name)
    assert_equal('FC Awesome', game.game_teams[1].name)
    assert_equal('Sammys', game.game_teams[2].name)

    game = BsTeamRanker::Game.new('áƏĭö 14, ƩƿƔƸȢ 268')
    assert_equal('áƏĭö', game.game_teams[0].name)
    assert_equal('ƩƿƔƸȢ', game.game_teams[1].name)
  end

  # this test scope involves multiple methods, more than a single unit
  def test_new_sets_game_teams_scores
    game = BsTeamRanker::Game.new('Tarantulas 3, Snakes 1')
    assert_equal(3, game.game_teams[0].score)
    assert_equal(1, game.game_teams[1].score)

    # test more than 2 teams
    game = BsTeamRanker::Game.new('Tarantulas 1, FC Awesome 0, Sammys 5')
    assert_equal(1, game.game_teams[0].score)
    assert_equal(0, game.game_teams[1].score)
    assert_equal(5, game.game_teams[2].score)

    game = BsTeamRanker::Game.new('áƏĭö 14, ƩƿƔƸȢ 268')
    assert_equal(14, game.game_teams[0].score)
    assert_equal(268, game.game_teams[1].score)
  end

  def test_scores
    game = BsTeamRanker::Game.new('Tarantulas 3, Snakes 1')
    assert_equal([3, 1], game.scores(game.game_teams))

    game = BsTeamRanker::Game.new('Aardvarks 5, Tarantulas 1, FC Awesome 0, Sammys 5')
    assert_equal([5, 1, 0, 5], game.scores(game.game_teams))
  end

  def test_score_max
    game = BsTeamRanker::Game.new(nil)
    assert_equal(nil, game.score_max(game.game_teams))

    game = BsTeamRanker::Game.new('Tarantulas 3, Snakes 1')
    assert_equal(3, game.score_max(game.game_teams))

    game = BsTeamRanker::Game.new('Aardvarks 5, Tarantulas 1, FC Awesome 0, Sammys 5')
    assert_equal(5, game.score_max(game.game_teams))
  end

  def test_teams_with_score
    # Don't create an array of expected teams and assert_equal arrays
    # array equality requires overriding == for elements and appears finicky
    # Instead check attributes individually
    # Reference
    # http://stackoverflow.com/questions/5265621/ruby-assert-equal-of-two-arrays-of-objects
    game = BsTeamRanker::Game.new(nil)
    actual_teams = game.teams_with_score(game.game_teams, 3)
    assert_equal(0, actual_teams.length)

    game = BsTeamRanker::Game.new('Aardvarks 5, Tarantulas 1, FC Awesome 0, Sammys 5')
    actual_teams = game.teams_with_score(game.game_teams, 3)
    assert_equal(0, actual_teams.length)

    actual_teams = game.teams_with_score(game.game_teams, 5)
    assert_equal(2, actual_teams.length)
    assert_equal('Aardvarks', actual_teams[0].name)
    assert_equal('Sammys', actual_teams[1].name)

    game = BsTeamRanker::Game.new('Tarantulas 3, Snakes 1')
    actual_teams = game.teams_with_score(game.game_teams, 1)
    assert_equal(1, actual_teams.length)
  end

  def test_teams_with_score_max
    game = BsTeamRanker::Game.new(nil)
    actual_teams = game.teams_with_score_max(game.game_teams)
    assert_equal(0, actual_teams.length)

    game = BsTeamRanker::Game.new('Tarantulas 3, Snakes 1')
    actual_teams = game.teams_with_score_max(game.game_teams)
    assert_equal(1, actual_teams.length)
    assert_equal('Tarantulas', actual_teams[0].name)

    game = BsTeamRanker::Game.new('Aardvarks 5, Tarantulas 1, FC Awesome 0, Sammys 5')
    actual_teams = game.teams_with_score_max(game.game_teams)
    assert_equal(2, actual_teams.length)
    assert_equal('Aardvarks', actual_teams[0].name)
    assert_equal('Sammys', actual_teams[1].name)
  end

end
