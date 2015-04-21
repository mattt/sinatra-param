require 'spec_helper'

describe 'Parameter Transformations' do
  describe 'default' do
    it 'sets a default value when none is given' do
      get('/default') do |response|
        expect(response.status).to eql 200
        expect(JSON.parse(response.body)['sort']).to eql 'title'
      end
    end

    it 'sets a default value from an empty hash' do
      get('/default/hash') do |response|
        expect(response.status).to eql 200
        expect(JSON.parse(response.body)['attributes']).to eql Hash.new
      end
    end

    it 'sets a default value from a proc' do
      get('/default/proc') do |response|
        expect(response.status).to eql 200
        expect(JSON.parse(response.body)['year']).to eql 2014
      end
    end
  end

  describe 'transform' do
    it 'transforms the input using to_proc' do
      get('/transform', order: 'asc') do |response|
        expect(response.status).to eql 200
        expect(JSON.parse(response.body)['order']).to eql 'ASC'
      end
    end

    it 'skips transformations when the value is nil' do
      get('/transform/required') do |response|
        expect(response.status).to eql 400
        expect(JSON.parse(response.body)['message']).to eq("Parameter is required")
      end
    end
  end
end
