class ProgramsController < ApplicationController
  before_action :set_program, only: [:show, :download, :edit, :update, :destroy, ]

  # GET /programs
  # GET /programs.json
  def index
    @programs = Program.all

  end

  # GET /programs/1
  # GET /programs/1.json
  def show
    @created_at_time = Program.format_date_time_est(@program.created_at)

  end

  def download
    respond_to do |format|
      format.html { send_data @program.build_schedule, filename: "#{@program.name}-#{Date.today}.html", notice: "Download starting"}
    end
  end

  # GET /programs/new
  def new
    @program = Program.new
  end

  # GET /programs/1/edit
  def edit
  end

  # POST /programs
  # POST /programs.json
  def create
    file_session = params[:file_session]
    file_speaker = params[:file_speaker]
    @program = Program.create!(program_params)
    sessions_count = Session.import(file_session, @program.id)
    speakers_count = Speaker.import(file_speaker, @program.id)
    respond_to do |format|
      format.html { redirect_to @program, notice: "Program was successfully created with #{sessions_count} sessions and #{speakers_count} speakers." }
      format.json { render :show, status: :created, location: @program }
    end

  end

  # PATCH/PUT /programs/1
  # PATCH/PUT /programs/1.json
  def update
    file_session = params[:file_session]
    file_speaker = params[:file_speaker]
    sessions_count = Session.check_for_diff(file_session, @program.id)
    speakers_count = Speaker.import(file_speaker, @program.id)

    respond_to do |format|
      if @program.update(program_params)
        format.html { redirect_to @program, notice: 'Program was successfully updated.' }
        format.json { render :show, status: :ok, location: @program }
      else
        format.html { render :edit }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /programs/1
  # DELETE /programs/1.json
  def destroy
    @program.destroy
    respond_to do |format|
      format.html { redirect_to programs_url, notice: 'Program was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_program
      @program = Program.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def program_params
      params.permit(:name, :created_at)
    end
end
