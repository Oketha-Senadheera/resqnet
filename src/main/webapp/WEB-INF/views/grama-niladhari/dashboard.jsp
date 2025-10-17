<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Grama Niladhari Dashboard - ResQnet</title>
</head>
<body>
    <h1>Grama Niladhari Dashboard</h1>
    <p>Welcome, ${sessionScope.authUser.email}</p>
    <p>Role: ${sessionScope.authUser.role}</p>
    <form method="post" action="${pageContext.request.contextPath}/logout">
        <button type="submit">Logout</button>
    </form>
</body>
</html>
