# Facetious

A Faceted search extension for ActiveRecord

## Installation

Add this line to your application's Gemfile:

    gem 'facetious'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install facetious

## Usage

```ruby
  require 'facetious'

  class MyRecord < ActiveRecord::Base
    facet :options
  end
```

Options are:
* :name (mandatory)
* :field_name (if different from the :name, or :where is used and you need to include a table name)
* :data_type => :string (default), :integer, :strings, :integers, :date (not yet implemented), :your_type
* :facet_title => "A String you can use in your form generator"
* :where => "SQL WHERE condition"; used to include an EXISTS clause when your facet value is in a joined table

Data Types are:
* :string
* :integer
* :date (not yet implemented)
* :strings (when you want to use "field IN (value_list)" instead of equality comparison
* :integers (same, but for integers)
* :my_custom_type may be used if you assign a converter proc to Facetious::Facet::ValueConverters[:my_custom_type]

```ruby
  MyRecord.where_clause_for_facets(:facet1 => "2069, 3000-2999", :facet2 => "Rose%").include(:some_association)
  MyRecord.find_by_facets(:facet1 => "2069, 3000-2999", :facet2 => "Rose%").include(:some_association)
```

where_clause_for_facets generates the appropriate SQL WHERE condition for the values in the parameters hash
find_by_facets does MyRecord.where(where_clause_for_facets(parameters))

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

