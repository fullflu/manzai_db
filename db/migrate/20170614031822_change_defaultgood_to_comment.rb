class ChangeDefaultgoodToComment < ActiveRecord::Migration
  # 変更内容
  def up
    change_column_default :comments, :good, 0
  end

  # 変更前の状態
  def down
    change_column :comments, :good, :integer, :null => true, :default => nil
  end
end
