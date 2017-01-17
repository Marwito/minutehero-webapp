class UsersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: [:bulk]
  before_action :set_user, except: [:index, :bulk]

  def index
    authorize User
    @users = User.all
    @users = @users.table_filters params, 'email'
  end

  def show; end

  # GET /users/1/edit
  def edit; end

  def update
    if @user.update_attributes(secure_params)
      flash[:notice] = 'User updated.'
      render :edit
    else
      render :edit, alert: 'Unable to update user.'
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: 'User deleted.'
  end

  def bulk
    authorize User
    @users = User.find bulk_params[:ids]
    @users.each { |u| u.send bulk_params[:action] }
    redirect_to users_path,
                notice: "Users succsessfully #{bulk_params[:action]}."
  end

  private

  def secure_params
    params.require(:user).permit(:email, :role, :blocked, :suspended,
                                 :first_name, :last_name, :company, :country,
                                 :time_zone, :product_id)
  end

  def set_user
    @user = User.find(params[:id])
    authorize @user
  end

  def bulk_params
    params.require(:bulk).permit(:action, ids: [])
  end
end
