class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable

  before_create :create_bitshares_account


  validates :name, presence: true, length: { minimum: 2, maximum: 63}, format: { with: /\A[a-z0-9\.\-]+\z/, message: "only lowercase letters, numbers and . - characters allowed" }
  validates :password, presence: true, length: { minimum: 6 }
  validates_confirmation_of :password

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
