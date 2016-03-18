$(document).on('page:change', function () {
  var $voteStatus = $('#vote-status');
  var voteStatus;

  if ($voteStatus.length) {
    voteStatus = setInterval(refreshPartial, 15000);
  }

  function refreshPartial() {
    $voteStatus = $('#vote-status');
    if ($voteStatus.length) {
      $.ajax({
        url: '/admin/voteringar/refresh',
        method: 'POST'
      })
    } else {
      clearInterval(voteStatus);
    }
  }
});
