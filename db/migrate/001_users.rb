class Users < ActiveRecord::Migration

  def self.up
    create_table :users do |t|
      t.string :email
      t.string :referer
    end
    add_index :users, :email
  end

  def self.down
    drop_table :users
  end
end
