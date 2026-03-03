class AddForeignKeyForUsersElections < ActiveRecord::Migration[8.1]
  def change
    add_foreign_key :elections, :users, validate: false
  end
end
