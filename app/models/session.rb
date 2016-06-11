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
      ) unless row["Session ID"] === nil

      sessions_count += 1
    end
    

     sessions_count
  end


  def self.check_for_diff(file, program_id)
    sessions_count = 0
    CSV.foreach(file.path, headers: true) do |row|

      # Session.where(session_id: row["Session ID"]).first_or_create(
      #   name: row["Name (required)"], 
      #   description: row["Description"], 
      #   start_time: row["Start Time (required)"], 
      #   end_time: row["End Time (required)"], 
      #   location: row["Location"], 
      #   session_tracks: row["Session Tracks"], 
      #   filters: row["Filters"], 
      #   speaker_id: row["Speaker IDs"], 
      #   link_urls: row["Link URLs"], 
      #   session_id: row["Session ID"],
      #   program_id: program_id
      #   )
      # Session.where(session_id: row["Session ID"]).update(
      #   name: row["Name (required)"], 
      #   description: row["Description"], 
      #   start_time: row["Start Time (required)"], 
      #   end_time: row["End Time (required)"], 
      #   location: row["Location"], 
      #   session_tracks: row["Session Tracks"], 
      #   filters: row["Filters"], 
      #   speaker_id: row["Speaker IDs"], 
      #   link_urls: row["Link URLs"], 
      #   session_id: row["Session ID"],
      #   program_id: program_id) if Session.where(session_id: row["Session ID"]) <=> row

      if Session.find_by session_id: row["Session ID"], program_id: program_id
        session = Session.find_by session_id: row["Session ID"], program_id: program_id
        Session.update(session.id, name: row["Name (required)"]) if session. name != row["Name (required)"]
        Session.update(session.id, description: row["Description"]) if session.description != row["Description"]
        Session.update(session.id, start_time: row["Start Time (required)"]) if session.start_time != row["Start Time (required)"]
        Session.update(session.id, end_time: row["End Time (required)"]) if session.end_time != row["End Time (required)"]
        Session.update(session.id, location: row["Location"]) if session.location != row["Location"]
        Session.update(session.id, session_tracks: row["Session Tracks"]) if session.session_tracks != row["Session Tracks"]
        Session.update(session.id, filters: row["Filters"]) if session.filters != row["Filters"]
        Session.update(session.id, speaker_id: row["Speaker IDs"]) if session.speaker_id != row["Speaker IDs"]
        Session.update(session.id, link_urls: row["Link URLs"]) if session.link_urls != row["Link URLs"]

      else
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
      ) unless row["Session ID"] === nil
      end
    end
  end

def build_session_page
  speakers = speaker_id.split(",")
  speakers_list = ""
  speakers_bios = ""
  speakers.each do |sid|
    speaker = program.speakers.find_by speaker_id: sid
    speakers_list << "#{speaker.fname} #{speaker.lname}, #{speaker.title.strip}, #{speaker.company}<br />"
    speakers_bios << "<h3>#{speaker.fname} #{speaker.lname}</h3>"
    speakers_bios << "<div class=\"picture\"><img src=\"#{speaker.img_url}\" alt=\"#{speaker.fname} #{speaker.lname}\"></div>" unless speaker.img_url.empty? || speaker.img_url.nil?
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
  time = "#{DateTime.parse(start_time.to_s).utc.strftime("%l:%M %p")} - #{DateTime.parse(end_time.to_s).utc.strftime("%l:%M %p")}"

  session_page = "<!--   URL is: #{name.gsub(/\W+/, "")}    --->"
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
  #fix_cp1252_utf8(session_page)


end

  def fix_cp1252_utf8(text)
  text.encode('cp1252',
              :fallback => {
                "\u0081" => "\x81".force_encoding("cp1252"),
                "\u008D" => "\x8D".force_encoding("cp1252"),
                "\u008F" => "\x8F".force_encoding("cp1252"),
                "\u0090" => "\x90".force_encoding("cp1252"),
                "\u009D" => "\x9D".force_encoding("cp1252")
              })
      .force_encoding("utf-8")
  end





end
