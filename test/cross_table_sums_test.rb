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
end
