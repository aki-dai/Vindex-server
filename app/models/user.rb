# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :movies
  has_and_belongs_to_many :tags

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         :omniauthable
  include DeviseTokenAuth::Concerns::User

  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid:auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.nickname = auth.info.nickname
      user.image = auth.info.image
    end
  end
end
