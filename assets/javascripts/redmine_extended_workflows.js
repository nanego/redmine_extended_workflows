function selectOptionForAll(parent_selector, element_selector, option) {
  $(parent_selector).find(`select[name^=${element_selector}]`).each(function() {
    $(this).val(option);
  })
}