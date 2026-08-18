# frozen_string_literal: true

ActiveAdmin.register_page 'Community Map' do
  menu priority: 1, label: 'Map'

  page_action :members, method: :get do
    response.headers['Cache-Control'] = 'private, no-store'
    render json: AdminMapData.call
  end

  content title: 'Community Map' do
    render partial: 'admin/community_map',
           locals: { members_url: admin_community_map_members_path }
  end
end
