class AddCardsFromUrlJob < ActiveJob::Base
  queue_as :add_cards

  def perform(params)
    words_collection = WordParser.word_collection(params[:url],
                                                  params[:original_text_selector],
                                                  params[:translated_text_selector])

    if words_collection
      words_collection.each do |original, translation|
        Card.create(original_text: original, translated_text: translation,
                    block_id: params[:block_id], user_id: params[:user_id])
      end
    end
  end
end
