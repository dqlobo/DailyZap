$(document).ready(function(){
    $('.carousel').slick({
	arrows: false,
	autoplay: true,
	autoplaySpeed: 3500,
 	fade: true,
	asNavFor: '.text-carousel'
    });
    $('.text-carousel').slick({
    	arrows: false,
    	fade: false,
    	asNavFor: '.carousel'
    });
});
