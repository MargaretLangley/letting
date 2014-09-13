// Grid row click simulation
// see $table rows in module.css.scss
//
$(document).ready(function() {
  $("div[data-link]").click(function() {
    window.location = $(this).data("link");
  });
});