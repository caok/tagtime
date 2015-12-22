var createURL = "http://localhost:3000/apis/issues" 
var indexURL = "http://localhost:3000/apis/issues"

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
