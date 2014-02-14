require 'spec_helper'

describe 'Parameter Transformations' do
  describe 'default' do
    it 'sets a default value when none is given' do
      get('/default') do |response|
        response.status.should == 200
        JSON.parse(response.body)['sort'].should == 'title'
      end
    end

    it 'sets a default value from a proc' do
      get('/default/proc') do |response|
        response.status.should == 200
        JSON.parse(response.body)['year'].should == 2014
      end
    end
  end

  describe 'transform' do
    it 'transforms the input using to_proc' do
      get('/transform', order: 'asc') do |response|
        response.status.should == 200
        JSON.parse(response.body)['order'].should == 'ASC'
      end
    end
  end
end
