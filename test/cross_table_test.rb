# frozen_string_literal: true

require 'test/unit'
require 'cross_table'
require 'yaml'

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
    # puts 'test_counts_from'
    # puts cross_tbl.to_yaml

    assert_equal(YAML.safe_load(<<~EXPECT_YAML), cross_tbl)
      ---
      :price_high:
        :win: 1
        :no_win: 4
        :all: 5
      :price_mid:
        :win: 1
        :no_win: 4
        :all: 5
      :price_low:
        :win: 4
        :no_win: 2
        :all: 6
      :total:
        :win: 6
        :no_win: 10
        :all: 16
    EXPECT_YAML
  end

  def test_counts_from_xy_titles
    cross_tbl = CrossTable.counts_from(
      recs: JOBS, group_rules: [PRICE, OS],
      y_keys: PRICE.keys, x_keys: OS.keys,
      ret_type: :xy_titles
    )

    pp cross_tbl
  end

  def test_counts_from_data_only
    cross_tbl = CrossTable.counts_from(
      recs: JOBS, group_rules: [PRICE, OS],
      y_keys: PRICE.keys, x_keys: OS.keys,
      ret_type: :data_only
    )

    pp cross_tbl
  end

  def test_sums_from
    cross_tbl = CrossTable.sums_from(
      recs: JOBS, field: :price, group_rules: [PRICE, OS],
      y_keys: PRICE.keys, x_keys: OS.keys
    )

    pp cross_tbl
  end

  def test_avgs_from
    cross_tbl = CrossTable.avgs_from(
      recs: JOBS, field: :price, group_rules: [PRICE, OS],
      y_keys: PRICE.keys, x_keys: OS.keys
    )

    pp cross_tbl
  end

  def test_from
    cross_tbl = CrossTable.from(
      recs: JOBS, group_rules: [PRICE, OS],
      y_keys: PRICE.keys, x_keys: OS.keys
    ) do |group_recs|
      group_recs.map { |r| r[:price] }.min
    end

    pp cross_tbl
  end

  def test_multiple_keys
    CrossTable.sums_from(
      recs: JOBS, field: :price, group_rules: [PRICE, OS, LANG],
      y_keys: PRICE.keys,
      x_keys: OS.keys.product(LANG.keys),
      ret_type: :xy_titles
    ).tap { |lang_counts| pp lang_counts }
    puts

    CrossTable.sums_from(
      recs: JOBS, field: :price, group_rules: [PRICE, OS, LANG],
      y_keys: PRICE.keys.product(OS.keys),
      x_keys: LANG.keys,
      ret_type: :xy_titles
    ).tap { |lang_counts| pp lang_counts }
    puts
  end
end
