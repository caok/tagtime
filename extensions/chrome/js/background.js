var issueURL = 'http://localhost:3000/apis/timelist' 

chrome.runtime.onMessage.addListener(function(project, sender, sendResponse){
  $.ajax({
    type: "GET",
    url: issueURL,
    data: {token: $.cookie('token'), project: project},
    dataType: 'JSON',
    async: false,
    success: function(rsp){
      sendResponse(JSON.stringify(rsp.data));
    }
  })
});
