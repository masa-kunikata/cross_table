# frozen_string_literal: true

require 'test/unit'
require 'cross_table'
require File.join(__dir__, 'test_sample')

class CrossTableAvgsTest < Test::Unit::TestCase
  include TestSample

  def test_avgs_from
    cross_tbl = CrossTable.avgs_from(
      recs: JOBS, field: :price, group_rules: [PRICE, OS],
      y_keys: PRICE.keys, x_keys: OS.keys
    )

    expected = {
      price_high: { win: 850.0, no_win: 767.5, all: 784.0 },
      price_mid: {  win: 210.0, no_win: 315.0, all: 294.0 },
      price_low: {  win: 110.0, no_win: 140.0, all: 120.0 },
      total: {      win: 250.0, no_win: 461.0, all: 381.875 },
    }

    assert_equal(expected, cross_tbl)
  end

  def test_avgs_from_xy_titles
    cross_tbl = CrossTable.avgs_from(
      recs: JOBS, field: :price, group_rules: [PRICE, OS],
      y_keys: PRICE.keys, x_keys: OS.keys,
      ret_type: :xy_titles
    )

    expected = [
      [nil, :win, :no_win, :all],
      [:price_high, 850.0, 767.5, 784.0],
      [:price_mid,  210.0, 315.0, 294.0],
      [:price_low,  110.0, 140.0, 120.0],
      [:total,      250.0, 461.0, 381.875],
    ]

    assert_equal(expected, cross_tbl)
  end

  def test_avgs_from_data_only
    cross_tbl = CrossTable.avgs_from(
      recs: JOBS, field: :price, group_rules: [PRICE, OS],
      y_keys: PRICE.keys, x_keys: OS.keys,
      ret_type: :data_only
    )

    expected = [
      [850.0, 767.5, 784.0],
      [210.0, 315.0, 294.0],
      [110.0, 140.0, 120.0],
      [250.0, 461.0, 381.875],
    ]

    assert_equal(expected, cross_tbl)
  end
end
