jQuery(function() {
  $('td, th', '#adjustments-sortable').each(function() {
    var cell;
    cell = $(this);
    return cell.width(cell.width());
  });
  $('#adjustments-sortable').sortable({
    axis: 'y',
    items: '.item',
    cursor: 'move',
    forcePlaceholderSize: true,
    placeholder: 'must-have-class',
    start: function(e, ui) {
      var cellCount;
      cellCount = 0;
      $('td, th', ui.helper).each(function() {
        var colspan, colspanAttr;
        colspan = 1;
        colspanAttr = $(this).attr('colspan');
        if (colspanAttr > 1) {
          colspan = colspanAttr;
        }
        return cellCount += colspan;
      });
      return ui.placeholder.html('<td colspan="' + cellCount + '">&nbsp</td>');
    },
    sort: function(e, ui) {
      return ui.item.addClass('active-item-shadow');
    },
    stop: function(e, ui) {
      return ui.item.removeClass('active-item-shadow');
    },
    update: function(e, ui) {
      var item_id, position;
      item_id = ui.item.data('item-id');
      position = ui.item.index();
      return $.ajax({
        type: 'POST',
        url: '/admin/justering/update_row_order',
        dataType: 'json',
        data: {
          id: item_id,
          adjustment: {
            row_order_position: position
          }
        },
        success: function() {
          return ui.item.children('td').effect('highlight', {
            color: '#fc9800'
          }, 3000);
        },
        error: function(response) {
          jQuery('#adjustments-sortable').sortable('cancel');
          jQuery('#adjustments-sortable').sortable('disable');
          return alert('Sorteringen misslyckades. Ladda om sidan!');
        }
      });
    }
  });
});
