require 'spec_helper'

describe WatchersController, type: :controller do
  render_views

  fixtures :users, :roles, :custom_fields #, :workflow_projects

  include Redmine::I18n

  before do
    @controller = WorkflowsController.new
    @request = ActionDispatch::TestRequest.create
    @response = ActionDispatch::TestResponse.new
    Setting.default_language = 'en'
    User.current = nil
    @request.session[:user_id] = 1 # permissions admin
  end

  describe "workflow projects" do

    let(:core_fields) { Project::CORE_FIELDS }
    let(:custom_fields) { ProjectCustomField.all }
    let(:roles) { Role.workflow_project_roles }

    it "returns a successful response for new tab projects" do
      get :projects
      expect(response).to have_http_status(:success)
    end

    it "displays all core and custom fields of project" do
      get :projects, :params => { role_id: 'all' }

      core_fields.each do |field|
        expect(response.body).to have_selector('td', text: l("field_" + field.sub(/_id$/, '')))
      end

      custom_fields.each do |field|
        expect(response.body).to have_selector("a", text: field.name)
      end
    end

    it "displays all roles when all roles are selected" do
      get :projects, :params => { role_id: 'all' }

      expect(response).to have_http_status(:success)
      expect(response.body).to have_css('select#role_id option[selected="selected"]', text: 'all')

      roles.each do |role|
        expect(response.body).to have_selector('td', text: role.name)
        core_fields.each do |field|
          expect(response.body).to have_selector("select[name='permissions[#{role.id}][#{field}]']")
        end

        custom_fields.each do |field|
          expect(response.body).to have_selector("select[name='permissions[#{role.id}][#{field.id}]']")
        end
      end
    end

    it "displays one role when one is selected" do
      role_id = roles.first.id
      get :projects, :params => { role_id: role_id }

      expect(response).to have_http_status(:success)
      expect(response.body).to have_css('select#role_id option[selected="selected"]', text: Role.find(1).name)

      roles.each do |role|
        core_fields.each do |field|
          if role.id == role_id
            expect(response.body).to have_selector("select[name='permissions[#{role.id}][#{field}]']")
          else
            expect(response.body).to_not have_selector("select[name='permissions[#{role.id}][#{field}]']")
          end
        end

        custom_fields.each do |field|
          if role.id == role_id
            expect(response.body).to have_selector("select[name='permissions[#{role.id}][#{field.id}]']")
          else
            expect(response.body).to_not have_selector("select[name='permissions[#{role.id}][#{field.id}]']")
          end
        end
      end
    end

    it "adds Workflows projects for selected roles and fields" do
      role_id_1 = roles.first.id
      role_id_2 = roles.last.id

      custom_field_id = custom_fields.first.id

      expect do
        post :projects, :params => {
          :role_id => roles.map(&:id),
          :permissions => {
            role_id_1 => { "name" => "readonly", "description" => "readonly", custom_field_id => "readonly" },
            role_id_2 => { "is_public" => "readonly", "description" => "readonly", custom_field_id => "readonly" },
          }
        }
      end.to change { WorkflowProject.count }.by(6)

      expect(WorkflowProject.where(:role_id => role_id_1, :field_name => "name").first.rule).to eq("readonly")
      expect(WorkflowProject.where(:role_id => role_id_2, :field_name => "is_public").first.rule).to eq("readonly")
      expect(WorkflowProject.where(:role_id => role_id_1, :field_name => custom_field_id).first.rule).to eq("readonly")
      expect(WorkflowProject.where(:role_id => role_id_2, :field_name => custom_field_id).first.rule).to eq("readonly")
    end

  end
end
