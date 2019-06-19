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

    expected =
      {:price_high=>{:win=>850.0, :no_win=>767.5, :all=>784.0},
       :price_mid=>{:win=>210.0, :no_win=>315.0, :all=>294.0},
       :price_low=>{:win=>110.0, :no_win=>140.0, :all=>120.0},
       :total=>{:win=>250.0, :no_win=>461.0, :all=>381.875}}    

    assert_equal(expected, cross_tbl)
  end
end
