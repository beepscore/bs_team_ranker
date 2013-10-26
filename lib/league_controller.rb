#!/usr/bin/env ruby

require_relative 'game'

class LeagueController

  attr_reader :file_encoding
  attr_reader :file_name
  attr_reader :file_string
  attr_reader :games
  attr_reader :teams

  def initialize(file_name, external_encoding)
    @file_name = file_name

    # ruby 1.9.3 and ruby 2.0 default_external encoding is UTF-8
    # You can see this from irb
    # $ irb
    # irb(main):001:0> Encoding.default_external
    # => <Encoding:UTF-8>

    # https://www.ruby-lang.org/en/news/2013/02/24/ruby-2-0-0-p0-is-released/
    # default internal_encoding is nil. set it.
    internal_encoding = "utf-8"
    if (external_encoding == internal_encoding)
      # avoid ruby warning:
      # Ignoring internal encoding utf-8: it is identical to external encoding utf-8
      read_access_and_encoding = "r"
    else
      read_access_and_encoding = "r:#{external_encoding}:#{internal_encoding}"
    end

    # at end of block, file will be closed automatically
    File.open(@file_name, read_access_and_encoding) do |file|

      @file_encoding = file.external_encoding

      @file_string = ""
      file.each_line do |line|
        @file_string += line
      end

    end

    @games = []
    @teams = []

  end

  def add_games(a_games, a_games_string)
    a_games_string.each_line do |line|
      # add game
      # use chomp to remove line ending (platform independent \n, \r)
      game = Game.new(line.chomp)
      a_games.push(game)
    end
  end

  def team_name_in_teams? (a_teams, a_team_name)
    a_teams.any?{|team| team.name == a_team_name}
  end

  def update_teams(a_teams, a_game)
    a_game.game_teams.each do |game_team|
      # if game involves one or more unknown teams, add them to a_teams
      unless team_name_in_teams?(a_teams, game_team.name)
        team = Team.new(game_team.name)
        a_teams.push(team)
      end
    end
  end

end
