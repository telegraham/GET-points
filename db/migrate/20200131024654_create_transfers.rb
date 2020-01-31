class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.integer :to_id
      t.integer :from_id
      t.integer :points
    end
  end
end
