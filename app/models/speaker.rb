class Speaker < ActiveRecord::Base
  belongs_to :program

  def self.import(file, program_id)
    CSV.foreach(file.path, headers: true) do |row|
      unless row["Speaker ID"] == nil
        @current = Speaker.find_or_create_by(speaker_id: row["Speaker ID"], program_id: program_id)
        @current.update(
          fname: row["First Name (required)"], 
          lname: row["Last Name (required)"],
          title: row["Title"],
          company: row["Company"],
          description: row["Description"], 
          img_url: row["Image URL"],
          website: row["Website"], 
          twitter: row["Twitter Handle"], 
          facebook: row["Facebook URL"], 
          linkedin: row["LinkedIn URL"], 
          session_ids: row["Session IDs"], 
          attendee_id: row["Attendee ID"],
          speaker_id: row["Speaker ID"], 
          program_id: program_id
        )
      end
    end
    Speaker.where(program_id: program_id).count 
  end
end
