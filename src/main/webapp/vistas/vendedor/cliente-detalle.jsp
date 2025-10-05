<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/vistas/includes/head-resources.jsp" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <title>Detalle del cliente</title>
</head>
<body>
    <%@ include file="/vistas/includes/header-vendedor.jsp" %>
    <%@ include file="/vistas/includes/sidebar-vendedor.jsp" %>

    <div class="content-wrapper">
        <section class="content-header">
            <h1>Detalle del cliente</h1>
            <small>Información completa y compras realizadas</small>
        </section>

        <section class="content">
            <%@ include file="/vistas/includes/alertas.jsp" %>

            <!-- Datos del cliente -->
            <div class="box box-info">
                <div class="box-header with-border">
                    <h3 class="box-title">Información del cliente</h3>
                </div>
                <div class="box-body">
                    <p><strong>Nombre:</strong> ${cliente.nombre} ${cliente.apellido}</p>
                    <p><strong>Email:</strong> ${cliente.email}</p>
                    <p><strong>Teléfono:</strong> ${cliente.telefono}</p>
                    <p><strong>Dirección:</strong> ${cliente.direccion}</p>
                    <p><strong>Estado:</strong>
                        <span class="badge ${cliente.estado ? 'badge-success' : 'badge-secondary'}">
                            ${cliente.estado ? 'Activo' : 'Inactivo'}
                        </span>
                    </p>
                    <p><strong>Fecha de registro:</strong>
                        <fmt:formatDate value="${cliente.fechaRegistro}" pattern="dd/MM/yyyy" />
                    </p>
                </div>
            </div>

            <!-- Historial de compras -->
            <div class="box box-primary">
                <div class="box-header with-border">
                    <h3 class="box-title">Historial de compras</h3>
                </div>
                <div class="box-body">
                    <c:choose>
                        <c:when test="${not empty historialCompras}">
                            <table class="table table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th>Fecha</th>
                                        <th>Productos</th>
                                        <th>Total</th>
                                        <th>Estado</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="venta" items="${historialCompras}">
                                        <tr>
                                            <td>
                                                <fmt:formatDate value="${venta.fechaVenta}" pattern="dd/MM/yyyy HH:mm" />
                                            </td>
                                            <td>
                                                <ul class="list-unstyled">
                                                    <c:forEach var="item" items="${venta.productos}">
                                                        <li>${item.nombreProducto} (${item.cantidad} x S/. ${item.precioUnitario})</li>
                                                    </c:forEach>
                                                </ul>
                                            </td>
                                            <td>S/. ${venta.totalFinal}</td>
                                            <td>
                                                <span class="label ${venta.estado == 'Confirmada' ? 'label-success' : venta.estado == 'Pendiente' ? 'label-warning' : 'label-default'}">
                                                    ${venta.estado}
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-info">Este cliente aún no ha realizado compras.</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Total gastado -->
            <div class="box box-success">
                <div class="box-header with-border">
                    <h3 class="box-title">Total gastado por el cliente</h3>
                </div>
                <div class="box-body">
                    <h4>S/. ${totalGastado}</h4>
                </div>
            </div>

            <a href="srvClientesVendedor?accion=listar" class="btn btn-default">
                <i class="fa fa-arrow-left"></i> Volver a clientes
            </a>
        </section>
    </div>

    <%@ include file="/vistas/includes/footer.jsp" %>
</body>
</html>
