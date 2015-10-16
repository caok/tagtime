var createURL = "http://localhost:3002/apis/issues" 

var tagTime = new Vue({
  el: "#tagtime",
  data: {
    timeTip: "time format: 1h30m"
  },
  methods: { 
    createTag: function(e){
      console.log("start!")
      $.ajax({
        type: "POST",
        url: createURL,
        data: {},
        success: function(data){
          console.log(data.notice)
        },
        dataType: 'JSON'
      });
    } 
  }
}); 
