# Cafe Au Lait
Cafe Au Lait is a Node.js [Remember the Milk](rememberthemilk.com) library written in CoffeeScript.

## Installation
Clone or download this repo in a location accessible by your codebase. You'll need both RememberTheMilk.coffee/js (your pick) and this repo's node_modules. When things are a bit more stable, I'll set it up as a proper npm package.

## Getting set up
```
RememberTheMilk = require('./RememberTheMilk');
rtm = new RememberTheMilk(api_key, secret_key)
```


## Authentication
Initial authentication with the RTM api is a bit complex. For more info, see https://www.rememberthemilk.com/services/api/authentication.rtm.

Currently, Cafe Au Lait only supports authenticating as a desktop application. Here's an example of a simple CoffeeScript command-line application that authenticates.

```
RememberTheMilk = require('./RememberTheMilk');
rtm = new RememberTheMilk(api_key, secret_key)
rtm.getAuthUrl (url) ->
  console.log "Before continuing, you need to authenticate with Remember The Milk. Go to the following URL, allow access to the application, and then press any key in the terminal window: #{url}"

  stdin.resume()

  stdin.on 'data', ->
    rtm.getAuthToken (token) ->
      # At this point, the user is authenticated and can perform any actions
```

If you have a token persisted from a previous request, you can load it into the RTM object by manually setting the `token` property, and it will be used for all future API requests.

`rtm.token = "a valid token"`

## Performing API actions
The `get` method allows you to perform any API actions listed on https://www.rememberthemilk.com/services/api/methods/.

```
RememberTheMilk = require('./RememberTheMilk');
rtm = new RememberTheMilk(api_key, secret_key)
rtm.token = 'a valid token'
rtm.get 'rtm.lists.getList', (response) ->
  console.log response
  # => { stat: 'ok',
  # lists:
  # { list:
  #    [ { id: 'list id',
  #     name: 'Inbox',
  #     deleted: '0',
  #     locked: '1',
  #     archived: '0',
  #     position: '-1',
  #     smart: '0',
  #     sort_order: '0' }, ...]
  #   }
  # }
```

## Warning
Consider this alpha software; use at your own risk. There's very little error handling code. I'll hopefully have the time to make this more robust in the future, including adding in more domain knowledge of the API objects themselves.

## Contributing
If you want to fork this and jam on it, feel free. There's some basic unit test coverage, and I'll happily respond to any questions you have.

## License
Cafe Au Lait is licensed under the MIT License
(C) 2013 Michael Walker

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
