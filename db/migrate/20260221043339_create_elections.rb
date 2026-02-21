class CreateElections < ActiveRecord::Migration[8.1]
  def change
    create_table :elections do |t|
      t.string :name
      t.datetime :expiration_at

      t.timestamps
    end
  end
end
