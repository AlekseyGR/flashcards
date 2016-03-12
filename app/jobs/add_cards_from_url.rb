class AddCardsFromUrlJob < ActiveJob::Base
  queue_as :add_cards

  def perform(*args)

  end
end
