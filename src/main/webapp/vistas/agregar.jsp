
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <title>agregar empleado</title>
    </head>
    <body>
        <div class="container mt-3">
            <div class="card">
                <div class="card-body">
                    <h3>Nuevo empleado</h3>
                    <hr>
                    <form action="EmpleadoControlador" method="post">
                        <div class="form-group">
                            <label>Nombres</label>
                            <input name="nombres" type="text" class="form-control" maxlength="50" required="">
                        </div>
                        <div class="form-group">
                            <label>Nombres</label>
                            <input name="apellidos" type="text" class="form-control" maxlength="50" required="">
                        </div>
                        <div class="form-group">
                            <label>Fecha ingreso</label>
                            <input name="fechaIngreso" type="date" class="form-control" required="">
                        </div>
                        <div class="form-group">
                            <label>Sueldo</label>
                            <input name="sueldo" type="number" class="form-control" maxlength="50" required="">
                        </div>
                        <div class="form-group">
                            <input type="hidden" name="accion" value="guardar"> 
                            <button class="btn btn-primary btn-sm">Registrar</button>
                            <a href="EmpleadoControlador?accion=listar" class="btn btn-dark btn-sm">Volver atras</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>
