module RedmineExtendedWorkflows
  module Hooks
    class ModelHook < Redmine::Hook::Listener
      def after_plugins_loaded(_context = {})
        require_relative 'controllers/workflows_controller'
        require_relative 'helpers/workflows_helper'
        require_relative 'models/project'
        require_relative 'models/role'
      end
    end
  end
end
