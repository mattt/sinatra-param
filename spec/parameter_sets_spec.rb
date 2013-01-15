require 'spec_helper'

describe 'Parameter Sets' do
  def app; App; end

  describe 'one_of' do
    it 'returns 406 on requests that contain more than one mutually exclusive parameter' do
      params = [
        {a: 1, b: 2},
        {b: 2, c: 3},
        {a: 1, b: 2, c: 3}
      ]
      params.each do |param|
        get('/choice', param) do |response|
          response.status.should == 406
          JSON.parse(response.body)['message'].should =~ /mutually exclusive/
        end
      end
    end

    it 'returns successfully for requests that only have one parameter' do
      params = [
        {a: 1},
        {b: 2},
        {c: 3}
      ]
      params.each do |param|
        get('/choice', param) do |response|
          response.status.should == 200
          JSON.parse(response.body)['message'].should =~ /OK/
        end
      end
    end
  end
end
