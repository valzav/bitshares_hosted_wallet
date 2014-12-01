class CreateCoupons < ActiveRecord::Migration
  def change
    create_table(:coupons) do |t|
      t.string :code
      t.string :account_name
      t.integer :ref_coupon_id
      t.integer :asset_amount, :limit => 8
      t.string :asset_symbol
      t.integer :asset_precision
      t.integer :asset_blockchainid
      t.datetime :expires_at
      t.datetime :redeemed_at
      t.timestamps
    end

    add_index :coupons, :code, unique: true
    add_index :coupons, :ref_coupon_id, unique: false
  end
end
