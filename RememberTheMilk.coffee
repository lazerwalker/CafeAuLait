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

  getAuthUrl: (callback, opts={}) =>
    perms = opts[perms] || "delete"
    @getFrob (frob) =>
      params = @signRequest
        perms: perms
        frob: frob

      callback?("#{@authUrl}#{querystring.stringify(params)}")

  getFrob: (callback) ->
    if @frob?
      callback?(@frob)
      return

    params = @signRequest
      method: "rtm.auth.getFrob"
    request.get "#{@restUrl}#{querystring.stringify(params)}", (err, response, body) =>
      frob = JSON.parse(body).rsp.frob
      if err or !frob
        callback?(undefined, err)
      else
        @frob = frob
        callback?(frob)

  getAuthToken: (callback) ->
    @getFrob (frob, error) =>
      if error
        callback(undefined, error)
        return
      params = @signRequest
        method: "rtm.auth.getToken"
        frob: frob

      request.get "#{@restUrl}#{querystring.stringify(params)}", (err, response, body) =>
        token = JSON.parse(body).rsp.auth.token
        if err or !token?
          callback?(undefined, err)
        else
          @token = token
          callback?(token)


