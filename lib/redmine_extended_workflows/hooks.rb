module RedmineExtendedWorkflows
  module Hooks
    class ModelHook < Redmine::Hook::Listener
      def after_plugins_loaded(_context = {})
        require_relative 'controllers/workflows_controller_concern'
        require_relative 'controllers/projects_controller'
        require_relative 'helpers/workflows_helper'
        require_relative 'models/project'
        require_relative 'models/role_patch'
        require_relative 'models/custom_field'
      end
    end

    class Hooks < Redmine::Hook::ViewListener
      #adds our css on each page
      def view_layouts_base_html_head(context)
        stylesheet_link_tag("redmine_extended_workflows", :plugin => "redmine_extended_workflows")
      end
    end
  end
end
