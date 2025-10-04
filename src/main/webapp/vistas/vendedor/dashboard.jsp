<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/vistas/includes/head-resources.jsp" %>

<!DOCTYPE html>
<html lang="es">
    <head>
        <title>Panel del Vendedor</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/custom/css/custom.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script> <!-- Chart.js CDN -->
    </head>
    <body>
        <%@ include file="/vistas/includes/header-vendedor.jsp" %>
        <%@ include file="/vistas/includes/sidebar-vendedor.jsp" %>

        <div class="content-wrapper">
            <section class="content-header">
                <h1>Panel del Vendedor</h1>
                <small>Resumen de tu actividad</small>
            </section>

            <section class="content">
                <div class="row">
                    <!-- Métricas -->
                    <c:set var="productos" value="${totalProductos != null ? totalProductos : 0}" />
                    <c:set var="ventas" value="${ventasHoy != null ? ventasHoy : 0}" />
                    <c:set var="clientes" value="${totalClientes != null ? totalClientes : 0}" />
                    <c:set var="stockBajo" value="${inventarioBajo != null ? inventarioBajo : 0}" />

                    <div class="col-lg-3 col-xs-6">
                        <div class="small-box bg-gradient-aqua dashboard-box">
                            <div class="inner">
                                <h3>${productos}</h3>
                                <p>Productos disponibles</p>
                            </div>
                            <div class="icon"><i class="fa fa-cube"></i></div>
                            <a href="srvProductos?accion=listar" class="small-box-footer">Ver productos <i class="fa fa-arrow-circle-right"></i></a>
                        </div>
                    </div>

                    <div class="col-lg-3 col-xs-6">
                        <div class="small-box bg-gradient-green dashboard-box">
                            <div class="inner">
                                <h3>${ventas}</h3>
                                <p>Ventas hoy</p>
                            </div>
                            <div class="icon"><i class="fa fa-shopping-cart"></i></div>
                            <a href="srvVentas?accion=listar" class="small-box-footer">Ver ventas <i class="fa fa-arrow-circle-right"></i></a>
                        </div>
                    </div>

                    <div class="col-lg-3 col-xs-6">
                        <div class="small-box bg-gradient-yellow dashboard-box">
                            <div class="inner">
                                <h3>${clientes}</h3>
                                <p>Clientes registrados</p>
                            </div>
                            <div class="icon"><i class="fa fa-users"></i></div>
                            <a href="srvClientes?accion=listar" class="small-box-footer">Ver clientes <i class="fa fa-arrow-circle-right"></i></a>
                        </div>
                    </div>

                    <div class="col-lg-3 col-xs-6">
                        <div class="small-box bg-gradient-red dashboard-box">
                            <div class="inner">
                                <h3>${stockBajo}</h3>
                                <p>Stock bajo</p>
                            </div>
                            <div class="icon"><i class="fa fa-exclamation-triangle"></i></div>
                            <a href="srvInventario?accion=listar" class="small-box-footer">Revisar inventario <i class="fa fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                </div>

                <!-- Gráfico de ventas semanales -->
                <div class="row mt-4">
                    <div class="col-lg-6">
                        <div class="box box-info">
                            <div class="box-header with-border">
                                <h3 class="box-title">Ventas esta semana</h3>
                            </div>
                            <div class="box-body">
                                <canvas id="graficoVentas" height="120"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- Últimas ventas -->
                    <div class="row mt-4">
                        <div class="col-lg-8">
                            <div class="box box-primary">
                                <div class="box-header with-border">
                                    <h3 class="box-title">Últimas 5 ventas</h3>
                                </div>
                                <div class="box-body">
                                    <c:choose>
                                        <c:when test="${not empty ventasRecientes}">
                                            <table class="table table-hover table-striped">
                                                <thead>
                                                    <tr>
                                                        <th>Fecha</th>
                                                        <th>Cliente</th>
                                                        <th>Producto</th>
                                                        <th>Estado</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="venta" items="${ventasRecientes}" varStatus="status">
                                                        <c:if test="${status.index < 5}">
                                                            <tr>
                                                                <td><fmt:formatDate value="${venta.fecha}" pattern="dd/MM/yyyy HH:mm" /></td>
                                                                <td>${venta.nombreCliente}</td>
                                                                <td>${venta.nombreProducto}</td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${venta.estado == 'Confirmada'}">
                                                                            <span class="label label-success">Confirmada</span>
                                                                        </c:when>
                                                                        <c:when test="${venta.estado == 'Pendiente'}">
                                                                            <span class="label label-warning">Pendiente</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="label label-default">${venta.estado}</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                            </tr>
                                                        </c:if>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="alert alert-info">No hay ventas registradas.</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <!-- Clientes nuevos -->
                        <div class="col-lg-4">
                            <div class="box box-warning">
                                <div class="box-header with-border">
                                    <h3 class="box-title">Clientes nuevos esta semana</h3>
                                    <span class="badge bg-yellow pull-right">${clientesSemana != null ? clientesSemana : 0}</span>
                                </div>
                                <div class="box-body">
                                    <c:choose>
                                        <c:when test="${not empty clientesRecientes}">
                                            <ul class="list-group">
                                                <c:forEach var="c" items="${clientesRecientes}">
                                                    <li class="list-group-item">
                                                        <strong>${c.nombre} ${c.apellido}</strong>
                                                        <span class="label label-info pull-right">${c.estado}</span><br>
                                                        <small>DNI: ${c.dni} | Registro: <fmt:formatDate value="${c.fechaRegistro}" pattern="dd/MM/yyyy" /></small>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="alert alert-info">No hay nuevos clientes esta semana.</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="box-footer text-center">
                                    <a href="srvClientes?accion=listar" class="btn btn-sm btn-default">Ver todos los clientes</a>
                                </div>
                            </div>
                        </div>
                    </div>
            </section>
        </div>

        <%@ include file="/vistas/includes/footer.jsp" %>
        <script>
         const ventasPorDia = ${ventasPorDiaSemanaJson}; // Esto debe ser un JSON generado en el servlet

         const ctx = document.getElementById('graficoVentas').getContext('2d');
         new Chart(ctx, {
             type: 'bar',
             data: {
                 labels: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'],
                 datasets: [{
                         label: 'Ventas',
                         data: ventasPorDia,
                         backgroundColor: 'rgba(60,141,188,0.9)'
                     }]
             },
             options: {
                 responsive: true,
                 scales: {
                     y: {beginAtZero: true}
                 }
             }
         });
        </script>
    </body>
</html>
