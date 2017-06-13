# sinatra-param2
[![Build Status](https://travis-ci.org/adrianbn/sinatra-param2.svg?branch=master)](https://travis-ci.org/adrianbn/sinatra-param2)

_Parameter Validation & Type Coercion for Sinatra_

**`sinatra-param2` is a fork of [`sinatra-param`](https://github.com/mattt/sinatra-param) that works with Sinatra 2 and has many nice additions.**

REST conventions take the guesswork out of designing and consuming web APIs. Simply `GET`, `POST`, `PATCH`, or `DELETE` resource endpoints, and you get what you'd expect.

However, when it comes to figuring out what parameters are expected... well, all bets are off.

This Sinatra extension takes a first step to solving this problem on the developer side

**`sinatra-param2` allows you to declare, validate, and transform endpoint parameters as you would in frameworks like [ActiveModel](http://rubydoc.info/gems/activemodel/3.2.3/frames) or [DataMapper](http://datamapper.org/).**

> Use `sinatra-param2` in combination with [`Rack::PostBodyContentTypeParser` and `Rack::NestedParams`](https://github.com/rack/rack-contrib) to automatically parameterize JSON `POST` bodies and nested parameters.

## Install

You can install `sinatra-param2` from the command line with the following:

```bash
$ gem install sinatra-param2
```

Alternatively, you can specify `sinatra-param2` as a dependency in your `Gemfile` and run `$ bundle install`:

```ruby
gem "sinatra-param2", require: "sinatra/param"
```

## Example

``` ruby
require 'sinatra/base'
require 'sinatra/param'
require 'json'
require 'uri'  # only needed for URI.regexp example below

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
    param :price,       String, format: /[<\=>]\s*\$\d+/
    param :referrer     String, format: URI.regexp

    one_of :q, :categories

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
- `Date`, `Time`, & `DateTime`

### Validations

Encapsulate business logic in a consistent way with validations. If a parameter does not satisfy a particular condition, a `400` error is returned with a message explaining the failure.

- `required`
- `blank`
- `is`
- `in`, `within`, `range`
- `min` / `max`
- `min_length` / `max_length`
- `format`

### Defaults and Transformations

Passing a `default` option will provide a default value for a parameter if none is passed.  A `default` can defined as either a default or as a `Proc`:

```ruby
param :attribution, String, default: "©"
param :year, Integer, default: lambda { Time.now.year }
```

Use the `transform` option to take even more of the business logic of parameter I/O out of your code. Anything that responds to `to_proc` (including `Proc` and symbols) will do.

```ruby
param :order, String, in: ["ASC", "DESC"], transform: :upcase, default: "ASC"
param :offset, Integer, min: 0, transform: lambda {|n| n - (n % 10)}
```

## One Of

Using `one_of`, routes can specify two or more parameters to be mutually exclusive, and fail if _more than one_ of those parameters is provided:

```ruby
param :a, String
param :b, String
param :c, String

one_of :a, :b, :c
```

## Any Of

Using `any_of`, a route can specify that _at least one of_ two or more parameters are required, and fail if _none of them_ are provided:

```ruby
param :x, String
param :y, String

any_of :x, :y
```

## Nested Hash Validation

Using block syntax, a route can validate the fields nested in a parameter of Hash type. These hashes can be nested to an arbitrary depth.
This block will only be run if the top level validation passes and the key is present.

```ruby
param :a, Hash do
  param :b, String
  param :c, Hash do
    param :d, Integer
  end
end
```

## All Or None Of

Using `all_or_none_of`, a router can specify that _all_ or _none_ of a set of parameters are required, and fail if _some_ are provided:

```ruby
param :x, String
param :y, String

all_or_none_of :x,:y
```

### Exceptions

By default, when a parameter precondition fails, `Sinatra::Param` will `halt 400` with an error message:

```json
{
    "message": "Parameter must be within [\"ASC\", \"DESC\"]",
    "errors": {
        "order": "Parameter must be within [\"ASC\", \"DESC\"]"
    }
}
```

To change this, you can set `:raise_sinatra_param_exceptions` to `true`, and intercept `Sinatra::Param::InvalidParameterError` with a Sinatra `error do...end` block. (To make this work in development, set `:show_exceptions` to `false` and `:raise_errors` to `true`):

```ruby
set :raise_sinatra_param_exceptions, true

error Sinatra::Param::InvalidParameterError do
    {error: "#{env['sinatra.error'].param} is invalid"}.to_json
end
```

Custom exception handling can also be enabled on an individual parameter basis, by passing the `raise` option:

```ruby
param :order, String, in: ["ASC", "DESC"], raise: true

one_of :q, :categories, raise: true
```

## Contact

Adrian Bravo ([@adrianbravon](http://twitter.com/adrianbravon))

## License

sinatra-param2 is released under an MIT license. See LICENSE for more information.
