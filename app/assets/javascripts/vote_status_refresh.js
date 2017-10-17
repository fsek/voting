function refresh() {
  var $voteStatus = $('#vote-status');
  var voteStatus;
  var position;

  if ($voteStatus.length) {
    position = $voteStatus.data('position');
    voteStatus = setInterval(refreshPartial, 15000);
  }

  function refreshPartial() {
    $voteStatus = $('#vote-status');
    if ($voteStatus.length && $voteStatus.data('position') == position) {
      $.ajax({
        url: '/admin/voteringar',
        method: 'GET'
      })
    } else {
      clearInterval(voteStatus);
    }
  }
};

$(document).on('turbolinks:load', refresh);
