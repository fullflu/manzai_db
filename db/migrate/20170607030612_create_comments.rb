class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
        t.integer :product_id
        t.text :daihon
        t.boolean :tsukkomi
        t.integer :prev_id
        t.integer :post_id
        t.integer :good
      t.timestamps null: false
    end
  end
end
