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
        $('.inp-cbx-x').css("background-color", "#6ba1e5");

        const xCenter = 125;
        const yCenter = 125;

        const xMax = 1;
        const yMax = 1;

        const xScale = xCenter / (xMax + 0.5);
        const yScale = yCenter / (yMax + 0.5);

        const xOffset = xCenter + 0.5;
        const yOffset = yCenter + 0.5;

        let canvas = document.getElementById('canvasId');
        if (canvas.getContext) {
            canvas.height = yCenter * 2;
            canvas.width = xCenter * 2;
            let context = canvas.getContext("2d");
            drawAxes(context);
            drawAreas(context);
            <%
                if (entriesObject != null) {
                    List<RequestDetails> entries = (List<RequestDetails>) entriesObject;
                    for (RequestDetails requestDetails : entries) {
                        double x = (125 / 1.5) * (requestDetails.getX() / requestDetails.getR()) + 125;
                        double y = - (125 / 1.5) * (requestDetails.getY() / requestDetails.getR()) + 125;
                    %>
                        context.fillStyle = '#000000';
                        context.fillRect(<%=x%>, <%=y%>, 3, 3);
                    <%
                    }
                }
            %>
        }

        canvas.addEventListener("mousedown", function (e) {
            canvasClickListener(canvas, e);
        });

        function canvasClickListener(canvas, event) {
            let rect = canvas.getBoundingClientRect();
            let x = event.clientX - rect.left - xCenter;
            let y = -(event.clientY - rect.top - yCenter);

            if ($('.inp-cbx-r:checked').length === 0) {
                alert("Невозможно определить координаты точки, так как не задан радиус!")
            } else {
                let rVal = $('.inp-cbx-r:checked').val();

                const realX = x * rVal / xScale;
                const realY = y * rVal / yScale;

                const formData = $("#form-id").serializeArray();
                formData.push({name: "x", value: realX});
                formData.push({name: "yStr", value: realY});
                formData.push({name: "yVal", value: realY});
                formData.push({name: "r", value: rVal});
                formData.push({name: "onlyDefaultValidation", value: true});
                doRequest(formData);
            }
        }

        let lastX = '';

        $('.inp-cbx-x').click(function () {
            $('.inp-cbx-x').css("background-color", "#6ba1e5");
            $('.inp-cbx-x').css("color", "#000000");
            lastX = this.id.substring(1);
            $('.x-select .warning').removeClass('icon-visible');
            $(this).css("background-color", "#b51101");
            $(this).css("color", "#ffffff");
        });

        $('#Y-select').on('focus', function () {
            $('.y-select .warning').removeClass('icon-visible');
        });

        $('.clear-cookie').on('click', function () {
            $('.results tr:not(:first-child)').remove();
            $.post("/lab2", 'clearSession');
            location.reload();
        });

        $('.inp-cbx-r').on('click', function () {
            $('.r-select .warning').removeClass('icon-visible');
            let rVal = this.value;
            if (rVal) {
                let context = canvas.getContext("2d");
                <%
                    if (entriesObject != null) {
                        List<RequestDetails> entries = (List<RequestDetails>) entriesObject;
                        for (RequestDetails requestDetails : entries) {
                            int r = requestDetails.getR();
                            double x = (125 / 1.5) * (requestDetails.getX() / r) + 125;
                            double y = - (125 / 1.5) * (requestDetails.getY() / r) + 125;
                        %>
                            if (rVal === '<%=r%>') {
                                if (<%=requestDetails.isEntry()%>) {
                                    context.fillStyle = '#00ff00';
                                } else {
                                    context.fillStyle = '#ff0000';
                                }
                            } else {
                                context.fillStyle = '#000000';
                            }
                            context.fillRect(<%=x%>, <%=y%>, 3, 3);
                        <%
                        }
                    }
                %>
            }
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

                doRequest(formData);
            }

        });

        function doRequest(data) {
            $.ajax({
                type: "POST",
                url: "/lab2",
                data: data,
                dataType: "html",
                success: function () {
                    location.reload();
                }
            });
        }

        function drawAxes(ctx) {
            ctx.font = "14px serif";
            ctx.strokeText('Y', xCenter + 10, 15);
            ctx.strokeText('X', xCenter * 2 - 10, yCenter - 10);

            ctx.font = "12px serif";
            ctx.lineWidth = 1;

            // draw x-axis
            ctx.beginPath();
            ctx.moveTo(0, yOffset);
            ctx.lineTo(xCenter * 2, yOffset);
            ctx.stroke();
            ctx.closePath();

            // draw arrow
            ctx.beginPath();
            ctx.moveTo(xCenter * 2 + 0.5, yCenter + 0.5);
            ctx.lineTo(xCenter * 2 + 0.5 - 8, yCenter + 0.5 - 3);
            ctx.lineTo(xCenter * 2 + 0.5 - 8, yCenter + 0.5 + 3);
            ctx.stroke();
            ctx.closePath();
            ctx.fill();

            // draw x values
            let j = -xMax;
            while (j <= xMax) {
                let x = j * xScale;
                ctx.strokeStyle = '#aaa';
                ctx.beginPath();
                ctx.moveTo(x + xOffset, yOffset);
                ctx.lineTo(x + xOffset, yOffset - 5);
                ctx.stroke();
                ctx.closePath();

                ctx.strokeStyle = '#666';
                ctx.strokeText(j === 1 || j === -1 ? 'R' : 'R/2', x + xOffset - 5, yOffset - 10);

                j += 0.5;
                if (j === 0) {
                    j += 0.5;
                }
            }

            // draw y-axis
            ctx.beginPath();
            ctx.moveTo(xOffset, 0);
            ctx.lineTo(xOffset, yCenter * 2);
            ctx.stroke();
            ctx.closePath();

            // draw arrow
            ctx.beginPath();
            ctx.moveTo(xCenter + 0.5, 0.5);
            ctx.lineTo(xCenter + 0.5 - 3, 0.5 + 8);
            ctx.lineTo(xCenter + 0.5 + 3, 0.5 + 8);
            ctx.stroke();
            ctx.closePath();
            ctx.fill();

            // draw y values
            j = -yMax;
            while (j <= yMax) {
                let y = j * yScale;
                ctx.strokeStyle = '#aaa';
                ctx.beginPath();
                ctx.moveTo(xOffset, y + yOffset);
                ctx.lineTo(xOffset + 5, y + yOffset);
                ctx.stroke();
                ctx.closePath();

                ctx.strokeStyle = '#666';
                ctx.strokeText(j === 1 || j === -1 ? 'R' : 'R/2', xOffset + 10, y + yOffset + 5);

                j += 0.5;
                if (j === 0) {
                    j += 0.5;
                }
            }
        }

        function offsetX(v) {
            return xOffset + (v * xScale);
        }

        function offsetY(v) {
            return yOffset - (v * yScale);
        }

        function drawAreas(ctx) {
            ctx.lineWidth = 1;
            ctx.globalAlpha = 0.5;
            ctx.strokeStyle = '#0257b6';
            ctx.fillStyle = '#0257b6';

            // triangle
            ctx.beginPath();
            ctx.moveTo(offsetX(0), offsetY(0));
            ctx.lineTo(offsetX(1), offsetY(0));
            ctx.lineTo(offsetX(0), offsetY(-0.5));
            ctx.fill();
            ctx.closePath();

            // rectangle
            ctx.beginPath();
            ctx.moveTo(offsetX(0), offsetY(0));
            ctx.lineTo(offsetX(0), offsetY(0.5));
            ctx.lineTo(offsetX(-1), offsetY(0.5));
            ctx.lineTo(offsetX(-1), offsetY(0));
            ctx.fill();
            ctx.closePath();

            // circle
            ctx.beginPath();
            ctx.moveTo(offsetX(0), offsetY(0));
            ctx.arc(offsetX(0), offsetY(0), offsetX(1) - offsetX(0), Math.PI, Math.PI / 2, true);
            ctx.fill();
            ctx.closePath();
        }
    });
</script>
</body>
</html>
