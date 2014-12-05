class WelcomeController < ApplicationController

  def home
    @user = User.new
    @info = BitShares::API::Misc.info()

    res = BitShares::API::Blockchain.get_asset(0)
    @asset_symbol = res['symbol']
    precision = res['precision'].to_i
    res = BitShares::API::Wallet.account_balance('angel')
    @balance = res[0][1][0][1]/precision
    #res = BitShares::API::Wallet.account_balance('valzav')
    #logger.debug "bal-----> #{.inspect}"
  end

  def index
    if params[:account_name]
      if current_user
        register_account(params[:account_name], params[:account_key])
      else
        session[:pending_registration] = {account_name: params[:account_name], account_key: params[:account_key]}
      end
    elsif session[:pending_registration]
      reg = session[:pending_registration]
      register_account(reg['account_name'], reg['account_key'])
      session.delete(:pending_registration)
    end
  end

  private

  def register_account(account_name, account_key)
    logger.debug "---------> registering account #{account_name}, key: #{account_key}"
    begin
      BitShares::API::Wallet.add_contact_account(account_name, account_key)
      BitShares::API::Wallet.account_register(account_name, 'angel')
      flash[:notice] = "Account #{account_name} was successfully registered."
    rescue BitShares::API::Rpc::Error => ex
      error = eval(ex.to_s)["message"]
      logger.error("!!! Error. Cannot register account #{account_name} - #{error}")
      flash.now[:alert] = "Cannot register account #{account_name} - #{error}"
    end
  end

end
