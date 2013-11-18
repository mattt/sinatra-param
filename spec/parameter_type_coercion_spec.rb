require 'spec_helper'

describe 'Parameter Types' do
  describe 'String' do
    it 'coerces strings' do
      get('/coerce/string', arg: '1234') do |response|
        response.status.should == 200
        JSON.parse(response.body)['arg'].should eq('1234')
      end
    end
  end

  describe 'Integer' do
    it 'coerces integers' do
      get('/coerce/integer', arg: '1234') do |response|
        response.status.should == 200
        JSON.parse(response.body)['arg'].should eq(1234)
      end
    end
  end

  describe 'Float' do
    it 'coerces floats' do
      get('/coerce/float', arg: '1234') do |response|
        response.status.should == 200
        JSON.parse(response.body)['arg'].should eq(1234.0)
      end
    end
  end

  describe 'Time' do
    it 'coerces time' do
      get('/coerce/time', arg: '20130117') do |response|
        response.status.should == 200
        JSON.parse(response.body)['arg'].should match(/2013-01-17 00:00:00/)
      end
    end
  end

  describe 'Date' do
    it 'coerces date' do
      get('/coerce/date', arg: '20130117') do |response|
        response.status.should == 200
        JSON.parse(response.body)['arg'].should eq('2013-01-17')
      end
    end
  end

  describe 'DateTime' do
    it 'coerces datetimes' do
      get('/coerce/datetime', arg: '20130117') do |response|
        response.status.should == 200
        JSON.parse(response.body)['arg'].should eq('2013-01-17T00:00:00+00:00')
      end
    end
  end

  describe 'Array' do
    it 'coerces arrays' do
      get('/coerce/array', arg: '1,2,3,4,5') do |response|
        response.status.should == 200
        parsed_body = JSON.parse(response.body)
        parsed_body['arg'].should be_an(Array)
        parsed_body['arg'].should eq(%w(1 2 3 4 5))
      end
    end
  end

  describe 'Hash' do
    it 'coerces hashes' do
      get('/coerce/hash', arg: 'a:b,c:d') do |response|
        response.status.should == 200
        parsed_body = JSON.parse(response.body)
        parsed_body['arg'].should be_an(Hash)
        parsed_body['arg'].should eq({ 'a' => 'b', 'c' => 'd'})
      end
    end
  end

  describe 'Boolean' do
    it 'coerces truthy booleans to true' do
      %w(1 true t yes y).each do |bool|
        get('/coerce/boolean', arg: bool) do |response|
          response.status.should == 200
          JSON.parse(response.body)['arg'].should be_true
        end
      end
    end
  end
end
