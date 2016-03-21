App.add_cards_notification = App.cable.subscriptions.create 'AddCardsNotificationChannel',
  received: (data) ->
    console.log data

