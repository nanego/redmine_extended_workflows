module RedmineExtendedWorkflows::Helpers
  module WorkflowsHelper

    def field_permission_project_tag(permissions, role, field, roles)
      name = field.is_a?(CustomField) ? field.id.to_s : field
      options = [["", ""], [l(:label_readonly), "readonly"]]

      if permissions.present? && permissions[role.id].present?
        if perm = permissions[role.id][name]
          selected = perm.first
        end
      end

      select_tag("permissions[#{role.id}][#{name}]", options_for_select(options, selected))
    end
  end
end

WorkflowsHelper.prepend RedmineExtendedWorkflows::Helpers::WorkflowsHelper
ActionView::Base.prepend WorkflowsHelper
