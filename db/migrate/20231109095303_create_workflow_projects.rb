class CreateWorkflowProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :workflow_projects do |t|
      t.column :role_id, :integer, :null => false
      t.column :field_name, :string, :limit => 30
      t.column :rule, :string, :limit => 30
    end
    add_index :workflow_projects, [:role_id], :name => :index_workflow_projects_role_id
  end
end
