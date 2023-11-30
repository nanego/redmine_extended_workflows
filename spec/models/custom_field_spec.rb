require "spec_helper"

describe "CustomField" do

  fixtures :custom_fields, :roles

  it "updates the table workflow_project in case of cascade deleting" do
    field = CustomField.create(name: 'Test', type: 'ProjectCustomField', field_format: 'string')
    roles = Role.first(2)
    WorkflowProject.create(role_id: roles.first.id, field_name: field.id.to_s, rule: 'readonly')
    WorkflowProject.create(role_id: roles.last.id, field_name: field.id.to_s, rule: 'readonly')

    expect do
      field.destroy
    end.to change { WorkflowProject.count }.by(-2)
  end
end
