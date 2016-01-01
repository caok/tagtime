class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy, :destroy_member, :give_manager_right, :revoke_manager_right]

  def index
    @projects = current_user.projects.active
  end

  def name_list
    project_names= current_user.projects.select(:name).map(&:name)
    render json: project_names
  end

  def show
    @issues = @project.issues
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
        format.html { redirect_to projects_path, notice: 'Project was successfully created.' }
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
        format.html { redirect_to projects_path }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def assign
    project = Project.find(params[:project_id])
    Participation.find_or_create_by(user_id: params[:participation][:user_id], project_id: project.id, role: "participator")
    redirect_to edit_project_path(project)
  end

  def give_manager_right
    @project.participations.where(id: params[:member_id]).update_all(role: 'manager')
    redirect_to edit_project_path(@project)
  end

  def revoke_manager_right
    @project.participations.where(id: params[:member_id]).update_all(role: 'participator')
    redirect_to edit_project_path(@project)
  end

  def destroy_member
    @project.participations.where(id: params[:member_id]).destroy_all
    redirect_to edit_project_path(@project)
  end

  def destroy
    @project.close!
    respond_to do |format|
      format.html { redirect_to projects_path }
      format.json { head :no_content }
    end
  end

  def users
    project = current_user.projects.find_by(id: params[:project_id])
    users = []
    if project.present?
      project.users.each do |user|
        users << {id: user.id, text: user.name}
      end
    end

    render json: users
  end

  private
    def set_project
      @project = current_user.projects.find(params[:id])
    end

  def project_params
    params.require(:project).permit(:name, :content, :repo_url, :state)
  end
end
