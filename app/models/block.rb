# ## Schema Information
#
# Table name: `blocks`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`created_at`**  | `datetime`         |
# **`id`**          | `integer`          | `not null, primary key`
# **`title`**       | `string`           | `not null`
# **`updated_at`**  | `datetime`         |
# **`user_id`**     | `integer`          | `not null`
#

class Block < ActiveRecord::Base
  has_many :cards, dependent: :destroy
  belongs_to :user

  validates :title, presence: { message: 'Необходимо заполнить поле.' }

  def current?
    id == user.current_block_id
  end
end
