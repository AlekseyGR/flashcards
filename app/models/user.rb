# ## Schema Information
#
# Table name: `users`
#
# ### Columns
#
# Name                                   | Type               | Attributes
# -------------------------------------- | ------------------ | ---------------------------
# **`created_at`**                       | `datetime`         |
# **`crypted_password`**                 | `string`           |
# **`current_block_id`**                 | `integer`          |
# **`email`**                            | `string`           | `indexed`
# **`id`**                               | `integer`          | `not null, primary key`
# **`locale`**                           | `string`           |
# **`remember_me_token`**                | `string`           | `indexed`
# **`remember_me_token_expires_at`**     | `datetime`         |
# **`reset_password_email_sent_at`**     | `datetime`         |
# **`reset_password_token`**             | `string`           | `indexed`
# **`reset_password_token_expires_at`**  | `datetime`         |
# **`salt`**                             | `string`           |
# **`updated_at`**                       | `datetime`         |
#
# ### Indexes
#
# * `index_users_on_email` (_unique_):
#     * **`email`**
# * `index_users_on_remember_me_token`:
#     * **`remember_me_token`**
# * `index_users_on_reset_password_token`:
#     * **`reset_password_token`**
#

class User < ActiveRecord::Base
  rolify
  has_many :cards, dependent: :destroy
  has_many :blocks, dependent: :destroy
  has_many :authentications, dependent: :destroy
  belongs_to :current_block, class_name: 'Block'
  before_create :set_default_locale
  before_validation :set_default_locale, on: :create

  accepts_nested_attributes_for :authentications

  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  validates :password, confirmation: true, presence: true,
            length: { minimum: 3 }
  validates :password_confirmation, presence: true
  validates :email, uniqueness: true, presence: true,
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ }
  validates :locale, presence: true,
            inclusion: { in: I18n.available_locales.map(&:to_s),
                         message: 'Выберите локаль из выпадающего списка.' }

  def has_linked_github?
    authentications.where(provider: 'github').present?
  end

  def set_current_block(block)
    update_attribute(:current_block_id, block.id)
  end

  def reset_current_block
    update_attribute(:current_block_id, nil)
  end

  private

  def set_default_locale
    self.locale = I18n.locale.to_s
  end
end
