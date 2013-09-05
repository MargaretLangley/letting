$( document ).ready(function() {

  // current panel switch code
  $('.toggle').click(function(event) {
    event.preventDefault();
    doToggle($(this));
  });

  function doToggle(toggle) {
    var toggleSelection = toggle.closest('.toggle-selection');
    togglableChildren(toggleSelection).slideToggle('fast');
    toggle.trigger('testEventHandler');
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


   // this custom event is to separate the entity specific code from
   // the toggle code.
   $('.entity-event').on('testEventHandler', function() {
      var toggleSelection = $(this).closest('.toggle-selection');
      toggleSelection.children('.model_type').val($(this).data('model-type-to'));
   });

  $(onWindowLoad);

});

