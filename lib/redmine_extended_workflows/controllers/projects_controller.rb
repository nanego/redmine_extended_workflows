require_dependency 'projects_controller'

class ProjectsController < ApplicationController
  append_before_action :remove_read_only_attributes, :only => [:update]

  private

  def remove_read_only_attributes

    attributes = @project.read_only_attribute_names(User.current)
    all_params_keys = params[:project].keys

    all_params_keys += params[:project][:custom_field_values].keys if params[:project][:custom_field_values].present?

    params[:project] = params[:project].except(*attributes)

    params[:project][:custom_field_values] = params[:project][:custom_field_values].except(*attributes) if params[:project][:custom_field_values].present?

    allowed_fields_keys = params[:project].keys
    allowed_fields_keys += params[:project][:custom_field_values].keys if params[:project][:custom_field_values].present?

    @rejected_fields_keys = all_params_keys - allowed_fields_keys
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