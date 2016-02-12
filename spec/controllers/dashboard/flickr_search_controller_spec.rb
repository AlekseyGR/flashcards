require 'rails_helper'
require 'support/helpers/flickr_api_stub_helper.rb'
include FlickrApiStubHelper

describe Dashboard::FlickrSearchController do
  let(:user) { FactoryGirl.create(:user) }
  let(:arr) { assigns(:photos) }

  before(:each) do
    flickr_responce_stub
    @controller.send(:auto_login, user)
  end

  describe "when user didn't set search tag" do
    before(:each) do
      xhr :get, :search, search: ''
    end

    it 'returns success status' do
      expect(response.status).to eq(200)
    end

    it 'returns array' do
      expect(arr).to be_instance_of(Array)
    end

    it 'returns 10 elements' do
      expect(arr.length).to eq 10
    end

    it 'returns recend photo' do
      expect(arr).to eq(@resent_photo_result)
    end
  end

  describe 'user set search tag' do
    before(:each) { xhr :get, :search, search: 'test' }

    it 'returns success status' do
      expect(response.status).to eq(200)
    end

    it 'returns array' do
      expect(arr).to be_instance_of(Array)
    end

    it 'returns 10 elements' do
      expect(arr.length).to eq 10
    end

    it 'returns search photo' do
      expect(assigns(:photos)).to eq(@searched_photo_result)
    end
  end
end
