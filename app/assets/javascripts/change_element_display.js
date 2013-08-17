function setElementDisplayNone()
{
  if (document.getElementById('client_entity_1') != undefined)
  {
    document.getElementById('client_entity_1').style.display="none";
  }
  else
  {
    document.getElementById('property_entity_1').style.display="none";
    document.getElementById('property_billing_profile_entity_1').style.display="none";
    document.getElementById('changeBillingDisplay').innerHTML = "Add Person";
  }
  document.getElementById('changeDisplay').innerHTML = "Add Person";
}

function changeElementDisplay(elId)
 {
    var currentDisplay = document.getElementById(elId).style.display;
    var buttonString = "Remove Person";

    if (currentDisplay == 'none'){document.getElementById(elId).style.display="block";}
    else
    {
     document.getElementById(elId).style.display="none";
     buttonString = "Add Person";
    }

    if (elId == 'property_entity_1'|| elId == 'client_entity_1'){
            document.getElementById('changeDisplay').innerHTML = buttonString;
    }
    else {document.getElementById('changeBillingDisplay').innerHTML = buttonString;}
}