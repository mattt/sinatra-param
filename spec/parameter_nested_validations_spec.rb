require 'spec_helper'

describe 'Nested Validation' do
  context '' do
    it 'should validate the children when the parent is present' do
      params = {
        :parent => {
          :required_child => 1,
        }
      }

      get("/validation/hash/nested_values", params) do |response|
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['message']).to eq("OK")
      end
    end

    it 'should be invalid when the parent is present but a nested validation fails' do
      params = {
        :parent => {
          :optional_chlid => 'test'
        }
      }

      get("/validation/hash/nested_values", params) do |response|
        expect(response.status).to eq(400)
        body = JSON.parse(response.body)
        expect(body['message']).to eq("Parameter is required")
        expect(body['errors']).to eq({
          "parent[required_child]" => "Parameter is required"
        })
      end
    end

    it 'should not require sub params when the parent hash is not present and not required' do
      params = {}
      get("/validation/hash/nested_values", params) do |response|
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['message']).to eq("OK")
      end
    end

    it 'should allow arbitrary levels of nesting' do
      params = {
        :parent => {
          :required_child => 1,
          :nested_child => {
            :required_sub_child => 'test'
          }
        }
      }

      get("/validation/hash/nested_values", params) do |response|
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['message']).to eq("OK")
      end
    end

    it 'should have the proper error message for multiple levels deep validation errors' do
      params = {
        :parent => {
          :required_child => 1,
          :nested_child => {
            :required_sub_child => 'test',
            :optional_sub_child => 'test'
          }
        }
      }

      get("/validation/hash/nested_values", params) do |response|
        expect(response.status).to eq(400)
        body = JSON.parse(response.body)
        expect(body['message']).to eq("'test' is not a valid Integer")
        expect(body['errors']).to eq({
          "parent[nested_child][optional_sub_child]" => "'test' is not a valid Integer"
        })
      end
    end

    it 'should error when sub hash validation is tried on a non Hash parameter' do
      params = {
        :parent => {
          :child => 'test'
        }
      }

      get("/validation/hash/bad_nested_values", params) do |response|
        expect(response.status).to eq(400)
        body = JSON.parse(response.body)
        expect(body['message']).to eq("Only the Hash parameter validation can use sub hash validation method")
        expect(body['errors']).to eq({
          "parent" => "Only the Hash parameter validation can use sub hash validation method"
        })
      end
    end

    it 'should work with one_of nested in a hash' do
      params = {
        :parent => {
          :a => 'test'
        }
      }

      get("/one_of/nested", params) do |response|
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['message']).to eq("OK")
      end
    end

    it "should error when one_of isn't satisfied in a nested hash" do
      params = {
        :parent => {
          :a => 'test',
          :b => 'test'
        }
      }

      get("/one_of/nested", params) do |response|
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['message']).to eq("Invalid parameters parent[[a, b, c]]")
      end
    end

    it 'should work with any_of nested in a hash' do
      params = {
        :parent => {
          :a => 'test'
        }
      }

      get("/any_of/nested", params) do |response|
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['message']).to eq("OK")
      end
    end

    it "should error when one_of isn't satisfied in a nested hash" do
      params = {
        :parent => {
          :d => 'test'
        }
      }

      get("/any_of/nested", params) do |response|
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['message']).to eq("Invalid parameters parent[[a, b, c]]")
      end
    end

  end
end
