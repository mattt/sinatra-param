RSpec.describe 'Flash' do
  def app
    @app = AppWithFlash
  end

  describe 'set up error' do
    it 'should return simple json message with all errors' do
      get('/errors/validation/required', arg: 1, arg2: 0)
      
      json_response = JSON.parse(last_response.body)

      expect(json_response[0].keys.first).to eq('arg')
      expect(json_response[0]['arg']).to include(
        'Parameter cannot be less than 12',
        'Parameter must be within 2..100'
      )
    end
  end

  it 'should raise error when more than one parameter is specified' do
    params = {a: 1, b: 2, c: 3}

    get('/errors/one_of/3', params)

    json_response = JSON.parse(last_response.body)
    
    expect(json_response[0]).to eq('Only one of [a, b, c] is allowed')
  end

  it 'should raise error when no parameters are specified' do
    params = {}
    
    get('/errors/any_of', params)

    json_response = JSON.parse(last_response.body)
    
    expect(json_response[0]).to eq('One of parameters [a, b, c] is required')
  end
end
