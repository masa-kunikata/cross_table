# frozen_string_literal: true

require 'test/unit'
require 'cross_table'
require File.join(__dir__, 'test_sample')

class CrossTableMultipleKeysTest < Test::Unit::TestCase
  include TestSample

  def test_multiple_keys
    CrossTable.sums_from(
      recs: JOBS, field: :price, group_rules: [PRICE, OS, LANG],
      y_keys: PRICE.keys,
      x_keys: OS.keys.product(LANG.keys),
      ret_type: :xy_titles
    ).tap do |cross_tbl|
      expected =
        [[nil,
          [:win, "Ruby"],
          [:win, "PHP"],
          [:win, "Java"],
          [:win, "c"],
          [:win, "cpp"],
          [:no_win, "Ruby"],
          [:no_win, "PHP"],
          [:no_win, "Java"],
          [:no_win, "c"],
          [:no_win, "cpp"],
          [:all, "Ruby"],
          [:all, "PHP"],
          [:all, "Java"],
          [:all, "c"],
          [:all, "cpp"]],
         [:price_high, 0, 0, 850, 0, 0, 0, 540, 1870, 660, 0, 0, 540, 2720, 660, 0],
         [:price_mid, 0, 0, 210, 0, 0, 300, 0, 760, 200, 0, 300, 0, 970, 200, 0],
         [:price_low, 100, 220, 0, 120, 0, 160, 0, 120, 0, 0, 260, 220, 120, 120, 0],
         [:total, 100, 220, 1060, 120, 0, 460, 540, 2750, 860, 0, 560, 760, 3810, 980, 0]]
      assert_equal(expected, cross_tbl)
    end

    CrossTable.sums_from(
      recs: JOBS, field: :price, group_rules: [PRICE, OS, LANG],
      y_keys: PRICE.keys.product(OS.keys),
      x_keys: LANG.keys,
      ret_type: :xy_titles
    ).tap do |cross_tbl|
    
      expected =
        [[nil, "Ruby", "PHP", "Java", "c", "cpp"],
         [[:price_high, :win], 0, 0, 850, 0, 0],
         [[:price_high, :no_win], 0, 540, 1870, 660, 0],
         [[:price_high, :all], 0, 540, 2720, 660, 0],
         [[:price_mid, :win], 0, 0, 210, 0, 0],
         [[:price_mid, :no_win], 300, 0, 760, 200, 0],
         [[:price_mid, :all], 300, 0, 970, 200, 0],
         [[:price_low, :win], 100, 220, 0, 120, 0],
         [[:price_low, :no_win], 160, 0, 120, 0, 0],
         [[:price_low, :all], 260, 220, 120, 120, 0],
         [[:total, :win], 100, 220, 1060, 120, 0],
         [[:total, :no_win], 460, 540, 2750, 860, 0],
         [[:total, :all], 560, 760, 3810, 980, 0]]
      assert_equal(expected, cross_tbl)
    end
  end
end
