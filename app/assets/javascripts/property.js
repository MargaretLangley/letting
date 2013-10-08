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

});

