var TagIssues = (function($){
  var issues, html, regs;
  var cache = {};

  var test_data = {
    1: "2h30m", 2: "1h30m", 3: "30m"
  }

  var fetch_data = function(){
    // should fetch issue according to issue state(open, closed)
    return test_data;
  };

  var init_cache = function(){
    cache.$issues = $(".issue-meta");
    cache.data = fetch_data();
    cache.regs = { 
      issue: /^#(\d+)/i //"#3 opend 22 minutes ago"
    };
  }; 
  init_cache();

  var get_time_of_issue = function(text){ 
    var an = text.trim().match(cache.regs.issue); 
    return cache.data[an[1]];
  };

  var init_issues = function(){ 
    cache.$issues.each(function(){ 
      time = get_time_of_issue($(this).text());
      $('<span />').text(time).addClass("tag_time").appendTo($(this)); 
    });
  };

  return {
    init: init_issues
  }
})(jQuery);

TagIssues.init();
