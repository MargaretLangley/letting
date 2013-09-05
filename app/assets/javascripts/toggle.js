$( document ).ready(function() {

  // current panel switch code
  $('.toggle').click(function(event) {
    event.preventDefault();
    doToggle($(this));
  });

  function doToggle(element) {
    var toggleSelection = element.closest('.toggle-selection');
    togglableChildren(toggleSelection).slideToggle('fast');
    toggleSelection.children('.model_type').val(element.data('model-type-to'));
  }

  $('.checkbox-toggle').click(function(event) {
    var selection = $(this).closest('.selection');
    togglableChildren(selection).slideToggle('fast');
  });

  function togglableChildren(element) {
    return element.children('.togglable');
  }

  function onWindowLoad() {
    $('.toggleOnStart').toggle();
  }

  $(onWindowLoad);

});

