require 'rails_helper'

RSpec.describe Feedback, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:rating) }
    it { should validate_presence_of(:comment) }
    it { should validate_presence_of(:current_url) }
    it { should validate_presence_of(:restaurant_id) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
  end
end
