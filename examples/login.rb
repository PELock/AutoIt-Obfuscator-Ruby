# frozen_string_literal: true

###############################################################################
#
# AutoIt Obfuscator — login example
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
result = client.login
p result
