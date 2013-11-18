require 'spec_helper'

describe 'Parameter' do
  it 'only sets parameters present in request or with a default value' do
    get('/', a: 'a', b: 'b') do |response|
      response_body = JSON.parse(response.body)
      response_body.member?('a').should eq true
      response_body.member?('b').should eq true
      response_body.member?('c').should eq true
      response_body.member?('d').should eq false
    end
  end
  it 'is a thing' do
    get('/keys/stringify', q: 'test') do |response|
      response.body.should eq 'TEST'
    end
  end
end
