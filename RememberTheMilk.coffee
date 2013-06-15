md5 = require 'md5'
request = require 'request'

Object::asQueryString = ->
  paramStrings = []
  for key, value of @
    if typeof value isnt 'function'
      paramStrings.push("#{key}=#{value}")
  paramString = "?" + paramStrings.join("&")
  paramString

module.exports = class RememberTheMilk
  baseUrl: "http://www.rememberthemilk.com/services"

  constructor: (@apiKey, @sharedSecret) ->

  apiSig: (params) ->
    keys = Object.keys(params).sort()
    string = keys.reduce (string, key) =>
      "#{string}#{key}#{params[key]}"
    , ''

    string = "#{@sharedSecret}#{string}"
    md5.digest_s(string)

  signRequest: (params) ->
    params["api_sig"] = @apiSig(params)
    params

  getAuthUrl: ->
    params = @signRequest
      api_key: @apiKey
      perms: "delete"

    "#{@baseUrl}/auth/#{params.asQueryString()}"