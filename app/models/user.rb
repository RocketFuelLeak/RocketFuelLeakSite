class User < ActiveRecord::Base
  rolify
    # Include default devise modules. Others available are:
    # :lockable and :timeoutable
    devise :database_authenticatable, :registerable, :omniauthable,
           :recoverable, :rememberable, :trackable, :validatable,
           :confirmable

    has_many :posts

    validates :username, presence: true, uniqueness: { case_sensitive: false },
              format: { with: /\A[A-Z][a-z]+\z/ }

    validates_acceptance_of :terms_read, accept: true

    def self.from_omniauth(auth)
        where(auth.slice(:provider, :uid)).first_or_create do |user|
            user.provider = auth.provider
            user.uid = auth.uid
            user.email = auth.info.email
            user.username = auth.info.nickname
        end
    end

    def self.new_with_session(params, session)
        if session["devise.user_attributes"]
            new(session["devise.user_attributes"], without_protection: true) do |user|
                user.attributes = params
                user.valid?
            end
        else
            super
        end
    end

    def password_required?
        super && provider.blank?
    end

    def update_with_password(params, *options)
        if encrypted_password.blank?
            update_attributes(params, *options)
        else
            super
        end
    end

    def to_s
        "#{username}"
    end
end
