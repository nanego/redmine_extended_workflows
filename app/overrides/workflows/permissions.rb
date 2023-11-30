Deface::Override.new :virtual_path  => 'workflows/permissions',
                     :name          => 'add-workflows-projects-tab',
                     :insert_after  => '.tabs ul li:last',
                     :text          => "<li><%= link_to l(:label_fields_projects), '/workflows/projects' %></li>"
