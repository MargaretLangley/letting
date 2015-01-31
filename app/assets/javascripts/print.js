$( document ).ready(function() {
  // js print window
  $('.js-print').click(function() {
    window.print();
    return false;
  });

  $('.js-print_section').click(function() {
    alert('print section');
    var prtSection = document.getElementById('print-account');
    var WinPrint = window.open('', '', 'left=0,top=0,width=800,height=900,toolbar=0,scrollbars=0,status=0');

    // stylesheet insertion into js
    // WinPrint.document.write("<link href='/stylesheets/report.css' media='print' rel='stylesheet' type='text/css' />\n");
    // stylesheet_link_tag 'print', media: 'print', 'data-turbolinks-track' => true


    WinPrint.document.write(prtSection.innerHTML);
    WinPrint.document.write('print')
    WinPrint.document.close();
    WinPrint.focus();
    WinPrint.print();
    WinPrint.close();
    return false;
 });
});

function print_n_ret() {
  window.print();
  history.go(-1);
  return false;
}
