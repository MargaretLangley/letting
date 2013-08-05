function changeElementDisplay(elId)
 {
    var currentDisplay = document.getElementById(elId).style.display;

    if(currentDisplay == 'none')
    {
      document.getElementById(elId).style.display="block";
     }
    else
    {
     document.getElementById(elId).style.display="none";
    }
}