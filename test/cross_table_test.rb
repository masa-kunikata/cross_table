# frozen_string_literal: true

require 'test/unit'
require 'cross_table'

class CrossTableTest < Test::Unit::TestCase
  JOBS = [
    { lang: :ruby, os: :win,   price: 100, level: :easy   },
    { lang: :ruby, os: :linux, price: 300, level: :hard   },
    { lang: :ruby, os: :mac,   price: 160, level: :normal },
    { lang: :php,  os: :mac,   price: 540, level: :easy   },
    { lang: :php,  os: :win,   price: 220, level: :normal },
    { lang: :php,  os: :win,   price: 30,  level: :easy   },
    { lang: :java, os: :linux, price: 120, level: :normal },
    { lang: :java, os: :win,   price: 850, level: :easy   },
    { lang: :java, os: :linux, price: 300, level: :hard   },
    { lang: :java, os: :linux, price: 990, level: :normal },
    { lang: :java, os: :win,   price: 210, level: :normal },
    { lang: :java, os: :linux, price: 460, level: :easy   },
    { lang: :java, os: :linux, price: 880, level: :easy   },
    { lang: :c,    os: :mac,   price: 200, level: :hard   },
    { lang: :c,    os: :win,   price: 120, level: :easy   },
    { lang: :c,    os: :mac,   price: 660, level: :normal },
  ].freeze

  def test_group_count
    prices = {
      price_high: ->(rec) { 500 <= rec[:price] },
      price_mid: ->(rec) { 200 <= rec[:price] && rec[:price] < 500 },
      price_low: ->(rec) { rec[:price] < 200 },
      total: ->(_) { true },
    }
    oses = {
      win: ->(rec) { rec[:os] == :win },
      no_win: ->(rec) { rec[:os] != :win },
      total: ->(_) { true },
    }

    CrossTable.counts_from(
      recs: JOBS, group_rules: [prices, oses],
      y_keys: prices.keys, x_keys: oses.keys
    ).tap { |counts| pp counts }
    puts

    CrossTable.sums_from(
      recs: JOBS, field: :price, group_rules: [prices, oses],
      y_keys: prices.keys, x_keys: oses.keys
    ).tap { |sums| pp sums }
    puts

    CrossTable.avgs_from(
      recs: JOBS, field: :price, group_rules: [prices, oses],
      y_keys: prices.keys, x_keys: oses.keys, ret_type: :xy_titles
    ).tap { |avgs| pp avgs }
    puts

    mins = CrossTable.from(
      recs: JOBS, group_rules: [prices, oses],
      y_keys: prices.keys, x_keys: oses.keys, ret_type: :data_only
    ) do |group_recs|
      group_recs.map { |r| r[:price] }.min
    end
    pp mins
    puts

    levels = {
      none: ->(rec) { rec[:level].nil? },
      easy: ->(rec) { rec[:level] == :easy },
      normal: ->(rec) { rec[:level] == :normal },
      hard: ->(rec) { rec[:level] == :hard },
    }

    CrossTable.avgs_from(
      recs: JOBS, field: :price, group_rules: [prices, oses, levels],
      y_keys: prices.keys, x_keys: oses.keys.product(levels.keys)
    ).tap { |level_counts| pp level_counts }
    puts
  end
end
