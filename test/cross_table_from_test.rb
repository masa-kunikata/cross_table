# frozen_string_literal: true

require 'test/unit'
require 'cross_table'
require File.join(__dir__, 'test_sample')

class CrossTableFromTest < Test::Unit::TestCase
  include TestSample

  def test_from
    cross_tbl = CrossTable.from(
      recs: JOBS, group_rules: [PRICE, OS],
      y_keys: PRICE.keys, x_keys: OS.keys
    ) do |group_recs|
      group_recs.map { |r| r[:price] }.min
    end

    expected = {
      price_high: { win: 850, no_win: 540, all: 540 },
      price_mid: {  win: 210, no_win: 200, all: 200 },
      price_low: {  win: 30,  no_win: 120, all: 30 },
      total: {      win: 30,  no_win: 120, all: 30 },
    }

    assert_equal(expected, cross_tbl)
  end
end
