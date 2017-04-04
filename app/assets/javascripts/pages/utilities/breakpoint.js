'use strict';

$(function(){
  breakpoint.init();  
});

var breakpoint = {
  init: function(){
    //set currentSize on page load
    breakpoint.checkSize();

    //update currentSize when the window changes size
    $(window).resize(breakpoint.checkSize);
  },

  small: 499, //match scss 
  medium: 768, //match scss
  large: 1080, //match scss

  currentSize: 'desktop',

  checkSize: function(){
    var width = $(window).width();

    if(width < breakpoint.medium){
      breakpoint.currentSize = 'phone';

    } else if(breakpoint.medium <= width < breakpoint.large) {
      breakpoint.currentSize = 'tablet';

    } else {
      breakpoint.currentSize = 'desktop';
    }
  }
};