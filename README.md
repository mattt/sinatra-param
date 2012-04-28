# sinatra-param
_Parameter Validation and Typecasting for Sinatra_

## Example

``` ruby
class App < Sinatra::Base
  helpers Sinatra::Param

  before do
    content_type :json
  end
  
  # GET /messages
  # GET /messages?sort=name&order=ASC
  get '/messages' do
    param :sort,  String, default: "name"
    param :order, String, in: ["ASC", "DESC"], transform: :upcase, default: "ASC"
    
    {
      sort: params[:sort],
      order: params[:order]
    }.to_json
  end
end
```

## Contact

Mattt Thompson

- http://github.com/mattt
- http://twitter.com/mattt
- m@mattt.me

## License

sinatra-param is available under the MIT license. See the LICENSE file for more info.