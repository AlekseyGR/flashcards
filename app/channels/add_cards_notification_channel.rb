class AddCardsNotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "add_cards_notification"
  end
end
