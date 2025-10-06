<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/vistas/includes/head-resources.jsp" />
<!DOCTYPE html>
<html>
    <head>
        <title>Dashboard | Panel de Administración</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/custom/css/custom.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    </head>
    <body id="page-top">
        <jsp:include page="/vistas/includes/header-admin.jsp" />
        <jsp:include page="/vistas/includes/sidebar-admin.jsp" />
        
        <div class="content-wrapper">
            <section class="content-header">
                <h1>Panel del Administrador</h1>
                <small>Resumen de tu actividad</small>
            </section>

            <section class="content">
                <div class="row">
                    <!-- Productos -->
                    <div class="col-lg-3 col-xs-6">
                        <div class="small-box bg-gradient-aqua dashboard-box">
                            <div class="inner">
                                <h3>${totalProductos != null ? totalProductos : 0}</h3>
                                <p>Productos disponibles</p>
                            </div>
                            <div class="icon">
                                <i class="fa fa-cube"></i>
                            </div>
                            <a href="srvProductos?accion=listar" class="small-box-footer">
                                Ver productos <i class="fa fa-arrow-circle-right"></i>
                            </a>
                        </div>
                    </div>

                    <!-- Ventas -->
                    <div class="col-lg-3 col-xs-6">
                        <div class="small-box bg-gradient-green dashboard-box">
                            <div class="inner">
                                <h3>${ventasHoy != null ? ventasHoy : 0}</h3>
                                <p>Ventas hoy</p>
                            </div>
                            <div class="icon">
                                <i class="fa fa-shopping-cart"></i>
                            </div>
                            <a href="srvVentas?accion=listar" class="small-box-footer">
                                Ver ventas <i class="fa fa-arrow-circle-right"></i>
                            </a>
                        </div>
                    </div>

                    <!-- Clientes -->
                    <div class="col-lg-3 col-xs-6">
                        <div class="small-box bg-gradient-yellow dashboard-box">
                            <div class="inner">
                                <h3>${totalClientes != null ? totalClientes : 0}</h3>
                                <p>Clientes registrados</p>
                            </div>
                            <div class="icon">
                                <i class="fa fa-users"></i>
                            </div>
                            <a href="srvClientes?accion=listar" class="small-box-footer">
                                Ver clientes <i class="fa fa-arrow-circle-right"></i>
                            </a>
                        </div>
                    </div>

                    <!-- Inventario bajo -->
                    <div class="col-lg-3 col-xs-6">
                        <div class="small-box bg-gradient-red dashboard-box">
                            <div class="inner">
                                <h3>${inventarioBajo != null ? inventarioBajo : 0}</h3>
                                <p>Stock bajo</p>
                            </div>
                            <div class="icon">
                                <i class="fa fa-exclamation-triangle"></i>
                            </div>
                            <a href="srvInventario?accion=listar" class="small-box-footer">
                                Revisar inventario <i class="fa fa-arrow-circle-right"></i>
                            </a>
                        </div>
                    </div>
                </div>

                <div class="row mt-4">

                    <div class="col-xl-8 col-lg-7">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold text-primary">Resumen de Ingresos (Últimos 6 meses)</h6>
                            </div>
                            <div class="card-body">
                                <div style="height: 400px;"><canvas id="ventasChart"></canvas></div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-4 col-lg-5">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold text-primary">Distribución de Ventas por Producto</h6>
                            </div>
                            <div class="card-body">
                                <div style="height: 400px;"><canvas id="productosTopChart"></canvas></div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
        <jsp:include page="/vistas/includes/footer.jsp" />
    </div>
</div>

<script>
    // Colores de la plantilla (usados en los gráficos)
    const PRIMARY = '#4e73df'; // Azul
    const SUCCESS = '#1cc88a'; // Verde
    const WARNING = '#f6c23e'; // Naranja
    const DANGER = '#e74a3b';  // Rojo
    const INFO = '#36b9cc';    // Turquesa

    // ******************************************************
    // 1. Gráfico de Ventas Mensuales (Área/Línea)
    // ******************************************************
    const ctxVentas = document.getElementById('ventasChart');
    new Chart(ctxVentas, {
        type: 'line',
        data: {
            // ❗ REEMPLAZAR con ${meses} y ${montos} del Servlet ❗
            labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'],
            datasets: [{
                    label: 'Ventas (€)',
                    data: [12000, 19000, 3000, 5000, 20000, 30000],
                    backgroundColor: 'rgba(78, 115, 223, 0.05)', // Fondo semitransparente
                    borderColor: PRIMARY,
                    pointRadius: 3, pointBackgroundColor: PRIMARY, fill: 'start', tension: 0.3
                }]
        },
        options: {
            responsive: true, maintainAspectRatio: false,
            scales: {
                x: {grid: {display: false}},
                y: {beginAtZero: true, grid: {color: "rgb(234, 236, 244)", drawBorder: false}}
            },
            plugins: {legend: {display: false}}
        }
    });

    // ******************************************************
    // 2. Gráfico de Productos Top (Dona)
    // ******************************************************
    const ctxProductos = document.getElementById('productosTopChart');
    new Chart(ctxProductos, {
        type: 'doughnut',
        data: {
            // ❗ REEMPLAZAR con ${nombresProductos} y ${cantidades} del Servlet ❗
            labels: ['Camiseta', 'Pantalón', 'Vestido', 'Chaqueta', 'Zapatos'],
            datasets: [{
                    label: 'Cantidad Vendida',
                    data: [150, 120, 90, 60, 40],
                    backgroundColor: [PRIMARY, SUCCESS, INFO, WARNING, DANGER],
                    hoverBorderColor: "rgba(234, 236, 244, 1)",
                }]
        },
        options: {
            responsive: true, maintainAspectRatio: false, cutout: '80%',
            plugins: {legend: {display: true, position: 'bottom'}}
        }
    });
</script>
<%-- Fin del Script --%>
</body>
</html>