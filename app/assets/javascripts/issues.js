$(document).ready(function(){
  (function(){
    var issueIndex = "http://localhost:3002/issues";

    new Vue({ 
      el: "#issues",
      data: {
        issues: [],
        searchText: ""
      },
      created: function(){
        this.fetchData();
      },
      methods: {
        fetchData: function(){
          var self = this;
          $.ajax({
            url: issueIndex,
            dataType: 'JSON',
            success: function(data) { 
              self.issues = data;
            }
          })
        },
        update: function(){
        },
        delete: function(){
        } 
      }
    }); 
  })();
});
