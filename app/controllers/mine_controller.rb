class MineController < ApplicationController
  before_action :authenticate_user!

  def profile
    @projects = current_user.projects
  end
end
