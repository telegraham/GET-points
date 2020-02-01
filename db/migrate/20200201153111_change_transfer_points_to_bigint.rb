class ChangeTransferPointsToBigint < ActiveRecord::Migration
  def up
    change_column :transfers, :points, :bigint
  end

  def down
    change_column :transfers, :points, :integer
  end
end
