# frozen_string_literal: true

require 'test/unit'
require 'cross_table'
require File.join(__dir__, 'test_sample')

class CrossTableFromTest < Test::Unit::TestCase
  include TestSample

  def min(group_recs)
    group_recs.map { |r| r[:price] }.min
  end

  def test_from
    cross_tbl = CrossTable.from(
      recs: JOBS, group_rules: [PRICE, OS],
      y_keys: PRICE.keys, x_keys: OS.keys,
      &method(:min)
    )

    expected = {
      price_high: { win: 850, no_win: 540, all: 540 },
      price_mid: {  win: 210, no_win: 200, all: 200 },
      price_low: {  win: 30,  no_win: 120, all: 30 },
      total: {      win: 30,  no_win: 120, all: 30 },
    }

    assert_equal(expected, cross_tbl)
  end

  def test_from_xy_titles
    cross_tbl = CrossTable.from(
      recs: JOBS, group_rules: [PRICE, OS],
      y_keys: PRICE.keys, x_keys: OS.keys,
      ret_type: :xy_titles,
      &method(:min)
    )

    expected = [
      [nil, :win, :no_win, :all],
      [:price_high, 850, 540, 540],
      [:price_mid,  210, 200, 200],
      [:price_low,  30,  120, 30],
      [:total,      30,  120, 30],
    ]

    assert_equal(expected, cross_tbl)
  end

  def test_from_data_only
    cross_tbl = CrossTable.from(
      recs: JOBS, group_rules: [PRICE, OS],
      y_keys: PRICE.keys, x_keys: OS.keys,
      ret_type: :data_only,
      &method(:min)
    )

    expected = [
      [850, 540, 540],
      [210, 200, 200],
      [30,  120, 30],
      [30,  120, 30],
    ]

    assert_equal(expected, cross_tbl)
  end
end
