md5 = require 'md5'
request = require 'request'
querystring = require 'querystring'

module.exports = class RememberTheMilk
  authUrl: "http://www.rememberthemilk.com/services/auth/?"
  restUrl: "http://www.rememberthemilk.com/services/rest/?"

  constructor: (@apiKey, @sharedSecret) ->

  apiSig: (params) ->
    keys = Object.keys(params).sort()
    string = keys.reduce (string, key) =>
      "#{string}#{key}#{params[key]}"
    , ''

    string = "#{@sharedSecret}#{string}"
    md5.digest_s(string)

  signRequest: (params={}) ->
    params["api_key"] = @apiKey
    params["format"] = 'json'
    params["api_sig"] = @apiSig(params)
    params

  getAuthUrl: (callback) =>
    @getFrob (frob) =>
      params = @signRequest
        perms: "delete"
        frob: frob

      callback?("#{@authUrl}#{querystring.stringify(params)}")

  getFrob: (callback) ->
    params = @signRequest
      method: "rtm.auth.getFrob"
    request.get "#{@restUrl}#{querystring.stringify(params)}", (err, response, body) ->
      if err
        callback?(undefined, err)
      else
        frob = response?.rsp?.frob
        callback?(frob)