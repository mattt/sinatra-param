require 'spec_helper'

describe 'destroy_undefined_params' do
  it "gets rid of parameters that weren' in the request we got" do
    get('/destroy_undefined_params', a: 'joske', c: 'jefke') do |response|
      res = JSON.parse(response.body)

      expect(res['a']).to eq('joske')
      expect(res['c']).to be_nil
    end
  end
end
