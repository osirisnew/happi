# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_09_15_144015) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "beta_signups", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "signed_up_at"
    t.bigint "team_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id"], name: "index_beta_signups_on_team_id"
  end

  create_table "blazer_audits", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "query_id"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at"
    t.index ["query_id"], name: "index_blazer_audits_on_query_id"
    t.index ["user_id"], name: "index_blazer_audits_on_user_id"
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.bigint "creator_id"
    t.bigint "query_id"
    t.string "state"
    t.string "schedule"
    t.text "emails"
    t.text "slack_channels"
    t.string "check_type"
    t.text "message"
    t.datetime "last_run_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_blazer_checks_on_creator_id"
    t.index ["query_id"], name: "index_blazer_checks_on_query_id"
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.bigint "dashboard_id"
    t.bigint "query_id"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dashboard_id"], name: "index_blazer_dashboard_queries_on_dashboard_id"
    t.index ["query_id"], name: "index_blazer_dashboard_queries_on_query_id"
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_blazer_dashboards_on_creator_id"
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.text "description"
    t.text "statement"
    t.string "data_source"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_blazer_queries_on_creator_id"
  end

  create_table "canned_responses", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "label", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id"], name: "index_canned_responses_on_team_id"
  end

  create_table "custom_email_addresses", force: :cascade do |t|
    t.string "email", null: false
    t.bigint "team_id", null: false
    t.bigint "user_id"
    t.datetime "confirmed_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "from_name"
    t.index ["team_id"], name: "index_custom_email_addresses_on_team_id"
    t.index ["user_id"], name: "index_custom_email_addresses_on_user_id"
  end

  create_table "customers", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "email", null: false
    t.string "company"
    t.string "phone"
    t.string "country_code"
    t.string "location"
    t.datetime "last_contacted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "blocked", default: false, null: false
    t.index ["email", "team_id"], name: "index_customers_on_email_and_team_id", unique: true
    t.index ["email"], name: "index_customers_on_email"
    t.index ["team_id"], name: "index_customers_on_team_id"
  end

  create_table "message_threads", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "team_id", null: false
    t.string "subject", default: "", null: false
    t.string "status", default: "open", null: false
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "reply_to"
    t.index ["customer_id"], name: "index_message_threads_on_customer_id"
    t.index ["team_id"], name: "index_message_threads_on_team_id"
    t.index ["user_id"], name: "index_message_threads_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "message_thread_id", null: false
    t.string "sender_type", null: false
    t.bigint "sender_id", null: false
    t.boolean "internal", default: false, null: false
    t.text "body", default: "", null: false
    t.text "raw", default: "", null: false
    t.string "status", default: "pending", null: false
    t.jsonb "metadata", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "from_address"
    t.decimal "spam_score", precision: 8, scale: 2
    t.string "channel", default: "email", null: false
    t.index ["message_thread_id"], name: "index_messages_on_message_thread_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.string "plan", default: "basic", null: false
    t.string "mail_hash", default: "", null: false
    t.datetime "verified_at"
    t.string "invite_code"
    t.boolean "whitelabel", default: false, null: false
    t.string "time_zone", default: "Eastern Time (US & Canada)", null: false
    t.string "country_code", default: "US", null: false
    t.string "shared_secret"
    t.string "publishable_key"
    t.integer "available_seats", default: 3, null: false
    t.integer "messages_limit", default: 3000, null: false
    t.string "stripe_customer_id"
    t.string "stripe_subscription_id"
    t.string "subscription_status", default: "pending", null: false
    t.index ["invite_code"], name: "index_teams_on_invite_code", unique: true
    t.index ["mail_hash"], name: "index_teams_on_mail_hash", unique: true
    t.index ["publishable_key"], name: "index_teams_on_publishable_key", unique: true
    t.index ["shared_secret"], name: "index_teams_on_shared_secret", unique: true
  end

  create_table "teams_users", force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "user_id"
    t.index ["team_id", "user_id"], name: "index_teams_users_on_team_id_and_user_id", unique: true
    t.index ["team_id"], name: "index_teams_users_on_team_id"
    t.index ["user_id"], name: "index_teams_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.bigint "team_id"
    t.string "role", default: "user", null: false
    t.jsonb "metadata", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["team_id"], name: "index_users_on_team_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "canned_responses", "teams"
  add_foreign_key "custom_email_addresses", "teams"
  add_foreign_key "custom_email_addresses", "users"
  add_foreign_key "customers", "teams"
  add_foreign_key "message_threads", "customers"
  add_foreign_key "message_threads", "teams"
  add_foreign_key "message_threads", "users"
  add_foreign_key "messages", "message_threads"
  add_foreign_key "teams_users", "teams"
  add_foreign_key "teams_users", "users"
  add_foreign_key "users", "teams"
end
