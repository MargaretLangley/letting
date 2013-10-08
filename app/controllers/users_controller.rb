####
#
# UsersController
#
# Why does this class exist?
#
# Restful action of the Users resource
#
# How does this fit into the larger system?
#
# Only admins are permitted to access the users controller and manage them.
#
####
#
class UsersController < ApplicationController
  def index
    @users = User.all
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

  def users_params
    params
    .require(:user)
    .permit(:email, :password, :password_confirmation, :admin)
  end
end
