var TagIssues = (function($){
  var ISSUE_API = 'http://localhost:3002/apis/issues'


  var issues, html, regs;
  var cache = {};

  var test_datas = [{"number":1,"time":"3h53m"},{"number":2,"time":"1h27m"},{"number":3,"time":"2h13m"},{"number":4,"time":"1h27m"},{"number":5,"time":"2h57m"},{"number":6,"time":"2h17m"},{"number":7,"time":"3h46m"},{"number":8,"time":"3h28m"},{"number":9,"time":"3h12m"},{"number":10,"time":"1h34m"}]

  var init_cache = function(){
    cache.$issues = $(".issue-meta");
    cache.regs = { 
      issue: /^#(\d+)/i //"#3 opend 22 minutes ago" 
    };
  }; 
  init_cache();

  var fetch_data = function(update){
    // should fetch issue according to issue state(open, closed)
    // $.get(ISSUE_API, function(datas){ 
    //   cache.datas = datas;
    //   update_issue();
    // })
    cache.datas = test_datas;
    update_issues();
  }; 

  var get_time_of_issue = function(text){ 
    var an = text.trim().match(cache.regs.issue); 
    var time = "";
    $.each(cache.datas, function(index, data){
      if(data["number"] != an[1]) {
        time = data["time"];
        return false;
      }
    });
    return time;
  }; 

  var update_issues = function(){ 
    cache.$issues.each(function(){ 
      time = get_time_of_issue($(this).text());
      $('<span />').text(time).addClass("tag_time").appendTo($(this)); 
    });
  };

  var init = function(){
    fetch_data();
  }

  return {
    init: init
  }
})(jQuery);

TagIssues.init();
