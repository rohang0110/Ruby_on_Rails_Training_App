module Api
  module V1
    class DeleteUser < ActiveInteraction::Base
      integer :id

      def execute
        user = User.find_by(id: id)

        errors.add(:base, 'User not found') and return if user.nil?

        if user.destroy
          { message: 'User deleted successfully.' }
        else
          errors.merge!(user.errors)
        end
      end
    end
  end
end
