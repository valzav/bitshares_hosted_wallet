class CreateCouponsAndAssets < ActiveRecord::Migration
  def change
    create_table(:assets) do |t|
      t.integer :assetid
      t.string :symbol
      t.string :name
      t.string :description
      t.integer :precision
      t.timestamps
    end

    create_table(:coupons) do |t|
      t.string :code
      t.string :account_name
      t.integer :ref_coupon_id
      t.integer :asset_id
      t.integer :amount, :limit => 8
      t.datetime :expires_at
      t.datetime :redeemed_at
      t.timestamps
    end

    add_index :coupons, :code, unique: true
    add_index :coupons, :ref_coupon_id, unique: false
    add_index :coupons, :asset_id, unique: false
  end
end
