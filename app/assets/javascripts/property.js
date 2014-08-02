$(function () {

  // charges-due-on toggle: on-date => every-month
  // change month input to -1
  //
  $('.js-every-month').on('change', function() {
    $(this).next('input[type=hidden]').val('-1');
  });

  return $('#property_client_ref').autocomplete({
    source: $('#property_client_ref').data('autocomplete-source'),
    select: function(event, ui) {
      event.preventDefault();
      $(this).val(ui.item.label);
      return $('#client_id').val(ui.item.value);
    }
  });

});
