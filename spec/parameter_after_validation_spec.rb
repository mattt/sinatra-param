require 'spec_helper'


describe 'Parameter after_validation' do
  describe 'default' do
    it 'add a new params["b"] which has the same value as params["a] after validation passed' do
      get('/after_validation', {a: "value_a"}) do |response|
        expect(response.status).to eql 200
        expect(JSON.parse(response.body)['b']).to eql 'value_a'
      end
    end

  end
end
