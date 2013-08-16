function setElementDisplayNone()
 {
    document.getElementById('property_entity_1').style.display="none";
    document.getElementById('property_billing_profile_entity_1').style.display="none";
    document.getElementById('client_entity_1').style.display="none";
     var currentDisplay = document.getElementById(elId).style.display;
      if (currentDisplay == 'none')    alert("currentDisplay none");

}

function changeElementDisplay(elId)
 {
    var currentDisplay = document.getElementById(elId).style.display;

    if (currentDisplay == 'none')
    {
      document.getElementById(elId).style.display="block";
     }
    else
    {
     document.getElementById(elId).style.display="none";
    }
}