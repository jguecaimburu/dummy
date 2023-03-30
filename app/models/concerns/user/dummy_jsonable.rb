class User
  module DummyJsonable
    extend ActiveSupport::Concern

    class_methods do
      def create_from_dummy_json_data!(dummy_data)
        data = process_dummy_json_data(dummy_data)
        
        user = User.find_by(external_source: "dummy_json", external_reference: data[:user][:external_reference])
        return if user

        transaction do
          user = self.create!(data[:user])
          user.create_bank!(data[:bank])
          user.create_address!(data[:user_address])
          company = Company.find_by(name: data[:company][:name])
          unless company
            company = Company.create!(data[:company])
            company.create_address!(data[:company_address])
          end
          user.create_company_member!(company: company)
        end
        
        user
      end

      def process_dummy_json_data(dummy_data)
        data = {
          user: {},
          user_address: {},
          company: {},
          company_member: {},
          company_address: {},
          bank: {}
        }
        dummy_data.deep_transform_keys { |k| k.underscore.to_sym }.each_with_object(data) do |(key, value), processed_data|
          process_dummy_attribute(key, value, processed_data)
        end
      end

      def process_dummy_attribute(key, value, processed_data)
        case key
        when :id
          processed_data[:user][:external_reference] = value
          processed_data[:user][:external_source] = "dummy_json"
        when :hair
          processed_data[:user][:hair_color] = value[:color]
          processed_data[:user][:hair_type] = value[:type]
        when :address
          coordinates = value[:coordinates]
          address_data = value.except(:coordinates)
          address_data[:latitude] = coordinates[:lat]
          address_data[:longitude] = coordinates[:lng]
          processed_data[:user_address] = address_data
        when :company
          coordinates = value[:address][:coordinates]
          address_data = value[:address].except(:coordinates)
          address_data[:latitude] = coordinates[:lat]
          address_data[:longitude] = coordinates[:lng]
          processed_data[:company_address] = address_data
          processed_data[:company][:name] = value[:name]
          processed_data[:company_member][:department] = value[:department]
          processed_data[:company_member][:title] = value[:title]
        when :bank
          processed_data[:bank] = value
        else
          processed_data[:user][key] = value
        end
      end
    end
  end
end