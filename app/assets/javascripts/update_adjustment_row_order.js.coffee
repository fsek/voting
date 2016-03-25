jQuery ->

  $('td, th', '#adjustments-sortable').each ->
    cell = $(this)
    cell.width cell.width()

  $('#adjustments-sortable').sortable(
    axis: 'y'
    items: '.item'
    cursor: 'move'
    forcePlaceholderSize: true,
    placeholder: 'must-have-class',

    start: (e, ui) ->
      cellCount = 0
      $('td, th', ui.helper).each ->
        colspan = 1
        colspanAttr = $(this).attr('colspan')
        if colspanAttr > 1
          colspan = colspanAttr
        cellCount += colspan
      ui.placeholder.html('<td colspan="' + cellCount + '">&nbsp</td>')

    sort: (e, ui) ->
      ui.item.addClass('active-item-shadow')
    stop: (e, ui) ->
      ui.item.removeClass('active-item-shadow')
    update: (e, ui) ->
      item_id = ui.item.data('item-id')
      position = ui.item.index()
      $.ajax(
        type: 'POST'
        url: '/admin/justering/update_row_order'
        dataType: 'json'
        data: { id: item_id, adjustment: {row_order_position: position } }
        success: ->
          ui.item.children('td').effect('highlight', { color: '#fc9800'}, 3000)
        error: (response) ->
          jQuery('#adjustments-sortable').sortable('cancel')
          jQuery('#adjustments-sortable').sortable('disable')
          alert('Sorteringen misslyckades. Ladda om sidan!')
      )
  )

  $('.adjustments-deleterow').on 'click', ->
    if confirm 'Är du helt säker på att du vill ta bort justeringen?'
      $row = $(this).parent('tr')
      $.ajax(
        type: 'POST'
        url: '/admin/justering/' + $row.data('item-id')
        dataType: 'json'
        data: { '_method': 'delete' }
        success: ->
          $row.addClass 'danger'
          $row.fadeOut 3000, ->
            $(this).remove()
        error: ->
          alert('Det gick inte att ta bort justeringen')
      )
