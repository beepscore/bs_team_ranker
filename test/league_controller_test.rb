#!/usr/bin/env ruby

require 'minitest/unit'
require 'minitest/autorun'
require_relative '../lib/bs_team_ranker/league_controller'
require_relative 'bs_test_constants'

class LeagueControllerTest < MiniTest::Unit::TestCase

  def test_new_sets_games
    league_controller = BsTeamRanker::LeagueController.new
    assert_equal([], league_controller.games)
  end

  def test_new_sets_teams
    league_controller = BsTeamRanker::LeagueController.new
    assert_equal({}, league_controller.teams)
  end

  def test_add_games
    league_controller = BsTeamRanker::LeagueController.new
    league_controller.add_games(GAMES_STRING_ASCII)
    assert_equal(5, league_controller.games.length)

    assert_equal(["Lions", "Tarantulas", "Lions", "Tarantulas", "Lions"],
                 league_controller.games.map{ |game| game.game_teams[0].name })
    assert_equal([3, 1, 1, 3, 4],
                 league_controller.games.map{ |game| game.game_teams[0].score })
    assert_equal(["Snakes", "FC Awesome", "FC Awesome", "Snakes", "Grouches"],
                 league_controller.games.map{ |game| game.game_teams[1].name })
    assert_equal([3, 0, 1, 1, 0],
                 league_controller.games.map{ |game| game.game_teams[1].score })

    league_controller = BsTeamRanker::LeagueController.new
    league_controller.add_games(GAMES_STRING_UTF8)
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
    league_controller = BsTeamRanker::LeagueController.new
    assert_equal(0, league_controller.games.length)
    league_controller.add_games(GAMES_STRING_ASCII)
    assert_equal(5, league_controller.games.length)
    league_controller.add_games(GAMES_STRING_UTF8)
    assert_equal(11, league_controller.games.length)
    league_controller.add_games(GAMES_STRING_ASCII)
    assert_equal(16, league_controller.games.length)
  end

  def test_add_games_updates_teams
    league_controller = BsTeamRanker::LeagueController.new
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'Lions'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'Snakes'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'Tarantulas'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'FC Awesome'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'Grouches'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'Elephants'))

    league_controller.add_games(GAMES_STRING_ASCII)

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

    assert_equal([1, 2, 0, 5], [lions.won, lions.tied, lions.lost, lions.points])
    assert_equal([0, 1, 1, 1], [snakes.won, snakes.tied, snakes.lost, snakes.points])
    assert_equal([2, 0, 0, 6], [tarantulas.won, tarantulas.tied, tarantulas.lost, tarantulas.points])
    assert_equal([0, 1, 1, 1], [fc_awesome.won, fc_awesome.tied, fc_awesome.lost, fc_awesome.points])
    assert_equal([0, 0, 1, 0], [grouches.won, grouches.tied, grouches.lost, grouches.points])
  end

  def test_add_games_team_names_utf8
    league_controller = BsTeamRanker::LeagueController.new
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'Lions'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'Snakes'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'Tarantulas'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'FC Awesome'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'Grouches'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'áƏĭö'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'ƩƿƔƸȢ'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'Furry Bears'))
    assert(!league_controller.team_name_in_teams?(league_controller.teams, 'Elephants'))

    league_controller.add_games(GAMES_STRING_UTF8)

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

    assert_equal([1, 2, 0, 5], [lions.won, lions.tied, lions.lost, lions.points])
    assert_equal([0, 1, 1, 1], [snakes.won, snakes.tied, snakes.lost, snakes.points])
    assert_equal([2, 0, 0, 6], [tarantulas.won, tarantulas.tied, tarantulas.lost, tarantulas.points])
    assert_equal([0, 1, 1, 1], [fc_awesome.won, fc_awesome.tied, fc_awesome.lost, fc_awesome.points])
    assert_equal([0, 0, 1, 0], [grouches.won, grouches.tied, grouches.lost, grouches.points])
    assert_equal([0, 0, 1, 0], [áƏĭö.won, áƏĭö.tied, áƏĭö.lost, áƏĭö.points])
    assert_equal([1, 0, 0, 3], [ƩƿƔƸȢ.won, ƩƿƔƸȢ.tied, ƩƿƔƸȢ.lost, ƩƿƔƸȢ.points])
    assert_equal([0, 0, 1, 0], [furry_bears.won, furry_bears.tied, furry_bears.lost, furry_bears.points])
  end

  def test_team_name_in_teams
    league_controller = BsTeamRanker::LeagueController.new
    test_teams = {}
    assert(!league_controller.team_name_in_teams?(test_teams, 'Flounders'))
    assert(!league_controller.team_name_in_teams?(test_teams, 'Boom'))
    assert(!league_controller.team_name_in_teams?(test_teams, 'Kicks'))

    test_teams['Flounders'.to_sym] = BsTeamRanker::Team.new('Flounders')
    assert(league_controller.team_name_in_teams?(test_teams, 'Flounders'))
    assert(!league_controller.team_name_in_teams?(test_teams, 'Boom'))
    assert(!league_controller.team_name_in_teams?(test_teams, 'Kicks'))

    test_teams['Boom'.to_sym] = BsTeamRanker::Team.new('Boom')
    assert(league_controller.team_name_in_teams?(test_teams, 'Flounders'))
    assert(league_controller.team_name_in_teams?(test_teams, 'Boom'))
    assert(!league_controller.team_name_in_teams?(test_teams, 'Kicks'))
  end

  def test_teams_in_game
    league_controller = BsTeamRanker::LeagueController.new
    league_controller.add_games(GAMES_STRING_ASCII)
    assert_equal(2, league_controller.teams_in_game(league_controller.games[0]).size)

    # expect allow more than 2 teams in a game
    league_controller = BsTeamRanker::LeagueController.new
    league_controller.add_games(GAMES_STRING_UTF8)
    assert_equal(3, league_controller.teams_in_game(league_controller.games[4]).size)
  end

  def test_ranked_teams
    league_controller = BsTeamRanker::LeagueController.new
    league_controller.add_games(GAMES_STRING_ASCII)

    actual_ranked_teams = league_controller.ranked_teams(league_controller.teams)
    assert_equal('Tarantulas', actual_ranked_teams[0].name)
    assert_equal(["Tarantulas", "Lions", "FC Awesome", "Snakes", "Grouches"],
                 actual_ranked_teams.map{ |team| team.name })
  end

  def test_ranked_teams_string_ascii
    league_controller = BsTeamRanker::LeagueController.new
    league_controller.add_games(GAMES_STRING_ASCII)
    actual_result = league_controller.ranked_teams_string(league_controller.ranked_teams(league_controller.teams))

    expected_result = <<END
1. Tarantulas, 6 pts
2. Lions, 5 pts
3. FC Awesome, 1 pt
3. Snakes, 1 pt
5. Grouches, 0 pts
END

    assert_equal(expected_result, actual_result)
  end

  def test_ranked_teams_string_utf8
    league_controller = BsTeamRanker::LeagueController.new
    league_controller.add_games(GAMES_STRING_UTF8)
    actual_result = league_controller.ranked_teams_string(league_controller.ranked_teams(league_controller.teams))

    expected_result = <<END
1. Tarantulas, 6 pts
2. Lions, 5 pts
3. ƩƿƔƸȢ, 3 pts
4. FC Awesome, 1 pt
4. Snakes, 1 pt
6. Furry Bears, 0 pts
6. Grouches, 0 pts
6. áƏĭö, 0 pts
END

    assert_equal(expected_result, actual_result)
  end

end
