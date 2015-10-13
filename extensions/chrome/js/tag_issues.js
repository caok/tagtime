var TagIssues = (function($){
  var issues, html;
  var jq_mapping = {};

  var init_jquery_mapping = function(){
    jq_mapping.$issues = $(".issue-meta")
  };

  init_jquery_mapping();

  var init_issues = function(){ 
    jq_mapping.$issues.each(function(){ 
      $('<span />').text("2h:30m").addClass("tag_time").appendTo($(this)); 
    });
  };

  return {
    init: init_issues
  }
})(jQuery);

TagIssues.init();
