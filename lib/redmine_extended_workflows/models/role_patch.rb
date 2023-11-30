module RedmineExtendedWorkflows::Models
  module RolePatch
    def self.included(base)
      base.class_eval do
        has_many :workflow_projects, :dependent => :destroy

        def self.excluded_workflow_roles
          Role.all - Role.sorted.select(&:consider_workflow?)
        end
      end
    end
  end
end
Role.send(:include, RedmineExtendedWorkflows::Models::RolePatch)
