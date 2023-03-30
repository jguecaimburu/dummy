# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength, Metrics/AbcSize, Metrics/MethodLength
class CreateInitialModels < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name, index: true
      t.string :last_name, index: true
      t.string :maiden_name, index: true
      t.string :email, index: true
      t.integer :age
      t.string :gender
      t.string :phone
      t.string :username
      t.string :password
      t.date :birth_date
      t.string :image
      t.string :blood_group
      t.integer :height
      t.float :weight
      t.string :eye_color
      t.string :hair_color
      t.string :hair_type
      t.string :university
      t.string :domain
      t.string :mac_address
      t.string :ip
      t.string :ein
      t.string :ssn
      t.string :user_agent
      t.boolean :soft_deleted, default: false, index: true
      t.timestamps
    end

    create_table :companies do |t|
      t.string :name, index: { unique: true }
      t.timestamps
    end

    create_table :company_members do |t|
      t.references :user, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true
      t.string :title
      t.string :department
      t.timestamps
    end

    create_table :addresses do |t|
      t.string :address
      t.string :city
      t.float :latitude
      t.float :longitude
      t.string :postal_code
      t.string :state
      t.references :addressable, polymorphic: true, null: false
      t.timestamps
    end

    create_table :banks do |t|
      t.string :card_number
      t.string :card_expire
      t.string :card_type
      t.string :currency
      t.string :iban
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end

    create_table :dummy_json_user_responses do |t|
      t.references :user, null: true, foreign_key: true, index: { unique: true }
      t.jsonb :data
      t.string :status, default: "pending", index: true
      t.string :external_reference, index: { unique: true }
      t.timestamps
    end
  end
  # rubocop:enable Metrics/BlockLength, Metrics/AbcSize, Metrics/MethodLength
end
