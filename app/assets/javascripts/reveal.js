$( document ).ready(function() {

  $('.reveal-partial').click(function(event) {
    event.preventDefault();
    var parent = findParentofRevealableElements($(this));
    firstHiddenChild(parent).slideToggle('fast')
    if( noHiddenChildren(parent) ) { toggleDisableable($(this)); }
  });

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

  $('.hide-partial').click(function(event) {
    event.preventDefault();
    $(this).closest('.revealable').slideToggle('fast');
    findClearable($(this).closest('.revealable')).val("");;
    var selection = findParentofRevealableElements($(this));
    if(anyVisibleChildren(selection)) {
      toggleDisableable($(selection).children('.reveal-partial'));
    }
    // $(this).prev('input[type=hidden]').val('1')
  });

  function anyVisibleChildren(element) {
    return element.children('.revealable:visible:first').length > 0;
  }

  function findClearable(element) {
    return element.find('.clearable');
  }

  $('.remove-fields').click(function(event) {
    event.preventDefault();
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('.selection').slideToggle('fast')
  });

  // current panel switch code
  $('.toggle').click(function(event) {
    event.preventDefault();
    var selection = $(this).closest('.toggle-selection');
    togglableChildren(selection).slideToggle('fast')
  });

  function togglableChildren(element) {
    return element.children('.togglable');
  }

  $('.checkbox-toggle').click(function(event) {
    var selection = $(this).closest('.selection');
    togglableChildren(selection).slideToggle('fast');
  });

});
