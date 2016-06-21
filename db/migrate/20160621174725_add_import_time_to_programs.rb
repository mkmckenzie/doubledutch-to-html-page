class AddImportTimeToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :import_time, :datetime
  end
end
