require "spec_helper"

describe "Role" do

  fixtures :custom_fields, :roles

  it "Update the table workflow_project in case of cascade deleting" do
    custom_fields = CustomField.where(type: "ProjectCustomField" )
    role_test = Role.create!(:name => 'Test')
    role_test.add_permission! :add_issues

    WorkflowProject.create(:role_id => role_test.id, :field_name => "#{custom_fields.first.id}", :rule => 'readonly')
    WorkflowProject.create(:role_id => role_test.id, :field_name => "name", :rule => 'readonly')

    expect do
      role_test.destroy
    end.to change { WorkflowProject.count }.by(-2)
  end
end