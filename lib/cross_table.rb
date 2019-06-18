# frozen_string_literal: true

require 'cross_table/version'
require 'cross_table/grouping'

# cross tabulation (pivot table) utility
module CrossTable
  module_function

  def from(recs:, group_rules:, y_keys:, x_keys:, ret_type: nil, &aggr_proc)
    of(Grouping.group(recs, group_rules, &aggr_proc),
       y_keys: y_keys, x_keys: x_keys,
       ret_type: ret_type)
  end

  def counts_from(recs:, group_rules:, y_keys:, x_keys:, ret_type: nil)
    of(Grouping.counts(recs, group_rules),
       y_keys: y_keys, x_keys: x_keys,
       ret_type: ret_type)
  end

  def sums_from(recs:, field:, group_rules:, y_keys:, x_keys:, ret_type: nil)
    of(Grouping.sums(recs, field, group_rules),
       y_keys: y_keys, x_keys: x_keys,
       ret_type: ret_type)
  end

  def avgs_from(recs:, field:, group_rules:, y_keys:, x_keys:, ret_type: nil)
    of(Grouping.avgs(recs, field, group_rules),
       y_keys: y_keys, x_keys: x_keys,
       ret_type: ret_type)
  end

  def of(grouped_hash, y_keys:, x_keys:, ret_type: nil)
    vals = y_keys.map do |y_dig_keys|
      x_keys.map do |x_dig_keys|
        grouped_hash.dig(*y_dig_keys).dig(*x_dig_keys)
      end
    end

    case ret_type
    when :data_only
      return vals

    when :xy_titles
      return ([nil] + y_keys).zip([x_keys] + vals).map do |row_title, value_row|
        [row_title] + value_row
      end
    end

    y_keys.map.zip(
      vals.map do |row|
        x_keys.zip(row).to_h
      end
    ).to_h
  end
end
