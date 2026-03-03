class AddIndexUsersToElections < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!
  def change
    add_index :elections, :user_id, algorithm: :concurrently
  end
end
