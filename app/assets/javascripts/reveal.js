$( document ).ready(function() {

  $('.reveal-link').click(function(event) {
    event.preventDefault();
    var parent = findParentofRevealableElements($(this));
    firstHiddenChild(parent).slideToggle('fast')
    if( noHiddenChildren(parent) ) { toggleDisableable($(this)); }
  });

  $('.hide-link').click(function(event) {
    event.preventDefault();
    $(this).closest('fieldset').slideToggle('fast');
    $(this).closest('fieldset').find('.clearable').val('');
    var selection = findParentofRevealableElements($(this));
    if(anyVisibleChildren(selection)) {
      toggleDisableable($(selection).children('.reveal-link'));
     }
  });

  $('.destroy-link').click(function(event) {
    event.preventDefault();
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').find('.clearable').prop('disabled', true)
  });

  function findParentofRevealableElements(element) {
    return element.closest('.reveal-parent');
  }

  function noHiddenChildren(element) {
    return element.children('.revealable:hidden:first').length === 0;
  }

  function firstHiddenChild(element) {
    return element.children('.revealable:hidden:first');
  }

  function anyVisibleChildren(element) {
    return element.children('.revealable:visible:first').length > 0;
  }

  function toggleDisableable(element) {
    element.toggleClass('disabled');
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
