require_dependency 'project'

module RedmineExtendedWorkflows::Models
  module Project

    # Returns the names of attributes that are read-only for user or the current user
    # For users with multiple roles, the read-only fields are the intersection of
    # read-only fields of each role
    # The result is an array of strings where sustom fields are represented with their ids
    #
    # Examples:
    #   project.read_only_attribute_names # => ['description', '2']
    #   project.read_only_attribute_names(user) # => []
    def read_only_attribute_names(user = nil)
      return [] if user.nil?

      user_real = user || User.current
      return [] if user_real.admin?

      user_roles_in_project =  user_real.roles_for_project(self)

      return [] if user_roles_in_project.empty?

      Project.get_read_only_attribute_for_roles(user_roles_in_project)

    end

    def self.get_read_only_attribute_for_roles(roles)
      workflow_projects =
        WorkflowProject.where(
          :rule => 'readonly', :role_id => roles.map(&:id)
        )

      workflow_projects_fields = workflow_projects.map(&:field_name)
      read_only_attributes = []

      # Handle cases where roles lack permission to perform update/project.
      workflow_roles_user = roles - Role.excluded_workflow_roles

      # Include this field if it is set to read-only for all consider_workflow roles.
      workflow_projects_fields.each do |field|
        occurrences = workflow_projects_fields.count(field)
      read_only_attributes <<  field if occurrences == workflow_roles_user.count
      end

      read_only_attributes.uniq
    end
  end
end
Project.send(:include, RedmineExtendedWorkflows::Models::Project)
class Project < ActiveRecord::Base
  CORE_FIELDS = %w(name description is_public parent_id inherit_members).freeze
end
