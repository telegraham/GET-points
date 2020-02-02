class AddTimestampsToTransfers < ActiveRecord::Migration
  def change
    add_column :transfers, :created_at, :datetime#, null: false, default: DateTime.now
    add_column :transfers, :updated_at, :datetime#, null: false, default: DateTime.now
  end
end
