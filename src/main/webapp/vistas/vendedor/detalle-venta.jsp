<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/vistas/includes/head-resources.jsp" %>

<c:set var="pageActive" value="ventas" />
<!DOCTYPE html>
<html lang="es">
    <head>
        <title>Detalle de Venta</title>
        <style>
            .info-box-custom {
                border: 1px solid #ddd;
                border-radius: 3px;
                padding: 15px;
                margin-bottom: 20px;
                background: #fff;
            }
            .info-box-custom h4 {
                margin-top: 0;
                color: #3c8dbc;
                border-bottom: 2px solid #3c8dbc;
                padding-bottom: 10px;
            }
            .detail-row {
                margin-bottom: 10px;
            }
            .detail-label {
                font-weight: bold;
                color: #666;
            }
            .table-productos th {
                background-color: #3c8dbc;
                color: white;
            }
            .total-section {
                background: #f4f4f4;
                padding: 15px;
                border-radius: 3px;
                margin-top: 20px;
            }
            .btn-action-group {
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body class="hold-transition skin-blue sidebar-mini">
        <div class="wrapper">

            <%@ include file="/vistas/includes/header-vendedor.jsp" %>
            <%@ include file="/vistas/includes/sidebar-vendedor.jsp" %>

            <div class="content-wrapper">
                <section class="content-header">
                    <h1>
                        Detalle de Venta
                        <small>Información completa de la venta</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="srvDashboardVendedor?accion=listar"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                        <li><a href="srvVentas?accion=listar"><i class="fa fa-shopping-cart"></i> Ventas</a></li>
                        <li class="active">Detalle</li>
                    </ol>
                </section>

                <section class="content">
                    <%@ include file="/vistas/includes/alertas.jsp" %>

                    <!-- Botones de acción -->
                    <div class="btn-action-group">
                        <a href="srvVentas?accion=listar" class="btn btn-default">
                            <i class="fa fa-arrow-left"></i> Volver al listado
                        </a>
                        <a href="srvVentas?accion=descargarBoleta&id=${venta.idVenta}" 
                           class="btn btn-primary" 
                           target="_blank">
                            <i class="fa fa-file-pdf-o"></i> Descargar Boleta PDF
                        </a>
                    </div>

                    <div class="row">
                        <!-- Información de la Venta -->
                        <div class="col-md-6">
                            <div class="info-box-custom">
                                <h4><i class="fa fa-file-text"></i> Información de la Venta</h4>

                                <div class="detail-row">
                                    <span class="detail-label">Número de Venta:</span>
                                    <span class="pull-right">
                                        <strong style="font-size: 16px; color: #3c8dbc;">
                                            B<fmt:formatNumber value="${venta.idVenta}" pattern="000000"/>
                                        </strong>
                                    </span>
                                </div>

                                <div class="detail-row">
                                    <span class="detail-label">Fecha y Hora:</span>
                                    <span class="pull-right">
                                        <i class="fa fa-calendar"></i> 
                                        <fmt:formatDate value="${venta.fechaVenta}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                    </span>
                                </div>

                                <div class="detail-row">
                                    <span class="detail-label">Estado:</span>
                                    <span class="pull-right">
                                        <c:choose>
                                            <c:when test="${venta.estado}">
                                                <span class="label label-success">
                                                    <i class="fa fa-check"></i> Activa
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="label label-danger">
                                                    <i class="fa fa-times"></i> Cancelada
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>

                                <div class="detail-row">
                                    <span class="detail-label">Total de Venta:</span>
                                    <span class="pull-right">
                                        <strong style="font-size: 18px; color: #00a65a;">
                                            S/. <fmt:formatNumber value="${venta.totalFinal}" pattern="#,##0.00"/>
                                        </strong>
                                    </span>
                                </div>
                            </div>
                        </div>

                        <!-- Información del Cliente -->
                        <div class="col-md-6">
                            <div class="info-box-custom">
                                <h4><i class="fa fa-user"></i> Información del Cliente</h4>

                                <div class="detail-row">
                                    <span class="detail-label">Nombre Completo:</span>
                                    <span class="pull-right">
                                        ${venta.nombreCliente != null ? venta.nombreCliente : 'No especificado'}
                                    </span>
                                </div>

                                <div class="detail-row">
                                    <span class="detail-label">Email:</span>
                                    <span class="pull-right">
                                        <i class="fa fa-envelope"></i> 
                                        ${venta.emailCliente != null ? venta.emailCliente : 'No especificado'}
                                    </span>
                                </div>

                                <div class="detail-row">
                                    <span class="detail-label">Teléfono:</span>
                                    <span class="pull-right">
                                        <i class="fa fa-phone"></i> 
                                        ${venta.telefonoCliente != null ? venta.telefonoCliente : 'No especificado'}
                                    </span>
                                </div>

                                <div class="detail-row">
                                    <span class="detail-label">Dirección:</span>
                                    <span class="pull-right">
                                        <i class="fa fa-map-marker"></i> 
                                        ${venta.direccionCliente != null ? venta.direccionCliente : 'No especificado'}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Detalle de Productos -->
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">
                                <i class="fa fa-shopping-basket"></i> Productos Comprados
                            </h3>
                            <span class="badge bg-blue pull-right" style="font-size: 14px; padding: 5px 10px;">
                                ${venta.productos != null ? venta.productos.size() : 0} producto(s)
                            </span>
                        </div>

                        <div class="box-body">
                            <c:choose>
                                <c:when test="${empty venta.productos}">
                                    <div class="alert alert-warning">
                                        <i class="fa fa-exclamation-triangle"></i> 
                                        No se encontraron productos para esta venta.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-bordered table-striped table-hover table-productos">
                                            <thead>
                                                <tr>
                                                    <th style="width: 5%;">#</th>
                                                    <th style="width: 35%;">Producto</th>
                                                    <th style="width: 12%;">Color</th>
                                                    <th style="width: 10%;">Talla</th>
                                                    <th style="width: 10%;" class="text-center">Cantidad</th>
                                                    <th style="width: 14%;" class="text-right">P. Unitario</th>
                                                    <th style="width: 14%;" class="text-right">Subtotal</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach var="item" items="${venta.productos}" varStatus="status">
                                                <tr>
                                                    <td class="text-center">${status.index + 1}</td>
                                                    <td>
                                                        <strong>${item.nombreProducto}</strong>
                                                    </td>
                                                    <td>
                                                <c:choose>
                                                    <c:when test="${not empty item.color}">
                                                        <span class="label label-default">${item.color}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">-</span>
                                                    </c:otherwise>
                                                </c:choose>
                                                </td>
                                                <td>
                                                <c:choose>
                                                    <c:when test="${not empty item.talla}">
                                                        <span class="label label-info">${item.talla}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">-</span>
                                                    </c:otherwise>
                                                </c:choose>
                                                </td>
                                                <td class="text-center">
                                                    <strong>${item.cantidad}</strong>
                                                </td>
                                                <td class="text-right">
                                                    S/. <fmt:formatNumber value="${item.precioUnitario}" pattern="#,##0.00"/>
                                                </td>
                                                <td class="text-right">
                                                    <strong style="color: #00a65a;">
                                                        S/. <fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/>
                                                    </strong>
                                                </td>
                                                </tr>
                                            </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- Total -->
                                    <div class="total-section">
                                        <div class="row">
                                            <div class="col-xs-8 text-right">
                                                <h4 style="margin: 0;">TOTAL FINAL:</h4>
                                            </div>
                                            <div class="col-xs-4 text-right">
                                                <h3 style="margin: 0; color: #00a65a;">
                                                    <strong>S/. <fmt:formatNumber value="${venta.totalFinal}" pattern="#,##0.00"/></strong>
                                                </h3>
                                            </div>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Botones de acción inferior -->
                    <div class="btn-action-group">
                        <a href="srvVentas?accion=listar" class="btn btn-default">
                            <i class="fa fa-arrow-left"></i> Volver al listado
                        </a>
                        <a href="srvVentas?accion=descargarBoleta&id=${venta.idVenta}" 
                           class="btn btn-primary" 
                           target="_blank">
                            <i class="fa fa-file-pdf-o"></i> Descargar Boleta PDF
                        </a>
                    </div>

                </section>
            </div>

            <%@ include file="/vistas/includes/footer.jsp" %>
        </div>

        <script>
            $(document).ready(function () {
                setTimeout(function () {
                    $('.alert').fadeOut('slow');
                }, 5000);
            });
        </script>
    </body>
</html>
