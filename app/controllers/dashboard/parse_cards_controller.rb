module Dashboard
  class ParseCardsController < Dashboard::BaseController
    def new; end

    def create
      AddCardsFromUrlJob.perform_later(parse_cards_params)
      redirect_to cards_path, notice: "Cards adding task from #{parse_cards_params[:url]} was added in queue."
    end

    private

    def parse_cards_params
      params.require(:parse_cards).permit(:user_id, :url, :original_text_selector, :translated_text_selector, :block_id)
    end
  end
end
