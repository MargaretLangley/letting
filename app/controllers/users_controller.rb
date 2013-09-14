class UsersController < ApplicationController
  before_filter :authorize
  def index
    @users = User.all
     # @users = User.search(search_param).page(params[:page]).load
     # redirect_to edit_user_path @users.first if unique_search?
   end

  def show
    @user = User.find params[:id]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new users_params
    if @user.save
      redirect_to users_path, notice: "#{@user.id} successfully created!"
    else
      render :new
    end
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    if @user.update users_params
      redirect_to users_path, notice: "#{@user.id} successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, alert: "#{@user.id} user successfully deleted!"
  end

  private

  def authorized
      if current_user && !current_user.admin?
      redirect_to root_url, alert: "Not authorized"
    end
  end

  def unique_search?
    @users.size == 1 && search_param.present?
  end

  def search_param
    params[:search]
  end

  def users_params
     params.require(:user).permit(:email, :password, :password_confirmation, :admin)
    # permit :id, :email, :password_digest, :admin
  end
end