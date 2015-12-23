var createURL = "http://localhost:3000/apis/issues" 
var indexURL = "http://localhost:3000/apis/issues"

String.prototype.endWith=function(endStr){
  var d=this.length-endStr.length;
  return (d>=0&&this.lastIndexOf(endStr)==d)
}

function init_tag_content(){
  chrome.tabs.getSelected(function(tab) {
    console.log(tab.title);
    title = tab.title;
    url = tab.url;
    if (url.indexOf('issues') > 0){
      if (url.endWith('issues')) {
        //issue list page
        project = title.match(/\/\w+$/)[0].replace('/', '');
        var str = '@' + project + ' ';
      } else {
        //issue detail page
        num = title.match(/Issue #\d /)[0].trim().replace('Issue ', '');
        project = title.match(/\/\w+$/)[0].replace('/', '');
        var str = '@' + project + ' ' + num + ' ';
      }
    } else {
      var str = '';
    }
    $('#input_time').val(str);
  });
};

var tagTime = new Vue({
  el: "#tagtime",
  data: {
    timeTip: "time format: 1h30m",
    notice: "",
    latestIssues: [],
    tagContent: ''
  },
  created: function(){
    this.fetchIssue();
  },
  methods: { 
    createTag: function(e){
      var self = this;
      $.ajax({
        type: "POST",
        url: createURL,
        data: {tag: self.tagContent},
        success: function(data){ 
          console.log(data);
          //self.notice = data.message;
          self.latestIssues.unshift(data.data);
          self.tagContent = '';
        },
        dataType: 'JSON'
      });
    },
    fetchIssue: function(e){
      var self = this;
      $.ajax({
        type: "GET",
        url: indexURL,
        dataType: 'JSON',
        success: function(data){
          console.log(data);
          self.latestIssues = data;
        }
      })
    }
  }
}); 

init_tag_content();
