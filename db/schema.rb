# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141204150501) do

  create_table "assets", force: true do |t|
    t.integer  "assetid"
    t.string   "symbol"
    t.string   "name"
    t.string   "description"
    t.integer  "precision"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupons", force: true do |t|
    t.string   "code"
    t.string   "account_name"
    t.integer  "ref_coupon_id"
    t.integer  "asset_id"
    t.integer  "amount",        limit: 8
    t.datetime "expires_at"
    t.datetime "redeemed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coupons", ["asset_id"], name: "index_coupons_on_asset_id", using: :btree
  add_index "coupons", ["code"], name: "index_coupons_on_code", unique: true, using: :btree
  add_index "coupons", ["ref_coupon_id"], name: "index_coupons_on_ref_coupon_id", using: :btree

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name",                   default: "", null: false
    t.string   "email",                  default: ""
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
