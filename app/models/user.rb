class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:cryptr]

  def self.from_omniauth(provider_data)
    where(
      tenant: provider_data.extra.raw_info.tnt,
      provider: provider_data.provider,
      uid: provider_data.uid
    ).first_or_create  do |user|
      user.email = provider_data.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
end
