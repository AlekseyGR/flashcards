class AddCardsFromUrlJob < ActiveJob::Base
  queue_as :add_cards

  def perform(**args)
    parse_params = {
      url: args[:url],
      original_text_selector: args[:original_text_selector],
      translated_text_selector: args[:translated_text_selector],
      user_id: args[:user_id],
      block_id: args[:block_id]
    }

    parser = CardParser.new(parse_params)
  end
end
