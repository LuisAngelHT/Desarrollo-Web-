<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="/vistas/includes/head-resources.jsp" %>

<c:set var="pageActive" value="clientes" />
<!DOCTYPE html>
<html lang="es">
    <head>
        <title>Detalle del Cliente</title>
        <style>
            .info-box {
                cursor: default;
            }
            .profile-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 30px;
                border-radius: 3px;
                margin-bottom: 20px;
            }
            .stat-card {
                transition: transform 0.2s;
            }
            .stat-card:hover {
                transform: translateY(-5px);
            }
            .producto-item {
                padding: 10px;
                border-left: 3px solid #3c8dbc;
                margin-bottom: 10px;
                background: #f9f9f9;
            }
            .badge-custom {
                font-size: 12px;
                padding: 5px 10px;
            }
        </style>
    </head>
    <body class="hold-transition skin-blue sidebar-mini">
        <%@ include file="/vistas/includes/header-vendedor.jsp" %>
        <%@ include file="/vistas/includes/sidebar-vendedor.jsp" %>

        <div class="content-wrapper">
            <section class="content-header">
                <h1>
                    Detalle del Cliente
                    <small>Información completa</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="srvDashboardVendedor?accion=listar"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                    <li><a href="srvClientes?accion=listar"> Clientes</a></li>
                    <li class="active"> Detalle</li>
                </ol>
            </section>

            <section class="content">
                <%@ include file="/vistas/includes/alertas.jsp" %>

                <!-- Box superior: Información personal del cliente -->
                <div class="box box-primary">
                    <div class="box-body box-profile">
                        <div class="row">
                            <!-- Avatar y nombre -->
                            <div class="col-md-3 text-center">
                                <div style="width: 150px; height: 150px; margin: 0 auto 15px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                                    <span style="font-size: 60px; color: white; font-weight: bold;">
                                        ${fn:substring(cliente.nombre, 0, 1)}${fn:substring(cliente.apellido, 0, 1)}
                                    </span>
                                </div>
                                <h3 class="profile-username text-center" style="margin-top: 0;">
                                    ${cliente.nombre} ${cliente.apellido}
                                </h3>
                                <p class="text-muted text-center">
                                    <c:choose>
                                        <c:when test="${cliente.estado}">
                                            <span class="label label-success badge-custom">
                                                <i class="fa fa-check-circle"></i> Cliente Activo
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="label label-default badge-custom">
                                                <i class="fa fa-ban"></i> Cliente Inactivo
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>

                            <!-- Información de contacto -->
                            <div class="col-md-9">
                                <h4 style="margin-top: 0; border-bottom: 2px solid #3c8dbc; padding-bottom: 10px;">
                                    <i class="fa fa-info-circle"></i> Información de Contacto
                                </h4>
                                <div class="row" style="margin-top: 20px;">
                                    <div class="col-md-6">
                                        <ul class="list-unstyled" style="font-size: 15px; line-height: 2;">
                                            <li>
                                                <i class="fa fa-envelope text-primary" style="width: 25px;"></i>
                                                <strong>Email:</strong> ${cliente.email}
                                            </li>
                                            <li>
                                                <i class="fa fa-phone text-success" style="width: 25px;"></i>
                                                <strong>Teléfono:</strong> 
                                                <c:choose>
                                                    <c:when test="${not empty cliente.telefono}">
                                                        ${cliente.telefono}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">No registrado</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="col-md-6">
                                        <ul class="list-unstyled" style="font-size: 15px; line-height: 2;">
                                            <li>
                                                <i class="fa fa-map-marker text-danger" style="width: 25px;"></i>
                                                <strong>Dirección:</strong> 
                                                <c:choose>
                                                    <c:when test="${not empty cliente.direccion}">
                                                        ${cliente.direccion}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">No registrada</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </li>
                                            <li>
                                                <i class="fa fa-calendar text-warning" style="width: 25px;"></i>
                                                <strong>Fecha de Registro:</strong> 
                                                <fmt:formatDate value="${cliente.fechaRegistro}" pattern="dd/MM/yyyy" />
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="box-footer">
                        <div class="row">
                            <div class="col-xs-12">
                                <a href="srvClientes?accion=listar" class="btn btn-default">
                                    <i class="fa fa-arrow-left"></i> Volver al listado
                                </a>
                                <a href="srvClientes?accion=historial&id=${cliente.idUsuario}" class="btn btn-primary">
                                    <i class="fa fa-shopping-cart"></i> Ver historial completo
                                </a>
                                <c:choose>
                                    <c:when test="${cliente.estado}">
                                        <button type="button" class="btn btn-warning pull-right" onclick="cambiarEstado(${cliente.idUsuario}, false)">
                                            <i class="fa fa-ban"></i> Desactivar cliente
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" class="btn btn-success pull-right" onclick="cambiarEstado(${cliente.idUsuario}, true)">
                                            <i class="fa fa-check"></i> Activar cliente
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Box de estadísticas: Cards con métricas rápidas -->
                <div class="row">
                    <!-- Total de compras -->
                    <div class="col-lg-4 col-xs-6">
                        <div class="small-box bg-aqua stat-card">
                            <div class="inner">
                                <h3>${totalCompras}</h3>
                                <p>Total de Compras</p>
                            </div>
                            <div class="icon">
                                <i class="fa fa-shopping-cart"></i>
                            </div>
                            <a href="srvClientes?accion=historial&id=${cliente.idUsuario}" class="small-box-footer">
                                Ver historial <i class="fa fa-arrow-circle-right"></i>
                            </a>
                        </div>
                    </div>

                    <!-- Monto total gastado -->
                    <div class="col-lg-4 col-xs-6">
                        <div class="small-box bg-green stat-card">
                            <div class="inner">
                                <h3>S/. <fmt:formatNumber value="${montoTotalGastado}" pattern="#,##0.00" /></h3>
                                <p>Monto Total Gastado</p>
                            </div>
                            <div class="icon">
                                <i class="fa fa-money"></i>
                            </div>
                            <a href="#" class="small-box-footer">
                                <c:choose>
                                    <c:when test="${totalCompras > 0}">
                                        Promedio: S/. <fmt:formatNumber value="${montoTotalGastado / totalCompras}" pattern="#,##0.00" />
                                    </c:when>
                                    <c:otherwise>
                                        Sin compras aún
                                    </c:otherwise>
                                </c:choose>
                            </a>
                        </div>
                    </div>

                    <!-- Última compra -->
                    <div class="col-lg-4 col-xs-6">
                        <div class="small-box bg-yellow stat-card">
                            <div class="inner">
                                <h3>
                                    <c:choose>
                                        <c:when test="${not empty ultimaCompra}">
                                            <fmt:formatDate value="${ultimaCompra.fechaVenta}" pattern="dd/MM/yyyy" />
                                        </c:when>
                                        <c:otherwise>
                                            N/A
                                        </c:otherwise>
                                    </c:choose>
                                </h3>
                                <p>Última Compra</p>
                            </div>
                            <div class="icon">
                                <i class="fa fa-calendar"></i>
                            </div>
                            <a href="#" class="small-box-footer">
                                <c:choose>
                                    <c:when test="${not empty ultimaCompra}">
                                        Monto: S/. <fmt:formatNumber value="${ultimaCompra.totalFinal}" pattern="#,##0.00" />
                                    </c:when>
                                    <c:otherwise>
                                        Sin compras registradas
                                    </c:otherwise>
                                </c:choose>
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Top productos más comprados -->
                <div class="row">
                    <div class="col-md-12">
                        <div class="box box-success">
                            <div class="box-header with-border">
                                <h3 class="box-title">
                                    <i class="fa fa-star"></i> Top Productos Más Comprados
                                </h3>
                            </div>
                            <div class="box-body">
                                <c:choose>
                                    <c:when test="${not empty topProductos}">
                                        <div class="row">
                                            <c:forEach var="producto" items="${topProductos}" varStatus="status">
                                                <div class="col-md-6">
                                                    <div class="producto-item">
                                                        <div class="row">
                                                            <div class="col-xs-2 text-center">
                                                                <span class="badge bg-blue" style="font-size: 18px; padding: 10px 15px;">
                                                                    ${status.index + 1}
                                                                </span>
                                                            </div>
                                                            <div class="col-xs-7">
                                                                <strong style="font-size: 15px;">${producto.nombreProducto}</strong>
                                                                <br>
                                                                <small class="text-muted">
                                                                    <i class="fa fa-tag"></i> Categoría: ${producto.categoria}
                                                                </small>
                                                            </div>
                                                            <div class="col-xs-3 text-right">
                                                                <span class="badge bg-green" style="font-size: 14px;">
                                                                    ${producto.cantidadComprada} unidades
                                                                </span>
                                                                <br>
                                                                <small class="text-muted">
                                                                    S/. <fmt:formatNumber value="${producto.totalGastado}" pattern="#,##0.00" />
                                                                </small>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <c:if test="${status.index % 2 == 1}">
                                                    <div class="clearfix visible-md visible-lg"></div>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="alert alert-info">
                                            <i class="fa fa-info-circle"></i> 
                                            Este cliente aún no ha realizado compras.
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

        <!-- Modal de confirmación para cambiar estado -->
        <div class="modal fade" id="modalCambiarEstado" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Confirmar acción</h4>
                    </div>
                    <div class="modal-body">
                        <p id="mensajeConfirmacion"></p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
                        <button type="button" class="btn btn-primary" id="btnConfirmarCambio">Confirmar</button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            var idClienteActual = 0;
            var nuevoEstado = false;

            function cambiarEstado(idCliente, activar) {
                idClienteActual = idCliente;
                nuevoEstado = activar;

                var mensaje = activar ?
                        '¿Está seguro de que desea <strong>activar</strong> este cliente?' :
                        '¿Está seguro de que desea <strong>desactivar</strong> este cliente?';

                $('#mensajeConfirmacion').html(mensaje);
                $('#modalCambiarEstado').modal('show');
            }

            $(document).ready(function () {
                $('#btnConfirmarCambio').click(function () {
                    // Enviar petición al servlet
                    window.location.href = 'srvClientes?accion=cambiarEstado&id=' + idClienteActual + '&estado=' + nuevoEstado;
                });

                // Auto-ocultar alertas después de 5 segundos
                setTimeout(function () {
                    $('.alert').fadeOut('slow');
                }, 5000);
            });
        </script>
    </body>
</html>