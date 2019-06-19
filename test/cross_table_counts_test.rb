# frozen_string_literal: true

require 'test/unit'
require 'cross_table'
require File.join(__dir__, 'test_sample')

class CrossTableCountsTest < Test::Unit::TestCase
  include TestSample

  def test_counts_from
    cross_tbl = CrossTable.counts_from(
      recs: JOBS, group_rules: [PRICE, OS],
      y_keys: PRICE.keys, x_keys: OS.keys
    )

    expected = {
      price_high: { win: 1, no_win: 4,  all: 5 },
      price_mid: {  win: 1, no_win: 4,  all: 5 },
      price_low: {  win: 4, no_win: 2,  all: 6 },
      total: {      win: 6, no_win: 10, all: 16 },
    }

    assert_equal(expected, cross_tbl)
  end

  def test_counts_from_xy_titles
    cross_tbl = CrossTable.counts_from(
      recs: JOBS, group_rules: [PRICE, OS],
      y_keys: PRICE.keys, x_keys: OS.keys,
      ret_type: :xy_titles
    )

    expected = [
      [nil, :win, :no_win, :all],
      [:price_high, 1, 4,  5],
      [:price_mid,  1, 4,  5],
      [:price_low,  4, 2,  6],
      [:total,      6, 10, 16]
    ]

    assert_equal(expected, cross_tbl)
  end

  def test_counts_from_data_only
    cross_tbl = CrossTable.counts_from(
      recs: JOBS, group_rules: [PRICE, OS],
      y_keys: PRICE.keys, x_keys: OS.keys,
      ret_type: :data_only
    )

    expected = [
      [1, 4, 5],
      [1, 4, 5],
      [4, 2, 6],
      [6, 10, 16]
    ]

    assert_equal(expected, cross_tbl)
  end
end
