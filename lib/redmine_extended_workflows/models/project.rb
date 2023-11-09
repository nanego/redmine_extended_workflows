require_dependency 'project'

class Project < ActiveRecord::Base
  CORE_FIELDS =  %w(name description is_public parent_id inherit_members).freeze
end