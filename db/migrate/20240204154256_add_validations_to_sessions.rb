class AddValidationsToSessions < ActiveRecord::Migration[6.1]
  def change
    change_table :sessions do |t|
      t.change :coach_hash_id, :string, null: false
      t.change :client_hash_id, :string, null: false
      t.change :start, :datetime, null: false
      t.change :duration, :integer, null: false, default: 30
    end
  end
end
