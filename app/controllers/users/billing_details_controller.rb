# frozen_string_literal: true

module Users
  class BillingDetailsController < ApplicationController
    before_action :set_user
    before_action :set_bank
    before_action :set_address

    def show; end

    private

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_bank
      @bank = @user.bank
    end

    def set_address
      @address = @user.address
    end
  end
end
