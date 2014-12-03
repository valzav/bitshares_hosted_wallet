class Asset < ActiveRecord::Base
  has_many :coupons

  def self.sync_with_blockchain
    data = BitShares::API::Blockchain.list_assets()
    puts data.inspect
    data.each do |a|
      next if Asset.where(id: a['id']).first
      Asset.create(assetid: a['id'], symbol: a['symbol'], name: a['name'], description: a['description'], precision: a['precision'])
    end
  end

end
