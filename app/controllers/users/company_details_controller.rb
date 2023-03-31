module Users
  class CompanyDetailsController < ApplicationController
    before_action :set_user

    def show
      @company_member = @user.company_member
      @company = @company_member&.company
    end

    private

    def set_user
      @user = User.find(params[:user_id])
    end
  end
end