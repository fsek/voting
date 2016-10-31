var sel;
sel = function() {
  $('.select2').select2({
    theme: 'bootstrap'
  });
};

var selTag;
selTag = function() {
  $('.select2_tags').select2({
    tags: true,
    theme: 'bootstrap'
  });
};

$(document).ready(sel);
$(document).on('page:load', sel);

$(document).ready(selTag);
$(document).on('page:load', selTag);
