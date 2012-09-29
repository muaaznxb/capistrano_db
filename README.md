# Capistrano::Db

Helps you out to sync up you datbases between your local and server machines. 

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano_db'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano_db

## Usage

Add `require 'capistrano_db/tasks` into your `deploy.rb`

Then you can use `cap db:pull` and `cap db:push` commands. Enjoy!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
