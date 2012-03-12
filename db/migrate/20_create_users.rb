class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :username
      t.string :cached_slug
      t.boolean :verified
      t.string :unconfirmed_email
      t.database_authenticatable  :null => false
      t.recoverable
      t.rememberable
      t.trackable
      t.encryptable
      t.confirmable
      t.token_authenticatable
      t.timestamps
    end

    create_table :util_emails do |t|
      t.integer :user_id
      t.string :email
      t.string :confirmation_token
      t.datetime :confirmation_date
      t.datetime :confirmation_sent_at
      t.string :status
      t.timestamps
    end

    create_table :util_contacts do |t|
      t.integer :user_id
      t.integer :project_id
      t.string :service
      t.string :identifier
      t.boolean :verified

      t.timestamps
    end

  end
end
