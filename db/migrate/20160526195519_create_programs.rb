class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.string :name
      t.datetime :created_at

      t.timestamps null: false
    end
  end
end
