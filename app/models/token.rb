# frozen_string_literal: true

class Token < ApplicationRecord
  before_create :set_defaults

  private

  def set_defaults
    self.value ||= SecureRandom.hex(32)
    self.expired_at ||= 24.hours.from_now
  end
end
