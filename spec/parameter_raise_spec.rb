require 'spec_helper'

describe 'Exception' do
  describe 'raise' do
    it 'should raise error when option is specified' do
      expect {
        get('/raise/validation/required')
      }.to raise_error
    end
  end

  it 'should raise error when more than one parameter is specified' do
    params = {a: 1, b: 2, c: 3}
    expect {
      get('/raise/one_of/3', params)
    }.to raise_error
  end

  it 'should raise error when no parameters are specified' do
    params = {}
    expect {
      get('/raise/any_of', params)
    }.to raise_error
  end
end
