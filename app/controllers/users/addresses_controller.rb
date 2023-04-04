# frozen_string_literal: true

module Users
  class AddressesController < ApplicationController
    before_action :set_user
    before_action :set_address, only: %i[show edit update]

    def show; end

    def new
      if @user.address
        redirect_to user_address_path(@user, @user.address)
        return
      end

      @address = Address.new(user: @user)
    end

    def edit; end

    def create
      @address = Address.new(address_params.merge(user: @user))

      respond_to do |format|
        if @address.save
          format.html { redirect_to user_billing_detail_path(@user), notice: "Address was successfully created." }
          format.json { render :show, status: :created, location: user_address_path(@user, @address) }
          format.turbo_stream
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @address.errors, status: :unprocessable_entity }
          format.turbo_stream do
            render turbo_stream:
                     turbo_stream.replace(dom_id(@address), partial: "users/addresses/form",
                                                            locals: { address: @address }),
                   status: :unprocessable_entity
          end
        end
      end
    end

    def update
      respond_to do |format|
        if @address.update(address_params)
          format.html { redirect_to user_billing_detail_path(@user), notice: "Address was successfully updated." }
          format.turbo_stream do
            redirect_to user_address_path(@user, @address), notice: "Address was successfully updated."
          end
          format.json { render :show, status: :ok, location: user_address_path(@user, @address) }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @address.errors, status: :unprocessable_entity }
          format.turbo_stream do
            render turbo_stream:
                     turbo_stream.replace(dom_id(@address), partial: "users/addresses/form",
                                                            locals: { address: @address }),
                   status: :unprocessable_entity
          end
        end
      end
    end

    private

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_address
      @address = @user.address
    end

    def address_params
      params.require(:address).permit(
        :address, :city, :latitude, :longitude, :postal_code, :state
      )
    end
  end
end
