class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :user_id
      t.integer :group_id
      t.string :title

      t.timestamps null: false
    end
  end
end
