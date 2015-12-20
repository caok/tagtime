class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = current_user.projects
  end

  def show
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        Participation.find_or_create_by(user_id: current_user.id, project_id: @project.id, role: 'owner')
        format.html { redirect_to mine_profile_path, notice: 'Project was successfully created.' }
        format.json { render action: 'show', status: :created, location: @project }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to mine_profile_path, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def assign
    project = Project.find(params[:project_id])
    Participation.find_or_create_by(user_id: params[:participation][:user_id], project_id: project.id, role: params[:participation][:role])
    redirect_to project
  end

  def destroy
    @project.close!
    respond_to do |format|
      format.html { redirect_to mine_profile_path }
      format.json { head :no_content }
    end
  end

  private
    def set_project
      @project = current_user.projects.find(params[:id])
    end

  def project_params
    params.require(:project).permit(:name, :content, :repo_url, :state)
  end
end

