<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/vistas/includes/head-resources.jsp" %>

<c:set var="pageActive" value="clientes" />
<!DOCTYPE html>
<html lang="es">
    <head>
        <title>Gestión de clientes</title>
    </head>
    <body>
        <%@ include file="/vistas/includes/header-vendedor.jsp" %>
        <%@ include file="/vistas/includes/sidebar-vendedor.jsp" %>

        <div class="content-wrapper">
            <section class="content-header">
                <h1>Clientes</h1>
                <small>Listado de clientes registrados</small>
            </section>

            <section class="content">
                <%@ include file="/vistas/includes/alertas.jsp" %>

                <!-- Listado -->
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title">Clientes registrados</h3>
                        <div class="box-tools pull-right">
                            <span class="badge bg-blue">${totalClientes} cliente(s)</span>
                        </div>
                    </div>
                    <div class="box-body">
                        <c:choose>
                            <c:when test="${empty listaClientes}">
                                <div class="alert alert-info">
                                    <i class="fa fa-info-circle"></i> No hay clientes registrados en el sistema.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-bordered table-hover">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Nombre completo</th>
                                                <th>Email</th>
                                                <th>Teléfono</th>
                                                <th>Dirección</th>
                                                <th>Estado</th>
                                                <th>Acciones</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="c" items="${listaClientes}">
                                                <tr>
                                                    <td>${c.idUsuario}</td>
                                                    <td><strong>${c.nombre} ${c.apellido}</strong></td>
                                                    <td>${c.email}</td>
                                                    <td>${c.telefono != null ? c.telefono : '-'}</td>
                                                    <td>${c.direccion != null ? c.direccion : '-'}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${c.estado}">
                                                                <span class="label label-success">Activo</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="label label-default">Inactivo</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <a href="srvClientes?accion=ver&id=${c.idUsuario}" class="btn btn-sm btn-info" title="Ver detalle">
                                                            <i class="fa fa-eye"></i> Ver
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </section>
        </div>

        <%@ include file="/vistas/includes/footer.jsp" %>
    </body>
</html>