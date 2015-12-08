module ActiveAdmin
  class PagePolicy < ApplicationPolicy
    def show?
      user.is_admin?
    end
  end
end
