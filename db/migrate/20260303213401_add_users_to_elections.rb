class AddUsersToElections < ActiveRecord::Migration[8.1]
  def change
    add_reference :elections, :user, index: false
  end
end
