
class User < ApplicationRecord
  validates :email, presence: true
  validates :username, presence: true
  validates :password_digest, presence: true, length: { minimum: 3, maximum: 20 }, unless: :login_with_provider?

  def login_with_provider?
    provider.present?
  end
end
