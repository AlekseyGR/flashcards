require 'rails_helper'
require 'support/helpers/login_helper.rb'
include LoginHelper

feature 'User try enter to Admin dashboard' do
  describe 'when user is not logged in' do
    it 'should redirect to login path' do
      visit admin_root_path
      expect(page).to have_content(I18n.t('.sing_up_label'))
    end
  end

  describe 'when user logged in as admin' do
    let!(:user) { create(:user, :admin) }

    before(:each) do
      visit root_path
      login('test@test.com', '12345', 'Войти')
      visit admin_root_path
    end

    it 'and open admin dashboard' do
      expect(page).to have_content('Flashcards Admin Panel')
    end
  end
end
