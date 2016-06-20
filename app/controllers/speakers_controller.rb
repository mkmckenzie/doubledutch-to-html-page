class SpeakersController < ApplicationController
  before_action :set_program, except: [:import]

  def index
    @speakers = @program.speakers
  end

  def create
    @speaker = @program.speaker.create(params[:file_speaker])
    redirect_to root_url, notice: "Speaker Successfully Created"
  end

  def update
  end

  def destroy
  end

  def import
    Speaker.import(params[:file_speaker])
    redirect_to root_url, notice: "#{@speaker_count} speakers imported"
  end

  def new
    @speaker = Speaker.new(:program => @program)
  end

  private

  def set_program
    @program = Program.find(params[:program_id])
  end


end
