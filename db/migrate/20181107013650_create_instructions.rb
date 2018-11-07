class CreateInstructions < ActiveRecord::Migration[5.2]
  def change
    create_table :instructions do |t|
      t.integer :recipe_id
      t.string :content
      t.integer :position
    end
  end
end
