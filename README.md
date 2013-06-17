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
* :field_name
* :data_type
* :facet_title
* :where
	=> "SQL where fragment"

Data Types are:
* :string
* :integer
* :date
* :strings
* :integers
* :my_custom_type => {}

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

