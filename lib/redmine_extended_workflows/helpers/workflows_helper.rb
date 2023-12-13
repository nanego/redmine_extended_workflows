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

    def select_option_for_all_links(parent_selector, element_selector, option, label)
      content_tag 'p' do        
        link_to_function(l(:button_all), "selectOptionForAll('#{parent_selector}', '#{element_selector}', '#{option}')") +
        " | ".html_safe +
        link_to_function(l(:button_none), "selectOptionForAll('#{parent_selector}', '#{element_selector}', '')")
      end
    end

  end
end

WorkflowsHelper.prepend RedmineExtendedWorkflows::Helpers::WorkflowsHelper
ActionView::Base.prepend WorkflowsHelper
