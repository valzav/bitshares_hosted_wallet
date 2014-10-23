class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable

  before_create :create_bitshares_account


  validates :name, presence: true, length: { minimum: 2, maximum: 63}, format: { with: /\A[a-z0-9\.\-]+\z/, message: "only lowercase letters, numbers and . - characters allowed" }
  validates :password, presence: true, length: { minimum: 3 }
  validates :password_confirmation, presence: true, length: { minimum: 3 }

  private

  def create_bitshares_account

    puts "=== create_bitshares_account === name: #{self.name}"
    #puts BitShares::API::Misc.get_info()
    res = BitShares::API::Wallet.account_create(self.name)
    puts res

  end

end
