md5 = require 'md5'
request = require 'request'

module.exports = class RememberTheMilk
  constructor: (@apiKey, @sharedSecret) ->

  signRequest: (params) ->
    keys = Object.keys(params).sort()
    string = keys.reduce (string, key) =>
      "#{string}#{key}#{params[key]}"
    , ''

    string += @sharedSecret
    md5.digest_s(string)