class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :name
      t.string :description
      t.string :start_time
      t.string :end_time
      t.string :location
      t.string :session_tracks
      t.string :filters
      t.string :speaker_id
      t.string :link_urls
      t.string :session_id
      t.references :program, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
