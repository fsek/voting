var bottom;
bottom = function () {
    var docHeight = $(window).height();
    var footerHeight = $('#copyright').height()
    var footerTop = $('#copyright').position().top + footerHeight;

    if (footerTop < docHeight) {
        $('#footer').css('margin-top', 22 + (docHeight - footerTop) + 'px');
    }
};

$(document).ready(bottom)
