class AddDeletedToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :deleted, :boolean
  end
end
