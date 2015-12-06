require 'rails_helper'
require 'support/helpers/login_helper.rb'
include LoginHelper

describe 'Admin panel' do
  context 'when user not loged in' do
    it 'should redirect to login page' do
      visit admin_root_path

      expect(page).to have_content(I18n.t('.sing_up_label'))
    end
  end

  context 'when user has role admin and signed in' do
    let!(:user) { create(:admin) }

    before(:each) do
      login('test@test.com', '12345', 'Войти')
    end

    it 'should open admin panel' do
      # visit root_path
      # login('test@test.com', '12345', 'Войти')
      binding.pry
      visit admin_root_path
      # save_and_open_page

      expect(page).to have_content 'Вход выполнен успешно.'
    end
  end
end

# describe "User enters admin area" do
#   let(:login_and_enter) do
#     login("test@test.com", "12345", "Войти")
#     visit admin_root_path
#   end

#   context "when not authenticated" do
#     before do
#       visit admin_root_path
#     end

#     it "redirects to login" do
#       expect(page).to have_content("Войти")
#     end
#   end

#   context "when authenticated but not as admin" do
#     let!(:user) { create(:user) }

#     before do
#       login_and_enter
#     end

#     it "shows proper alert message" do
#       expect(page).to have_content(
#         "Вы не авторизованы для выполнения данного действия.")
#     end
#     it "redirect to root path" do
#       expect(page).to have_content("Добро пожаловать.")
#     end
#   end

#   context "when authenticated as admin" do
#     let!(:admin) { create(:user, :admin) }

#     it "allows to enter" do
#       login_and_enter
#       expect(page).to have_content("Панель управления")
#     end
#   end
# end
