# sinatra-param
_Parameter Contracts for Sinatra_

REST conventions take the guesswork out of designing and consuming web APIs. Simply `GET`, `POST`, `PATCH`, or `DELETE` resource endpoints, and you get what you'd expect.

However, when it comes to figuring out what parameters are expected... well, all bets are off. 

This Sinatra extension takes a first step to solving this problem on the developer side

**`sinatra-param` allows you to declare, validate, and transform endpoint parameters as you would in frameworks like [ActiveModel](http://rubydoc.info/gems/activemodel/3.2.3/frames) or [DataMapper](http://datamapper.org/).**

> Use `sinatra-param` in combination with [`Rack::PostBodyContentTypeParser` and `Rack::NestedParams`](https://github.com/rack/rack-contrib) to automatically parameterize JSON `POST` bodies and nested parameters.

## Example

``` ruby
require 'sinatra/base'
require 'sinatra/param'
require 'json'

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

Encapsulate business logic in a consistent way with validations. If a parameter does not satisfy a particular condition, a `400` error is returned with a message explaining the failure.

- `required`
- `blank`
- `is`
- `in`, `within`, `range`
- `min` / `max`

### Error handling

Decide what error message to return when a validation error occurs or pass some custom code that will handle the error. The custom code works just like `transform`. Anything that responds to `to_proc` will do.

Example:

``` ruby
  get 'error_handling' do
    param :a,     :String, in: ['a', 'A'],      error_msg: 'Must be either a or A'
    param :order, :String, in: ["ASC", "DESC"], on_error: proc { |params| raise UnknownOrderError }
  end
```

### Defaults and Transformations

Passing a `default` option will provide a default value for a parameter if none is passed.

Use the `transform` option to take even more of the business logic of parameter I/O out of your code. Anything that responds to `to_proc` (including Procs and symbols) will do.

## Contact

Mattt Thompson

- http://github.com/mattt
- http://twitter.com/mattt
- m@mattt.me

## License

sinatra-param is available under the MIT license. See the LICENSE file for more info.
