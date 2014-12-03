class Admin::CouponsController < Admin::BaseController

  helper_method :sort_column, :sort_direction

  before_filter :find_coupon, :only => [:edit, :update, :show, :destroy]

  def index
    @q = Coupon.search(params[:q])
    @coupons = find_coupons
  end


  def new
    @coupon = Coupon.new
  end

  def create
    @coupon = Coupon.new(coupon_params)
    if @coupon.save
      redirect_to admin_coupon_path(@coupon), :notice => "Successfully created coupon."
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @coupon.update_attributes(coupon_params)
      redirect_to admin_coupons_path, :notice => "Successfully updated coupon."
    else
      render :edit
    end
  end

  def destroy
    @coupon.destroy
    redirect_to admin_coupons_path, :notice => "Coupon deleted."
  end

  protected

  def find_coupon
    @coupon = Coupon.find(params[:id])
  end

  def find_coupons
    search_relation = @q.result
    @coupons = search_relation.order(sort_column + " " + sort_direction).references(:coupon).page params[:page]
  end

  def sort_column
    Coupon.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def coupon_params
    params.require(:coupon).permit(:code, :expires_at, :redeemed_at, :account_name, :amount, :ref_coupon_id, :asset, :asset_id)
  end

end
