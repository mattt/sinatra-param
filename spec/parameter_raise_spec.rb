require 'spec_helper'

describe 'Exception' do
  describe 'raise' do
    it 'should raise error when option is specified' do
      expect {
        get('/raise')
      }.to raise_error
    end
  end
end
