$(document).ready(function(){
    $('.carousel').slick({
	arrows: false,
	autoplay: true,
	autoplaySpeed: 2300,
 	fade: true,
	asNavFor: '.text-carousel'
    });
    $('.text-carousel').slick({
    	arrows: false,
    	fade: false,
	adaptiveHeight: true,
    	asNavFor: '.carousel'
    });
});
