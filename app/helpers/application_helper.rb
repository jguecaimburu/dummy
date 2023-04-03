# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def model_human_name
    model_class.model_name.human
  end

  def model_human_attribute_name(attribute)
    model_class.human_attribute_name(attribute)
  end
end
