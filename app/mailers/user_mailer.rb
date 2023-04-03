# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def incinerated
    @user = params[:user]
    mail(to: @user.email, subject: "Your data was successfully deleted from our Dummy database")
  end
end
