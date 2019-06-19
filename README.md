# CrossTable

Cross tabulation (Pivot table) utility
to convert table data to a pivot table form.
  
<div>

<div style="float:left;">

   *Source (List table)*

  |os     |lang |price|
  |:---   |:--- |--:|
  |win    |ruby |123|
  |linux  |ruby |12|
  |mac    |php  |270|
  |win    |java |560|
  |win    |php  |750|
  |linux  |java |950|
  |win    |java |1200|
  |win    |php  |500|
  |mac    |php  |10|
  |mac    |java |566|
  |win    |ruby |210|

</div>

<div style="float:left;">
  
  &nbsp;&gt;&gt;&gt;&nbsp;
 
</div>

<div style="float:left;">

  *Destination (Pivot table)*

  |     |ruby |java |php  |
  |:--  |  --:|  --:|  --:|
  |win  | 333 |1760 |1250 |
  |linux| 12  |950  |0    |
  |mac  | 0   |566  |280  |

</div>

</div>

<br style="clear: both;"/>

[The test code to get the sample table above.](test/cross_table_readme_sample_test.rb)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cross_table'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cross_table

## Usage

### Records Count

```ruby
require 'cross_table'

cross_tbl = CrossTable.counts_from(
  recs: [],         # Source List Table(Enumerable)
  group_rules: [],  # Grouping Rules (Array of Hash)
  y_keys: [],       # Y-axis Keys (Array)
  x_keys: []        # X-axis Keys (Array)
  ret_type: nil     # Type of returned Pivot table. (nil|:xy_titles|:data_only)
)

```

[Sample test code of CrossTable.counts_from](test/cross_table_counts_test.rb)

[Sample data and group_rule setting](test/test_sample.rb)


### Fields Summary

```ruby
require 'cross_table'

cross_tbl = CrossTable.sums_from(
  recs: [],         # Source List Table(Enumerable of Hash)
  field: :fld_name  # Target field name to be summarised
  group_rules: [],  # Grouping Rules (Array of Hash)
  y_keys: [],       # Y-axis Keys (Array)
  x_keys: []        # X-axis Keys (Array)
  ret_type: nil     # Type of returned Pivot table. (nil|:xy_titles|:data_only)
)

```

[Sample test code of CrossTable.sums_from](test/cross_table_sums_test.rb)

[Sample data and group_rule setting](test/test_sample.rb)

### Fields Average

```ruby
require 'cross_table'

cross_tbl = CrossTable.avgs_from(
  recs: [],         # Source List Table(Enumerable of Hash)
  field: :fld_name  # Target field name to be summarised
  group_rules: [],  # Grouping Rules (Array of Hash)
  y_keys: [],       # Y-axis Keys (Array)
  x_keys: []        # X-axis Keys (Array)
  ret_type: nil     # Type of returned Pivot table. (nil|:xy_titles|:data_only)
)

```

[Sample test code of CrossTable.avgs_from](test/cross_table_avgs_test.rb)

[Sample data and group_rule setting](test/test_sample.rb)

### Arbitral Property

```ruby
require 'cross_table'

cross_tbl = CrossTable.from(
  recs: [],         # Source List Table(Enumerable of Hash)
  group_rules: [],  # Grouping Rules (Array of Hash)
  y_keys: [],       # Y-axis Keys (Array)
  x_keys: []        # X-axis Keys (Array)
  ret_type: nil     # Type of returned Pivot table. (nil|:xy_titles|:data_only)
  &aggr_proc        # Proc/block to get a value from the arg "group_recs"
)

```

[Sample test code of CrossTable.from to get a Minumum value.](test/cross_table_from_test.rb)

[Sample data and group_rule setting](test/test_sample.rb)


## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/masa-kunikata/cross_table.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
