# sinatra-param
_Parameter Contracts for Sinatra_

REST conventions takes the guesswork out of designing and consuming web APIs. `GET` / `POST` / `PATCH` / `DELETE` resource endpoints and you get what you'd expect.

But figuring out what parameters are expected... well, all bets are off. This Sinatra extension takes a first step to solving this problem on the developer side

**`sinatra-param` allows you to declare, validate, and transform endpoint parameters as you would in frameworks like [ActiveModel](http://rubydoc.info/gems/activemodel/3.2.3/frames) or [DataMapper](http://datamapper.org/).**

## Example

``` ruby
require 'sinatra/param'
class App < Sinatra::Base
  helpers Sinatra::Param

  before do
    content_type :json
  end

  # GET /search?q=example
  # GET /search?q=example&categories=news
  # GET /search?q=example&sort=created_at&order=ASC
  get '/search' do
    param :q,           String, required: true
    param :categories,  Array
    param :sort,        String, default: "title"
    param :order,       String, in: ["ASC", "DESC"], transform: :upcase, default: "ASC"

    {...}.to_json
  end
end
```

### Parameter Types

By declaring parameter types, incoming parameters will automatically be transformed into an object of that type. For instance, if a param is `Boolean`, values of `'1'`, `'true'`, `'t'`, `'yes'`, and `'y'` will be automatically transformed into `true`.

- `String`
- `Integer`
- `Float`
- `Boolean` _("1/0", "true/false", "t/f", "yes/no", "y/n")_
- `Array` _("1,2,3,4,5")_
- `Hash` _(key1:value1,key2:value2)_

### Validations

Encapsulate business logic in a consistent way with validations. If a parameter does not satisfy a particular condition, a `406` error is returned with a message explaining the failure.

- `required`
- `blank`
- `is`
- `in`, `within`, `range`
- `min` / `max`

### Defaults and Transformations

Passing a `default` option will provide a default value for a parameter if none is passed.

Use the `transform` option to take even more of the business logic of parameter I/O out of your code. Anything that responds to `to_proc` (including Procs and symbols) will do.

### Custom Error Codes

By default, responses will return a `406` when a validation error occurs. You can opt to respond with a different error by passing an `error` option:

```ruby
param :sort, String, error: 400
```

## Next Steps

- [Design by contract](http://en.wikipedia.org/wiki/Design_by_contract) like this is great for developers, and with a little meta-programming, it could probably be exposed to users as well. The self-documenting dream of [Hypermedia folks](http://twitter.com/#!/steveklabnik) could well be within reach.

- Support for Rails-style Arrays (`'key[]=value1&key[]=value2'`) and Hashes (`'key[a]=value1&key[b]=value2`). /via [@manton](https://twitter.com/#!/manton)

## Contact

Mattt Thompson

- http://github.com/mattt
- http://twitter.com/mattt
- m@mattt.me

## License

sinatra-param is available under the MIT license. See the LICENSE file for more info.
