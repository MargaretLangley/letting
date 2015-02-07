$(function () {

  // server side writes out the client options under a data tag
  // This is the readable by this JavaScript.
  // data-autocomplete-source= [
  //     {"label" "11 Mr Adams",  "value" :1},
  //     {"label" "12 Mr Botham", "value" :2}
  //     ]
  //
  return $('#property_client_ref').autocomplete({
    source: $('#property_client_ref').data('autocomplete-source'),
    select: function(event, ui) {
      event.preventDefault();
      $(this).val(ui.item.label);
      return $('#client_id').val(ui.item.value);
    }
  });

});
