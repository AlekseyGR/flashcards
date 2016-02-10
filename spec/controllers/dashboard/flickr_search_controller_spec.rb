require 'rails_helper'
require 'support/helpers/flickr_api_stub_helper.rb'
include FlickrApiStubHelper

describe Dashboard::FlickrSearchController do
  let(:user) { FactoryGirl.create(:user) }
  before(:each) do
    flickr_responce_stub
    @controller.send(:auto_login, user)
  end

  describe 'when user didn\'t set search tag' do
    it 'returns recend photo'do
      get :search, search: '', format: 'js'
      expect(response.status).to eq(200)
      # expect(assigns(:photos)).to eq(@resent_photo_result)
    end
  end

  xdescribe 'user set search tag' do
    it 'returns search photo' do
      get :search, search: 'test', format: 'js'
      # expect(response.status).to eq(200)
      expect(assigns(:photos)).to eq(@searched_photo_result)
    end
  end
end
