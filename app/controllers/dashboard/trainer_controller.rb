class Dashboard::TrainerController < Dashboard::BaseController

  def index
    if params[:id]
      @card = current_user.cards.find(params[:id])
    else
      @card = first_repeating_or_pending_card
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def review_card
    @card = current_user.cards.find(params[:card_id])

    check_result = @card.check_translation(trainer_params[:user_translation])

    if check_result[:state]
      if check_result[:distance] == 0
        flash[:notice] = t(:correct_translation_notice)
      else
        flash[:alert] = t 'translation_from_misprint_alert',
                          user_translation: trainer_params[:user_translation],
                          original_text: @card.original_text,
                          translated_text: @card.translated_text
      end
      redirect_to trainer_path
    else
      flash[:alert] = t(:incorrect_translation_alert)
      redirect_to trainer_path(id: @card.id)
    end
  end

  private

  def first_repeating_or_pending_card
    if current_user.current_block
      current_user.current_block.cards.first_repeating_or_pending_card
    else
      current_user.cards.first_repeating_or_pending_card
    end
  end

  def trainer_params
    params.permit(:user_translation)
  end
end
