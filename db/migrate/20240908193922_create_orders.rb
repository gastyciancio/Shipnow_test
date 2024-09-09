class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :reference, null: false
      t.boolean :ready, default: false
      t.datetime :ready_at
      t.references :storage, null: false, foreign_key: true

      t.timestamps
    end
    add_index :orders, :reference, unique: true
  end
end
