require 'spec_helper'

describe ProjectsController, type: :controller do

  render_views

  fixtures :projects, :users, :roles, :members, :member_roles , :custom_fields, :custom_values, :custom_fields_projects

  include Redmine::I18n

  before do
    @controller = ProjectsController.new
    @request = ActionDispatch::TestRequest.create
    @response = ActionDispatch::TestResponse.new
    User.current = nil
    @request.session[:user_id] = 2 # permissions are hard
  end

  def setAuthorizationAPI(user, password = nil)
    Setting.rest_api_enabled = '1'
    request.headers['Authorization'] =  ActionController::HttpAuthentication::Basic.encode_credentials(user, password || user)
  end


  describe "Update project" do
    let(:core_fields) { Project::CORE_FIELDS }
    let(:custom_fields) { CustomField.where(type: "ProjectCustomField" ) }
    let(:roles) { Role.sorted.select(&:consider_workflow?) }
    let(:project) { Project.find(1) }
    it "Should allow update all fields when user admin" do
      admin = User.find(1)
      User.current = admin
      @request.session[:user_id] = 1
      field_id = custom_fields.first.id

      roles.each do |role|
        WorkflowProject.create(:role_id => role.id, :field_name => "name", :rule => 'readonly')
        WorkflowProject.create(:role_id => role.id, :field_name => "description", :rule => 'readonly')
        WorkflowProject.create(:role_id => role.id, :field_name => "#{field_id}", :rule => 'readonly')
      end

      name_test = "new_name"
      description_test = "new_description"
      field_test = "Beta"

      patch :update, params: { id: project.id,
                      project: { name: name_test, description: description_test, :custom_field_values => { "#{field_id}" => field_test } }
                    }
      project.reload

      expect(project.name).to eq(name_test)
      expect(project.description).to eq(description_test)
      expect(project.custom_field_values.first.value).to eq(field_test)

    end

    it "Should regect the non-editable fields" do
      field_id = custom_fields.first.id
      roles.each do |role|
        WorkflowProject.create(:role_id => role.id, :field_name => "name", :rule => 'readonly')
        WorkflowProject.create(:role_id => role.id, :field_name => "description", :rule => 'readonly')
        WorkflowProject.create(:role_id => role.id, :field_name => "#{field_id}", :rule => 'readonly')
      end

      name_test = "new_name"
      description_test = "new_description"
      field_test = "Beta"
      patch :update, params: { id: project.id,
                      project: { name: name_test, description: description_test, :custom_field_values => { "#{field_id}" => field_test } }
                    }
      project.reload

      expect(project.name).to_not eq(name_test)
      expect(project.description).to_not eq(description_test)
      expect(project.custom_field_values.first.value).to_not eq(field_test)
    end

    it "Should modify fields that are not designated as read-only for one of the assigned role(s) of user" do
      field_id = custom_fields.first.id
      member = Member.find(1) # this member is with user_id 2 ,project_id1 ,and it has one role 1 manager.
      member.roles << Role.find(2)
      member.save


      WorkflowProject.create(:role_id => 1, :field_name => "name", :rule => 'readonly')
      WorkflowProject.create(:role_id => 1, :field_name => "description", :rule => 'readonly')
      WorkflowProject.create(:role_id => 1, :field_name => "#{field_id}", :rule => 'readonly')

      WorkflowProject.create(:role_id => 2, :field_name => "description", :rule => 'readonly')
      WorkflowProject.create(:role_id => 2, :field_name => "#{field_id}", :rule => 'readonly')



      name_test = "new_name"
      description_test = "new_description"
      field_test = "Beta"

      patch :update, params: { id: project.id,
                      project: { name: name_test, description: description_test, :custom_field_values => { "#{field_id}" => field_test } }
                    }
      project.reload

      expect(project.name).to eq(name_test)
      expect(project.description).to_not eq(description_test)
      expect(project.custom_field_values.first.value).to_not eq(field_test)
    end
  end

  describe "Update project by API" do
    let(:core_fields) { Project::CORE_FIELDS }
    let(:custom_fields) { CustomField.where(type: "ProjectCustomField" ) }
    let(:roles) { Role.sorted.select(&:consider_workflow?) }
    let(:project) { Project.find(1) }

    it "Should modify fields that are not designated as read-only for one of the assigned role(s) of user api" do
      setAuthorizationAPI('jsmith', 'jsmith')
      field_id = custom_fields.first.id
      member = Member.find(1) # this member is with user_id 2 ,project_id1 ,and it has one role 1 manager.
      member.roles << Role.find(2)
      member.save


      WorkflowProject.create(:role_id => 1, :field_name => "name", :rule => 'readonly')
      WorkflowProject.create(:role_id => 1, :field_name => "description", :rule => 'readonly')
      WorkflowProject.create(:role_id => 1, :field_name => "#{field_id}", :rule => 'readonly')

      WorkflowProject.create(:role_id => 2, :field_name => "description", :rule => 'readonly')
      WorkflowProject.create(:role_id => 2, :field_name => "#{field_id}", :rule => 'readonly')


      name_test = "new_name"
      description_test = "new_description"
      field_test = "Beta"


      patch :update, params: {
        id: project.id,
        project: { name: name_test, description: description_test, :custom_field_values => { "#{field_id}" => field_test } },
        format: :json,
      }


      project.reload

      expect(project.name).to eq(name_test)
      expect(project.description).to_not eq(description_test)
      expect(project.custom_field_values.first.value).to_not eq(field_test)
    end
    it "Should allow update all fields when user admin" do
      User.current = User.find(1)
      @request.session[:user_id] = 1
      setAuthorizationAPI('admin', 'admin')

      field_id = custom_fields.first.id

      roles.each do |role|
        WorkflowProject.create(:role_id => role.id, :field_name => "name", :rule => 'readonly')
        WorkflowProject.create(:role_id => role.id, :field_name => "description", :rule => 'readonly')
        WorkflowProject.create(:role_id => role.id, :field_name => "#{field_id}", :rule => 'readonly')
      end

      name_test = "new_name"
      description_test = "new_description"
      field_test = "Beta"

      patch :update, params: { id: project.id,
                      project: { name: name_test, description: description_test, :custom_field_values => { "#{field_id}" => field_test } }
                    }
      project.reload

      expect(project.name).to eq(name_test)
      expect(project.description).to eq(description_test)
      expect(project.custom_field_values.first.value).to eq(field_test)
    end
  end
end