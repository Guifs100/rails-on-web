require "rails_helper"

RSpec.describe User, type: :model do
  describe '.valid' do
    context 'when the username is empty' do
      it 'user is invalid to be created' do
        expected_errors = {:username=>["can't be blank"]}
        user = User.new(email: 'teste@teste.com', password_digest: '1234')

        invalid = user.valid?

        expect(user.valid?).to be false
        expect(user.errors.messages).to eq(expected_errors)
      end
    end

    context 'when the email is empty' do
      it 'user is invalid to be created' do
        expected_errors = {:email=>["can't be blank"]}
        user = User.new(username: 'teste', password_digest: '1234')

        invalid = user.valid?

        expect(user.valid?).to be false
        expect(user.errors.messages).to eq(expected_errors)
      end
    end

    context 'when the password is empty' do
      context "and the user doesn't have provider" do
        it 'user is invalid to be created' do
          expected_errors = {:password_digest =>["can't be blank", 'is too short (minimum is 3 characters)']}
          user = User.new(username: 'teste', email: 'teste@teste.com')

          expect(user.valid?).to be false
          expect(user.errors.messages).to eq(expected_errors)
        end
      end

      context "and the user have provider" do
        it 'user is valid to be created' do
          expected_errors = {:password_digest =>["can't be blank", 'is too short (minimum is 3 characters)']}
          user = User.new(username: 'teste', email: 'teste@teste.com', provider: 'google')

          expect(user.valid?).to be true
          expect(user.errors.messages).to be_empty
        end
      end
    end
  end
end
