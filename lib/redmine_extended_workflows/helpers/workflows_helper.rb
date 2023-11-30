module RedmineExtendedWorkflows::Helpers
  module WorkflowsHelper
    def field_permission_project_tag(permissions, role, field, roles)

      name = field.is_a?(CustomField) ? field.id.to_s : field
      options = [["", ""], [l(:label_readonly), "readonly"]]
      html_options = {}

      if  permissions.count > 0 && permissions[role.id].present?
        if perm = permissions[role.id][name]
          selected = perm.first
        end
      end

      hidden = field.is_a?(CustomField) &&
        !field.visible? &&
        !roles.detect {|role| role.custom_fields.to_a.include?(field)}

      if hidden
        options[0][0] = l(:label_hidden)
        selected = ''
        html_options[:disabled] = true
      end

      select_tag("permissions[#{role.id}][#{name}]", options_for_select(options, selected), html_options)
    end
  end
end

WorkflowsHelper.prepend RedmineExtendedWorkflows::Helpers::WorkflowsHelper
ActionView::Base.prepend WorkflowsHelper
