class AddCardsNotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "add_cards_notification_#{current_user.id}"
  end
end
