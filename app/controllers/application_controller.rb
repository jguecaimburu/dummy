# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  include ActionView::RecordIdentifier

  helper_method :model_class

  def model_class
    controller_name.classify.constantize
  end
end
