
function setBlockDisplay(elId,fieldset)
{
  if (document.getElementById(elId).value.length > 0)
  {
    document.getElementById(fieldset).style.display="block";
  }
  else
  {
    document.getElementById(fieldset).style.display="none";
  }
}

function setFieldDisplay(elId)
{
  if (document.getElementById(elId).value.length > 0)
  {
    document.getElementById(elId).style.visibility="visible";
  }
  else
  {
    document.getElementById(elId).style.visibility="hidden";
  }
}

function changeFieldDisplay(elId)
{
  document.getElementById(elId).style.visibility="visible";
}


function toggleFieldDisplay(fieldset,buttonId,addText,removeText)
{
  if (document.getElementById(fieldset).style.display == 'none')
  {
    document.getElementById(fieldset).style.display="block";
    document.getElementById(buttonId).innerHTML = removeText;
   }
   else
   {
   document.getElementById(fieldset).style.display="none";
   document.getElementById(buttonId).innerHTML = addText;
  }
}

$(function () {
  $("#property_charge_1").css("display", "none");
  $("#property_charge_2").css("display", "none");
  $("#property_charge_3").css("display", "none");

  $("#client_entity_0 > h3").html("Person/Company");
  $("#client_entity_0 > closeBut").css("display", "none");
  $("#company_wanted").click(function(event){
    //  $("#company_name").css("display", "block");
    //  $("#client_entity_0").css("display", "none");
    $("#client_entity_0 > h3").html("Person/Company");
    $("#client_entities_attributes_0_title").siblings("label").css("display", "none");
    $("#client_entities_attributes_0_initials").siblings("label").css("display", "none");
    $("#client_entities_attributes_0_initials").css("display", "none");
    $("#client_entities_attributes_0_title").css("display", "none");
     event.preventDefault();
  });

 if ($("#property_billing_profile_attributes_use_profile").is(':checked')) {
   } else {
     $("#property_billing_profile_address").css("display", "none");
     $("#billing_profile_entity_0").css("display", "none");
  }

$("#client_entity_add").click(function(event){
  $("#client_entity_1").css("display", "block");
  event.preventDefault();
  });

$("#property_entity_add").click(function(event){
  $("#property_entity_1").css("display", "block");
  event.preventDefault();
  });

$("#billing_entity_add").click(function(event){
  $("#billing_profile_entity_1").css("display", "block");
  event.preventDefault();
  });

  $('#property_billing_profile_attributes_use_profile').change(function () {
    $('#blank_slate').toggle(!this.checked);
  }).change(); //ensure visible state matches initially


  $("#property_billing_profile_attributes_use_profile").click(function(event){
    if ($("#property_billing_profile_attributes_use_profile").is(':checked')) {
        $("#property_billing_profile_address").css("display", "block");
       $("#billing_profile_entity_0").css("display", "block");
     }
  event.preventDefault();
  });

 $("#addCharge").click(function(event){
   $("#property_charge_1").css("display", "block");
  event.preventDefault();
  });

  $("#removeBut").click(function(event){
  $("#property_charge_1").css("display", "none");
  event.preventDefault();
  });

 });


