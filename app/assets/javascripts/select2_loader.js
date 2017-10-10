const sel = function() {
  $('.select2-single').select2({
    theme: 'bootstrap'
  });
};

const selTag = function() {
  $('.select2-tags').select2({
    tags: true,
    theme: 'bootstrap'
  });
};

// Turbolinks 5 fix
const clear = function() {
  $('.select2-single').select2('destroy');
  $('.select2-tags').select2('destroy');
};

$(document).on('turbolinks:load', sel);
$(document).on('turbolinks:load', selTag);
$(document).on('turbolinks:before-cache', clear);
