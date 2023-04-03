# frozen_string_literal: true

module Users
  class BulkTrashesController < ApplicationController
    def create
      @selected_ids = bulk_trash_params[:selected_ids]
      respond_to do |format|
        if User.bulk_trash(@selected_ids)
          format.html { redirect_to users_path, notice: "Users were successfully trashed." }
          format.turbo_stream
          format.json { head :no_content }
        else
          format.html { redirect_to users_path, alert: "Users could not be trashed." }
          format.turbo_stream { redirect_to users_path, alert: "Users could not be trashed." }
          format.json { head :unprocessable_entity }
        end
      end
    end

    private

    def bulk_trash_params
      params.permit(selected_ids: [])
    end
  end
end
