horaa = require 'horaa'
querystring = require('querystring')
RememberTheMilk = require('../lib/RememberTheMilk.coffee')

validateRequest = (url, expectedParams) ->
  [path, paramString] = url.split('?')
  params = querystring.parse(paramString)

  expect(path).toEqual("http://www.rememberthemilk.com/services/rest/")
  expect(params.api_sig).not.toBeUndefined()

  for key, value of expectedParams
    expect(params[key]).toEqual(value)

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

      api_sig  = @rtm._apiSig
        api_key: @api
        format: 'json'
        frob: 'frob'
        perms: 'delete'

      @rtm.getAuthUrl (url) =>
        expect(url).toEqual("http://www.rememberthemilk.com/services/auth/?perms=delete&frob=frob&api_key=#{@api}&format=json&api_sig=#{api_sig}")

  describe "getFrob", ->
    beforeEach ->
      @request = horaa('request')
      @request.hijack 'get', (url, callback) =>
        valid = validateRequest url,
          api_key: @api
          method: "rtm.auth.getFrob"

        response = JSON.stringify({rsp: {frob: "a valid frob"}})
        callback(undefined, undefined, response)

    afterEach ->
      @request.restore('get')

    it 'should return a valid frob', ->
      @rtm.getFrob (frob) ->
        expect(frob).toEqual("a valid frob")

    it 'should store the frob', ->
      @rtm.getFrob (frob) =>
        expect(@rtm.frob).toEqual(frob)

    it 'should use the stored value when called again', ->
      @rtm.getFrob (frob) =>
        @rtm.frob = 'foo'
        @rtm.getFrob (frob) ->
          expect(frob).toEqual('foo')

  describe "getAuthToken", ->
    beforeEach ->
      spyOn(@rtm, "getFrob").andCallFake (callback) ->
        callback('frob')

      @request = horaa('request')
      @request.hijack 'get', (url, callback) =>
        valid = validateRequest url,
          api_key: @api
          method: "rtm.auth.getToken"
          frob: "frob"

        response = JSON.stringify({rsp: {auth: {token: "a valid token"}}})
        callback(undefined, undefined, response)

    afterEach ->
      @request.restore('get')

    it "should return a valid auth token", ->
      @rtm.getAuthToken (token) ->
        expect(token).not.toBeUndefined()

    it "should store the token", ->
      @rtm.getAuthToken (token) =>
        expect(@rtm.token).toEqual(token)

  describe 'get', ->
    beforeEach ->
      @rtm.token = 'a valid token'
      @request = horaa('request')
      @request.hijack 'get', (url, callback) =>
        valid = validateRequest url,
          api_key: @api
          method: "rtm.tasks.getList"
          list_id: "a list"
          auth_token: 'a valid token'

        response = JSON.stringify({rsp: true})
        callback(undefined, undefined, response)

    afterEach ->
      @request.restore('get')

    it 'should make a request', ->
      @rtm.get 'rtm.tasks.getList', list_id: 'a list', (response) ->
        expect(response).toBeTruthy()