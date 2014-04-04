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

    it 'returns 400 on requests when integer is invalid' do
      get('/coerce/integer', arg: '123abc') do |response|
        response.status.should == 400
        JSON.parse(response.body)['message'].should eq('Invalid Parameter: arg')
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

    it 'returns 400 on requests when float is invalid' do
      get('/coerce/float', arg: '123abc') do |response|
        response.status.should == 400
        JSON.parse(response.body)['message'].should eq('Invalid Parameter: arg')
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

    it 'returns 400 on requests when time is invalid' do
      get('/coerce/time', arg: '123abc') do |response|
        response.status.should == 400
        JSON.parse(response.body)['message'].should eq('Invalid Parameter: arg')
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

    it 'returns 400 on requests when date is invalid' do
      get('/coerce/date', arg: 'abc') do |response|
        response.status.should == 400
        JSON.parse(response.body)['message'].should eq('Invalid Parameter: arg')
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

    it 'returns 400 on requests when datetime is invalid' do
      get('/coerce/datetime', arg: 'abc') do |response|
        response.status.should == 400
        JSON.parse(response.body)['message'].should eq('Invalid Parameter: arg')
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
    
    it 'coerces arrays with arg[] style' do
      get('/coerce/array', 'arg[]' => ['1','2','3','4','5']) do |response|
        response.status.should == 200
        parsed_body = JSON.parse(response.body)
        parsed_body['arg'].should be_an(Array)
        parsed_body['arg'].should eq(%w(1 2 3 4 5))
      end
    end
  end
  
  describe 'Array of' do
    it 'coerces array of String' do
      get('/coerce/array/string', arg: '1,2,3,4,5') do |response|
        response.status.should == 200
        parsed_body = JSON.parse(response.body)
        parsed_body['arg'].should be_an(Array)
        parsed_body['arg'].each{ |p| p.should be_an(String) }
        parsed_body['arg'].should eq(%w(1 2 3 4 5))
      end
    end
    
    it 'coerces array of Integer' do
      get('/coerce/array/integer', arg: '1,2,3,4,5') do |response|
        response.status.should == 200
        parsed_body = JSON.parse(response.body)
        parsed_body['arg'].should be_an(Array)
        parsed_body['arg'].each{ |p| p.should be_an(Integer) }
        parsed_body['arg'].should eq([1,2,3,4,5])
      end
    end
    
    it 'coerces array of Float' do
      get('/coerce/array/float', arg: '1,2,3,4,5') do |response|
        response.status.should == 200
        parsed_body = JSON.parse(response.body)
        parsed_body['arg'].should be_an(Array)
        parsed_body['arg'].each{ |p| p.should be_an(Float) }
        parsed_body['arg'].should eq([1,2,3,4,5])
      end
    end
    
    it 'coerces array of time' do
      get('/coerce/array/time', arg: '20130117,20130118') do |response|
        response.status.should == 200
        parsed_body = JSON.parse(response.body)
        parsed_body['arg'].should be_an(Array)
        parsed_body['arg'].should eq([Time.new(2013,01,17).to_s, Time.new(2013,01,18).to_s])
      end
    end
    
    it 'coerces array of date' do
      get('/coerce/array/date', arg: '20130117,20130118') do |response|
        response.status.should == 200
        parsed_body = JSON.parse(response.body)
        parsed_body['arg'].should be_an(Array)
        parsed_body['arg'].should eq([Date.new(2013,01,17).to_s, Date.new(2013,01,18).to_s])
      end
    end
    
    it 'coerces array of datetime' do
      get('/coerce/array/datetime', arg: '20130117,20130118') do |response|
        response.status.should == 200
        parsed_body = JSON.parse(response.body)
        parsed_body['arg'].should be_an(Array)
        parsed_body['arg'].should eq([DateTime.new(2013,01,17).to_s, DateTime.new(2013,01,18).to_s])
      end
    end
    
    it 'coerces array of boolean' do
      get('/coerce/array/boolean', arg: '1,true,t,yes,t,0,false,f,no,n') do |response|
        response.status.should == 200
        parsed_body = JSON.parse(response.body)
        parsed_body['arg'].should be_an(Array)
        parsed_body['arg'].should eq([true,true,true,true,true,false,false,false,false,false])
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

    it 'coerces falsey booleans to false' do
      %w(0 false f no n).each do |bool|
        get('/coerce/boolean', arg: bool) do |response|
          response.status.should == 200
          JSON.parse(response.body)['arg'].should be_false
          JSON.parse(response.body)['arg'].should_not be_nil
        end
      end
    end

    it 'coerces truthy booleans to true when default is false' do
      %w(1 true t yes y).each do |bool|
        get('/default/boolean/false', arg: bool) do |response|
          response.status.should == 200
          JSON.parse(response.body)['arg'].should be_true
        end
      end
    end

    it 'coerces falsey booleans to false when default is true' do
      %w(0 false f no n).each do |bool|
        get('/default/boolean/true', arg: bool) do |response|
          response.status.should == 200
          JSON.parse(response.body)['arg'].should be_false
          JSON.parse(response.body)['arg'].should_not be_nil
        end
      end
    end
  end
end
