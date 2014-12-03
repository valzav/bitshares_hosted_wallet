class Coupon < ActiveRecord::Base
  belongs_to :asset

  before_create :generate_code
  validates :code, presence: true
  validates :amount, presence: true
  validates :asset_id, presence: true

  before_validation(on: :create) do
    generate_code()
    logger.debug "after_validation: #{self.inspect}"
    a = Asset.find(self.asset_id)
    self.amount *= a.precision
  end

  def asset_amount
    self.amount / asset.precision
  end

  def redeem(account_name, public_key)
    if status() == 'ok'
      BitShares::API::Wallet.add_contact_account(account_name, public_key)
      BitShares::API::Wallet.account_register(account_name, 'angel')
      BitShares::API::Wallet.transfer(self.amount / asset.precision, asset.symbol, 'angel', account_name, "#{self.code}")
      update_attribute(:redeemed_at, Time.now.to_s(:db))
    end
  end

  def generate_code
    self.code = 'F01-' + SecureRandom.urlsafe_base64(9).upcase
  end

  def status
    return @status if @status
    @status = if !self.code
                'notfound'
              elsif self.redeemed_at
                'redeemed'
              elsif self.expires_at and self.expires_at < DateTime.now
                'expired'
              else
                'ok'
              end
    return @status
  end

end
