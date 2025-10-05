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
                <!-- Filtros por fecha -->
                <form method="get" action="srvDashboardVendedor" class="form-inline mb-3">
                    <div class="form-group">
                        <label for="desde">Desde:</label>
                        <input type="date" name="desde" id="desde" class="form-control" value="${desde}">
                    </div>
                    <div class="form-group ml-2">
                        <label for="hasta">Hasta:</label>
                        <input type="date" name="hasta" id="hasta" class="form-control" value="${hasta}">
                    </div>
                    <button type="submit" class="btn btn-primary ml-2">Filtrar</button>
                </form>

                <p class="text-muted">Mostrando datos desde <strong>${desde}</strong> hasta <strong>${hasta}</strong></p>

                <c:set var="totalProductos" value="10" />
                <c:set var="ventasHoy" value="5" />
                <c:set var="totalClientes" value="20" />
                <c:set var="inventarioBajo" value="3" />
                <c:set var="ventasFiltradas" value="12" />
                <c:set var="ingresosFiltrados" value="450.75" />
                <c:set var="ventasPorDiaSemanaJson" value="[2, 3, 1, 0, 4, 2, 0]" />
                <c:set var="productosTop" value="${[
                                                   {'nombre':'Producto A','cantidad':5},
                                                   {'nombre':'Producto B','cantidad':3}
                                                   ]}" />
                <c:set var="ventasRecientes" value="${[
                                                      {'fecha':now, 'nombreCliente':'Juan', 'nombreProducto':'Producto A', 'estado':'Confirmada'}
                                                      ]}" />
                <c:set var="clientesRecientes" value="${[
                                                        {'nombre':'Ana','apellido':'Gómez','estado':'Activo','dni':'12345678','fechaRegistro':now}
                                                        ]}" />
                <c:set var="clientesSemana" value="1" />


                <!-- Métricas generales -->
                <div class="row">
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

                <!-- Métricas filtradas -->
                <div class="row">
                    <div class="col-md-6">
                        <div class="info-box bg-light">
                            <span class="info-box-icon bg-blue"><i class="fa fa-line-chart"></i></span>
                            <div class="info-box-content">
                                <span class="info-box-text">Ventas entre fechas</span>
                                <span class="info-box-number">${ventasFiltradas}</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-box bg-light">
                            <span class="info-box-icon bg-green"><i class="fa fa-money"></i></span>
                            <div class="info-box-content">
                                <span class="info-box-text">Ingresos entre fechas (S/)</span>
                                <span class="info-box-number">${ingresosFiltrados}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Gráfico y productos más vendidos -->
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

                    <div class="col-lg-6">
                        <div class="box box-success">
                            <div class="box-header with-border">
                                <h3 class="box-title">Top productos vendidos</h3>
                            </div>
                            <div class="box-body">
                                <c:choose>
                                    <c:when test="${not empty productosTop}">
                                        <table class="table table-bordered">
                                            <thead>
                                                <tr>
                                                    <th>Producto</th>
                                                    <th>Ventas</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="p" items="${productosTop}">
                                                    <tr>
                                                        <td>${p.nombre}</td>
                                                        <td>${p.cantidad}</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="alert alert-info">No hay productos vendidos en este rango.</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Últimas ventas y clientes nuevos -->
                <div class="row mt-4">
                    <div class="col-lg-8">
                        <!-- ... tu bloque de últimas ventas se mantiene igual ... -->
                    </div>
                    <div class="col-lg-4">
                        <!-- ... tu bloque de clientes nuevos se mantiene igual ... -->
                    </div>
                </div>
            </section>
        </div>

        <%@ include file="/vistas/includes/footer.jsp" %>

        <!-- Chart.js gráfico -->
        <c:if test="${not empty ventasPorDiaSemanaJson}">
            <script>
                const ctx = document.getElementById('graficoVentas').getContext('2d');
                const ventasPorDia = ${ventasPorDiaSemanaJson};

                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'],
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
        </c:if>
    </body>

