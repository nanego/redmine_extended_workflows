module RedmineExtendedWorkflows::Models
  module RolePatch
    def self.included(base)
      base.class_eval do
        has_many :workflow_projects, :dependent => :destroy

        def workflow_project_roles?
          has_permission?(:edit_project)
        end
      end
    end
  end
end
Role.send(:include, RedmineExtendedWorkflows::Models::RolePatch)
