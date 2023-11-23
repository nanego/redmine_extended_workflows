require_dependency 'custom_field'

class CustomField < ActiveRecord::Base

  before_destroy :delete_workflow_projects_rules

  def delete_workflow_projects_rules
    WorkflowProject.where(:field_name => id).delete_all if type == "ProjectCustomField"
  end
end