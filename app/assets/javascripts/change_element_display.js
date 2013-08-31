$(function () {

  $("#client_entity_0 > h3").html("Person/Company");
  $("#client_entity_0 > closeBut").css("display", "none");

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


 });

