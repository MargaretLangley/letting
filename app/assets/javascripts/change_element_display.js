
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
  $('#property_billing_profile_attributes_use_profile').change(function () {
    $('#blank_slate').toggle(!this.checked);
  }).change(); //ensure visible state matches initially
});

