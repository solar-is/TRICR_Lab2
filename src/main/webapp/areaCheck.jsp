<%@ page import="domain.RequestDetails" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" type="text/css" href="style.css"/>
</head>
<body>
<%
    if (request.getAttribute("requestDetails") == null) { %>
        <p>Nice try, mamkin hacker! Server side validation is still working, so please do valid requests.</p>
    <% } else {
        RequestDetails requestDetails = (RequestDetails) request.getAttribute("requestDetails"); %>
        <table class="results area-check-table">
            <tr>
                <th>X</th>
                <th>Y</th>
                <th>R</th>
                <th>Попадание</th>
            </tr>
            <tr>
                <td><%= requestDetails.getX() %>
                </td>
                <td><%= requestDetails.getY() %>
                </td>
                <td><%= requestDetails.getR() %>
                </td>
                <%= requestDetails.isEntry() ? "<td class=\"in\">Попадает</td>" : "<td class=\"out\">Не попадает</td>" %>
            </tr>
        </table>
    <% } %>
<a class="to_main_page" href="/index.jsp">To the main page</a>
</body>
</html>
