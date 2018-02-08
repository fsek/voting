function loadSelect2() {
  $('.select2-single').select2({
    theme: 'bootstrap',
    width: 'resolve'
  });
};

function loadSelect2Tags() {
  $('.select2-tags').select2({
    tags: true,
    theme: 'bootstrap'
  });
};

// Turbolinks 5 fix
function clearSelect2() {
  $('.select2-single').select2('destroy');
  $('.select2-tags').select2('destroy');
};

$(document).on('turbolinks:load', loadSelect2);
$(document).on('turbolinks:load', loadSelect2Tags);
$(document).on('turbolinks:before-cache', clearSelect2);
