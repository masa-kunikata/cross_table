# frozen_string_literal: true

require 'test/unit'
require 'cross_table'
require File.join(__dir__, 'test_sample')

class CrossTableSumsTest < Test::Unit::TestCase
  include TestSample

  def test_sums_from
    cross_tbl = CrossTable.sums_from(
      recs: JOBS, field: :price, group_rules: [PRICE, OS],
      y_keys: PRICE.keys, x_keys: OS.keys
    )

    expected = {
      price_high: { win: 850,  no_win: 3070, all: 3920 },
      price_mid: {  win: 210,  no_win: 1260, all: 1470 },
      price_low: {  win: 440,  no_win: 280,  all: 720 },
      total: {      win: 1500, no_win: 4610, all: 6110 },
    }

    assert_equal(expected, cross_tbl)
  end

  def test_sums_from_xy_titles
    cross_tbl = CrossTable.sums_from(
      recs: JOBS, field: :price, group_rules: [PRICE, OS],
      y_keys: PRICE.keys, x_keys: OS.keys,
      ret_type: :xy_titles
    )

    expected = [
      [nil, :win, :no_win, :all],
      [:price_high, 850, 3070, 3920],
      [:price_mid, 210,  1260, 1470],
      [:price_low, 440,  280,  720],
      [:total,    1500,  4610, 6110],
    ]

    assert_equal(expected, cross_tbl)
  end

  def test_sums_from_data_only
    cross_tbl = CrossTable.sums_from(
      recs: JOBS, field: :price, group_rules: [PRICE, OS],
      y_keys: PRICE.keys, x_keys: OS.keys,
      ret_type: :data_only
    )

    expected = [
      [850,  3070, 3920],
      [210,  1260, 1470],
      [440,  280,  720],
      [1500, 4610, 6110],
    ]

    assert_equal(expected, cross_tbl)
  end
end
