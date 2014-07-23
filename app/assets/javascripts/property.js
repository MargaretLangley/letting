$(function () {

  $("#property_entity_add").click(function(event){
    $("#property_entity_1").css("display", "block");
    event.preventDefault();
  });

  // charges-due-on toggle: on-date => every-month
  // change month input to -1
  //
  $('.js-every-month').on('change', function() {
    $(this).next('input[type=hidden]').val('-1');
  });

  // hiding a panel when button clicked
  // this could be used elsewhere in program
  $('.js-remove-fields').click(function(event) {
    event.preventDefault();
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('.js-selection').slideToggle('fast');
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
