class Session < ActiveRecord::Base
  belongs_to :program

  def self.import(file, program_id)
    session_ids_from_file = []
    CSV.foreach(file.path, headers: true) do |row|
      unless row["Session ID"] == nil || row["Name (required)"] == nil
          @current = Session.find_or_create_by(session_id: row["Session ID"], program_id: program_id)
          @current.update(
                name: row["Name (required)"] || "none", 
                description: row["Description"], 
                start_time: row["Start Time (required)"], 
                end_time: row["End Time (required)"], 
                location: row["Location"], 
                session_tracks: row["Session Tracks"], 
                filters: row["Filters"], 
                speaker_id: row["Speaker IDs"], 
                link_urls: row["Link URLs"], 
                session_id: row["Session ID"],
                program_id: program_id,
                deleted: false
                )
          session_ids_from_file << row["Session ID"]
      end
      all_sessions = Session.where(program_id: program_id).map { |session| session.session_id }
      
      unless all_sessions - session_ids_from_file == 0
        sessions_mark_as_deleted = all_sessions - session_ids_from_file
        sessions_mark_as_deleted.each do |id|
          Session.find_by(session_id: id, program_id: program_id).update(deleted: true)
        end
      end
    end
      Session.where(program_id: program_id).count
  end

  def build_session_page
    speakers_list = ""
    speakers_bios = ""
    speaker_id.split(",").each do |sid|
      speaker = program.speakers.find_by speaker_id: sid
      speakers_list << "#{speaker.fname} #{speaker.lname}, #{speaker.title.strip}, #{speaker.company}<br />"
      speakers_bios << "<h3>#{speaker.fname} #{speaker.lname}</h3>"
      speakers_bios << "<div class=\"picture\"><img src=\"#{speaker.img_url}\" 
                        alt=\"#{speaker.fname} #{speaker.lname}\"></div>" unless speaker.img_url.empty? || speaker.img_url.nil?
      speakers_bios << "<p class=\"bio\" id=\"#{speaker.fname.gsub(/\W+/, "")}#{speaker.lname.gsub(/\W+/, "")}\">"     
      if speaker.description.empty? || speaker.description.nil?
        speakers_bios << "Bio Coming Soon</p>"
      else 
       speakers_bios << "#{speaker.description}</p>"
      end
    end

    loc = if location.empty? || location.nil?
            "TBD"
          else
            location
          end

    tech_tracks = "Session Tracks: #{session_tracks}" unless session_tracks.empty? || session_tracks.nil?

    date = "#{DateTime.parse(start_time.to_s).utc.strftime("%A, %B %e, %Y")}"
    time = "#{DateTime.parse(start_time.to_s).utc.strftime("%l:%M %p")} -#{DateTime.parse(end_time.to_s).utc.strftime("%l:%M %p")}"

    session_page = "<!--   URL is: #{name.gsub(/\W+/, "")}    --->\n"
    session_page << <<-HERE 
                      <div class="sessionDescription">
                        <div class="session">
                            <h2> #{name} </h2>
                            <p class="timeDateLoc">#{date}
                            <br />#{time}
                            <br />#{loc}</p>
                            <p class="speakersList">
                            #{speakers_list}
                            </p>
                            <p class="summaryDescription">#{description}</p>
                            #{tech_tracks}
                            <p class="filter">Session Type: #{filters}</p>      
                        </div>
                        <div class="speakersBio">
                            #{speakers_bios}
                        </div>
                    </div>
                    HERE
    fix_cp1252_utf8(session_page)
  end

  def fix_cp1252_utf8(text)
  text.encode('cp1252',
              :fallback => {
                "\u06EA" => "\x6ea".force_encoding("cp1252"),
                "\u06DD" => "\x6dd".force_encoding("cp1252"),
                "\uFFFD" => "\xfffd".force_encoding("cp1252"),
                "\u0081" => "\x81".force_encoding("cp1252"),
                "\u008D" => "\x8D".force_encoding("cp1252"),
                "\u008F" => "\x8F".force_encoding("cp1252"),
                "\u0090" => "\x90".force_encoding("cp1252"),
                "\u009D" => "\x9D".force_encoding("cp1252")
              })
      .force_encoding("utf-8").encode("utf-8")
  end

end
