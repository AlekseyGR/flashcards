require 'rails_helper'
include LoginHelper

RSpec.describe Dashboard::ParseCardsController, type: :controller do
  context 'non-autorized access' do
    describe 'GET parse_cards#new' do
      it 'redirect to login page' do
        get :new
        expect(response).to redirect_to(login_path)
      end
    end

    describe 'POST parse_cards#create' do
      it 'redirect to login page' do
        post :create, some_params: :anything
        expect(response).to redirect_to(login_path)
      end
    end
  end

  context 'authorized access' do
    let(:user) { FactoryGirl.create(:user_with_one_block_without_cards) }
    before(:each) { allow(controller).to receive(:current_user) { user } }

    describe 'GET parse_cards#new' do
      it 'respond with status 200' do
        get :new
        expect(response.status).to eq(200)
      end
    end

    describe 'POST parse_cards#create' do
      it 'respond with status 200' do
        post :create, parse_cards: { user_id: user.id, url: 'http://someurl.com',
                                     original_text_selector: 'div.original', translated_text_selector: 'div.translated',
                                     block_id: user.blocks.first.id }
        expect(response.status).to redirect_to(cards_path)
      end
    end
  end
end
