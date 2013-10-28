#!/usr/bin/env ruby

require_relative 'game'

class LeagueController

  attr_reader :games
  attr_accessor :teams

  def initialize()

    @games = []
    # Use hash for faster lookup than array.
    # Could use Set to guarantee elements are unique, but lookup may not be as convenient.
    @teams = {}

  end

  # updates model objects @games and @teams
  # adds new teams and updates team attributes won, tied, lost.
  def add_games(a_games_string)

    if (a_games_string.nil? || ('' == a_games_string))
      return
    end

    a_games_string.each_line do |line|
      # add game
      # use chomp to remove line ending (platform independent \n, \r)
      game = Game.new(line.chomp)
      @games.push(game)

      update_teams(game)
    end

  end

  # private API. Exposed for use by unit tests
  def team_name_in_teams? (a_teams, a_team_name)
    a_teams.has_key?(a_team_name.to_sym)
  end

  # private API. Exposed for use by unit tests
  # adds team(s) to @teams if a_game involves one or more unknown teams
  def add_new_teams(a_game)
    a_game.game_teams.each do |game_team|
      unless team_name_in_teams?(@teams, game_team.name)
        team = Team.new(game_team.name)
        @teams[game_team.name.to_sym] = team
      end
    end
  end

  # private API. Exposed for use by unit tests
  # returns team instances matching a_game game_team instances
  def teams_in_game(a_game)
    teams_in_game = {}
    a_game.game_teams.each do |game_team|
      team_in_game = @teams[game_team.name.to_sym]
      teams_in_game[game_team.name.to_sym] = team_in_game
    end
    teams_in_game
  end

  # private API. Exposed for use by unit tests
  def teams_with_score_max(a_game)
    teams_with_score_max = {}
    game_teams_with_score_max = a_game.teams_with_score_max(a_game.game_teams)
    game_teams_with_score_max.each do |game_team_with_score_max|
      # find team instance matching game_team instance
      team_with_score_max = @teams[game_team_with_score_max.name.to_sym]
      teams_with_score_max[game_team_with_score_max.name.to_sym] = team_with_score_max
    end
    teams_with_score_max
  end

  # private API. Exposed for use by unit tests
  # updates won, tied, lost for each team in this game
  # adds new teams
  def update_teams(a_game)

    add_new_teams(a_game)

    teams_in_game = teams_in_game(a_game)
    teams_with_score_max = teams_with_score_max(a_game)

    teams_in_game.each_value do |team_in_game|

      if !teams_with_score_max.has_key?(team_in_game.name.to_sym)
        # team isn't in group with high score
        team_in_game.lost += 1

      else
        # team is in group with high score.
        # team won or tied
        if (1 == teams_with_score_max.length)
          # only one team has high score
          # team won
          team_in_game.won += 1
        elsif (2 <= teams_with_score_max.length)
          # more than one team has high score
          # team tied
          team_in_game.tied += 1
        end
      end
    end
  end

  # return ranked teams
  # sorted by points in decreasing order
  # for ties, secondary sort by name
  def ranked_teams(a_teams)
    ranked = []
    ranked = a_teams.values.to_a

    # http://stackoverflow.com/questions/15993693/ruby-sorting-hash-by-key-and-tie-breaking-on-value
    # http://www.rubyinside.com/how-to/ruby-sort-hash
    # returns array
    ranked.sort_by!{ |team| [-team.points, team.name] }
  end

  # write ranked teams to a file
  def write_ranked_teams(a_ranked_teams)

    ranked_string = ''
    rank = 1
    previous_team_points = a_ranked_teams[0].points
    a_ranked_teams.each do |team|
      if team.points < previous_team_points
        # This team isn't tied. Advance rank.
        # After ties, increment by more than 1 e.g. 1, 2, 3, 3, 5 not 1, 2, 3, 3, 4
        # add 1 because array index starts at 0, rank starts at 1.
        rank = a_ranked_teams.index(team) + 1
      end

      points_abbreviation = 'pts'
      if  1 == team.points
        points_abbreviation = 'pt'
      end

      # Assume we want to use newline \n at end of each line as specified in expected-output.txt
      # Alternatively could use File write line to get system dependent line ending.
      ranked_string.concat("#{rank}. #{team.name}, #{team.points} #{points_abbreviation}\n")

      previous_team_points = team.points
    end

    puts
    puts ranked_string
    # TODO Write to file
    ranked_string
  end

end
