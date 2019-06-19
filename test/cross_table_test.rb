# frozen_string_literal: true

require 'test/unit'
require 'cross_table'

class CrossTableTest < Test::Unit::TestCase
  JOBS = [
    { lang: :ruby, os: :win,   price: 100 },
    { lang: :ruby, os: :linux, price: 300 },
    { lang: :ruby, os: :mac,   price: 160 },
    { lang: :php,  os: :mac,   price: 540 },
    { lang: :php,  os: :win,   price: 190 },
    { lang: :php,  os: :win,   price: 30  },
    { lang: :java, os: :linux, price: 120 },
    { lang: :java, os: :win,   price: 850 },
    { lang: :java, os: :linux, price: 300 },
    { lang: :java, os: :linux, price: 990 },
    { lang: :java, os: :win,   price: 210 },
    { lang: :java, os: :linux, price: 460 },
    { lang: :java, os: :linux, price: 880 },
    { lang: :c,    os: :mac,   price: 200 },
    { lang: :c,    os: :win,   price: 120 },
    { lang: :c,    os: :mac,   price: 660 },
  ].freeze

  LANG = {
    'Ruby' => ->(rec) { rec[:lang] == :ruby },
    'PHP' => ->(rec) { rec[:lang] == :php },
    'Java' => ->(rec) { rec[:lang] == :java },
    'c' => ->(rec) { rec[:lang] == :c },
    'cpp' => ->(rec) { rec[:lang] == :cpp },
  }.freeze

  PRICE = {
    price_high: ->(rec) { 500 <= rec[:price] },
    price_mid: ->(rec) { 200 <= rec[:price] && rec[:price] < 500 },
    price_low: ->(rec) { rec[:price] < 200 },
    total: ->(_) { true },
  }.freeze

  OS = {
    win: ->(rec) { rec[:os] == :win },
    no_win: ->(rec) { rec[:os] != :win },
    all: ->(_) { true },
  }.freeze

  def test_counts_from
    cross_tbl = CrossTable.counts_from(
      recs: JOBS, group_rules: [PRICE, OS],
      y_keys: PRICE.keys, x_keys: OS.keys
    )

    expected =
      {:price_high=>{:win=>1, :no_win=>4, :all=>5},
       :price_mid=>{:win=>1, :no_win=>4, :all=>5},
       :price_low=>{:win=>4, :no_win=>2, :all=>6},
       :total=>{:win=>6, :no_win=>10, :all=>16}}

    assert_equal(expected, cross_tbl)
  end

  def test_counts_from_xy_titles
    cross_tbl = CrossTable.counts_from(
      recs: JOBS, group_rules: [PRICE, OS],
      y_keys: PRICE.keys, x_keys: OS.keys,
      ret_type: :xy_titles
    )

    expected =
      [[nil, :win, :no_win, :all],
       [:price_high, 1, 4, 5],
       [:price_mid, 1, 4, 5],
       [:price_low, 4, 2, 6],
       [:total, 6, 10, 16]]

    assert_equal(expected, cross_tbl)
  end

  def test_counts_from_data_only
    cross_tbl = CrossTable.counts_from(
      recs: JOBS, group_rules: [PRICE, OS],
      y_keys: PRICE.keys, x_keys: OS.keys,
      ret_type: :data_only
    )

    expected = [[1, 4, 5], [1, 4, 5], [4, 2, 6], [6, 10, 16]]

    assert_equal(expected, cross_tbl)
  end

  def test_sums_from
    cross_tbl = CrossTable.sums_from(
      recs: JOBS, field: :price, group_rules: [PRICE, OS],
      y_keys: PRICE.keys, x_keys: OS.keys
    )

    expected =
      {:price_high=>{:win=>850, :no_win=>3070, :all=>3920},
       :price_mid=>{:win=>210, :no_win=>1260, :all=>1470},
       :price_low=>{:win=>440, :no_win=>280, :all=>720},
       :total=>{:win=>1500, :no_win=>4610, :all=>6110}}

    assert_equal(expected, cross_tbl)
  end

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

  def test_from
    cross_tbl = CrossTable.from(
      recs: JOBS, group_rules: [PRICE, OS],
      y_keys: PRICE.keys, x_keys: OS.keys
    ) do |group_recs|
      group_recs.map { |r| r[:price] }.min
    end

    expected =
      {:price_high=>{:win=>850, :no_win=>540, :all=>540},
       :price_mid=>{:win=>210, :no_win=>200, :all=>200},
       :price_low=>{:win=>30, :no_win=>120, :all=>30},
       :total=>{:win=>30, :no_win=>120, :all=>30}}

    assert_equal(expected, cross_tbl)
  end

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
