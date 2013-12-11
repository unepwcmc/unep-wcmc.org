$(document).ready(function(){
  $('button#trigger-menu').click(function() {
    $('ul#button-menu').toggle('slow');
  });
  $('button#content-button').click(function() {
    $('ul#content-small').toggle('slow');
    $('button#content-button').css({"background":"#4c9cda","color":"#fff", "border":"1px solid #4c9cda"});
  });
  $('button#fields-button').click(function() {
    $('ul#fields-small').toggle('slow');
    $('button#fields-button').css({"background":"#4c9cda","color":"#fff", "border":"1px solid #4c9cda"})
  });
});