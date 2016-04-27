# ## Schema Information
#
# Table name: `authentications`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`created_at`**  | `datetime`         |
# **`id`**          | `integer`          | `not null, primary key`
# **`provider`**    | `string`           | `not null, indexed => [uid]`
# **`uid`**         | `string`           | `not null, indexed => [provider]`
# **`updated_at`**  | `datetime`         |
# **`user_id`**     | `integer`          | `not null`
#
# ### Indexes
#
# * `index_authentications_on_provider_and_uid`:
#     * **`provider`**
#     * **`uid`**
#

class Authentication < ActiveRecord::Base
  belongs_to :user
  validates :user_id, :provider, :uid, presence: true
end
