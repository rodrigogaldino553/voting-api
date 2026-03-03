class ValidateAddForeignKeyForUsersElections < ActiveRecord::Migration[8.1]
  def change
    validate_foreign_key :elections, :users
  end
end
