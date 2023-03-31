module Users
  class BillingDetailsController < ApplicationController
    before_action :set_user

    def show
      # Remove
      # In view should consider if user has any bank or company member to decide if button to add or partial is rendered
      @bank = @user.bank
      @address = @user.address
    end

    private

    def set_user
      @user = User.find(params[:user_id])
    end
  end
end