# frozen_string_literal: true

###############################################################################
#
# AutoIt Obfuscator — default-options example
#
# Version        : v1.5.0
# Language       : Ruby
# Author         : Bartosz Wójcik
# Web page       : https://www.pelock.com
#
###############################################################################

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "autoit-obfuscator"

client = AutoItObfuscator.new("YOUR-WEB-API-KEY")
# flags default to false; enable the ones you need
client.rename_variables = true
client.crypt_strings = true

result = client.obfuscate_script_source('ConsoleWrite("Hello World")')
if result.nil?
  warn "Request failed."
  exit 1
end

if result["error"] == AutoItObfuscator::ERROR_SUCCESS
  puts result["output"]
else
  warn "Error code: #{result["error"]}"
  exit 1
end
