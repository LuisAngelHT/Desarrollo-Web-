<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>
    <h2>Iniciar Sesión</h2>
    <form action="srvUsuario" method="post">
        <input type="hidden" name="accion" value="verificar" />
        <label>Correo:</label>
        <input type="text" name="txtCorreo" required /><br><br>
        <label>Contraseña:</label>
        <input type="password" name="txtPass" required /><br><br>
        <input type="submit" value="Ingresar" />
    </form>

    <c:if test="${not empty error}">
        <p style="color:red;">${error}</p>
    </c:if>
</body>
</html>
