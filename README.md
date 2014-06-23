# HttpProxyFromEnv

Net::HTTP automatically detects and uses proxies from the environment.
http\_proxy\_from\_env is made from https://bugs.ruby-lang.org/projects/ruby-trunk/repository/revisions/36476

## Installation

Add this line to your application's Gemfile:

    gem 'http_proxy_from_env'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install http_proxy_from_env

## Usage

```
require 'http_proxy_from_env/net/http'
```

```
require 'http_proxy_from_env/open-uri'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
