class Admin::AdminController < ApplicationController
  before_filter :require_user, :check_rights

  protected
  def check_rights
    redirect_to root_path unless current_user.admin?
  end
end