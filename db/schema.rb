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

ActiveRecord::Schema.define(version: 20160406060352) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actions", force: :cascade do |t|
    t.integer  "operation_id"
    t.integer  "worker_id"
    t.integer  "cnt"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.float    "cost",               default: 0.0
    t.float    "amount",             default: 0.0
    t.integer  "linkedoperation_id"
    t.integer  "linkedworker_id"
  end

  add_index "actions", ["operation_id"], name: "index_actions_on_operation_id", using: :btree
  add_index "actions", ["worker_id"], name: "index_actions_on_worker_id", using: :btree

  create_table "operation_costs", force: :cascade do |t|
    t.date    "sdate"
    t.date    "edate"
    t.float   "cost"
    t.integer "operation_id"
  end

  add_index "operation_costs", ["operation_id"], name: "index_operation_costs_on_operation_id", using: :btree

  create_table "operations", force: :cascade do |t|
    t.integer  "workshop_id"
    t.string   "name"
    t.integer  "special"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "isactive",    default: true
  end

  add_index "operations", ["workshop_id"], name: "index_operations_on_workshop_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "workers", force: :cascade do |t|
    t.string   "fname"
    t.string   "sname"
    t.string   "tname"
    t.date     "birthday"
    t.integer  "pin"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "isactive",   default: true
    t.string   "phone"
    t.string   "cardcode"
  end

  create_table "workshops", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "isactive",   default: true
  end

  add_foreign_key "actions", "operations"
  add_foreign_key "actions", "operations", column: "linkedoperation_id"
  add_foreign_key "actions", "workers"
  add_foreign_key "actions", "workers", column: "linkedworker_id"
  add_foreign_key "operation_costs", "operations"
  add_foreign_key "operations", "workshops"
end
