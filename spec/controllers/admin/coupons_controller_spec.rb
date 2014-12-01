require 'spec_helper'

describe Admin::CouponsController do

  def mock_coupon(stubs={})
    (@mock_coupon ||= mock_model(Coupon).as_null_object).tap do |coupon|
      stubs.each_key do |method_name|
        allow(coupon).to receive(method_name).and_return(stubs[method_name])
      end
    end
  end

  before { allow(controller).to receive(:require_admin) }

  describe "GET index" do
    it "assigns all coupons as @coupons" do
      allow(controller).to receive(:find_coupons).and_return([mock_coupon])
      get :index
      expect(assigns(:coupons)).to eq([mock_coupon])
    end
  end

  describe "GET show" do
    it "assigns the requested coupon as @coupon" do
      allow(Coupon).to receive(:find).with("37") { mock_coupon }
      get :show, :id => "37"
      expect(assigns(:coupon)).to be(mock_coupon)
    end
  end

  
  describe "GET new" do
    it "assigns a new coupon as @coupon" do
      allow(Coupon).to receive(:new) { mock_coupon }
      get :new
      expect(assigns(:coupon)).to be(mock_coupon)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created coupon as @coupon" do
        allow(Coupon).to receive(:new).with({'these' => 'params'}) { mock_coupon(:save => true) }
        post :create, :coupon => {'these' => 'params'}
        expect(assigns(:coupon)).to be(mock_coupon)
      end

      it "redirects to the created coupon" do
        allow(Coupon).to receive(:new) { mock_coupon(:save => true) }
        post :create, :coupon => {}
        expect(response).to redirect_to(admin_coupons_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved coupon as @coupon" do
        allow(Coupon).to receive(:new).with({'these' => 'params'}) { mock_coupon(:save => false) }
        post :create, :coupon => {'these' => 'params'}
        expect(assigns(:coupon)).to be(mock_coupon)
      end

      it "re-renders the 'new' template" do
        allow(Coupon).to receive(:new) { mock_coupon(:save => false) }
        post :create, :coupon => {}
        expect(response).to render_template("new")
      end
    end

  end
  
  
  describe "GET edit" do
    it "assigns the requested coupon as @coupon" do
      allow(Coupon).to receive(:find).with("37") { mock_coupon }
      get :edit, :id => "37"
      expect(assigns(:coupon)).to be(mock_coupon)
    end
  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested coupon" do
        expect(Coupon).to receive(:find).with("37") { mock_coupon }
        expect(mock_coupon).to receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :coupon => {'these' => 'params'}
      end

      it "assigns the requested coupon as @coupon" do
        allow(Coupon).to receive(:find) { mock_coupon(:update_attributes => true) }
        put :update, :id => "1"
        expect(assigns(:coupon)).to be(mock_coupon)
      end

      it "redirects to the coupon" do
        allow(Coupon).to receive(:find) { mock_coupon(:update_attributes => true) }
        put :update, :id => "1"
        expect(response).to redirect_to(admin_coupons_url)
      end
    end

    describe "with invalid params" do
      it "assigns the coupon as @coupon" do
        allow(Coupon).to receive(:find) { mock_coupon(:update_attributes => false) }
        put :update, :id => "1"
        expect(assigns(:coupon)).to be(mock_coupon)
      end

      it "re-renders the 'edit' template" do
        allow(Coupon).to receive(:find) { mock_coupon(:update_attributes => false) }
        put :update, :id => "1"
        expect(response).to render_template("edit")
      end
    end

  end
  
  describe "DELETE destroy" do
    it "destroys the requested coupon" do
      expect(Coupon).to receive(:find).with("37") { mock_coupon }
      expect(mock_coupon).to receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the coupons list" do
      allow(Coupon).to receive(:find) { mock_coupon }
      delete :destroy, :id => "1"
      expect(response).to redirect_to(admin_coupons_url)
    end
  end

end

