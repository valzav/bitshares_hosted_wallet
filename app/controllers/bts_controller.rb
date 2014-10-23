class BtsController < ApplicationController
  before_action :authenticate_user!

  @@sanitizer = BitShares::CallsSanitizer.new

  def index
    gon.current_account = current_user
    render :layout => false
  end

  def rpc
    method = params['method']
    prms = params['params']
    allowed = @@sanitizer.sanitize(current_user.name, method, prms)
    if allowed
      #logger.debug "====== rpc call: user: #{current_user.name}, #{prms.inspect}"
      res = BitShares::API.rpc.request_raw(method, prms)
      #logger.debug "====== res: #{res.inspect}"
      render text: res
    else
      logger.debug "====== rpc call forbidden: #{method}"
      render text: '', status: 403
    end

  end

end
