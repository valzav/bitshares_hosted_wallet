module Api
  class CouponsController < Api::BaseController

    def show
      @coupon = Coupon.where(code: params[:id]).first
      @coupon = Coupon.new unless @coupon
      @coupon.set_redeem_code
    end

    def redeem
      @coupon = Coupon.where(code: params[:coupon_id]).first
      @coupon = Coupon.new unless @coupon
      @coupon.redeem(params[:account_name], params[:account_key])
    end

    private

      def coupon_params
        params.require(:coupon).permit(:code)
      end

      def query_params
        params.permit(:code)
      end

  end
end
