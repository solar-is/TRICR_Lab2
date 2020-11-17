<%@ page import="java.util.List" %>
<%@ page import="domain.RequestDetails" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
    <title>Lab 2 Просолович М.А. Тайц Ю.М.</title>
    <link rel="stylesheet" type="text/css" href="style.css"/>
</head>
<body>
<table class="wrapper">
    <tr class="header">
        <td class="students">P33211 Просолович М.А. Тайц Ю.М.</td>
        <td class="variant">Вариант 5126</td>
    </tr>
    <tr class="content">
        <td colspan="2">
            <h1>Лабораторная работа №2</h1>
            <div class="content-wrapper">
                <div class="area">
                    <canvas id="canvasId" width="200px" height="200px"></canvas>
                </div>

                <form id="form-id" class="selection">
                    <div class="x-select">
                        <label class="selection-label">Выберите X
                            <span class="warning" data-validate="Выберите хотя бы одно значение X"></span>
                        </label>
                        <% for (double i = -2; i <= 2; i += 0.5) { %>
                        <input class="inp-cbx-x" id="x<%=i%>" type="button" name="x" value="<%=i%>">
                        <% } %>
                    </div>
                    <div class="y-select">
                        <label class="selection-label" for="Y-select">Выберите Y
                            <span class="warning" data-validate="Y - значение в диапазоне (-5; 5)"></span>
                        </label>
                        <input id="Y-select" type="text" placeholder="-5...5" name="y" autocomplete="off">
                    </div>
                    <div class="r-select">
                        <label class="selection-label">Выберите R
                            <span class="warning" data-validate="Выберите одно значение R"></span>
                        </label>
                        <% for (int i = 1; i <= 5; i++) { %>
                        <input class="inp-cbx-r" id="r<%=i%>" type="radio" name="r" value="<%=i%>">
                        <label class="cbx-r" for="r<%=i%>">
                            <span><%=i%></span>
                        </label>
                        <% } %>
                    </div>
                    <input class="btn-submit" type="submit" value="Проверить">
                    <div class="clear-cookie">Очистить таблицу</div>
                </form>

                <table class="results">
                    <tr>
                        <th>X</th>
                        <th>Y</th>
                        <th>R</th>
                        <th>Попадание</th>
                    </tr>

                    <%
                        Object entriesObject = session.getAttribute("entries");
                        if (entriesObject != null) {
                            List<RequestDetails> entries = (List<RequestDetails>) entriesObject;
                            for (RequestDetails details : entries) {
                    %>
                    <tr>
                        <td><%= details.getX() %>
                        </td>
                        <td><%= details.getY() %>
                        </td>
                        <td><%= details.getR() %>
                        </td>
                        <%= details.isEntry() ? "<td class=\"in\">Попадает</td>" : "<td class=\"out\">Не попадает</td>" %>
                    </tr>
                    <%
                            }
                        }
                    %>

                </table>
            </div>
        </td>
    </tr>
</table>
<script type="text/javascript" src="jquery-3.4.1.min.js"></script>
<script>
    $(document).ready(function () {
        const canvas = document.getElementById('canvasId'),
            context = canvas.getContext('2d');

        context.fillStyle = 'red';

        const base_image = new Image();
        base_image.src = 'area.png';
        base_image.onload = function () {
            context.drawImage(base_image, 0, 0);

            let points = localStorage.getItem('points');
            let coordinatePairs = points.split(';');
            for (var i = 0; i<coordinatePairs.length; ++i) {
                let pair = coordinatePairs[i];
                context.fillRect(parseFloat(pair.split(',')[0]), parseFloat(pair.split(',')[1]), 2,2);
            }

        };

        function checkClick(canvas, event) {
            let rect = canvas.getBoundingClientRect();
            let x = event.clientX - rect.left - 100;
            let y = -(event.clientY - rect.top - 100);

            if ($('.inp-cbx-r:checked').length === 0) {
                alert("Невозможно определить координаты точки, так как не задан радиус!")
            } else {
                let rVal = $('.inp-cbx-r:checked').val();
                const rPixels = 80;

                const realX = x * rVal / rPixels;
                const realY = y * rVal / rPixels;

                const point = (event.clientX - rect.left) + "," + (event.clientY - rect.top);
                let points = localStorage.getItem('points');
                if (points) {
                    points += ";" + point;
                } else {
                    points = point;
                }
                localStorage.setItem('points', points);

                const formData = $("#form-id").serializeArray();
                formData.push({name: "x", value: realX});
                formData.push({name: "yStr", value: realY});
                formData.push({name: "yVal", value: realY});
                formData.push({name: "r", value: rVal});
                formData.push({name: "onlyDefaultValidation", value: true});

                $.ajax({
                    type: "POST",
                    url: "/lab2",
                    data: formData,
                    dataType: "html",
                    success: function (data) {
                        $('body').html(data);
                    }
                });

            }

        }

        canvas.addEventListener("mousedown", function (e) {
            checkClick(canvas, e);
        });

        let lastX = '';

        $('.inp-cbx-x').click(function () {
            lastX = this.id.substring(1);
            $('.x-select .warning').removeClass('icon-visible');
        });

        $('#Y-select').on('focus', function () {
            $('.y-select .warning').removeClass('icon-visible');
        });

        $('.clear-cookie').on('click', function () {
            $('.results tr:not(:first-child)').remove();
            localStorage.clear();
            $.post("/lab2", 'clearSession');
            location.reload();
        });

        $('.inp-cbx-r').on('click', function () {
            $('.r-select .warning').removeClass('icon-visible');
        });

        $('form').submit(function (e) {
            e.preventDefault();

            let validX = false;
            if (lastX !== '') {
                validX = true;
            }
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
            if ($('.inp-cbx-r:checked').length !== 0) {
                validR = true;
            }
            if (!validY) {
                $('.y-select .warning').addClass('icon-visible')
            }
            if (!validR) {
                $('.r-select .warning').addClass('icon-visible')
            }
            if (!validX) {
                $('.x-select .warning').addClass('icon-visible')
            }

            if (validY && validR && validX) {
                const formData = $("#form-id").serializeArray();
                formData.push({name: "x", value: lastX});
                formData.push({name: "yStr", value: yStringWithoutComma});
                formData.push({name: "yVal", value: yVal});

                $.ajax({
                    type: "POST",
                    url: "/lab2",
                    data: formData,
                    dataType: "html",
                    success: function (data) {
                        $('.content').html(data);
                    }
                });
            }
        });
    });
</script>
</body>
</html>
