$( document ).ready(function() {

  // current panel switch code
  $('.toggle').click(function(event) {
    event.preventDefault();
    doToggle($(this));
  });

  $('.checkbox-toggle').click(function(event) {
    doToggle($(this));
  });

  function doToggle(toggle) {
    var toggleSelection = toggle.closest('.toggle-selection');
    findTogglable(toggleSelection).slideToggle('fast');
    toggle.trigger('toggleEventHandler');
  }

  function findTogglable(element) {
    return element.find('.togglable');
  }

  function onWindowLoad() {
    $('.toggleOnStart').toggle();
  }

   // this custom event is to separate the entity specific code from
   // the toggle code.
  $('.entity-event').on('toggleEventHandler', function() {
    var toggleSelection = $(this).closest('.toggle-selection');
    toggleSelection.find('.model_type').val($(this).data('model-type-to'));
  });


  $('.charges').on('toggleEventHandler', function() {
    $(this).find(':input').val('');
  });

  $('.every-month').on('change', function() {
    $(this).next('input[type=hidden]').val('-1');
  });

  $(onWindowLoad);

});

