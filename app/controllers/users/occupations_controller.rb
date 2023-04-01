# frozen_string_literal: true

module Users
  class OccupationsController < ApplicationController
    before_action :set_user
    before_action :set_occupation, only: %i[show edit update]

    def show; end

    def new
      if @user.occupation
        redirect_to user_occupation_path(@user, @user.occupation)
        return
      end

      @occupation = Occupation.new(user: @user)
    end

    def edit; end

    def create
      @occupation = Occupation.new(occupation_params.merge(user: @user))

      respond_to do |format|
        if @occupation.save
          format.html do
            redirect_to user_occupation_path(@user, @occupation), notice: "Occupation was successfully created."
          end
          format.json { render :show, status: :created, location: user_occupation_path(@user, @occupation) }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @occupation.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @occupation.update(occupation_params)
          format.html do
            redirect_to user_occupation_path(@user, @occupation), notice: "Occupation was successfully updated."
          end
          format.json { render :show, status: :ok, location: user_occupation_path(@user, @occupation) }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @occupation.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_occupation
      @occupation = @user.occupation
    end

    def occupation_params
      params.require(:occupation).permit(
        :company_name, :title, :department, :address,
        :city, :latitude, :longitude, :postal_code, :state
      )
    end
  end
end
