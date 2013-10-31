#!/usr/bin/env ruby

require 'minitest/unit'
require 'minitest/autorun'
require_relative '../lib/bs_team_ranker/bs_optparse'

class BsOptparseTest < MiniTest::Unit::TestCase

  def test_parse_short_flag
    test_argv = ['-o', './my-output.txt', './games-a.txt']
    options = BsTeamRanker::BsOptparse.parse!(test_argv)
    assert_equal('./my-output.txt', options.output_file_name)
    assert_equal(['./games-a.txt'], test_argv, 'expect parse! alters its argument')
  end

  def test_parse_multiple_input
    test_argv = ['-o', './my-output.txt', './games-a.txt', './games-b.txt']
    options = BsTeamRanker::BsOptparse.parse!(test_argv)
    assert_equal('./my-output.txt', options.output_file_name)
    assert_equal(['./games-a.txt', './games-b.txt'], test_argv, 'expect parse! alters its argument')
  end

  def test_parse_long_flag
    test_argv = ['--outfile=./my-output.txt', './games-a.txt', './games-b.txt']
    options = BsTeamRanker::BsOptparse.parse!(test_argv)
    assert_equal('./my-output.txt', options.output_file_name)
    assert_equal(['./games-a.txt', './games-b.txt'], test_argv, 'expect parse! alters its argument')
  end

  def test_parse_output_in_middle
    test_argv = ['./games-a.txt', '-o', './my-output.txt', './games-b.txt']
    options = BsTeamRanker::BsOptparse.parse!(test_argv)
    assert_equal('./my-output.txt', options.output_file_name)
    assert_equal(['./games-a.txt', './games-b.txt'], test_argv, 'expect parse! alters its argument')
  end

end
