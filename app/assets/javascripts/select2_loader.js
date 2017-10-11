function select() {
  $('.select2-single').select2({
    theme: 'bootstrap'
  });
};

function selectTag() {
  $('.select2-tags').select2({
    tags: true,
    theme: 'bootstrap'
  });
};

// Turbolinks 5 fix
function clear() {
  $('.select2-single').select2('destroy');
  $('.select2-tags').select2('destroy');
};

$(document).on('turbolinks:load', select);
$(document).on('turbolinks:load', selectTag);
$(document).on('turbolinks:before-cache', clear);
