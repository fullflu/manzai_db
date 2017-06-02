class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :boke
      t.string :tsukkomi

      t.timestamps null: false
    end
  end
end
