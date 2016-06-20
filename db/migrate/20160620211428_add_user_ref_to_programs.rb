class AddUserRefToPrograms < ActiveRecord::Migration
  def change
    add_reference :programs, :user, index: true, foreign_key: true
  end
end
