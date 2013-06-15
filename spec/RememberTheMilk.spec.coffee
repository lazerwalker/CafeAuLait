horaa = require 'horaa'
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
      api_sig = @rtm.apiSig
        api_key: @api
        perms: 'delete'

      expect(@rtm.getAuthUrl()).toEqual("http://www.rememberthemilk.com/services/auth/?api_key=api&perms=delete&api_sig=#{api_sig}")




