horaa = require 'horaa'
querystring = require('querystring')
RememberTheMilk = require('../RememberTheMilk')

describe "RememberTheMilk", ->
  beforeEach ->
    @api = 'api'
    @secret = 'secret'
    @rtm = new RememberTheMilk(@api, @secret)

  describe "Constructor", ->
    it 'Sets the API key and Secret Key', ->
      expect(@rtm.apiKey).toEqual(@api)
      expect(@rtm.sharedSecret).toEqual(@secret)

  describe "getAuthUrl", ->
    it 'should return a valid auth URL', ->
      spyOn(@rtm, "getFrob").andCallFake (callback) ->
        callback('frob')

      api_sig  = @rtm.apiSig
        api_key: @api
        format: 'json'
        frob: 'frob'
        perms: 'delete'

      expect(@rtm.getAuthUrl()).toEqual("http://www.rememberthemilk.com/services/auth/?perms=delete&frob=frob&api_key=#{@api}&format=json&api_sig=#{api_sig}")

  describe "getFrob", ->
    beforeEach ->
      @request = horaa('request')
      @request.hijack 'get', (url, callback) =>
        [path, paramString] = url.split('?')
        params = querystring.parse(paramString)
        if path is "http://www.rememberthemilk.com/services/rest/" and
          params.api_key is @api and
          params.method is "rtm.auth.getFrob" and
          params?.api_sig
            callback(undefined, {rsp: {frob: "a valid frob"}})
        else
          callback("error")

    afterEach ->
      @request.restore('get')

    it 'should return a valid frob', ->
      @rtm.getFrob (frob) ->
        expect(frob).toEqual("a valid frob")



