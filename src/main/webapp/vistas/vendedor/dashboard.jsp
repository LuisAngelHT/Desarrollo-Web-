<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/vistas/includes/head-resources.jsp" %>

<!DOCTYPE html>
<html lang="es">
    <head>
        <title>Panel del Vendedor</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/custom/css/custom.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    </head>
    <body class="hold-transition skin-blue sidebar-mini">
        <%@ include file="/vistas/includes/header-vendedor.jsp" %>
        <%@ include file="/vistas/includes/sidebar-vendedor.jsp" %>

        <div class="content-wrapper">
            <section class="content-header">
                <h1>Panel del Vendedor</h1>
                <small>Bienvenido, ${nombre}</small>
            </section>

            <section class="content">
                <!-- Métricas generales dinámicas -->
                <div class="row">
                    <c:forEach var="box" items="${resumenBoxes}">
                        <div class="col-md-3 col-sm-6">
                            <div class="small-box bg-${box.color}">
                                <div class="inner">
                                    <h3>${box.valor}</h3>
                                    <p>${box.texto}</p>
                                </div>
                                <div class="icon">
                                    <i class="fa ${box.icono}"></i>
                                </div>
                                <a href="${box.link}" class="small-box-footer">
                                    Ver más <i class="fa fa-arrow-circle-right"></i>
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Gráfico y clientes recientes -->
                <div class="row">
                    <div class="col-lg-8">
                        <div class="box box-primary">
                            <div class="box-header with-border">
                                <h3 class="box-title">Ventas de los últimos 7 días</h3>
                            </div>
                            <div class="box-body">
                                <canvas id="graficoVentas" height="200"></canvas>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-4">
                        <div class="box box-info">
                            <div class="box-header with-border">
                                <h3 class="box-title">Clientes recientes</h3>
                                <span class="badge bg-blue pull-right">${clientesSemana}</span>
                            </div>
                            <div class="box-body">
                                <c:choose>
                                    <c:when test="${not empty clientesRecientes}">
                                        <ul class="list-group">
                                            <c:forEach var="c" items="${clientesRecientes}">
                                                <li class="list-group-item">
                                                    <strong>${c.nombre} ${c.apellido}</strong>
                                                    <span class="label ${c.estado == 'Activo' ? 'label-success' : 'label-default'} pull-right">
                                                        ${c.estado}
                                                    </span>
                                                    <br>
                                                    <small class="text-muted">${c.email}</small>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="alert alert-info">
                                            <i class="fa fa-info-circle"></i> No hay clientes registrados.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="box-footer text-center">
                                <a href="srvClientes?accion=listar" class="btn btn-sm btn-default">Ver todos</a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Últimas ventas -->
                <div class="row">
                    <div class="col-lg-12">
                        <div class="box box-warning">
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
                                                <c:forEach var="v" items="${ventasRecientes}">
                                                    <tr>
                                                        <td><fmt:formatDate value="${v.fecha}" pattern="dd/MM/yyyy HH:mm" /></td>
                                                        <td>${v.nombreCliente}</td>
                                                        <td>${v.nombreProducto}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${v.estado == 'Confirmada'}">
                                                                    <span class="label label-success">Confirmada</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="label label-warning">Pendiente</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="alert alert-info">
                                            <i class="fa fa-info-circle"></i> No hay ventas registradas.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>

        <%@ include file="/vistas/includes/footer.jsp" %>

        <!-- Chart.js -->
        <c:if test="${not empty ventasPorDiaSemanaJson}">
            <script>
                const ctx = document.getElementById('graficoVentas').getContext('2d');
                const ventasPorDia = ${ventasPorDiaSemanaJson};

                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'],
                        datasets: [{
                                label: 'Ventas',
                                data: ventasPorDia,
                                backgroundColor: 'rgba(60,141,188,0.8)',
                                borderColor: 'rgba(60,141,188,1)',
                                borderWidth: 1
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    stepSize: 1
                                }
                            }
                        }
                    }
                });
            </script>
        </c:if>
    </body>
</html>