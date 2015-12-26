var host = "http://localhost:3000/";
var createURL = host + "apis/issues";
var indexURL = host + "apis/issues";
var loginURL = host + "apis/login";
var authorizeURL = host + "apis/authorize";

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

function monitor_enter_button(){
  $('#input_time').bind('keyup', function(event) {
    if (event.keyCode == "13") {
      $("input[type='submit']").click();
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
          init_tag_content();
          $.cookie('token', rsp.token, { path: '/' });
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
