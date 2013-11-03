$(function () {

  // Billing profile is hidden by default. This will display an element
  // if present on the property

  if ($("#property_billing_profile_attributes_use_profile").is(':checked')) {
    $("#no_agent").css("display", "none");
    $("#blank_slate").css("display", "none");
    $("#agent_entity").css("display", "block");
    $("#agent_address").css("display", "block");
  }

  $("#property_entity_add").click(function(event){
    $("#property_entity_1").css("display", "block");
    event.preventDefault();
  });

  // charges - due-on toggling
  // clears the input each time a due-on is switched from monthly to on-date
  $('.charges').on('toggleEventHandler', function() {
    $(this).find(':input').val('');
  });


  // Minus one means every month
  $('.every-month').on('change', function() {
    $(this).next('input[type=hidden]').val('-1');
  });

  // hiding a panel when button clicked
  // this could be used elsewhere in program
  $('.remove-fields').click(function(event) {
    event.preventDefault();
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('.selection').slideToggle('fast');
  });

  // 1 JQuery - Select + Source Working
  // 2 JQuery - change working but not source
  // 3 Coffeescript - Select + Source

  // 1 select changes the label and data
  // Got it by converting 3 into JQuery
  // return $('#property_client_ref').autocomplete({
  //   source: $('#property_client_ref').data('autocomplete-source'),
  //   select: function(event, ui) {
  //     event.preventDefault();
  //     $(this).val(ui.item.label);
  //     return $('#client_id').val(ui.item.value);
  //   }
  // });

  // 2
  // http://stackoverflow.com/questions/6431459/jquery-autocomplete-trigger-change-event
  var client_ref = $("#property_client_ref").autocomplete({
      change: function() {
          alert('changed');
      }
   });
   client_ref.autocomplete('option','change').call(client_ref);

  // 3
  // http://stackoverflow.com/questions/13443012/rails-how-do-i-autocomplete-search-for-name-but-save-id
  // Equivalence in coffee script of the above method
  // jQuery ->
  // $('#property_client_ref').autocomplete
  //   source: $('#property_client_ref').data('autocomplete-source')
  //   select: (event, ui) ->

  //     # necessary to prevent autocomplete from filling in
  //     # with the value instead of the label
  //     event.preventDefault()

  //     $(this).val ui.item.label
  //     $('#client_id').val ui.item.value



});

