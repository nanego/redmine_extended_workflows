require_dependency 'role'

class Role < ActiveRecord::Base
  has_many :workflow_projects, :dependent => :destroy

  def self.excluded_workflow_roles
    Role.all - Role.sorted.select(&:consider_workflow?)
  end
end