$(document).ready(function () {
    $('.clear-session').on('click', function () {
        $('.results tr:not(:first-child)').remove();
        document.cookie = "entries= ; expires = Thu, 01 Jan 1970 00:00:00 GMT"
    });

    $('.inp-cbx-x').on('click', function () {
        $('.x-select .warning').removeClass('icon-visible');
    });

    $('.inp-cbx-r').on('click', function () {
        $('.r-select .warning').removeClass('icon-visible');
    });

    $('#Y-select').on('focus', function () {
        $('.y-select .warning').removeClass('icon-visible');
    });

    $('form').submit(function (e) {
        e.preventDefault();
        const x = $('.inp-cbx-x:checked').val();
        const r = $('.inp-cbx-r:checked').val();

        let validX = false;
        let validY = false;
        let validR = false;
        let yString = $('#Y-select').val().trim();
        let yStringWithoutComma = ''
        let yVal = 0;
        if (yString.match(/^-?[0-9]*[.,]?[0-9]+$/) && yString && yString !== '-') {
            yStringWithoutComma = yString.replace(',', '.');
            let digitsCount = yStringWithoutComma.indexOf('.') + 15
            yVal = parseFloat(yStringWithoutComma.substring(0, Math.min(digitsCount, yStringWithoutComma.length)));
            if (yVal > -5 && yVal < 5) {
                validY = true;
            }
        }
        if ($('.inp-cbx-x:checked').length === 1) {
            validX = true;
        }
        if ($('.inp-cbx-r:checked').length === 1) {
            validR = true;
        }

        if (!validX) {
            $('.x-select .warning').addClass('icon-visible')
        }
        if (!validY) {
            $('.y-select .warning').addClass('icon-visible')
        }
        if (!validR) {
            $('.r-select .warning').addClass('icon-visible')
        }
        if (validX && validY && validR) {
            $.ajax({
                type: 'POST',
                url: 'form.php',
                data: {'x': x, 'yStr': yStringWithoutComma, 'yVal': yVal, 'r': r},
                success: function (data) {
                    $('.results > tbody').append(data);
                },
                error: function (jqXHR) {
                    console.log(jqXHR);
                    alert("Ошибка " + jqXHR.status + ": " + jqXHR.statusText)
                }
            });
        }
    });
});