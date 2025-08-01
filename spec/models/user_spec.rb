# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
    expect(subject.errors.messages).to be_empty
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

  it 'is invalid with a duplicate email regardless of case' do
    create(:user, email: subject.email.upcase)
    expect(subject).not_to be_valid
  end

  it 'is invalid with a short password' do
    subject.password = subject.password_confirmation = '123'
    expect(subject).not_to be_valid
  end

  it 'is invalid without a password' do
    subject.password = nil
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

  it 'is valid for a leap year birthday' do
    leap_year = Date.leap?(Date.today.year) ? Date.today.year - 10 : Date.today.year - 12
    subject.age = 10
    subject.date_of_birth = Date.new(leap_year, 2, 29)
    expect(subject).to be_valid
  end

  it 'is invalid with date of birth in the future' do
    subject.date_of_birth = 1.year.from_now
    expect(subject).not_to be_valid
  end

  it 'is invalid with a phone number shorter than 10 digits' do
    subject.phone_number = '12345'
    expect(subject).not_to be_valid
  end

  it 'is invalid with an improperly formatted phone number' do
    subject.phone_number = 'ABCDE12345'
    expect(subject).not_to be_valid
  end
end