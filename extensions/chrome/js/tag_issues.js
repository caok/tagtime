var TagIssues = (function($){
  var issues, html, regs;
  var cache = {};

  var init_cache = function(){
    cache.$issues = $(".issue-meta-section.opened-by");
    cache.regs = { 
      issue: /^#(\d+)/i //"#3 opend 22 minutes ago" 
    };
  }; 
  init_cache();

  var fetch_data = function(update){
    project = $(".entry-title strong").text();
    console.log(project);
    chrome.runtime.sendMessage(project, function(response){
      console.log(response);
      cache.datas = JSON.parse(response);
      update_issues();
    });
  }; 

  var get_time_of_issue = function(text){ 
    var an = text.trim().match(cache.regs.issue); 
    var time = "";
    $.each(cache.datas, function(index, data){
      if(data["number"] == an[1]) {
        time = data["time"];
        return false;
      }
    });
    return time;
  }; 

  var update_issues = function(){ 
    cache.$issues.each(function(){ 
      time = get_time_of_issue($(this).text());
      if (time != ""){
        $('<span />').text(time).addClass("tag_time").appendTo($(this)); 
      };
    });
  };

  var init = function(){
    fetch_data();
  }

  return {
    init: init
  }
})(jQuery);

$(document).ready(function(){
  TagIssues.init();
})
