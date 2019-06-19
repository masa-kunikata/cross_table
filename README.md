# CrossTable

Cross tabulation (Pivot table) utility
to convert table data to a pivot table form.
  
<div>

<div style="float:left;">

   *Source (List table)*

  |lang |os     |price|
  |:--- |:---   |--:|
  |ruby |win    |123|
  |ruby |linux  |12|
  |php  |mac    |270|
  |java |win    |560|
  |php  |win    |750|
  |java |linux  |950|
  |java |win    |1200|
  |php  |win    |500|
  |php  |mac    |10|
  |java |mac    |566|
  |ruby |win    |210|

</div>

<div style="float:left;">
  
  &nbsp;&gt;&gt;&gt;&gt;&nbsp;
 
</div>

<div style="float:left;">

  *Destination (Pivot table)*

  |    |ruby|php|java|
  |:---|--:|--:|--:|
  | win| 123 |123|123|
  |linux| 123 |123|123|
  |mac| 123 |123|123|

</div>

</div>


<br style="clear: both;"/>


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

```ruby
require 'cross_table'

cross_tbl = CrossTable.counts_from(
  recs: [],
  group_rules: [],
  y_keys: [],
  x_keys: []
)

```
TODO!!!


## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/cross_table.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
