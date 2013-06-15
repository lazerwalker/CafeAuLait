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

        # md5 of 'aabbccsecret'
        md5 = '8a082c06f5f7a29c8ccf18d8ff27eb63'

        @rtm = new RememberTheMilk('', secret)
        expect(@rtm.signRequest(params)).toEqual(md5)


