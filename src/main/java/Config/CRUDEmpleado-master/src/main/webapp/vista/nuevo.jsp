<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer" />

        <title>Form Empleado</title>
    </head>
    <body>
        <div class="container mt-3">
            <div class="card">
                <div class="card-body">
                    <h3>${empleado.id == 0 ? "Nuevo": "Editar"} Empleado</h3>
                    <hr />
                    
                    <form action="EmpleadoControlador" method="post">
                        <div class="mb-3">
                            <label>Nombres:</label>
                            <input value="${empleado.nombres}" name="nombres" type="text" maxlength="50" 
                                   class="form-control" required="">
                        </div>

                        <div class="mb-3">
                            <label>Apellidos:</label>
                            <input value="${empleado.apellidos}" name="apellidos" type="text" maxlength="50" 
                                   class="form-control" required="">
                        </div>

                        <div class="mb-3">
                            <label>Fecha Ingreso:</label>
                            <input value="${empleado.fechaIngreso}" name="fechaIngreso" type="date" 
                                   class="form-control" required="">
                        </div>

                        <div class="mb-3">
                            <label>Sueldo:</label>
                            <input value="${empleado.sueldo}" name="sueldo" type="number" 
                                   class="form-control" required="">
                        </div>

                        <div class="mb-3">
                            <input type="hidden" name="id" value="${empleado.id}">
                            <input type="hidden" name="accion" value="guardar">
                            <button class="btn btn-primary btn-sm">
                                <i class="fa fa-save"></i> Guardar
                            </button>
                            <a href="EmpleadoControlador?accion=listar" 
                               class="btn btn-dark btn-sm">
                                <i class="fa fa-arrow-left"></i> Volver atras
                            </a>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </body>
</html>
