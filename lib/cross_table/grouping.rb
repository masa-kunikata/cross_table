module CrossTable
  module Grouping
    module_function

    # グループ化したレコードを集計してまとめた階層のハッシュを返す
    # @param recs [Array] target to be grouped
    # @param group_rules [Array] grouping processes. array of hash(key: group title, value: filter proc). 
    # @param agg_proc [Proc] proc to aggregate
    def group(recs, group_rules, &agg_proc)
      title_list  = group_rules.map{|h| h.keys}
      proc_list   = group_rules.map{|h| h.values}

      all_titles  = title_list.first.product(*title_list[1..-1])
      all_procs   = proc_list.first.product(*proc_list[1..-1])

      auto_dig_hash = Hash.new{|h,k| h[k] = h.class.new(&h.default_proc) }

      all_titles.zip(all_procs).each do |dig_keys, filter_procs|
        filtered_recs = filter_procs.reduce(recs) do |memo, proc|
          memo.select(&proc)
        end

        value = agg_proc[filtered_recs]

        last_key = dig_keys.pop
        auto_dig_hash.dig(*dig_keys).store(last_key, value)
      end

      auto_dig_hash
    end

    # グループ化した件数を値にもつ階層のハッシュを返す
    # @param recs [Array] グループ化する対象のデータ
    # @param group_rules [Array] グループ化処理ハッシュ(キー:グループ化タイトル、値:抽出proc)の配列。この順序でグループ化していく
    def counts(recs, group_rules)
      group(recs, group_rules) do |filtered_recs|
        filtered_recs.count
      end
    end

    # グループ化した合計値を値にもつ階層のハッシュを返す
    # @param recs [Array] グループ化する対象のデータ
    # @param field [Object] 合計するフィールド名
    # @param group_rules [Array] グループ化処理ハッシュ(キー:グループ化タイトル、値:抽出proc)の配列。この順序でグループ化していく
    def sums(recs, field, group_rules)
      group(recs, group_rules) do |filtered_recs|
        filtered_recs.map{|r| r[field]}.sum
      end
    end

    # グループ化した平均値を値にもつ階層のハッシュを返す
    # @param recs [Array] グループ化する対象のデータ
    # @param field [Object] 合計するフィールド名
    # @param group_rules [Array] グループ化処理ハッシュ(キー:グループ化タイトル、値:抽出proc)の配列。この順序でグループ化していく
    def avgs(recs, field, group_rules)
      group(recs, group_rules) do |filtered_recs|
        sum = filtered_recs.map{|r| r[field]}.sum
        count = filtered_recs.count
        sum.to_f / count.to_f
      end
    end
  end
end
