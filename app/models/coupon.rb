class Coupon < ActiveRecord::Base

  before_create :generate_code
  validates :code, presence: true
  validates :asset_amount, presence: true

  before_validation(on: :create) do
    self.code = 'F01-' + SecureRandom.uuid.split('-')[0].upcase
  end

  after_validation(on: :create) do
    self.code = 'F01-' + SecureRandom.uuid.split('-')[0].upcase
    self.asset_precision = 100000
    self.asset_amount *= self.asset_precision
    self.asset_symbol = 'XTS'
    self.asset_blockchainid = 0
  end

  def set_redeem_code
    res = true
    if self.redeemed_at
      self.code = 'redeemed'
      res = false
    elsif self.expires_at
      self.code = 'expired'
      res = false
    end
    return res
  end

  def redeem(account_name, public_key)
    logger.debug "--- redeeming coupon code #{self.code}"
    if set_redeem_code

      #BitShares::API::Wallet.account_create(account_name)
      BitShares::API::Wallet.add_contact_account(account_name, public_key)
      BitShares::API::Wallet.account_register(account_name, 'angel')
      BitShares::API::Wallet.transfer(self.asset_amount / self.asset_precision, self.asset_symbol, 'angel', account_name, "#{self.code} coupon")

      update_attribute(:redeemed_at, Time.now.to_s(:db))
    end
  end

  def generate_code
    self.code = 'F01-' + SecureRandom.uuid.split('-')[0].upcase
  end

  def amount
    am = if self.asset_precision and self.asset_precision > 0
           self.asset_amount / self.asset_precision
         else
           self.asset_amount
         end
    "#{am} #{self.asset_symbol}"
  end

  def status
    return 'na' unless self.code
    if self.code == 'redeemed'
      'redeemed'
    elsif self.code == 'expired'
      'expired'
    else
      'ok'
    end
    #'expired'
  end

end
