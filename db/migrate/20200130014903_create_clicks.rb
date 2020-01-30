class CreateClicks < ActiveRecord::Migration
  def change
    create_table :clicks do |t|
      t.belongs_to :user
      t.integer :value
      t.timestamps
    end
  end
end
