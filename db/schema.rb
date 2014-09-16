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

ActiveRecord::Schema.define(version: 20140325192253) do

  create_table "addons", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "curse"
    t.string   "wowinterface"
    t.boolean  "required"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.string   "curse_download"
    t.string   "wowinterface_download"
  end

  create_table "applications", force: true do |t|
    t.text     "content"
    t.string   "character_name"
    t.string   "character_realm"
    t.string   "character_guild_name"
    t.integer  "status"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "verified_character"
    t.string   "character_guild_realm"
  end

  add_index "applications", ["status"], name: "index_applications_on_status"
  add_index "applications", ["user_id"], name: "index_applications_on_user_id"

  create_table "characters", force: true do |t|
    t.string   "name"
    t.string   "guild_name"
    t.boolean  "confirmed"
    t.string   "confirmation_equipment"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar"
    t.integer  "class_id"
    t.string   "realm"
    t.string   "guild_realm"
  end

  add_index "characters", ["name"], name: "index_characters_on_name"
  add_index "characters", ["user_id"], name: "index_characters_on_user_id"

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "forum_categories", force: true do |t|
    t.string   "name"
    t.integer  "order"
    t.integer  "access"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forum_forums", force: true do |t|
    t.string   "name"
    t.integer  "order"
    t.integer  "read_access"
    t.integer  "write_access"
    t.integer  "forum_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  add_index "forum_forums", ["forum_category_id"], name: "index_forum_forums_on_forum_category_id"

  create_table "forum_posts", force: true do |t|
    t.text     "content"
    t.integer  "forum_topic_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "forum_posts", ["forum_topic_id"], name: "index_forum_posts_on_forum_topic_id"
  add_index "forum_posts", ["user_id"], name: "index_forum_posts_on_user_id"

  create_table "forum_topics", force: true do |t|
    t.string   "title"
    t.boolean  "locked"
    t.boolean  "pinned"
    t.integer  "forum_forum_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "forum_topics", ["forum_forum_id"], name: "index_forum_topics_on_forum_forum_id"
  add_index "forum_topics", ["user_id"], name: "index_forum_topics_on_user_id"

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.boolean  "published"
    t.datetime "published_at"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["user_id"], name: "index_posts_on_user_id"

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], name: "index_roles_on_name"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
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
    t.string   "provider"
    t.string   "uid"
    t.string   "username"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean  "terms_read"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"

end
