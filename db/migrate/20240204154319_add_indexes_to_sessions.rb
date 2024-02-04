class AddIndexesToSessions < ActiveRecord::Migration[6.1]
  def change
    add_index :sessions, :coach_hash_id
    add_index :sessions, :client_hash_id
    add_index :sessions, :start
    add_index :sessions, [:coach_hash_id, :start], unique: true
  end
end
