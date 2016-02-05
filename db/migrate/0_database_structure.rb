# encoding: UTF-8
class DatabaseStructure < ActiveRecord::Migration
  def change
    unless table_exists? :constants
      create_table 'constants', force: :cascade do |t|
        t.string 'name', limit: 255
        t.string 'value', limit: 255
        t.datetime 'created_at'
        t.datetime 'updated_at'
      end
    end
    unless table_exists? :contacts
      create_table 'contacts', force: :cascade do |t|
        t.string 'name', limit: 255
        t.string 'email', limit: 255
        t.boolean 'public', limit: 1
        t.text 'text', limit: 65535
        t.integer 'council_id', limit: 4
        t.datetime 'created_at'
        t.datetime 'updated_at'
      end
    end
    unless table_exists? :documents
      create_table 'documents', force: :cascade do |t|
        t.string 'pdf_file_name', limit: 255
        t.string 'pdf_content_type', limit: 255
        t.integer 'pdf_file_size', limit: 4
        t.datetime 'pdf_updated_at'
        t.string 'title', limit: 255
        t.boolean 'public', limit: 1
        t.boolean 'download', limit: 1
        t.string 'category', limit: 255
        t.integer 'profile_id', limit: 4
        t.datetime 'created_at'
        t.datetime 'updated_at'
        t.integer :user_id
      end
    end
    unless table_exists? :faqs
      create_table 'faqs', force: :cascade do |t|
        t.string 'question', limit: 255
        t.text 'answer', limit: 65535
        t.integer 'sorting_index', limit: 4
        t.datetime 'created_at'
        t.datetime 'updated_at'
        t.string 'category', limit: 255
      end
      add_index 'faqs', ['category'], name: 'index_faqs_on_category', using: :btree
    end
    unless table_exists? :menus
      create_table 'menus', force: :cascade do |t|
        t.string 'location', limit: 255
        t.integer 'index', limit: 4
        t.string 'link', limit: 255
        t.string 'name', limit: 255
        t.boolean 'visible', limit: 1
        t.boolean 'turbolinks', limit: 1, default: true
        t.boolean 'blank_p', limit: 1
        t.datetime 'created_at'
        t.datetime 'updated_at'
      end
    end
    unless table_exists? :news
      create_table 'news', force: :cascade do |t|
        t.string 'title', limit: 255
        t.text 'content', limit: 65535
        t.boolean 'front_page', limit: 1
        t.string 'image_file_name', limit: 255
        t.string 'image_content_type', limit: 255
        t.integer 'image_file_size', limit: 4
        t.datetime 'image_updated_at'
        t.datetime 'created_at'
        t.datetime 'updated_at'
        t.integer 'profile_id', limit: 4
        t.integer :user_id
      end
    end
    unless table_exists? :notices
      create_table 'notices', force: :cascade do |t|
        t.string 'title', limit: 255
        t.text 'description', limit: 65535
        t.boolean 'public', limit: 1
        t.date 'd_publish'
        t.date 'd_remove'
        t.integer 'sort', limit: 4
        t.string 'image_file_name', limit: 255
        t.string 'image_content_type', limit: 255
        t.integer 'image_file_size', limit: 4
        t.datetime 'image_updated_at'
        t.datetime 'created_at'
        t.datetime 'updated_at'
      end
    end
    unless table_exists? :permissions
      create_table 'permissions', force: :cascade do |t|
        t.string 'name', limit: 255
        t.string 'subject_class', limit: 255
        t.string 'action', limit: 255
        t.datetime 'created_at', null: false
        t.datetime 'updated_at', null: false
      end
    end
    unless table_exists? :users
      create_table 'users', force: :cascade do |t|
        t.string 'email', limit: 255, default: '', null: false
        t.string 'firstname', limit: 255, default: '', null: false
        t.string 'lastname', limit: 255, default: '', null: false
        t.string 'encrypted_password', limit: 255, default: '', null: false
        t.string 'reset_password_token', limit: 255
        t.datetime 'reset_password_sent_at'
        t.datetime 'remember_created_at'
        t.integer 'sign_in_count', limit: 4, default: 0, null: false
        t.datetime 'current_sign_in_at'
        t.datetime 'last_sign_in_at'
        t.string 'current_sign_in_ip', limit: 255
        t.string 'last_sign_in_ip', limit: 255
        t.datetime 'created_at'
        t.datetime 'updated_at'
      end
      add_index 'users', ['email'], name: 'index_users_on_email', unique: true, using: :btree
      add_index 'users', ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true, using: :btree
    end
  end
end
