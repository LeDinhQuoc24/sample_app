class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        if params[:session][:remember_me] == "1"
          remember(user)
        else
          forget(user)
        end
        redirect_back_or user
      else
        flash[:warning] = t ".message"
        redirect_to root_url
      end
    else
      flash.now[:danger] = t ".invalid" # Not quite right!
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
