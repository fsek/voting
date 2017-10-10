const adjustment = function () {
  $('td, th', '#adjustments-sortable').each(function() {
    const cell = $(this);
    return cell.width(cell.width());
  });

  $('#adjustments-sortable').sortable({
    axis: 'y',
    items: '.item',
    cursor: 'move',
    forcePlaceholderSize: true,
    placeholder: 'must-have-class',

    start(e, ui) {
      let cellCount = 0;
      $('td, th', ui.helper).each(function() {
        let colspan = 1;
        const colspanAttr = $(this).attr('colspan');
        if (colspanAttr > 1) {
          colspan = colspanAttr;
        }
        return cellCount += colspan;
      });
      return ui.placeholder.html(`<td colspan="${cellCount}">&nbsp</td>`);
    },

    sort(e, ui) {
      return ui.item.addClass('active-item-shadow');
    },
    stop(e, ui) {
      return ui.item.removeClass('active-item-shadow');
    },
    update(e, ui) {
      const item_id = ui.item.data('item-id');
      const position = ui.item.index();
      return $.ajax({
        type: 'POST',
        url: '/admin/justering/update_row_order',
        dataType: 'json',
        data: { id: item_id, adjustment: {row_order_position: position } },
        success() {
          return ui.item.children('td').effect('highlight', { color: '#fc9800'}, 3000);
        },
        error(response) {
          jQuery('#adjustments-sortable').sortable('cancel');
          jQuery('#adjustments-sortable').sortable('disable');
          return alert('Sorteringen misslyckades. Ladda om sidan!');
        }
      });
    }
  });

  $('.adjustments-deleterow').on('click', function() {
    if (confirm('Är du helt säker på att du vill ta bort justeringen?')) {
      const $row = $(this).parent('tr');
      return $.ajax({
        type: 'POST',
        url: `/admin/justering/${$row.data('item-id')}`,
        dataType: 'json',
        data: { '_method': 'delete' },
        success() {
          $row.addClass('danger');
          return $row.fadeOut(3000, function() {
            return $(this).remove();
          });
        },
        error() {
          return alert('Det gick inte att ta bort justeringen');
        }
      });
    }
  });
};

$(document).on('turbolinks:load', adjustment);
