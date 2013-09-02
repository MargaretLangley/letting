$( document ).ready(function() {

  $('.reveal-link').click(function(event) {
    event.preventDefault();
    var parent = findParentofRevealableElements($(this));
    firstHiddenChild(parent).slideToggle('fast')
    if( noHiddenChildren(parent) ) { toggleDisableable($(this)); }
  });

  $('.hide-link').click(function(event) {
    event.preventDefault();
    $(this).closest('.revealable').slideToggle('fast');
    findClearable($(this).closest('.revealable')).val("");;
    var selection = findParentofRevealableElements($(this));
    if(anyVisibleChildren(selection)) {
      toggleDisableable($(selection).children('.reveal-link'));
     }
    $(this).prev('input[type=hidden]').val('1')
    console.log( $(this).prev('input[type=hidden]').val() );
  });


  // $('.destroy-link').click(function(event)) {
  //   event.preventDefault();
  // }

  function noHiddenChildren(element) {
    return element.children('.revealable:hidden:first').length === 0;
  }

  function firstHiddenChild(element) {
    return element.children('.revealable:hidden:first');
  }

  function findParentofRevealableElements(element) {
    return element.closest('.reveal-selection');
  }

  function toggleDisableable(element) {
    element.toggleClass('disabled');
  }

  function anyVisibleChildren(element) {
    return element.children('.revealable:visible:first').length > 0;
  }

  function findClearable(element) {
    return element.find('.clearable');
  }

  function onWindowLoad() {
     var parent = findParentofRevealableElements($('.reveal-link'));
     if( noHiddenChildren(parent) ) { toggleDisableable($('.reveal-link')); }
  }

  $(onWindowLoad);

});
