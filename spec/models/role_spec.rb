require "spec_helper"

describe "Role" do

  fixtures :custom_fields, :roles

  it "Update the table workflow_project in case of cascade deleting" do
    custom_fields = CustomField.where(type: "ProjectCustomField")
    role_test = Role.create!(:name => 'Test')
    role_test.add_permission! :add_issues

    WorkflowProject.create(:role_id => role_test.id, :field_name => "#{custom_fields.first.id}", :rule => 'readonly')
    WorkflowProject.create(:role_id => role_test.id, :field_name => "name", :rule => 'readonly')

    expect do
      role_test.destroy
    end.to change { WorkflowProject.count }.by(-2)
  end

  it "Should return the roles which have the permission edit_project" do
    Role.create!(:name => 'Test')
    roles = Role.select(&:workflow_project_roles?)
    roles.each do |role|
      expect(role.has_permission?(:edit_project)).to be_truthy
    end
    expect(roles).not_to include(Role.last)
  end
end
