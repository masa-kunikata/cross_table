# frozen_string_literal: true

require 'test/unit'
require 'cross_table'

class CrossTableReadmeSampleTest < Test::Unit::TestCase
  SOURCE = [
    { 'os' => 'win',   'lang' => 'ruby', 'price' => 123 },
    { 'os' => 'linux', 'lang' => 'ruby', 'price' => 12 },
    { 'os' => 'mac',   'lang' => 'php',  'price' => 270 },
    { 'os' => 'win',   'lang' => 'java', 'price' => 560 },
    { 'os' => 'win',   'lang' => 'php',  'price' => 750 },
    { 'os' => 'linux', 'lang' => 'java', 'price' => 950 },
    { 'os' => 'win',   'lang' => 'java', 'price' => 1200 },
    { 'os' => 'win',   'lang' => 'php',  'price' => 500 },
    { 'os' => 'mac',   'lang' => 'php',  'price' => 10 },
    { 'os' => 'mac',   'lang' => 'java', 'price' => 566 },
    { 'os' => 'win',   'lang' => 'ruby', 'price' => 210 },
  ]

  OS = {
    'Windows' => ->(r){ r['os'] == 'win' },
    'GNU/Linux' => ->(r){ r['os'] == 'linux'},
    'Apple' => ->(r){ r['os'] == 'mac'},
  }

  LANG = {
    'Ruby' => ->(r){ r['lang'] == 'ruby' },
    'Java' => ->(r){ r['lang'] == 'java'},
    'PHP' => ->(r){ r['lang'] == 'php'},
  }

  def test_sums
    cross_tbl = CrossTable.sums_from(
      recs: SOURCE, field: 'price', group_rules: [OS, LANG],
      y_keys: OS.keys, x_keys: LANG.keys,
      ret_type: :data_only
    )

    expected = [
      [333, 1760, 1250],
      [12,  950,  0],
      [0,   566,  280]
    ]

    assert_equal(expected, cross_tbl)
  end
end
