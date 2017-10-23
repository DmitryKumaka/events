class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :name
      t.date :date
      t.boolean :visited_flag, default: false

      t.timestamps
    end
  end
end
