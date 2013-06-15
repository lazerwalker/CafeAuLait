horaa = require 'horaa'
RememberTheMilk = require('../RememberTheMilk')

describe "RememberTheMilk", ->
  beforeEach ->
    @rtm = new RememberTheMilk()

  describe "Constructor", ->
    it 'Sets the API key and Secret Key', ->
      api = 'foo'
      secret = 'bar'
      @rtm = new RememberTheMilk(api, secret)

      expect(@rtm.apiKey).toEqual(api)
      expect(@rtm.sharedSecret).toEqual(secret)

  describe "signRequest", ->
    describe "when param keys are not in alphabetical order", ->
      it "should produce the proper hash", ->
        params =
          c: 'c'
          a: 'a'
          b: 'b'
        secret = 'secret'

        md5 = horaa('md5')
        md5.hijack 'digest_s', (string) ->
          expect(string).toEqual("aabbccsecret")

        @rtm = new RememberTheMilk('', secret)
        @rtm.signRequest(params)




