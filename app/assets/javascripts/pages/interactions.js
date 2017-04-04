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

  //burger menu
  $(".js-menu--trigger").click(function(e){
    e.preventDefault();
    $(".js-menu--target").toggleClass("js-menu--visible")
  });

  //accordion
  if($('.js-accordion').length > 0){

    //open and close accordion targets when the trigger is clicked
    $('.js-acc-trigger').on('click', function(){

      //only run if screen is on phone breakpoint
      if(breakpoint.currentSize == 'phone'){
        var accordionItem = $(this).parent('.js-acc-item');

        if(accordionItem){
          var accordionTarget = accordionItem.find('.js-acc-target');
          
          if(accordionTarget){
            accordionTarget.toggleClass('accordion__content--hidden');
          }
        }
      }

      return false;
    });
  }
});