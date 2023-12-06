require 'workflows_controller' # only useful for Redmine < 5

module RedmineExtendedWorkflows::Controllers::WorkflowsControllerConcern
  extend ActiveSupport::Concern

  def projects
    find_update_project_roles

    if request.post? && @roles && params[:permissions]
      permissions = params[:permissions].deep_dup
      WorkflowProject.replace_permissions(permissions)

      flash[:notice] = l(:notice_successful_update)
      redirect_to_referer_or workflows_permissions_path if respond_to?(:workflows_permissions_path) # Redmine < 5
      redirect_to_referer_or permissions_workflows_path if respond_to?(:permissions_workflows_path) # Redmine >= 5
      return
    end

    if @roles.present?
      @fields = (Project::CORE_FIELDS).map { |field| [field, l("field_" + field.sub(/_id$/, ''))] }
      @custom_fields = CustomField.where(type: "ProjectCustomField").sort
      @custom_fields = group_projects_custom_fields_by_section(@custom_fields) if Redmine::Plugin.installed?(:redmine_custom_fields_sections)
      @permissions = WorkflowProject.rules_by_roles(@roles)
    end
  end

  private 

  def find_update_project_roles
    ids = Array.wrap(params[:role_id])
    if ids == ['all']
      @roles = Role.sorted.select(&:workflow_project_roles?)
    elsif ids.present?
      @roles = Role.where(:id => ids).to_a
    end
    @roles = nil if @roles.blank?
  end
end

class WorkflowsController < ApplicationController
  include RedmineExtendedWorkflows::Controllers::WorkflowsControllerConcern
end
