class Program < ActiveRecord::Base
  has_many :sessions, :dependent => :destroy
  has_many :speakers, :dependent => :destroy

  accepts_nested_attributes_for :sessions 
  accepts_nested_attributes_for :speakers


  def delete_if_name_is_nil
    sessions.as_json.delete_if {|session| session["name"] == nil }
  end

  def delete_if_name_is_nil_speaker
    speakers.as_json.delete_if {|session| session["speaker_id"] == nil }
  end

  def build_schedule
    sessions_clean = delete_if_name_is_nil
    speakers_clean = delete_if_name_is_nil_speaker
    
    @schedule = "<table class=\"schedule\">"

    sessions_clean.sort_by! {|session| [session["start_time"], session["name"]]}.each do |session|
      day_title = "<h2 class=\"titleDate\"><strong>#{format_date(session["start_time"])}</strong></h2>"
      start_time = format_time(session["start_time"])
      end_time = format_time(session["end_time"])
      weekday = format_day(session["start_time"])
      conf_code = split_conf_code(session["session_tracks"])
      print session["session_tracks"]
      speakers = split_speakers(session["speaker_id"])
      description = get_plain_text(session["description"])
      filters = session["filters"].split(",")
      short_description = "#{description[0,200]}...".gsub("&nbsp;", "")
      link = if session["link_urls"].empty? || session["link_urls"].nil?
                "#"
            else
              session["link_urls"]
            end
      
      meeting_type = ""
      filters.each {|filter| meeting_type << "<div class=\"#{filter.gsub(" ", "")} filter\">#{filter}</div>" }
      
      circles = ""

      conf_code.split(";").each do |code| 
        circles << "<div title=\"#{code}\" class=\"#{format_conf_code(code)} circle\"></div>"
      end

      @schedule << "<tr><td colspan=2 class=\"day\" id=\"#{weekday}\">
                  #{day_title}</td></tr>" unless @schedule.include?(day_title)
      
      @schedule << <<-HERE
                      <tr>
                        <td class="#{format_conf_code(conf_code)} dateTime">#{start_time} &ndash; #{end_time}</td>
                        <td class="#{conf_code} sessionInfo">
                          <p class="sessionName"><strong>#{session["name"]}</strong></p>
                          <p class="speakers"><em>#{speakers}</em></p>
                          <p class="shortDescription"> #{short_description} </p>
                          <p class="longDescription" style="display: none;">#{description}</p>
                          <p><span class="readMore" id="#{session["session_id"]}">Read More</span></p>
                          <p><a href="#{link}">Click here for more information</a></p>
                          #{meeting_type}
                          #{circles}
                        </td>
                      </tr>
                    HERE
    
    end

    @schedule << "</table>"
    
    speakers_clean.each do |speaker| 
      spid = speaker["speaker_id"]
      @schedule.gsub!(spid, 
                      "#{speaker["fname"].strip} #{speaker["lname"].strip}, 
                      #{speaker["title"].strip}, #{speaker["company"].strip}") if @schedule.include?(spid)
    end

    fix_cp1252_utf8(@schedule)

  end


  def format_date(date_string)
    DateTime.parse(date_string.to_s).utc.strftime("%A, %B %e, %Y")
  end

  def format_day(day_string)
    DateTime.parse(day_string.to_s).utc.strftime("%A")
  end

  def format_time(time_string)
    DateTime.parse(time_string.to_s).utc.strftime("%l:%M %p")
  end

  def self.format_date_time_est(string)
    Time.zone = 'Eastern Time (US & Canada)'
    DateTime.parse(string.to_s).in_time_zone.strftime("%A, %B %e, %Y at %l:%M %p EST")
  end

  def split_conf_code(session_tracks)
    session_tracks.match(/([a-z]),([A-Z])/)
    session_tracks.gsub(/([a-z]),([A-Z])/, "#{$1};#{$2}")
  end

  def format_conf_code(session_tracks)
    session_tracks.gsub(/,\s/, " ").gsub(/\s/, "").gsub(",", " ")
  end

  def split_speakers(presenter)
    presenter.split(',').join('<br />')
  end

  def get_plain_text(text)
    text.gsub(/<.*>/,"").gsub(/<\/.*>/, "")
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
