# frozen_string_literal: true

require 'test/unit'
require 'cross_table'
require File.join(__dir__, 'test_sample')

class CrossTableMultipleKeysTest < Test::Unit::TestCase
  include TestSample

  OSES = {
    'Windows' => ->(rec) { rec[:os] == :win },
    'Linux' => ->(rec) { rec[:os] == :linux },
  }.freeze

  def test_multiple_x_keys
    cross_tbl = CrossTable.sums_from(
      recs: JOBS, field: :price, group_rules: [PRICE, OSES, LANG],
      y_keys: PRICE.keys,
      x_keys: OSES.keys.product(LANG.keys),
      ret_type: :xy_titles
    )

    expected =
      [[nil,
        %w[Windows Ruby],
        %w[Windows PHP],
        %w[Windows Java],
        %w[Windows c],
        %w[Windows cpp],
        %w[Linux Ruby],
        %w[Linux PHP],
        %w[Linux Java],
        %w[Linux c],
        %w[Linux cpp]],
       [:price_high, 0,     0, 850,  0,   0, 0,   0, 1870, 0, 0],
       [:price_mid,  0,     0, 210,  0,   0, 300, 0, 760,  0, 0],
       [:price_low,  100, 220, 0,    120, 0, 0,   0, 120,  0, 0],
       [:total,      100, 220, 1060, 120, 0, 300, 0, 2750, 0, 0]]
    assert_equal(expected, cross_tbl)
  end

  def test_multiple_y_keys
    cross_tbl = CrossTable.sums_from(
      recs: JOBS, field: :price, group_rules: [PRICE, OSES, LANG],
      y_keys: PRICE.keys.product(OSES.keys),
      x_keys: LANG.keys,
      ret_type: :xy_titles
    )
    expected =
      [[nil, 'Ruby', 'PHP', 'Java', 'c', 'cpp'],
       [[:price_high, 'Windows'], 0,   0,   850,  0,   0],
       [[:price_high, 'Linux'],   0,   0,   1870, 0,   0],
       [[:price_mid, 'Windows'],  0,   0,   210,  0,   0],
       [[:price_mid, 'Linux'],    300, 0,   760,  0,   0],
       [[:price_low, 'Windows'],  100, 220, 0,    120, 0],
       [[:price_low, 'Linux'],    0,   0,   120,  0,   0],
       [[:total, 'Windows'],      100, 220, 1060, 120, 0],
       [[:total, 'Linux'],        300, 0,   2750, 0,   0]]

    assert_equal(expected, cross_tbl)
  end
end
