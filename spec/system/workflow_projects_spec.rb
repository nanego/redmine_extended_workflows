require "spec_helper"
require "active_support/testing/assertions"

RSpec.describe "workflow projects", type: :system do

  fixtures :roles, :users, :projects

  before do
    log_user('admin', 'admin')
  end

  it "link Set All readonly, No read-only fields " do
    visit 'workflows/projects'

    find('input[type="submit"][value="Edit"]').click

    all('a', text: "Set All readonly", minimum: 2)[0].click
    all('a', text: "Set All readonly", minimum: 2)[1].click
    select_elements = all('select[name^="permissions"]')

    # Check that the selected options are the same for all select elements and have readonly value
    select_elements.each do |elem|
      expect(elem.value).to eq("readonly")
    end

    all('a', text: "No read-only fields", minimum: 2)[0].click
    all('a', text: "No read-only fields", minimum: 2)[1].click
    select_elements = all('select[name^="permissions"]')

    # Check that the selected options are the same for all select elements and do not have readonly value
    select_elements.each do |elem|
      expect(elem.value).to_not eq("readonly")
      expect(elem.value).to eq("")
    end

  end
end
