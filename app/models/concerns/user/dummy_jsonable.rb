# frozen_string_literal: true

class User
  module DummyJsonable
    extend ActiveSupport::Concern

    included do
      has_one :dummy_json_user_response, dependent: :destroy
    end

    # rubocop:disable Metrics/BlockLength, Metrics/AbcSize, Metrics/MethodLength
    class_methods do
      def create_from_dummy_json_response!(dummy_json_user_response)
        external_reference = dummy_json_user_response.external_reference
        other_users = joins(:dummy_json_user_response)
                      .merge(DummyJsonUserResponse.where(external_reference:))
        return if other_users.exists?

        data = process_dummy_json_data(dummy_json_user_response.data)
        user = nil
        transaction do
          user = create!(data)
          dummy_json_user_response.update!(user:)
        end

        user
      end

      def process_dummy_json_data(dummy_data)
        data = {
          bank_attributes: {},
          address_attributes: {},
          occupation_attributes: {}
        }
        underscored_data = dummy_data.except("id").deep_transform_keys { |key| key.underscore.to_sym }
        underscored_data.each_with_object(data) do |(key, value), processed_data|
          process_dummy_attribute(key, value, processed_data)
        end
      end

      def process_dummy_attribute(key, value, processed_data)
        case key
        when :hair
          processed_data[:hair_color] = value[:color]
          processed_data[:hair_type] = value[:type]
        when :blood_group
          # NOTE: DummyJson blood type field uses the minus character (codepoint 8722) which could be confusing
          processed_data[:blood_group] = value.gsub("−", "-")
        when :address
          coordinates = value[:coordinates]
          address_data = value.except(:coordinates)
          address_data[:latitude] = coordinates[:lat]
          address_data[:longitude] = coordinates[:lng]
          processed_data[:address_attributes] = address_data
        when :company
          coordinates = value[:address][:coordinates]
          occupation_data = value[:address].except(:coordinates)
          occupation_data[:latitude] = coordinates[:lat]
          occupation_data[:longitude] = coordinates[:lng]
          occupation_data[:company_name] = value[:name]
          occupation_data[:department] = value[:department]
          occupation_data[:title] = value[:title]
          processed_data[:occupation_attributes] = occupation_data
        when :bank
          processed_data[:bank_attributes] = value
        else
          processed_data[key] = value
        end
      end
    end
    # rubocop:enable Metrics/BlockLength, Metrics/AbcSize, Metrics/MethodLength
  end
end
