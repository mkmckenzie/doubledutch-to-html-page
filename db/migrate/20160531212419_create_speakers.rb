class CreateSpeakers < ActiveRecord::Migration
  def change
    create_table :speakers do |t|
      t.string :fname
      t.string :lname
      t.string :title
      t.string :company
      t.string :description
      t.string :img_url
      t.string :website
      t.string :twitter
      t.string :facebook
      t.string :linkedin
      t.string :session_ids
      t.string :attendee_id
      t.string :speaker_id
      t.references :program, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
