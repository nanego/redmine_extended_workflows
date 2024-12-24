require_relative 'lib/redmine_extended_workflows/hooks'

Redmine::Plugin.register :redmine_extended_workflows do
  name 'Redmine Extended Workflows plugin'
  author 'Vincent ROBERT'
  description 'This plugin enhances standard workflows by introducing new configuration options.'
  version '0.0.1'
  url 'https://github.com/nanego/redmine_extended_workflows'
  requires_redmine_plugin :redmine_base_rspec, :version_or_higher => '0.0.3' if Rails.env.test?
end

# Support for Redmine 5
if Redmine::VERSION::MAJOR < 6
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
