class WelcomeController < ApplicationController

  def index
    @user = User.new
    @info = BitShares::API::Misc.info()

    res = BitShares::API::Blockchain.get_asset(0)
    @asset_symbol = res['symbol']
    precision = res['precision'].to_i
    res = BitShares::API::Wallet.account_balance('angel')
    res = BitShares::API::Wallet.account_balance('angel')
    @balance = res[0][1][0][1]/precision
    #res = BitShares::API::Wallet.account_balance('valzav')
    #logger.debug "bal-----> #{.inspect}"
  end

end
