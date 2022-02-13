class CreateFreeProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :free_products do |t|
      t.references :product, foreign_key: true
      t.integer :free_id, foreign_key: true
    end
  end
end
