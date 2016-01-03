var host = "http://localhost:3000/";
var createURL = host + "apis/issues";
var indexURL = host + "apis/issues";
var loginURL = host + "apis/login";
var authorizeURL = host + "apis/authorize";
var projectsURL = host + "apis/projects";
var projects = [];

String.prototype.endWith=function(endStr){
  var d=this.length-endStr.length;
  return (d>=0&&this.lastIndexOf(endStr)==d)
}

function check_login_status() {
  var result = false;
  if ($.cookie('token') != undefined){
    $.ajax({
      type: "POST",
      url: authorizeURL,
      data: {token: $.cookie('token')},
      dataType: 'JSON',
      async: false,
      success: function(rsp){
        if(rsp.type == 'success'){
          result = true;
        }else{
          $.removeCookie('token', { path: '/' });
        }
      }
    });
  }
  return result;
};

function init_tag_content(){
  chrome.tabs.getSelected(function(tab) {
    console.log(tab.title);
    var title = tab.title;
    var url = tab.url;
    var str = '';
    if (url.indexOf("https://github.com") >= 0 && url.indexOf('issues') >= 0){
      if (title.indexOf("Issues ·") >= 0) {
        //issue list page
        var project = title.match(/\/(\w+)$/)[1];
        project = project.toLowerCase();
        if (projects.indexOf(project) >= 0){
          console.log(project);
          str = '@' + project + ' ';
        }
      } else if (title.indexOf("Issue #") >= 0) {
        //issue detail page
        var num = title.match(/Issue #(\d+) /)[1];
        var project = title.match(/\/(\w+)$/)[1];
        project = project.toLowerCase();
        var content = title.match(/^(.+)\ \·\ Issue/)[1];
        if (projects.indexOf(project) >= 0){
          console.log(project);
          str = '@' + project + ' ' + num + ' ' + content + ' ';
        }
      }
    }
    $('#input_time').val(str);
    $("input#input_time").focus();
  });
};

function init_projects(){
  if ($.cookie('token') != undefined){
    $.ajax({
      type: "get",
      url: projectsURL,
      data: {token: $.cookie('token')},
      dataType: 'JSON',
      async: false,
      success: function(data){
        $('input#input_time').atwho({
          at: '@',
          data: data
        });
        projects = data;
      }
    });
  }
}

function monitor_enter_button(){
  $('#input_time').bind('keyup', function(event) {
    if (event.keyCode == "13") {
      var content = $(this).val().trim();
      var matched = content.match(/^@(\w+)/i);
      if (matched != undefined && matched[0] != content) {
        $("input[type='submit']").click();
      };
    }
  });
}

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
      if(self.tagContent != ""){
        $.ajax({
          type: "POST",
          url: createURL,
          data: {tag: self.tagContent, token: $.cookie('token')},
          success: function(data){ 
            console.log(data);
            //self.notice = data.message;
            self.latestIssues.unshift(data.data);
            self.tagContent = '';
          },
          dataType: 'JSON'
        });
      }
    },
    fetchIssue: function(e){
      console.log($.cookie('token'));
      var self = this;
      $.ajax({
        type: "GET",
        url: indexURL,
        data: {token: $.cookie('token')},
        dataType: 'JSON',
        success: function(data){
          console.log(data);
          self.latestIssues = data;
        }
      })
    }
  }
}); 

if(check_login_status()){
  $('#login').hide();
  $('#tagtime').show();

  init_projects();
  init_tag_content();
}else{
  $('#tagtime').hide();
  $('#login').show();
  $('#loginbutton').click(function(){
    $.ajax({
      type: "POST",
      url: loginURL,
      data: {useremail: $('input#useremail').val(), password: $('input#password').val()},
      dataType: 'JSON',
      async: false,
      success: function(rsp){
        if(rsp.type == 'success'){
          $('#login').hide();
          $('#tagtime').show();
          $.cookie('token', rsp.token, { path: '/' });
          init_projects();
          init_tag_content();
          $.ajax({
            type: "GET",
            url: indexURL,
            data: {token: $.cookie('token')},
            dataType: 'JSON',
            success: function(data){
              tagTime.$data.latestIssues = data;
            }
          })
        } else {
          $('#login .alert').html(rsp.message);
        }
      }
    });
  });
};
monitor_enter_button();
