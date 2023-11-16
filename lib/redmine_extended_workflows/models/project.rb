require_dependency 'project'

class Project < ActiveRecord::Base
  CORE_FIELDS =  %w(name description is_public parent_id inherit_members).freeze

  # Returns the names of attributes that are read-only for user or the current user
  # For users with multiple roles, the read-only fields are the intersection of
  # read-only fields of each role
  # The result is an array of strings where sustom fields are represented with their ids
  #
  # Examples:
  #   project.read_only_attribute_names # => ['description', '2']
  #   project.read_only_attribute_names(user) # => []
  def read_only_attribute_names(user=nil)
    return [] if user.nil?

    user_real = user || User.current
    return [] if user_real.admin?

    roles =  user_real.roles_for_project(project)

    return [] if roles.empty?

    workflow_projects =
      WorkflowProject.where(
        :rule => 'readonly', :role_id => roles.map(&:id)
      )

    workflow_projects_fields = workflow_projects.map(&:field_name)
    read_only_attribute = []

    # Include this field if it is set to read-only for all roles.
    workflow_projects_fields.each do |field|
      occurrences = workflow_projects_fields.count(field)
      read_only_attribute <<  field if occurrences == roles.count
    end

    read_only_attribute.uniq

  end


end