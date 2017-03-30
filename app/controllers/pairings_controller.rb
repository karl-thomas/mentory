class PairingsController < ApplicationController

  def index
    @offered_pairings = Pairing.where(mentee_id: nil).order(start_time: :asc)
  end

  def show
    @pairing = Pairing.find_by(id: params[:id])
    @user = User.find_by(id: params[:mentor_id])
  end

  def new
    @pairing = Pairing.new
  end

  def update #post
    @pairing = Pairing.find_by(id: params[:id])
    if @pairing.mentor_id == session[:user_id]
      if @pairing.update(pairing_params)
        redirect_to user_pairing_path
      else
        @errors = @pairing.errors.full_messages
        render 'edit'
      end
    else
      redirect_to new_session_path
    end
  end

  def edit #get
    @user = User.find(params[:user_id])
    @pairing = Pairing.find(params[:id])
    if @pairing.mentor_id == session[:user_id]
      render 'edit'
    else
      redirect_to new_session_path
    end
  end

  def create
    @pairing = Pairing.new(pairing_params)
    @pairing.mentor_id == session[:user_id]
    if @pairing.save
      redirect_to user_pairings_path
    else
      @errors = @pairing.errors.full_messages
      render 'new'
    end
  end

  def destroy
    @pairing = Pairing.find(params[:id])
    if @pairing.mentor_id == session[:user_id]
      @pairing.destroy
      redirect_to user_pairing_path
    else
      redirect_to new_session_path
    end
  end

  private
  def pairing_params
    params.require(:pairing).permit(:mentor_id, :mentee_id, :topic, :start_time)
  end

end
