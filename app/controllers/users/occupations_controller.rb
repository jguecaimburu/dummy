module Users
  class OccupationsController < ApplicationController
    before_action :set_user
    before_action :set_occupation

    def show
    end

    private

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_occupation
      @occupation = @user.occupation
    end
  end
end