# frozen_string_literal: true

module CrossTable
  # group process
  module Grouping
    module_function

    def group(recs, group_rules, &aggr_proc)
      all_titles  = product_all(group_rules.map(&:keys))
      all_procs   = product_all(group_rules.map(&:values))

      auto_dig_hash = Hash.new { |h, k| h[k] = h.class.new(&h.default_proc) }
      all_titles.zip(all_procs).each do |dig_keys, filter_procs|
        group_recs = filter_procs.reduce(recs) do |memo, proc|
          memo.select(&proc)
        end
        value = aggr_proc[group_recs]

        last_key = dig_keys.pop
        auto_dig_hash.dig(*dig_keys).store(last_key, value)
      end
      auto_dig_hash
    end

    def counts(recs, group_rules)
      group(recs, group_rules, &:count)
    end

    def sums(recs, field, group_rules)
      group(recs, group_rules) do |group_recs|
        group_recs.map { |r| r[field] }.sum
      end
    end

    def avgs(recs, field, group_rules)
      group(recs, group_rules) do |group_recs|
        sum = group_recs.map { |r| r[field] }.sum
        count = group_recs.count
        sum.to_f / count.to_f
      end
    end

    class << self
      private

      def product_all(list)
        list.first.product(*list[1..-1])
      end
    end
  end
end
