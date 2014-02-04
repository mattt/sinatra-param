require 'spec_helper'

describe 'on_error' do
  it 'Executes a proc in a InvalidParamterError is raised' do
    get('/error_handling/on_error', arg: 'wrong') do |response|
      expect(response.status).to eq(400)
      expect(response.body).to eq("we had an error")
    end
  end
end

describe 'error_msg' do
  it 'Adds a custom error message to the standard invalid parameter output' do
    get('/error_handling/error_msg', arg: 'wrong') do |response|
      expect(response.status).to eq(400)

      msg = JSON.parse(response.body)['message']
      expect(msg).to eq("Invalid parameter, arg\ncan't pass this, mate")
    end
  end
end
