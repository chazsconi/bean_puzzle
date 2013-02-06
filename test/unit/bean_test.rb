#require 'test_helper'
require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

module Puzzle
  class BeanTest < ActiveSupport::TestCase
    [:white, :yellow, :brown].each do |colour|
      [:big, :small].each do |size|
        test "Can create bean object of #{colour}, #{size}" do
          assert Puzzle::Bean.new(colour, size, :left, 5)
        end
      end
    end

    test "invalid bean colour" do
      assert_raise ArgumentError do
        Bean.new(:red,:small,:left, 5)
      end
    end

    test "invalid size" do
      assert_raise ArgumentError do
        Bean.new(:white,:medium,:left, 5)
      end
    end

    test "ID method works" do
      assert_equal "L5", Bean.new(:white,:big,:left, 5).id
      assert_equal "R5", Bean.new(:white,:big,:right, 5).id
      assert_equal "C5", Bean.new(:white,:big,:centre, 5).id
    end
  end
end