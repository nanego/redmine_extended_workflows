require_dependency 'role'

class Role < ActiveRecord::Base
  has_many :workflow_projects, :dependent => :destroy
end