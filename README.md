# AutoIt Obfuscator — Ruby Web API SDK

Ruby SDK for [AutoIt Obfuscator](https://www.pelock.com/products/autoit-obfuscator).

API: https://www.pelock.com/api/autoit-obfuscator/v1

Author: Bartosz Wójcik / PELock — https://www.pelock.com

## Installation

This gem is not published on RubyGems. Build it locally:

```bash
gem build autoit-obfuscator.gemspec
gem install autoit-obfuscator-*.gem
```

Or from a clone without installing:

```ruby
$LOAD_PATH.unshift(File.expand_path("lib", __dir__))
require "autoit-obfuscator"
```

Uses Ruby stdlib `Net::HTTP` only (no Faraday).

## Usage

```ruby
require "autoit-obfuscator"

client = AutoItObfuscator.new("YOUR-WEB-API-KEY")
client.rename_variables = true
client.crypt_strings = true

result = client.obfuscate_script_source('ConsoleWrite("Hello World")')

if result && result["error"] == AutoItObfuscator::ERROR_SUCCESS
  puts result["output"]
end
```

See `examples/`.

Strategy flags default to `false`. Empty or invalid keys run demo mode.

## License

Apache-2.0. Copyright Bartosz Wójcik / PELock.
