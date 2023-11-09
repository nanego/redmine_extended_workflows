require_dependency 'workflows_controller'

class WorkflowsController < ApplicationController

  def projects

    find_roles

    if request.post? && @roles && params[:permissions]
      permissions = params[:permissions].deep_dup
      permissions.each do |field, rule_by_field_id|
        rule_by_field_id.reject! {|field_id, rule| rule == 'no_change'}
      end

      WorkflowProject.replace_permissions(@roles, permissions)

      flash[:notice] = l(:notice_successful_update)
      redirect_to_referer_or workflows_permissions_path
      return
    end

    if @roles
      @fields = (Project::CORE_FIELDS ).map {|field| [field, l("field_"+field.sub(/_id$/, ''))]}
      @custom_fields = CustomField.where(type: "ProjectCustomField" ).sort
      @custom_fields = group_projects_custom_fields_by_section(@custom_fields) if Redmine::Plugin.installed?(:redmine_custom_fields_sections)
      @permissions = WorkflowProject.rules_by_roles(@roles)
    end
  end

end