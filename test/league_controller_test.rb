#!/usr/bin/env ruby

require 'minitest/unit'
require 'minitest/autorun'
require_relative '../lib/league_controller'

class LeagueControllerTest < MiniTest::Unit::TestCase

  attr_reader :games_string_ascii
  attr_reader :games_string_utf8

  def setup
    @games_string_ascii = <<END
Lions 3, Snakes 3
Tarantulas 1, FC Awesome 0
Lions 1, FC Awesome 1
Tarantulas 3, Snakes 1
Lions 4, Grouches 0
END

    @games_string_utf8 = <<END
Lions 3, Snakes 3
Tarantulas 1, FC Awesome 0
Lions 1, FC Awesome 1
Tarantulas 3, Snakes 1
áƏĭö 14, ƩƿƔƸȢ 268, Furry Bears 98
Lions 4, Grouches 0
END
  end

  def test_new_sets_games
    a_league_controller = LeagueController.new()
    assert_equal([], a_league_controller.games)
  end

  def test_new_sets_teams
    a_league_controller = LeagueController.new()
    assert_equal({}, a_league_controller.teams)
  end

  def test_add_games
    a_league_controller = LeagueController.new()
    a_league_controller.add_games(@games_string_ascii)
    assert_equal(5, a_league_controller.games.length)

    test_game = a_league_controller.games[0]
    assert_equal('Lions', test_game.game_teams[0].name)
    assert_equal(3, test_game.game_teams[0].score)

    a_league_controller = LeagueController.new()
    a_league_controller.add_games(@games_string_utf8)
    assert_equal(6, a_league_controller.games.length)

    test_game = a_league_controller.games[1]
    assert_equal('Tarantulas', test_game.game_teams[0].name)
    assert_equal(1, test_game.game_teams[0].score)

    test_game = a_league_controller.games[4]
    assert_equal('ƩƿƔƸȢ', test_game.game_teams[1].name)
    assert_equal(268, test_game.game_teams[1].score)
    assert_equal('Furry Bears', test_game.game_teams[2].name)
    assert_equal(98, test_game.game_teams[2].score)
  end

  def test_add_games_multiple_times
    a_league_controller = LeagueController.new()
    assert_equal(0, a_league_controller.games.length)
    a_league_controller.add_games(@games_string_ascii)
    assert_equal(5, a_league_controller.games.length)
    a_league_controller.add_games(@games_string_utf8)
    assert_equal(11, a_league_controller.games.length)
    a_league_controller.add_games(@games_string_ascii)
    assert_equal(16, a_league_controller.games.length)
  end

  def test_team_name_in_teams
    a_league_controller = LeagueController.new()
    test_teams = {}
    assert(!a_league_controller.team_name_in_teams?(test_teams, 'Flounders'))
    assert(!a_league_controller.team_name_in_teams?(test_teams, 'Boom'))
    assert(!a_league_controller.team_name_in_teams?(test_teams, 'Kicks'))

    test_teams['Flounders'.to_sym] = Team.new('Flounders')
    assert(a_league_controller.team_name_in_teams?(test_teams, 'Flounders'))
    assert(!a_league_controller.team_name_in_teams?(test_teams, 'Boom'))
    assert(!a_league_controller.team_name_in_teams?(test_teams, 'Kicks'))

    test_teams['Boom'.to_sym] = Team.new('Boom')
    assert(a_league_controller.team_name_in_teams?(test_teams, 'Flounders'))
    assert(a_league_controller.team_name_in_teams?(test_teams, 'Boom'))
    assert(!a_league_controller.team_name_in_teams?(test_teams, 'Kicks'))
  end

  def test_teams_in_game
    league_controller = LeagueController.new()
    league_controller.add_games(@games_string_ascii)
    assert_equal(2, league_controller.teams_in_game(league_controller.games[0]).size)

    # expect allow more than 2 teams in a game
    league_controller = LeagueController.new()
    league_controller.add_games(@games_string_utf8)
    assert_equal(3, league_controller.teams_in_game(league_controller.games[4]).size)
  end

  def test_add_games_updates_teams
    a_league_controller = LeagueController.new()
    assert(!a_league_controller.team_name_in_teams?(a_league_controller.teams, 'Lions'))
    assert(!a_league_controller.team_name_in_teams?(a_league_controller.teams, 'Snakes'))
    assert(!a_league_controller.team_name_in_teams?(a_league_controller.teams, 'Tarantulas'))
    assert(!a_league_controller.team_name_in_teams?(a_league_controller.teams, 'FC Awesome'))
    assert(!a_league_controller.team_name_in_teams?(a_league_controller.teams, 'Grouches'))
    assert(!a_league_controller.team_name_in_teams?(a_league_controller.teams, 'Elephants'))

    a_league_controller.add_games(@games_string_ascii)

    assert(a_league_controller.team_name_in_teams?(a_league_controller.teams, 'Lions'))
    assert(a_league_controller.team_name_in_teams?(a_league_controller.teams, 'Snakes'))
    assert(a_league_controller.team_name_in_teams?(a_league_controller.teams, 'Tarantulas'))
    assert(a_league_controller.team_name_in_teams?(a_league_controller.teams, 'FC Awesome'))
    assert(a_league_controller.team_name_in_teams?(a_league_controller.teams, 'Grouches'))
    assert(!a_league_controller.team_name_in_teams?(a_league_controller.teams, 'Elephants'))

    lions = a_league_controller.teams['Lions'.to_sym]
    snakes = a_league_controller.teams['Snakes'.to_sym]
    tarantulas = a_league_controller.teams['Tarantulas'.to_sym]
    fc_awesome = a_league_controller.teams['FC Awesome'.to_sym]
    grouches = a_league_controller.teams['Grouches'.to_sym]

    assert_equal(1, lions.won)
    assert_equal(2, lions.tied)
    assert_equal(0, lions.lost)
    assert_equal(5, lions.points)

    assert_equal(0, snakes.won)
    assert_equal(1, snakes.tied)
    assert_equal(1, snakes.lost)
    assert_equal(1, snakes.points)

    assert_equal(2, tarantulas.won)
    assert_equal(0, tarantulas.tied)
    assert_equal(0, tarantulas.lost)
    assert_equal(6, tarantulas.points)

    assert_equal(0, fc_awesome.won)
    assert_equal(1, fc_awesome.tied)
    assert_equal(1, fc_awesome.lost)
    assert_equal(1, fc_awesome.points)

    assert_equal(0, grouches.won)
    assert_equal(0, grouches.tied)
    assert_equal(1, grouches.lost)
    assert_equal(0, grouches.points)
  end

end
