<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/vistas/includes/head-resources.jsp" %>

<c:set var="pageActive" value="clientes" />
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Historial de compras</title>
</head>
<body>
    <%@ include file="/vistas/includes/header-vendedor.jsp" %>
    <%@ include file="/vistas/includes/sidebar-vendedor.jsp" %>

    <div class="content-wrapper">
        <section class="content-header">
            <h1>Historial de compras</h1>
            <small>Cliente: ${cliente.nombre} ${cliente.apellido}</small>
        </section>

        <section class="content">
            <%@ include file="/vistas/includes/alertas.jsp" %>

            <c:choose>
                <c:when test="${not empty historialCompras}">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">Compras realizadas</h3>
                        </div>
                        <div class="box-body">
                            <c:forEach var="venta" items="${historialCompras}">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <strong>Venta #${venta.idVenta}</strong> - 
                                        <fmt:formatDate value="${venta.fechaVenta}" pattern="dd/MM/yyyy HH:mm" />
                                        <span class="label ${venta.estado ? 'label-success' : 'label-danger'}" style="margin-left:10px;">
                                            ${venta.estado ? 'Completada' : 'Cancelada'}
                                        </span>
                                    </div>
                                    <div class="panel-body">
                                        <table class="table table-bordered table-sm">
                                            <thead>
                                                <tr>
                                                    <th>Producto</th>
                                                    <th>Cantidad</th>
                                                    <th>Precio unitario</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="item" items="${venta.productos}">
                                                    <tr>
                                                        <td>${item.nombreProducto}</td>
                                                        <td>${item.cantidad}</td>
                                                        <td>S/. ${item.precioUnitario}</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                        <p><strong>Total:</strong> S/. ${venta.totalFinal}</p>
                                    </div>
                                </div>
                            </c:forEach>
                            <hr>
                            <p><strong>Total gastado por el cliente:</strong> S/. ${totalGastado}</p>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-info">
                        Este cliente aún no ha realizado ninguna compra.
                    </div>
                </c:otherwise>
            </c:choose>

            <a href="srvClientes?accion=listar" class="btn btn-default">
                <i class="fa fa-arrow-left"></i> Volver a clientes
            </a>
        </section>
    </div>

    <%@ include file="/vistas/includes/footer.jsp" %>
</body>
</html>
