# UberModel

UberModel connects your legacy datasource to your ruby application, allowing
you to map legacy calls (TCP server, non-relational DB, etc) to Ruby models.

Tight integration exists between UberModel and ActiveRecord, allowing for
2-way associations that are handled transparently.

Unlike ActiveRecord, model attributes are defined manually by the user.  Data
access is handled by custom adapters, written by the user, which specify how to
interact with your datasource.  Each UberModel class will have a model module
that shadows it, specifying how to perform the 4 CRUD actions.

## Installation

Add this line to your application's Gemfile:

    gem 'uber_model'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install uber_model

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
