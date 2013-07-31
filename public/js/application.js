var sent_status;
var interval;
$(document).ready(function() {
  $('#submit_tweet').on('click', function(e) {
    // setTimeout(function() {
    //   console.log('hi');
    // }, 5000);
    sent_status = 'false';
    $.ajax({
      url: '/tweet',
      type: 'post',
      data: { status: $('#content').val(),
              time: $('#time').val() }
    }).done(function(result) {
      interval = setInterval( function() {
        checkStatus(result);
      }, 1000);
    }).fail(function(error) {
      $('.container').append('<p>Tweet Failed: ' + error + '</p>');
    });
  });
});


function checkStatus(job_id) {
  var status;
  console.log('checking...');
  $.ajax({
    url: '/status/' + job_id,
    type: 'get'
  }).done(function(result) {
    console.log(result);
    status = result;
    if (status == 'true') {
      $('.container').append('<p>Tweet Sent!</p>');
      $('#content').val('');
      clearInterval(interval);
    }
  });
  sent_status = status;
}
