
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


function addFieldDisplay(fieldset0,fieldset1,fieldset2,buttonId)
{
  var chargefields = new Array(fieldset0,fieldset1,fieldset2);
  var foundblockspace = false;
  var count = -1;

  while (foundblockspace === false)
  {
    count = count+1;
  //  alert(count);
    if (document.getElementById(chargefields[count]).style.display == 'none')
    {
     document.getElementById(chargefields[count]).style.display="block";
    foundblockspace = true;
    }
    if (count == 2)
    {
      foundblockspace = true;
   //   alert("true "+count);
  //    document.getElementById(buttonId).style.visibility="hidden";
    }
   }
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

  $("#removeBut").click(function(event){
  $("#property_charge_1").css("display", "none");
  event.preventDefault();
  });
  // Test functions
  $("#test2").css("display", "none");

  $("#swopBut").click(function(event){
    if($("#test1").css("display") == "none") {
      $("#test1").css("display", "block");
     $("#test2").css("display", "none");
     } else {
     $("#test1").css("display", "none");
     $("#test2").css("display", "block");
    }
  event.preventDefault();
  });
});





