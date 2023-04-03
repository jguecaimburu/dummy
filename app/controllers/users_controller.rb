# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @user_search = UserSearch.new(user_search_params)
    @pagy, @users = pagy(@user_search.users)
  end

  def show; end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_path(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_path(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @user.trash
        format.html { redirect_to users_path, notice: "User was successfully trashed." }
        format.json { head :no_content }
      else
        format.html { redirect_to users_path, alert: "User could not be trashed." }
        format.json { head :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :maiden_name, :email, :age, :gender,
      :phone, :username, :password, :birth_date, :image, :blood_group,
      :height, :weight, :eye_color, :hair_color, :hair_type, :university,
      :domain, :mac_address, :ip, :ein, :ssn, :user_agent
    )
  end

  def user_search_params
    return {} unless params.include?(:user_search)
    
    params.require(:user_search).permit(:search_term, :from_age, :to_age, :gender)
  end
end
