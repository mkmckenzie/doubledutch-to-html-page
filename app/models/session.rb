class Session < ActiveRecord::Base
  belongs_to :program

  require 'csv'

  def self.import(file, program_id)
    sessions_count = 0
    CSV.foreach(file.path, headers: true) do |row|
      Session.create(
        name: row["Name (required)"], 
        description: row["Description"], 
        start_time: row["Start Time (required)"], 
        end_time: row["End Time (required)"], 
        location: row["Location"], 
        session_tracks: row["Session Tracks"], 
        filters: row["Filters"], 
        speaker_id: row["Speaker IDs"], 
        link_urls: row["Link URLs"], 
        session_id: row["Session ID"],
        program_id: program_id
      )

      sessions_count += 1
    end
    

     sessions_count
  end


end
