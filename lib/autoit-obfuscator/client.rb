# frozen_string_literal: true

require "base64"
require "json"
require "zlib"

class AutoItObfuscator
  API_URL = "https://www.pelock.com/api/autoit-obfuscator/v1"
  ERROR_SUCCESS = 0
  ERROR_INPUT_SIZE = 1
  ERROR_INPUT = 2
  ERROR_PARSING = 3
  ERROR_OBFUSCATION = 4
  ERROR_OUTPUT = 5
  USER_AGENT = "PELock AutoIt Obfuscator"

  # All strategy flags default to false (same as the JavaScript / PHP SDKs).
  FLAG_PARAMS = {
    anti_debug: "anti_debug",
    anti_vm: "anti_vm",
    anti_sandbox: "anti_sandbox",
    anti_emulator: "anti_emulator",
    random_integers: "random_bucket_integers",
    random_characters: "random_bucket_characters",
    random_anti_regex: "random_bucket_anti_regex",
    random_arrays: "random_bucket_arrays",
    random_arrays_multidimensional: "random_bucket_arrays_multidimensional",
    random_functions: "random_bucket_functions",
    random_autostarted: "random_bucket_autostart",
    mix_code_flow: "mix_code_flow",
    rename_variables: "rename_variables",
    rename_functions: "rename_functions",
    rename_function_calls: "rename_function_calls",
    shuffle_functions: "shuffle_functions",
    resolve_constants: "resolve_const",
    crypt_numbers: "crypt_numbers",
    split_strings: "split_strings",
    modify_strings: "modify_strings",
    crypt_strings: "crypt_strings",
    insert_ternary_operators: "insert_ternary_operators"
  }.freeze

  attr_accessor :enable_compression, *FLAG_PARAMS.keys

  def initialize(api_key = nil)
    @api_key = api_key
    @enable_compression = false
    FLAG_PARAMS.each_key { |name| instance_variable_set("@#{name}", false) }
  end

  def login(return_as_object = true)
    post_request({ "command" => "login" }, return_as_object)
  end

  def obfuscate_script_file(script_file_path, return_as_object = true)
    source = File.read(script_file_path, encoding: "UTF-8")
    return nil if source.nil? || source.empty?

    obfuscate_script_source(source, return_as_object)
  rescue StandardError
    nil
  end

  def obfuscate_script_source(script_source, return_as_object = true)
    post_request({ "command" => "obfuscate", "source" => script_source }, return_as_object)
  end

  private

  def post_request(params_array, return_as_object)
    params = params_array.dup
    params["key"] = @api_key unless @api_key.nil? || @api_key.to_s.empty?

    FLAG_PARAMS.each do |name, key|
      params[key] = "1" if instance_variable_get("@#{name}")
    end

    if @enable_compression && params["source"]
      params["source"] = Base64.strict_encode64(Zlib::Deflate.deflate(params["source"], 9))
      params["compression"] = "1"
    end

    body = Http.post_multipart(API_URL, params, user_agent: USER_AGENT)
    return nil if body.nil? || body.empty?

    result = Http.parse_json(body)
    return nil if result.nil?

    depacked = false
    if @enable_compression && result["error"] == ERROR_SUCCESS && result["output"]
      begin
        result["output"] = Zlib::Inflate.inflate(Base64.decode64(result["output"]))
        depacked = true
      rescue StandardError
        return nil
      end
    end

    return result if return_as_object
    return JSON.generate(result) if depacked

    body
  end
end
