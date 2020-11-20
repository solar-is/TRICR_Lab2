<%@ page import="domain.RequestDetails" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<% if (request.getAttribute("requestDetails") != null) {
    RequestDetails requestDetails = (RequestDetails) request.getAttribute("requestDetails");
%>
<tr>
    <td><%= requestDetails.getX() %></td>
    <td><%= requestDetails.getY() %></td>
    <td><%= requestDetails.getR() %></td>
    <%= requestDetails.isEntry() ? "<td class=\"in\">Попадает</td>" : "<td class=\"out\">Не попадает</td>" %>
</tr>
<% } %>
