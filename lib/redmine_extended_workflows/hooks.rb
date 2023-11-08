module RedmineExtendedWorkflows
  module Hooks
    class ModelHook < Redmine::Hook::Listener
      def after_plugins_loaded(_context = {})
        require_relative 'controllers/workflows_controller'
        require_relative 'helpers/workflows_helper'
      end
    end
  end
end
