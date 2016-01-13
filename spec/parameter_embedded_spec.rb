require 'spec_helper'

describe 'Parameter' do
  it 'finds embedded parameters' do
    
    get('/embedded/parameters', {a: {a: 'string', b: 'false'}, c: {a: 'uppercase'}}) do |response|
      response_body = JSON.parse(response.body)
      expect(response_body['a']).to be_member('a')
      expect(response_body['a']).to be_member('b')
      expect(response_body['b']).to be_member('a')
      expect(response_body['b']['a']).to eq('test')
      expect(response_body['b']).to_not be_member('b')
      expect(response_body['c']).to be_member('a')
      expect(response_body['c']['a']).to eq('UPPERCASE')
    end
  end

  it 'raises error message when required embed is missing' do
    get('/embedded/parameters', {a: {a: 'string'}}) do |response|
      response_body = JSON.parse(response.body)
      expect(response_body['errors']).to be_member 'a[b]'
      expect(response_body['errors']['a[b]']).to eq 'Parameter is required'
    end
  end

end
