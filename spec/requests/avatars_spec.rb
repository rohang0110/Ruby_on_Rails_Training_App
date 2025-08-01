# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Avatars', type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET /avatar/edit' do
    it 'renders the edit template' do
      get edit_avatar_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Update Avatar')
    end
  end

  describe 'PATCH /avatar' do
    let(:file) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'avatar.jpg'), 'image/jpeg') }

    it 'attaches a new avatar' do
      patch avatar_path, params: { user: { avatar: file } }
      expect(response).to redirect_to(edit_avatar_path)
      follow_redirect!
      expect(user.reload.avatar).to be_attached
    end

    it 'returns error if file is missing' do
      patch avatar_path, params: { user: { avatar: nil } }
      expect(response).to render_template(:edit)
      expect(flash[:alert]).to be_present
    end
  end

  describe 'DELETE /avatar' do
    before do
      user.avatar.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'avatar.jpg')),
                         filename: 'avatar.jpg')
    end

    it 'deletes the attached avatar' do
      delete avatar_path
      expect(response).to redirect_to(edit_avatar_path)
      follow_redirect!
      expect(user.reload.avatar.attached?).to be_falsey
    end
  end
end
