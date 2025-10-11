<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="/vistas/includes/head-resources.jsp" %>

<c:set var="pageActive" value="clientes" />
<!DOCTYPE html>
<html lang="es">
    <head>
        <title>Historial de Compras - ${cliente.nombre} ${cliente.apellido}</title>
        <style>
            .venta-card {
                border-left: 4px solid #3c8dbc;
                margin-bottom: 20px;
                transition: all 0.3s ease;
            }
            .venta-card:hover {
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
                transform: translateX(5px);
            }
            .venta-header {
                background: #f9f9f9;
                padding: 15px;
                border-bottom: 1px solid #e0e0e0;
            }
            .venta-body {
                padding: 15px;
            }
            .producto-row {
                padding: 8px;
                border-bottom: 1px dashed #e0e0e0;
            }
            .producto-row:last-child {
                border-bottom: none;
            }
            .producto-row:hover {
                background: #f5f5f5;
            }
            .resumen-box {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 20px;
                border-radius: 5px;
                margin-bottom: 20px;
            }
            .estado-badge {
                font-size: 12px;
                padding: 5px 10px;
            }
            .empty-state {
                text-align: center;
                padding: 60px 20px;
            }
            .empty-state i {
                font-size: 80px;
                color: #d0d0d0;
                margin-bottom: 20px;
            }
        </style>
        <!-- Estilos para impresión -->
        <style media="print">
            .main-header, .main-sidebar, .content-header .breadcrumb,
            .box-tools, .btn, .no-print {
                display: none !important;
            }
            .content-wrapper {
                margin-left: 0 !important;
            }
            .venta-card {
                page-break-inside: avoid;
                border: 1px solid #ccc;
            }
            .box {
                box-shadow: none;
                border: 1px solid #ccc;
            }
        </style>
    </head>
    <body class="hold-transition skin-blue sidebar-mini">
        <%@ include file="/vistas/includes/header-vendedor.jsp" %>
        <%@ include file="/vistas/includes/sidebar-vendedor.jsp" %>

        <div class="content-wrapper">
            <section class="content-header">
                <h1>
                    Historial de Compras
                    <small>${cliente.nombre} ${cliente.apellido}</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="srvDashboardVendedor?accion=listar"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                    <li><a href="srvClientes?accion=listar"> Clientes</a></li>
                    <li class="active"> Historial</li>
                </ol>
            </section>

            <section class="content">
                <%@ include file="/vistas/includes/alertas.jsp" %>

                <!-- Resumen del cliente -->
                <div class="resumen-box">
                    <div class="row">
                        <div class="col-md-8">
                            <h3 style="margin-top: 0; margin-bottom: 10px;">
                                <i class="fa fa-user"></i> ${cliente.nombre} ${cliente.apellido}
                            </h3>
                            <p style="margin: 0; opacity: 0.9;">
                                <i class="fa fa-envelope"></i> ${cliente.email}
                                <c:if test="${not empty cliente.telefono}">
                                    &nbsp;|&nbsp; <i class="fa fa-phone"></i> ${cliente.telefono}
                                </c:if>
                            </p>
                        </div>
                        <div class="col-md-4 text-right">
                            <h4 style="margin-top: 0;">Total Gastado</h4>
                            <h2 style="margin: 0; font-weight: bold;">
                                S/. <fmt:formatNumber value="${totalGastado}" pattern="#,##0.00" />
                            </h2>
                            <p style="margin: 5px 0 0 0; opacity: 0.9;">
                                ${fn:length(historialCompras)} compra(s) realizadas
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Botones de acción -->
                <div class="row" style="margin-bottom: 20px;">
                    <div class="col-xs-12">
                        <a href="srvClientes?accion=ver&id=${cliente.idUsuario}" class="btn btn-default">
                            <i class="fa fa-arrow-left"></i> Volver al detalle
                        </a>
                        <a href="srvClientes?accion=listar" class="btn btn-default">
                            <i class="fa fa-list"></i> Volver al listado
                        </a>
                        <button onclick="window.print()" class="btn btn-primary pull-right">
                            <i class="fa fa-print"></i> Imprimir historial
                        </button>
                    </div>
                </div>

                <!-- Listado de compras -->
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i class="fa fa-shopping-cart"></i> Detalle de Compras
                        </h3>
                        <div class="box-tools pull-right">
                            <span class="badge bg-blue">${fn:length(historialCompras)} venta(s)</span>
                        </div>
                    </div>
                    <div class="box-body">
                        <c:choose>
                            <c:when test="${empty historialCompras}">
                                <!-- Estado vacío -->
                                <div class="empty-state">
                                    <i class="fa fa-shopping-cart"></i>
                                    <h3>No hay compras registradas</h3>
                                    <p class="text-muted">
                                        Este cliente aún no ha realizado ninguna compra en el sistema.
                                    </p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- Listado de ventas -->
                                <c:forEach var="venta" items="${historialCompras}" varStatus="status">
                                    <div class="venta-card">
                                        <!-- Cabecera de la venta -->
                                        <div class="venta-header">
                                            <div class="row">
                                                <div class="col-md-3 col-sm-6">
                                                    <strong><i class="fa fa-hashtag"></i> Venta #${venta.idVenta}</strong>
                                                </div>
                                                <div class="col-md-3 col-sm-6">
                                                    <i class="fa fa-calendar"></i> 
                                                    <fmt:formatDate value="${venta.fechaVenta}" pattern="dd/MM/yyyy HH:mm" />
                                                </div>
                                                <div class="col-md-3 col-sm-6">
                                                    <i class="fa fa-money"></i> 
                                                    <strong>S/. <fmt:formatNumber value="${venta.totalFinal}" pattern="#,##0.00" /></strong>
                                                </div>
                                                <div class="col-md-3 col-sm-6 text-right">
                                                    <c:choose>
                                                        <c:when test="${venta.estado}">
                                                            <span class="label label-success estado-badge">
                                                                <i class="fa fa-check-circle"></i> Completada
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="label label-danger estado-badge">
                                                                <i class="fa fa-times-circle"></i> Anulada
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Detalle de productos -->
                                        <div class="venta-body">
                                            <c:choose>
                                                <c:when test="${not empty venta.productos}">
                                                    <table class="table table-condensed" style="margin-bottom: 0;">
                                                        <thead>
                                                            <tr style="background: #f5f5f5;">
                                                                <th width="50%">Producto</th>
                                                                <th width="15%" class="text-center">Cantidad</th>
                                                                <th width="17%" class="text-right">P. Unitario</th>
                                                                <th width="18%" class="text-right">Subtotal</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="item" items="${venta.productos}">
                                                                <tr class="producto-row">
                                                                    <td>
                                                                        <i class="fa fa-cube text-muted"></i>
                                                                        ${item.nombreProducto}
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <span class="badge bg-gray">${item.cantidad}</span>
                                                                    </td>
                                                                    <td class="text-right">
                                                                        S/. <fmt:formatNumber value="${item.precioUnitario}" pattern="#,##0.00" />
                                                                    </td>
                                                                    <td class="text-right">
                                                                        <strong>
                                                                            S/. <fmt:formatNumber value="${item.cantidad * item.precioUnitario}" pattern="#,##0.00" />
                                                                        </strong>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                        <tfoot>
                                                            <tr style="background: #f9f9f9; font-weight: bold;">
                                                                <td colspan="3" class="text-right" style="padding: 10px;">
                                                                    TOTAL:
                                                                </td>
                                                                <td class="text-right" style="padding: 10px; font-size: 16px; color: #3c8dbc;">
                                                                    S/. <fmt:formatNumber value="${venta.totalFinal}" pattern="#,##0.00" />
                                                                </td>
                                                            </tr>
                                                        </tfoot>
                                                    </table>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="alert alert-warning" style="margin: 0;">
                                                        <i class="fa fa-exclamation-triangle"></i>
                                                        No se encontraron productos para esta venta.
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:forEach>

                                <!-- Resumen final -->
                                <div class="row" style="margin-top: 30px;">
                                    <div class="col-md-6 col-md-offset-6">
                                        <div class="box box-solid" style="margin-bottom: 0;">
                                            <div class="box-body" style="background: #ecf0f5;">
                                                <table class="table" style="margin: 0;">
                                                    <tr>
                                                        <td><strong>Total de compras:</strong></td>
                                                        <td class="text-right">${fn:length(historialCompras)}</td>
                                                    </tr>
                                                    <tr>
                                                        <td><strong>Monto promedio por compra:</strong></td>
                                                        <td class="text-right">
                                                            S/. <fmt:formatNumber value="${totalGastado / fn:length(historialCompras)}" pattern="#,##0.00" />
                                                        </td>
                                                    </tr>
                                                    <tr style="background: #3c8dbc; color: white; font-size: 16px;">
                                                        <td><strong>TOTAL GASTADO:</strong></td>
                                                        <td class="text-right">
                                                            <strong>S/. <fmt:formatNumber value="${totalGastado}" pattern="#,##0.00" /></strong>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </section>
        </div>

        <%@ include file="/vistas/includes/footer.jsp" %>

        <script>
            $(document).ready(function () {
                // Auto-ocultar alertas después de 5 segundos
                setTimeout(function () {
                    $('.alert').fadeOut('slow');
                }, 5000);

                // Mejorar la experiencia de impresión
                window.onbeforeprint = function () {
                    $('.content-wrapper').css('margin-left', '0');
                    $('.main-header, .main-sidebar, .breadcrumb, .box-tools, .btn').hide();
                };

                window.onafterprint = function () {
                    $('.content-wrapper').css('margin-left', '');
                    $('.main-header, .main-sidebar, .breadcrumb, .box-tools, .btn').show();
                };
            });
        </script>
    </body>
</html>