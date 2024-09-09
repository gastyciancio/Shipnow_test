class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :reference, null: false, unique: true

      t.timestamps
    end
    add_index :products, :reference, unique: true
  end
end
