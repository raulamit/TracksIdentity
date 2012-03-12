class CreateRefs < ActiveRecord::Migration
  def change

    create_table :ref_decodes do |t|
      t.string :name, :null => false
      t.string :constant_value, :null => false
      t.string :display_value, :null => false
      t.integer :sort_order
      t.boolean :is_active
      t.timestamps
    end

  end
end
