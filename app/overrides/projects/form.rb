Deface::Override.new :virtual_path  => 'projects/_form',
                     :name          => 'disable-standard-custom-fields',
                     :insert_bottom => "div.box",
                     :text          => <<SCRIPT
<script type="text/javascript">
  // Wait until all plugins override the form if it is required.
  document.addEventListener("DOMContentLoaded", function() {
    const attribute_names = "<%= @project.read_only_attribute_names(User.current).join(",") %>";
    for (const attribute of attribute_names.split(",")) {
      let element = document.querySelector(`#project_${attribute}`) ||
          document.querySelector(`#project_custom_field_values_${attribute}`) ||
          document.querySelectorAll(`input[name="project[custom_field_values][${attribute}][]"`);
      if (element !== null) {
        // Check if obj is an HTML element
        if (element instanceof Element){
          // Set the 'disabled' property to true to disable this element
          element.disabled = true;
        } else if (NodeList.prototype.isPrototypeOf(element)) { // Check if obj is a NodeList
          for(const el of element) {
            el.disabled = true;
          }
        }
      }
    }
  });
</script>
SCRIPT
