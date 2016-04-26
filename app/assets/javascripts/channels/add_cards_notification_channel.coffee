#= require channels/application_channel

App.add_cards_notification = App.cable.subscriptions.create 'AddCardsNotificationChannel',
  received: (data) ->
    alert data['message']

