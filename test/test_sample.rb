# frozen_string_literal: true

module TestSample
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
end
