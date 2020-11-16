<%@ page import="domain.RequestDetails" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%
    if (request.getAttribute("requestDetails") == null) { %>
        <p>Nice try, mamkin hacker! Server side validation is still working, so please do valid requests.</p>
    <% } else {
        RequestDetails requestDetails = (RequestDetails) request.getAttribute("requestDetails"); %>
        <p>
            Your parameters:
        </p>
        <p>
            X = <%= requestDetails.getX() %>
        </p>
        <p>
            Y = <%= requestDetails.getY() %>
        </p>
        <p>
            R = <%= requestDetails.getR() %>
        </p>
        <p>
            <%= requestDetails.isEntry() ? "Congratulations! Your point is inside!" : "Unfortunately, your point is outside the area." %>
        </p>
    <% } request.removeAttribute("x");%>
<a href="/index.jsp">Go back to main page</a>
</body>
</html>
