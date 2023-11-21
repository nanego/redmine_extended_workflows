require "spec_helper"

describe "CustomField" do

  fixtures :custom_fields, :roles

  it "Update the table workflow_project in case of cascade deleting" do
    field = CustomField.create(:name => 'Test',:type => 'ProjectCustomField', :field_format => 'string')
    roles = Role.sorted.select(&:consider_workflow?)
    WorkflowProject.create(:role_id => roles.first.id, :field_name => "#{field.id}", :rule => 'readonly')
    WorkflowProject.create(:role_id => roles.last.id, :field_name => "#{field.id}", :rule => 'readonly')

    expect do
      field.destroy
    end.to change { WorkflowProject.count }.by(-2)
  end
end