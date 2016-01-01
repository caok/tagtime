//= require jquery
//= require jquery_ujs
//= require jquery.caret.min
//= require jquery.atwho.min
//= require react
//= require react_ujs
//= require moment.min
//= require daterangepicker
//= require highcharts
//= require chartkick
//= require select2
//= require_tree .

$(document).ready(function(){
  Highcharts.setOptions({
    lang: {
            thousandsSep: ','
          }
  });

  $('input[name="date_range"]').daterangepicker({
    ranges: {
      'This Week': [moment().startOf('week').add(1, 'days'), moment().endOf('week').add(1, 'days')],
      'Last 7 Days': [moment().subtract(6, 'days'), moment()],
      'This Month': [moment().startOf('month'), moment().endOf('month')],
      'Last 30 Days': [moment().subtract(29, 'days'), moment()],
      'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
    }
  });
});
