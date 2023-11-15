require_dependency 'projects_controller'

class ProjectsController < ApplicationController
  append_before_action :remove_read_only_attributes, :only => [:update]

  private

  def remove_read_only_attributes
    attributes = @project.read_only_attribute_names(User.current)
    params_keys = params[:project].keys
    params[:project] = params[:project].except(*attributes)
    allowed_fields_keys = params[:project].keys
    @rejected_fields_keys = params_keys - allowed_fields_keys
  end

  # Renders a 200 response for partial successful updates
  def render_api_ok
    if @rejected_fields_keys.count > 0
      @messages = @rejected_fields_keys
      render :template => 'common/rejected_fields_messages.api', :status => 200, :layout => nil
    else
      render_api_head :no_content
    end
  end

end