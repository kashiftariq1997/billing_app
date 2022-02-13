# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :code
      t.decimal :price
      t.decimal :volume
      t.decimal :volume_price
      t.boolean :has_addon, default: false
      t.decimal :free_criteria

      t.timestamps
    end
  end
end
