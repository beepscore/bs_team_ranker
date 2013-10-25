#!/usr/bin/env ruby

require 'minitest/unit'
require_relative '../lib/team'

class TeamTest < MiniTest::Unit::TestCase

  def test_new_sets_name
    a_team = Team.new('Ravens')
    assert_equal('Ravens', a_team.name)
  end

end
