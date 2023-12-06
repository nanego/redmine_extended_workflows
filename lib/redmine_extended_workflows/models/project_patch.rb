module RedmineExtendedWorkflows::Models
  module ProjectPatch
    def self.included(base)
      base.class_eval do
        # Returns the names of attributes that are read-only for user or the current user
        # For users with multiple roles, the read-only fields are the intersection of
        # read-only fields of each role
        # The result is an array of strings where sustom fields are represented with their ids
        #
        # Examples:
        #   project.read_only_attribute_names # => ['description', '2']
        #   project.read_only_attribute_names(user) # => []
        def read_only_attribute_names(user = User.current)
          return [] if user.admin?
          Project.get_read_only_attribute_for_roles(user.roles_for_project(self))
        end

        def self.get_read_only_attribute_for_roles(roles)

          workflow_roles_user = roles & Role.sorted.select(&:workflow_project_roles?)

          WorkflowProject.where(role: workflow_roles_user,
                                rule: 'readonly')
                         .pluck(:field_name)
                         .group_by { |field_name| field_name }
                         .reject { |k, group| group.length != workflow_roles_user.size }
                         .keys
        end

      end
    end
  end
end
Project.send(:include, RedmineExtendedWorkflows::Models::ProjectPatch)

class Project < ActiveRecord::Base
  CORE_FIELDS = %w(name description is_public parent_id inherit_members homepage).freeze
end
