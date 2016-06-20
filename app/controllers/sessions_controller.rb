class SessionsController < ApplicationController
  before_action :set_program, except: [:import]
 

  def index
    @sessions = @program.sessions
  end

  def create
    @session = @program.session.create(params[:file_session])
    redirect_to root_url, notice: "Session Successfully Created"
  end

  def show
    @session = @program.sessions.find(params[:id])
    @html_page = @session.build_session_page

  end

  def update
  end

  def destroy
  end

  def import
    Session.import(params[:file_session])
    redirect_to root_url, notice: "#{@session_count} sessions imported"
  end

  def new
    @session = Session.new(:program => @program)
  end

  def download
    respond_to do |format|
      format.html { send_data @program.sessions.find(params[:id]).build_session_page, filename: "#{@program.sessions.find(params[:id]).name.gsub(/\W+/,"")}-#{Date.today}.html", notice: "Download starting"}
    end
  end

  private

  def set_program
    @program = Program.find(params[:program_id])
  end

end
