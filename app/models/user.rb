class User < ActiveRecord::Base

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable
  devise :omniauthable, :omniauth_providers => [:facebook, :twitter, :linkedin, :google_oauth2, :github]

  #before_create :create_bitshares_account

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update
  validates :name, presence: true #, length: { minimum: 2, maximum: 63}, format: { with: /\A[a-z0-9\.\-]+\z/, message: "only lowercase letters, numbers and . - characters allowed" }
  validates :password, presence: true, length: { minimum: 6 }
  #validates_confirmation_of :password

  def self.find_for_oauth(auth, signed_in_resource)

    logger.debug "\n-----> auth:"
    logger.debug auth.to_yaml
    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user

    if user.nil?
      email_is_verified = auth.info.email #&& (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          name: auth.info.name || auth.extra.raw_info.name,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        #user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end

    logger.debug "\n----> identity: #{identity.inspect}"
    logger.debug "----> user: #{user.inspect}\n"
    user
  end

  # def self.new_with_session(params, session)
  #   super.tap do |user|
  #     if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
  #       user.email = data["email"] if user.email.blank?
  #     end
  #   end
  # end

  private

  def create_bitshares_account
    puts "=== create_bitshares_account === name: #{self.name}"
    #puts BitShares::API::Misc.get_info()
    res = BitShares::API::Wallet.account_create(self.name)
    BitShares::API::Wallet.account_register(self.name, 'angel')
    BitShares::API::Wallet.transfer(200, 'XTS', 'angel', self.name, 'test drive funds')
    puts res
  end

end
