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
    league_controller = LeagueController.new()
    assert_equal([], league_controller.games)
  end

  def test_new_sets_teams
    league_controller = LeagueController.new()
    assert_equal({}, league_controller.teams)
  end

  def test_add_games
    league_controller = LeagueController.new()
    league_controller.add_games(@games_string_ascii)
    assert_equal(5, league_controller.games.length)

    test_game = league_controller.games[0]
    assert_equal('Lions', test_game.game_teams[0].name)
    assert_equal(3, test_game.game_teams[0].score)

    league_controller = LeagueController.new()
    league_controller.add_games(@games_string_utf8)
    assert_equal(6, league_controller.games.length)

    test_game = league_controller.games[1]
    assert_equal('Tarantulas', test_game.game_teams[0].name)
    assert_equal(1, test_game.game_teams[0].score)

    test_game = league_controller.games[4]
    assert_equal('ƩƿƔƸȢ', test_game.game_teams[1].name)
    assert_equal(268, test_game.game_teams[1].score)
    assert_equal('Furry Bears', test_game.game_teams[2].name)
    assert_equal(98, test_game.game_teams[2].score)
  end

  def test_add_games_multiple_times
    league_controller = LeagueController.new()
    assert_equal(0, league_controller.games.length)
    league_controller.add_games(@games_string_ascii)
    assert_equal(5, league_controller.games.length)
    league_controller.add_games(@games_string_utf8)
    assert_equal(11, league_controller.games.length)
    league_controller.add_games(@games_string_ascii)
    assert_equal(16, league_controller.games.length)
  end

  def test_add_games_updates_teams
    league_controller = LeagueController.new()
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'Lions'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'Snakes'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'Tarantulas'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'FC Awesome'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'Grouches'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'Elephants'))

    league_controller.add_games(@games_string_ascii)

    assert(league_controller.team_name_in_teams?(league_controller.teams, 'Lions'))
    assert(league_controller.team_name_in_teams?(league_controller.teams, 'Snakes'))
    assert(league_controller.team_name_in_teams?(league_controller.teams, 'Tarantulas'))
    assert(league_controller.team_name_in_teams?(league_controller.teams, 'FC Awesome'))
    assert(league_controller.team_name_in_teams?(league_controller.teams, 'Grouches'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'Elephants'))

    lions = league_controller.teams['Lions'.to_sym]
    snakes = league_controller.teams['Snakes'.to_sym]
    tarantulas = league_controller.teams['Tarantulas'.to_sym]
    fc_awesome = league_controller.teams['FC Awesome'.to_sym]
    grouches = league_controller.teams['Grouches'.to_sym]

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

  def test_add_games_team_names_utf8
    league_controller = LeagueController.new()
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'Lions'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'Snakes'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'Tarantulas'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'FC Awesome'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'Grouches'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'áƏĭö'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'ƩƿƔƸȢ'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'Furry Bears'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'Elephants'))

    league_controller.add_games(@games_string_utf8)

    assert(league_controller.team_name_in_teams?(league_controller.teams, 'Lions'))
    assert(league_controller.team_name_in_teams?(league_controller.teams, 'Snakes'))
    assert(league_controller.team_name_in_teams?(league_controller.teams, 'Tarantulas'))
    assert(league_controller.team_name_in_teams?(league_controller.teams, 'FC Awesome'))
    assert(league_controller.team_name_in_teams?(league_controller.teams, 'Grouches'))
    assert(league_controller.team_name_in_teams?(league_controller.teams, 'áƏĭö'))
    assert(league_controller.team_name_in_teams?(league_controller.teams, 'ƩƿƔƸȢ'))
    assert(league_controller.team_name_in_teams?(league_controller.teams, 'Furry Bears'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'Elephants'))

    lions = league_controller.teams['Lions'.to_sym]
    snakes = league_controller.teams['Snakes'.to_sym]
    tarantulas = league_controller.teams['Tarantulas'.to_sym]
    fc_awesome = league_controller.teams['FC Awesome'.to_sym]
    grouches = league_controller.teams['Grouches'.to_sym]
    áƏĭö = league_controller.teams['áƏĭö'.to_sym]
    ƩƿƔƸȢ = league_controller.teams['ƩƿƔƸȢ'.to_sym]
    furry_bears = league_controller.teams['Furry Bears'.to_sym]

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

    assert_equal(0, áƏĭö.won)
    assert_equal(0, áƏĭö.tied)
    assert_equal(1, áƏĭö.lost)
    assert_equal(0, áƏĭö.points)

    assert_equal(1, ƩƿƔƸȢ.won)
    assert_equal(0, ƩƿƔƸȢ.tied)
    assert_equal(0, ƩƿƔƸȢ.lost)
    assert_equal(3, ƩƿƔƸȢ.points)

    assert_equal(0, furry_bears.won)
    assert_equal(0, furry_bears.tied)
    assert_equal(1, furry_bears.lost)
    assert_equal(0, furry_bears.points)
  end

  def test_team_name_in_teams
    league_controller = LeagueController.new()
    test_teams = {}
    assert(!league_controller.team_name_in_teams?(test_teams, 'Flounders'))
    assert(!league_controller.team_name_in_teams?(test_teams, 'Boom'))
    assert(!league_controller.team_name_in_teams?(test_teams, 'Kicks'))

    test_teams['Flounders'.to_sym] = Team.new('Flounders')
    assert(league_controller.team_name_in_teams?(test_teams, 'Flounders'))
    assert(!league_controller.team_name_in_teams?(test_teams, 'Boom'))
    assert(!league_controller.team_name_in_teams?(test_teams, 'Kicks'))

    test_teams['Boom'.to_sym] = Team.new('Boom')
    assert(league_controller.team_name_in_teams?(test_teams, 'Flounders'))
    assert(league_controller.team_name_in_teams?(test_teams, 'Boom'))
    assert(!league_controller.team_name_in_teams?(test_teams, 'Kicks'))
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

  def test_ranked_teams
    league_controller = LeagueController.new()
    league_controller.add_games(@games_string_ascii)

    actual_ranked_teams = league_controller.ranked_teams(league_controller.teams)
    assert_equal('Tarantulas', actual_ranked_teams[0].name)
    assert_equal(["Tarantulas", "Lions", "FC Awesome", "Snakes", "Grouches"],
                 actual_ranked_teams.map{ |team| team.name })
  end

  def test_write_ranked_teams
    league_controller = LeagueController.new()
    league_controller.add_games(@games_string_ascii)
    actual_result = league_controller.write_ranked_teams(league_controller.ranked_teams(league_controller.teams))

    expected_result = <<END
1. Tarantulas, 6 pts
2. Lions, 5 pts
3. FC Awesome, 1 pt
3. Snakes, 1 pt
5. Grouches, 0 pts
END

    assert_equal(expected_result, actual_result)
  end

end
