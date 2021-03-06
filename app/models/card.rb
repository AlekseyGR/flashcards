# ## Schema Information
#
# Table name: `cards`
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`attempt`**          | `integer`          | `default("1"), not null`
# **`block_id`**         | `integer`          | `not null`
# **`created_at`**       | `datetime`         |
# **`efactor`**          | `float`            | `default("2.5"), not null`
# **`id`**               | `integer`          | `not null, primary key`
# **`image`**            | `string`           |
# **`interval`**         | `integer`          | `default("1"), not null`
# **`original_text`**    | `text`             |
# **`quality`**          | `integer`          | `default("5"), not null`
# **`repeat`**           | `integer`          | `default("1"), not null`
# **`review_date`**      | `datetime`         | `not null`
# **`translated_text`**  | `text`             |
# **`updated_at`**       | `datetime`         |
# **`user_id`**          | `integer`          | `not null`
#

require 'super_memo'

class Card < ActiveRecord::Base
  DISTANCE_MAX = 1 # max levenstain distance value

  belongs_to :user
  belongs_to :block

  validates :user_id, presence: true
  validate :texts_are_not_equal
  validates :original_text, :translated_text, :review_date,
            presence: { message: 'Необходимо заполнить поле.' }
  validates :user_id, presence: { message: 'Ошибка ассоциации.' }
  validates :block_id,
            presence: { message: 'Выберите колоду из выпадающего списка.' }
  validates :interval, :repeat, :efactor, :quality, :attempt, presence: true

  before_validation :set_review_date_as_now, on: :create

  mount_uploader :image, CardImageUploader

  scope :pending, -> { where('review_date <= ?', Time.now).order('RANDOM()') }
  scope :repeating, -> { where('quality < ?', 4).order('RANDOM()') }

  def check_translation(user_translation)
    distance = Levenshtein.distance(full_downcase(translated_text),
                                    full_downcase(user_translation))

    sm_hash = SuperMemo.algorithm(interval, repeat, efactor, attempt, distance, DISTANCE_MAX)

    handle_answer_distance(distance, sm_hash)
  end

  def self.pending_cards_notification
    users = User.where.not(email: nil)
    users.each do |user|
      if user.cards.pending.any?
        CardsMailer.pending_cards_notification(user.email).deliver_later
      end
    end
  end

  def self.first_repeating_or_pending_card
    card = pending.try(:first)
    card ||= repeating.try(:first)
    card
  end

  def handle_answer_distance(distance, sm_hash)
    if distance <= DISTANCE_MAX
      sm_hash.merge!(review_date: Time.zone.now + interval.to_i.days, attempt: 1)
      update(sm_hash)
      { state: true, distance: distance }
    else
      sm_hash.merge!(attempt: [attempt + 1, 5].min)
      update(sm_hash)
      { state: false, distance: distance }
    end
  end

  protected

  def set_review_date_as_now
    self.review_date = Time.now
  end

  def texts_are_not_equal
    if full_downcase(original_text) == full_downcase(translated_text)
      errors.add(:original_text, 'Вводимые значения должны отличаться.')
    end
  end

  def full_downcase(str)
    str.mb_chars.downcase.to_s.squeeze(' ').lstrip
  end
end
