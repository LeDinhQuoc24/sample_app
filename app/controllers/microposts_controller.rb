class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = t ".micropost_create"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      flash[:warning] = t ".fail"
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t ".micropost_delete"
      redirect_to request.referer || root_url
    else
      flash[:warning] = t ".fail"
      render "static_pages/home"
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    return if @micropost

    flash[:warning] = t ".not_fould"
    redirect_to root_url
  end
end
