require "spec_helper"

describe "Project" do

  fixtures :custom_fields, :roles, :projects
  let(:project) { Project.find(1) }
  let(:custom_fields) { ProjectCustomField.all }

  describe "Project/read_only_attribute_names" do
    it "does not return any fields when the user is an admin" do
      field_id = custom_fields.first.id
      user = User.find(1)

      roles.each do |role|
        WorkflowProject.create(:role_id => role.id, :field_name => "name", :rule => 'readonly')
        WorkflowProject.create(:role_id => role.id, :field_name => "description", :rule => 'readonly')
        WorkflowProject.create(:role_id => role.id, :field_name => field_id.to_s, :rule => 'readonly')
      end
      read_only_fields = project.read_only_attribute_names(user)
      expect(read_only_fields.size).to eq(0)
    end

    it "returns all fields that are set as read-only for all user's roles" do
      user = User.find(2)
      field_id = custom_fields.first.id
      member = Member.find(1) # this member is with user_id 2 ,project_id 1 ,and it has one role 1 manager.
      member.roles << Role.find(2)
      member.save

      WorkflowProject.create(:role_id => 1, :field_name => "name", :rule => 'readonly')
      WorkflowProject.create(:role_id => 1, :field_name => "description", :rule => 'readonly')
      WorkflowProject.create(:role_id => 1, :field_name => field_id.to_s, :rule => 'readonly')

      WorkflowProject.create(:role_id => 2, :field_name => "name", :rule => 'readonly')
      WorkflowProject.create(:role_id => 2, :field_name => "description", :rule => 'readonly')
      WorkflowProject.create(:role_id => 2, :field_name => field_id.to_s, :rule => 'readonly')

      read_only_fields = project.read_only_attribute_names(user)

      expect(read_only_fields.size).to eq(3)
      expect(read_only_fields).to include("name")
    end

    it "does not return any fields that are not set as read-only for one of the user roles" do
      user = User.find(2)
      field_id = custom_fields.first.id
      member = Member.find(1) # this member is with user_id 2, project_id 1, and role_id 1 manager
      member.roles << Role.find(2)
      member.save

      WorkflowProject.create(:role_id => 1, :field_name => "name", :rule => 'readonly')
      WorkflowProject.create(:role_id => 1, :field_name => "description", :rule => 'readonly')
      WorkflowProject.create(:role_id => 1, :field_name => field_id.to_s, :rule => 'readonly')

      WorkflowProject.create(:role_id => 2, :field_name => "description", :rule => 'readonly')
      WorkflowProject.create(:role_id => 2, :field_name => field_id.to_s, :rule => 'readonly')

      read_only_fields = project.read_only_attribute_names(user)

      expect(read_only_fields.size).to eq(2)
      expect(read_only_fields).to include("description")
      expect(read_only_fields).to_not include("name")
    end

    it "returns all fields set as read-only for all user roles when one of the roles is not in workflow_project_roles" do
      user = User.find(2)
      field_id = custom_fields.first.id
      Role.create!(:name => 'Test') # role does not have the permission update project

      member = Member.find(1) # this member is with user_id 2 ,project_id 1 ,and it has one role 1 manager
      member.roles << Role.find(2)
      member.roles << Role.last
      member.save

      WorkflowProject.create(:role_id => 1, :field_name => "name", :rule => 'readonly')
      WorkflowProject.create(:role_id => 1, :field_name => "description", :rule => 'readonly')
      WorkflowProject.create(:role_id => 1, :field_name => field_id.to_s, :rule => 'readonly')

      WorkflowProject.create(:role_id => 2, :field_name => "name", :rule => 'readonly')
      WorkflowProject.create(:role_id => 2, :field_name => "description", :rule => 'readonly')
      WorkflowProject.create(:role_id => 2, :field_name => field_id.to_s, :rule => 'readonly')

      read_only_fields = project.read_only_attribute_names(user)

      expect(read_only_fields.size).to eq(3)
      expect(read_only_fields).to include("name")
    end
  end

  describe "Project/get_read_only_attribute_for_roles" do
    it "returns all fields when they are set as read-only for every role" do
      field_id = custom_fields.first.id
      roles = Role.workflow_project_roles

      roles.each do |role|
        WorkflowProject.create(:role_id => role.id, :field_name => "name", :rule => 'readonly')
        WorkflowProject.create(:role_id => role.id, :field_name => "description", :rule => 'readonly')
        WorkflowProject.create(:role_id => role.id, :field_name => field_id.to_s, :rule => 'readonly')
      end

      read_only_fields = Project.get_read_only_attribute_for_roles(roles)
      expect(read_only_fields.size).to eq(3)
    end

    it "exclusively returns fields set as read-only for all roles" do
      field_id = custom_fields.first.id
      roles = Role.workflow_project_roles

      roles.each do |role|
        WorkflowProject.create(:role_id => role.id, :field_name => "name", :rule => 'readonly')
        WorkflowProject.create(:role_id => role.id, :field_name => field_id.to_s, :rule => 'readonly')
      end

      WorkflowProject.create(:role_id => roles.first.id, :field_name => "description", :rule => 'readonly')
      read_only_fields = Project.get_read_only_attribute_for_roles(roles)
      expect(read_only_fields.size).to eq(2)
    end

  end
end
