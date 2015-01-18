
$(document).ready(function() {
  $('.my-menu > li').bind('mouseover', openSubMenu);
  $('.my-menu > li').bind('mouseout', closeSubMenu);

  function openSubMenu() {
    $(this).find('ul').css('visibility', 'visible');
  };

  function closeSubMenu() {
    $(this).find('ul').css('visibility', 'hidden');
  };

});
