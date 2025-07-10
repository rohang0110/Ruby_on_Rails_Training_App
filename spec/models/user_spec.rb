require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is invalid without a first name' do
    subject.first_name = nil
    expect(subject).not_to be_valid
  end

  it 'is invalid without a last name' do
    subject.last_name = nil
    expect(subject).not_to be_valid
  end

  it 'is invalid without an email' do
    subject.email = nil
    expect(subject).not_to be_valid
  end

  it 'is invalid with a duplicate email' do
    create(:user, email: subject.email)
    expect(subject).not_to be_valid
  end

  it 'is invalid with a short password' do
    subject.password = subject.password_confirmation = '123'
    expect(subject).not_to be_valid
  end

  it "is invalid if age doesn't match date of birth" do
    subject.age = 20
    subject.date_of_birth = 10.years.ago
    expect(subject).not_to be_valid
  end

  it 'is valid if age matches date of birth' do
    subject.age = 30
    subject.date_of_birth = 30.years.ago.to_date
    expect(subject).to be_valid
  end
end
