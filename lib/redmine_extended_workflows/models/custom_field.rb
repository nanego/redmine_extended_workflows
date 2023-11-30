module RedmineExtendedWorkflows::Models
  module CustomField
    def self.included(base)
      base.class_eval do
        before_destroy :delete_workflow_projects_rules
      end
    end

    def delete_workflow_projects_rules
      WorkflowProject.where(:field_name => id).delete_all if type == "ProjectCustomField"
    end
  end
end

CustomField.send(:include, RedmineExtendedWorkflows::Models::CustomField)
