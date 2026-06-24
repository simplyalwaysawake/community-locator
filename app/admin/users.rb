# frozen_string_literal: true

ActiveAdmin.register User do
  menu priority: 2

  # Searchable / filterable list.
  filter :email
  filter :name
  filter :telegram
  filter :admin
  filter :confirmed_at
  filter :created_at

  includes :location

  index do
    selectable_column
    id_column
    column :email
    column :name
    column :telegram
    column('Country') { |user| user.location&.country }
    column('State') { |user| user.location&.state }
    column('City') { |user| user.location&.city }
    column :admin
    column :confirmed_at
    column :current_sign_in_at
    column :created_at
    actions
  end

  # Permit nested location and options so both are editable from the user form.
  permit_params :name, :email, :telegram, :admin,
                location_attributes: %i[id city state country postal_code],
                user_options_attributes: %i[id community_range notify_on_new_users]

  show do
    attributes_table do
      row :id
      row :email
      row :name
      row :telegram
      row :admin
      row :confirmed_at
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :created_at
      row :updated_at
    end

    panel 'Location' do
      if user.location
        attributes_table_for user.location do
          row :city
          row :state
          row :country
          row :postal_code
          row :latitude
          row :longitude
        end
      else
        para 'No location set.'
      end
    end

    panel 'Options' do
      if user.user_options
        attributes_table_for user.user_options do
          row :community_range
          row :notify_on_new_users
        end
      else
        para 'No options set.'
      end
    end
  end

  form do |f|
    f.inputs 'User' do
      f.input :name
      f.input :email
      f.input :telegram
      f.input :admin
    end

    f.inputs 'Location', for: [:location, f.object.location || Location.new] do |loc|
      loc.input :city, as: :string
      loc.input :state, as: :string
      loc.input :country, as: :string
      loc.input :postal_code, as: :string
    end

    f.inputs 'Options', for: [:user_options, f.object.user_options || UserOptions.new] do |opt|
      opt.input :community_range
      opt.input :notify_on_new_users
    end

    f.actions
  end
end
