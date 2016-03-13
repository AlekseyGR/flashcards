class AddCardsFromUrlJob < ActiveJob::Base
  queue_as :add_cards

  def perform(params)
    parse_params = {
      url: params[:url],
      original_text_selector: params[:original_text_selector],
      translated_text_selector: params[:translated_text_selector],
      user_id: params[:user_id],
      block_id: params[:block_id]
    }
    # parser = CardParser.new(parse_params)
  end
end
