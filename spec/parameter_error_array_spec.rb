require 'spec_helper'

describe 'Error array is built' do
  it 'returns an array of errors when sinatra_param_build_error_array is set' do
    # Set sinatra_param_build_error_array
    app.set :sinatra_param_build_error_array, true

    response = get('/build_error_array')
    response_body = JSON.parse(response.body)
    invalid_params = response_body.collect{ |err| err['param'] }

    invalid_params.should include 'a'
    invalid_params.should include 'b'

    # Unset sinatra_param_build_error_array
    app.set :sinatra_param_build_error_array, false
  end
end
