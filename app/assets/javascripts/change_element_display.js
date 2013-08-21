
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


function toggleFieldDisplay(fieldset,buttonId)
{
  if (document.getElementById(fieldset).style.display == 'none')
  {
    document.getElementById(fieldset).style.display="block";
    document.getElementById(buttonId).innerHTML = "Remove Person";
   }
   else
   {
   document.getElementById(fieldset).style.display="none";
   document.getElementById(buttonId).innerHTML = "Add Person";
  }
}

$(function () {
  $('#property_billing_profile_attributes_use_profile').change(function () {
    $('#blank_slate').toggle(!this.checked);
  }).change(); //ensure visible state matches initially
});

