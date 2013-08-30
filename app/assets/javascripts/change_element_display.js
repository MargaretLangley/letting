$(function () {

  $("#client_entity_0 > h3").html("Person/Company");
  $("#client_entity_0 > closeBut").css("display", "none");
  $("#company_wanted").click(function(event){
    //  $("#company_name").css("display", "block");
    //  $("#client_entity_0").css("display", "none");
    // $("#client_entity_0 > h3").html("Person/Company");
    // $("#client_entities_attributes_0_title").siblings("label").css("display", "none");
    // $("#client_entities_attributes_0_initials").siblings("label").css("display", "none");
    // $("#client_entities_attributes_0_initials").css("display", "none");
    // $("#client_entities_attributes_0_title").css("display", "none");
    //  event.preventDefault();
  });

  $('#property_billing_profile_attributes_use_profile').change(function () {
    $('#blank_slate').toggle(!this.checked);
    if ($('#property_billing_profile_attributes_use_profile').is( ":checked" ) )
    {
      $("#property_billing_profile_address").css("display", "block");
      $("#billing_profile_entity_0").css("display", "block");
      $("#no_agent").css("display", "none");
    } else {
      $("#property_billing_profile_address").css("display", "none");
      $("#billing_profile_entity_0").css("display", "none");
      $("#no_agent").css("display", "block");
    }
   }).change(); //ensure visible state matches initially

$("#property_entity_add").click(function(event){
  $("#property_entity_1").css("display", "block");
  event.preventDefault();
  });


 });
