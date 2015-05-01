require 'spec_helper'

describe Rack::APIMock do
  include TestApplicationHelper
  include Rack::Test::Methods

  let(:test_app) { TestApplicationHelper::TestApplication.new }
  let(:apidir) { File.expand_path(File.dirname(__FILE__)) + "/../api" }

  describe 'GET / with "Content-Type: application/json"' do
    let(:app) { Rack::APIMock.new(test_app, apidir: apidir) }

    it 'should return index_get.json' do
      get '/', {}, {"CONTENT_TYPE" => "application/json", "REQUEST_PATH" => "/"}

      expect(last_response.status).to eq 200
      expect(last_response.body).to eq File.open("#{apidir}/index_get.json", &:read)
    end
  end

  describe 'GET /index with "Content-Type: application/json"' do
    let(:app) { Rack::APIMock.new(test_app, apidir: apidir) }

    it 'should return index_get.json' do
      get '/index', {}, {"CONTENT_TYPE" => "application/json", "REQUEST_PATH" => "/"}

      expect(last_response.status).to eq 200
      expect(last_response.body).to eq File.open("#{apidir}/index_get.json", &:read)
    end
  end

  describe 'POST / with "Content-Type: application/json"' do
    let(:app) { Rack::APIMock.new(test_app, apidir: apidir) }

    it 'should return index_post.json' do
      post '/', {}, {"CONTENT_TYPE" => "application/json", "REQUEST_PATH" => "/"}

      expect(last_response.status).to eq 200
      expect(last_response.body).to eq File.open("#{apidir}/index_post.json", &:read)
    end
  end

  describe 'DELETE / with "Content-Type: application/json"' do
    let(:app) { Rack::APIMock.new(test_app, apidir: apidir) }

    it 'should return index_delete.json' do
      delete '/', {}, {"CONTENT_TYPE" => "application/json", "REQUEST_PATH" => "/"}

      expect(last_response.status).to eq 200
      expect(last_response.body).to eq File.open("#{apidir}/index_delete.json", &:read)
    end
  end

  describe 'PUT / with "Content-Type: application/json"' do
    let(:app) { Rack::APIMock.new(test_app, apidir: apidir) }

    it 'should return index_put.json' do
      put '/', {}, {"CONTENT_TYPE" => "application/json", "REQUEST_PATH" => "/"}

      expect(last_response.status).to eq 200
      expect(last_response.body).to eq File.open("#{apidir}/index_put.json", &:read)
    end
  end

  describe 'GET / with "Content-Type: application/xml"' do
    let(:app) { Rack::APIMock.new(test_app, apidir: apidir) }

    it 'should return index_get.xml' do
      get '/', {}, {"CONTENT_TYPE" => "application/xml", "REQUEST_PATH" => "/"}

      expect(last_response.status).to eq 200
      expect(last_response.body).to eq File.open("#{apidir}/index_get.xml", &:read)
    end
  end

  describe 'GET /items/sample with "Content-Type: application/json"' do
    let(:app) { Rack::APIMock.new(test_app, apidir: apidir) }

    it 'should return items/sample_get.json.erb' do
      get '/items/sample', {}, {"CONTENT_TYPE" => "application/json", "REQUEST_PATH" => "/items/sample"}

      expect(last_response.status).to eq 200
      expect(last_response.body).to eq ERB.new(File.open("#{apidir}/items/sample_get.json.erb", &:read), nil, '<>').result
      expect(last_response.header['Content-Type']).to eq "application/json"
    end
  end

  describe 'POST /items/sample with "Content-Type: application/json"' do
    let(:app) { Rack::APIMock.new(test_app, apidir: apidir) }

    it 'should return items/sample_post.json.erb' do
      post '/items/sample', {}, {"CONTENT_TYPE" => "application/json", "REQUEST_PATH" => "/items/sample"}

      expect(last_response.status).to eq 201
      expect(last_response.body).to eq ERB.new(File.open("#{apidir}/items/sample_post.json.erb", &:read), nil, '<>').result
      expect(last_response.header['Content-Type']).to eq "application/json"
    end
  end

  describe 'POST /items/sample with "Content-Type: empty"' do
    let(:app) { Rack::APIMock.new(test_app, apidir: apidir) }

    it 'should return items/sample_post.json.erb' do
      post '/items/sample', {}, {"CONTENT_TYPE" => "", "REQUEST_PATH" => "/items/sample"}

      expect(last_response.status).to eq 201
      expect(last_response.body).to eq ERB.new(File.open("#{apidir}/items/sample_post.json.erb", &:read), nil, '<>').result
      expect(last_response.header['Content-Type']).to eq "application/json"
    end
  end

  describe 'GET /items/sample?headers with "Content-Type: application/json"' do
    let(:app) { Rack::APIMock.new(test_app, apidir: apidir) }

    it 'should return items/sample_get.json.erb' do
      get '/items/sample?headers', {}, {
        "CONTENT_TYPE" => "application/json",
        "REQUEST_PATH" => "/items/sample",
        "QUERY_STRING" => "headers"
      }

      body = ERB.new(File.open("#{apidir}/items/sample_get.json.erb", &:read), nil, '<>').result
      response = JSON.parse(body).select{|k| k == "headers"}.to_json

      expect(last_response.status).to eq 200
      expect(last_response.body).to eq response
      expect(last_response.header['Content-Type']).to eq "application/json"
    end
  end
end
