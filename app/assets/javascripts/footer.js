var bottom;
bottom = function () {
    var docHeight = $(window).height();
    var footerHeight = $('#copyright').height()
    var footerTop = $('#copyright').position().top + footerHeight;

    if (footerTop < docHeight) {
        $('#copyright').css('margin-top', 2 + (docHeight - footerTop) + 'px');
    }
};

$(document).ready(bottom)
