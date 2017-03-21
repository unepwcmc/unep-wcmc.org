window.CMS.timepicker = function () {
  $('input[type=text][data-cms-datetime]').datetimepicker({
    format: 'yyyy-mm-dd',
    minView: 2,
    autoclose: true
  });
}

$(function () {
  $('input[value="twitter_share_text"]').parent().find("input[type=text]").attr({maxlength: 140});
});

$(function() {
  $('a[disabled=disabled]').click(function(event){
    return false;
    // Prevent disabled links from working & stop alerts (such as confirm messages)
  });
});

