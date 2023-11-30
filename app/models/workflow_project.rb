class WorkflowProject < ActiveRecord::Base

  belongs_to :role
  validates_presence_of :role

  def self.rules_by_roles(roles)
    WorkflowProject.where(role: roles).inject({}) do |h, w|
      h[w.role_id] ||= {}
      h[w.role_id][w.field_name] ||= []
      h[w.role_id][w.field_name] << w.rule
      h
    end
  end

  def self.replace_permissions(permissions)
    transaction do
      permissions&.each do |role_id, rule_by_field|
        rule_by_field&.each do |field, rule|
          where(role_id: role_id, field_name: field).destroy_all

          if rule.present?
            WorkflowProject.create!(role_id: role_id, field_name: field, rule: rule)
          end
        end
      end
    end
  end

end
