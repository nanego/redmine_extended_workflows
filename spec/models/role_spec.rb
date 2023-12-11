require "spec_helper"

describe "Role" do

  fixtures :custom_fields, :roles

  it "updates the table workflow_project in case of cascade deleting" do
    custom_fields = ProjectCustomField.all
    role_test = Role.create!(:name => 'Test')
    role_test.add_permission! :add_issues

    WorkflowProject.create(:role_id => role_test.id, :field_name => "#{custom_fields.first.id}", :rule => 'readonly')
    WorkflowProject.create(:role_id => role_test.id, :field_name => "name", :rule => 'readonly')

    expect do
      role_test.destroy
    end.to change { WorkflowProject.count }.by(-2)
  end

  it "returns the roles which have the permission edit_project" do
    role_without_permission = Role.create!(:name => 'Test')
    roles = Role.workflow_project_roles
    roles.each do |role|
      expect(role.has_permission?(:edit_project)).to be_truthy
    end
    expect(roles).not_to include(role_without_permission)
  end
end
