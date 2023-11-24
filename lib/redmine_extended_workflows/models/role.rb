require_dependency 'role'

module RedmineExtendedWorkflows::Models
  module Role
    def self.included(base)
      base.class_eval do
        has_many :workflow_projects, :dependent => :destroy
      end
    end
  end
end
Role.send(:include, RedmineExtendedWorkflows::Models::Role)
