$(document).ready(function() {
  $("div[data-link]").click(function() {
    window.location = $(this).data("link");
  });
});