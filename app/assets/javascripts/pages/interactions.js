$(document).ready(function(){
  $('button#trigger-menu').click(function() {
    $('ul#button-menu').slideToggle('slow');
  });

  $('button.data').click(function() {
    $('ul#content-small').toggle('slow');
    $('button.data').css({"background":"#4c9cda","color":"#fff", "border":"1px solid #4c9cda"});
  });

  $('button#fields-button').click(function() {
    $('ul#fields-small').toggle('slow');
    $('button#fields-button').css({"background":"#4c9cda","color":"#fff", "border":"1px solid #4c9cda"})
  });

  $('div.status#ok').slideDown('normal');
  $('div.status#warning').slideDown('normal');

  $('div.status#ok i.icon-chevron-up').click(function() {
    $('div.status#ok').slideUp('normal');
  });

  $('div.status#warning i.icon-chevron-up').click(function() {
    $('div.status#warning').slideUp('normal');
  });

  $('ul.subnav-small li.header#strengthen-button i').click(function() {
    $('ul.expertise-small#strengthen').slideToggle('normal');
  });

  $('ul.subnav-small li.header#specialise-button i').click(function() {
    $('ul.expertise-small#specialise').slideToggle('normal');
  });

  $(".menu--collapsable").find(".menu__toggle").click(function(){
    $(".menu--collapsable").find(".menu__item").slideToggle('fast')
  });

});
