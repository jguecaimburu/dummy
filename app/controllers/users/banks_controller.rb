# frozen_string_literal: true

module Users
  class BanksController < ApplicationController
    include ActionView::RecordIdentifier

    before_action :set_user
    before_action :set_bank, only: %i[show edit update]

    def show; end

    def new
      if @user.bank
        redirect_to user_bank_path(@user, @user.bank)
        return
      end

      @bank = Bank.new(user: @user)
    end

    def edit; end

    # rubocop:disable Metrics/AbcSize
    def create
      @bank = Bank.new(bank_params.merge(user: @user))

      respond_to do |format|
        if @bank.save
          format.html { redirect_to user_billing_detail_path(@user), notice: "Bank was successfully created." }
          format.turbo_stream
          format.json { render :show, status: :created, location: user_bank_path(@user, @bank) }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.turbo_stream { render :new, status: :unprocessable_entity }
          format.json { render json: @bank.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @bank.update(bank_params)
          format.html { redirect_to user_billing_detail_path(@user), notice: "Bank was successfully updated." }
          format.turbo_stream do
            redirect_to user_bank_path(@user, @bank), notice: "Bank was successfully updated."
          end
          format.json { render :show, status: :ok, location: user_bank_path(@user, @bank) }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.turbo_stream { render :edit, status: :unprocessable_entity }
          format.json { render json: @bank.errors, status: :unprocessable_entity }
        end
      end
    end
    # rubocop:enable Metrics/AbcSize

    private

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_bank
      @bank = @user.bank
    end

    def bank_params
      params.require(:bank).permit(
        :iban, :currency, :card_type, :card_number, :card_expire
      )
    end
  end
end
