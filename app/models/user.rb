class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :lockable and :timeoutable
    devise :database_authenticatable, :registerable, :omniauthable,
           :recoverable, :rememberable, :trackable, :validatable,
           :confirmable

    rolify

    has_one :character, dependent: :destroy
    has_one :application, dependent: :destroy

    has_many :posts, dependent: :destroy
    has_many :comments, dependent: :destroy

    validates :username, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[A-Za-z0-9]{3,16}\z/ } #,format: { with: /\A[A-Z][a-z]+\z/ }

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

    def recaptcha_required?
        provider.blank?
    end

    def update_with_password(params, *options)
        if encrypted_password.blank?
            update_attributes(params, *options)
        else
            super
        end
    end

    def gravatar_url(size = 48)
        id = Digest::MD5.hexdigest(email.downcase)
        "http://gravatar.com/avatar/#{id}?s=#{size}&d=mm"
    end

    def profile_image(size = 48)
        if character and character.confirmed
            character.avatar
        else
            gravatar_url(size)
        end
    end

    def confirmed_character?
        character.present? and character.confirmed
    end

    def to_s
        confirmed_character? ? character.name : username
    end

    def to_param
        if confirmed_character?
            "#{id}-#{character.name.parameterize}#{'-' + character.realm.parameterize unless character.realm == WoW.realm}"
        else
            "#{id}-#{username.parameterize}"
        end
    end
end
