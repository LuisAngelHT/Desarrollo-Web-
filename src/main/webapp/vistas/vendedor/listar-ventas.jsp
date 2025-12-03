<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/vistas/includes/head-resources.jsp" %>

<c:set var="pageActive" value="ventas" />
<!DOCTYPE html>
<html lang="es">
    <head>
        <title>Gestión de Ventas</title>
        <style>
            .search-box {
                position: relative;
            }
            .search-loading {
                position: absolute;
                right: 10px;
                top: 50%;
                transform: translateY(-50%);
                display: none;
            }
            .table-hover tbody tr:hover {
                background-color: #f5f5f5;
                cursor: pointer;
            }
            .filter-buttons {
                margin-bottom: 15px;
            }
            .filter-buttons .btn {
                margin-right: 5px;
            }
        </style>
    </head>
    <body class="hold-transition skin-blue sidebar-mini">
        <div class="wrapper">

            <%@ include file="/vistas/includes/header-vendedor.jsp" %>
            <%@ include file="/vistas/includes/sidebar-vendedor.jsp" %>

            <div class="content-wrapper">
                <section class="content-header">
                    <h1>Ventas</h1>
                    <small>Historial y gestión de ventas realizadas</small>
                    <ol class="breadcrumb">
                        <li><a href="srvDashboardVendedor?accion=listar"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                        <li class="active">Ventas</li>
                    </ol>
                </section>

                <section class="content">
                    <%@ include file="/vistas/includes/alertas.jsp" %>

                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <div class="row">
                                <!-- Título y badges -->
                                <div class="col-md-6">
                                    <h3 class="box-title" style="margin: 0;">
                                        Historial de Ventas
                                    </h3>
                                    <div style="margin-top: 10px;">
                                        <span class="badge bg-blue" style="font-size: 13px; padding: 6px 10px;">
                                            <i class="fa fa-shopping-cart"></i> ${totalVentas} venta(s)
                                        </span>
                                        <c:if test="${not empty montoTotal}">
                                            <span class="badge bg-green" style="font-size: 13px; padding: 6px 10px; margin-left: 5px;">
                                                <i class="fa fa-money"></i> S/. <fmt:formatNumber value="${montoTotal}" pattern="#,##0.00"/>
                                            </span>
                                        </c:if>
                                    </div>
                                </div>

                                <!-- Búsqueda en tiempo real -->
                                <div class="col-md-6 text-right">
                                    <div class="search-box" style="display: inline-block; position: relative; width: 350px;">
                                        <input type="text" 
                                               id="buscarVenta" 
                                               class="form-control" 
                                               placeholder="Buscar por cliente o número de venta..."
                                               value="${terminoBusqueda}"
                                               autocomplete="off">
                                        <i class="fa fa-spinner fa-spin search-loading"></i>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Filtros por estado -->
                        <div class="box-body">
                            <div class="filter-buttons">
                                <c:choose>
                                    <c:when test="${empty estadoFiltro and empty terminoBusqueda}">
                                        <a href="srvVentas?accion=listar" class="btn btn-sm btn-primary">
                                            <i class="fa fa-list"></i> Todas
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="srvVentas?accion=listar" class="btn btn-sm btn-default">
                                            <i class="fa fa-list"></i> Todas
                                        </a>
                                    </c:otherwise>
                                </c:choose>

                                <c:choose>
                                    <c:when test="${estadoFiltro eq true}">
                                        <a href="srvVentas?accion=filtrar&estado=true" class="btn btn-sm btn-success">
                                            <i class="fa fa-check-circle"></i> Activas
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="srvVentas?accion=filtrar&estado=true" class="btn btn-sm btn-default">
                                            <i class="fa fa-check-circle"></i> Activas
                                        </a>
                                    </c:otherwise>
                                </c:choose>

                                <c:choose>
                                    <c:when test="${estadoFiltro eq false}">
                                        <a href="srvVentas?accion=filtrar&estado=false" class="btn btn-sm btn-danger">
                                            <i class="fa fa-times-circle"></i> Canceladas
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="srvVentas?accion=filtrar&estado=false" class="btn btn-sm btn-default">
                                            <i class="fa fa-times-circle"></i> Canceladas
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <c:choose>
                                <c:when test="${empty listaVentas}">
                                    <div class="alert alert-info">
                                        <i class="fa fa-info-circle"></i> 
                                        <c:choose>
                                            <c:when test="${not empty terminoBusqueda}">
                                                No se encontraron ventas que coincidan con "<strong>${terminoBusqueda}</strong>".
                                            </c:when>
                                            <c:otherwise>
                                                No hay ventas registradas en el sistema.
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-bordered table-hover table-striped table-condensed">
                                            <thead class="bg-light-blue">
                                                <tr>
                                                    <th style="width: 8%;">N° Venta</th>
                                                    <th style="width: 22%;">Cliente</th>
                                                    <th style="width: 15%;">Fecha</th>
                                                    <th style="width: 12%;">Total</th>
                                                    <th style="width: 10%;">Estado</th>
                                                    <th style="width: 13%;">Acciones</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach var="v" items="${listaVentas}">
                                                <tr>
                                                    <td class="text-center">
                                                        <strong>B<fmt:formatNumber value="${v.idVenta}" pattern="000000"/></strong>
                                                    </td>
                                                    <td>
                                                        <i class="fa fa-user"></i> ${v.nombreCliente}
                                                    </td>
                                                    <td>
                                                        <i class="fa fa-calendar"></i> 
                                                <fmt:formatDate value="${v.fechaVenta}" pattern="dd/MM/yyyy HH:mm"/>
                                                </td>
                                                <td class="text-right">
                                                    <strong style="color: #00a65a;">
                                                        S/. <fmt:formatNumber value="${v.totalFinal}" pattern="#,##0.00"/>
                                                    </strong>
                                                </td>
                                                <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${v.estado}">
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
                                                </td>
                                                <td class="text-center">
                                                    <a href="srvVentas?accion=ver&id=${v.idVenta}" 
                                                       class="btn btn-xs btn-info" 
                                                       title="Ver detalle">
                                                        <i class="fa fa-eye"></i>
                                                    </a>
                                                    <a href="srvVentas?accion=descargarBoleta&id=${v.idVenta}" 
                                                       class="btn btn-xs btn-primary" 
                                                       title="Descargar boleta"
                                                       target="_blank">
                                                        <i class="fa fa-file-pdf-o"></i>
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

                        <!-- Paginación -->
                        <c:if test="${totalPaginas > 1}">
                            <div class="box-footer clearfix">
                                <div class="row">
                                    <!-- Información de registros -->
                                    <div class="col-sm-5">
                                        <div class="dataTables_info" style="padding-top: 7px;">
                                            Mostrando ${(paginaActual - 1) * 10 + 1} a 
                                            ${paginaActual * 10 > totalVentas ? totalVentas : paginaActual * 10} 
                                            de ${totalVentas} ventas
                                        </div>
                                    </div>

                                    <!-- Controles de paginación -->
                                    <div class="col-sm-7">
                                        <ul class="pagination pagination-sm no-margin pull-right">

                                            <!-- Primera página -->
                                            <li class="${paginaActual == 1 ? 'disabled' : ''}">
                                            <c:choose>
                                                <c:when test="${not empty terminoBusqueda}">
                                                    <a href="srvVentas?accion=buscar&termino=${terminoBusqueda}&pagina=1">
                                                        <i class="fa fa-angle-double-left"></i>
                                                    </a>
                                                </c:when>
                                                <c:when test="${not empty estadoFiltro}">
                                                    <a href="srvVentas?accion=filtrar&estado=${estadoFiltro}&pagina=1">
                                                        <i class="fa fa-angle-double-left"></i>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="srvVentas?accion=listar&pagina=1">
                                                        <i class="fa fa-angle-double-left"></i>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                            </li>

                                            <!-- Anterior -->
                                            <li class="${paginaActual == 1 ? 'disabled' : ''}">
                                            <c:choose>
                                                <c:when test="${not empty terminoBusqueda}">
                                                    <a href="srvVentas?accion=buscar&termino=${terminoBusqueda}&pagina=${paginaActual - 1}">
                                                        <i class="fa fa-angle-left"></i>
                                                    </a>
                                                </c:when>
                                                <c:when test="${not empty estadoFiltro}">
                                                    <a href="srvVentas?accion=filtrar&estado=${estadoFiltro}&pagina=${paginaActual - 1}">
                                                        <i class="fa fa-angle-left"></i>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="srvVentas?accion=listar&pagina=${paginaActual - 1}">
                                                        <i class="fa fa-angle-left"></i>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                            </li>

                                            <!-- Números de página -->
                                            <c:forEach begin="1" end="${totalPaginas}" var="i">
                                                <c:choose>
                                                    <c:when test="${i == paginaActual}">
                                                        <li class="active"><a href="#">${i}</a></li>
                                                    </c:when>
                                                    <c:when test="${i >= paginaActual - 2 && i <= paginaActual + 2}">
                                                        <li>
                                                        <c:choose>
                                                            <c:when test="${not empty terminoBusqueda}">
                                                                <a href="srvVentas?accion=buscar&termino=${terminoBusqueda}&pagina=${i}">${i}</a>
                                                            </c:when>
                                                            <c:when test="${not empty estadoFiltro}">
                                                                <a href="srvVentas?accion=filtrar&estado=${estadoFiltro}&pagina=${i}">${i}</a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <a href="srvVentas?accion=listar&pagina=${i}">${i}</a>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        </li>
                                                    </c:when>
                                                </c:choose>
                                            </c:forEach>

                                            <!-- Siguiente -->
                                            <li class="${paginaActual == totalPaginas ? 'disabled' : ''}">
                                            <c:choose>
                                                <c:when test="${not empty terminoBusqueda}">
                                                    <a href="srvVentas?accion=buscar&termino=${terminoBusqueda}&pagina=${paginaActual + 1}">
                                                        <i class="fa fa-angle-right"></i>
                                                    </a>
                                                </c:when>
                                                <c:when test="${not empty estadoFiltro}">
                                                    <a href="srvVentas?accion=filtrar&estado=${estadoFiltro}&pagina=${paginaActual + 1}">
                                                        <i class="fa fa-angle-right"></i>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="srvVentas?accion=listar&pagina=${paginaActual + 1}">
                                                        <i class="fa fa-angle-right"></i>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                            </li>

                                            <!-- Última página -->
                                            <li class="${paginaActual == totalPaginas ? 'disabled' : ''}">
                                            <c:choose>
                                                <c:when test="${not empty terminoBusqueda}">
                                                    <a href="srvVentas?accion=buscar&termino=${terminoBusqueda}&pagina=${totalPaginas}">
                                                        <i class="fa fa-angle-double-right"></i>
                                                    </a>
                                                </c:when>
                                                <c:when test="${not empty estadoFiltro}">
                                                    <a href="srvVentas?accion=filtrar&estado=${estadoFiltro}&pagina=${totalPaginas}">
                                                        <i class="fa fa-angle-double-right"></i>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="srvVentas?accion=listar&pagina=${totalPaginas}">
                                                        <i class="fa fa-angle-double-right"></i>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </section>
            </div>

            <%@ include file="/vistas/includes/footer.jsp" %>
        </div>

        <!-- Script de búsqueda en tiempo real -->
        <script>
            $(document).ready(function () {
                var timeout = null;
                var $input = $('#buscarVenta');
                var $loading = $('.search-loading');

                $input.on('keyup', function () {
                    clearTimeout(timeout);
                    var termino = $(this).val().trim();

                    // Mostrar spinner
                    $loading.show();

                    // Delay de 300ms antes de buscar
                    timeout = setTimeout(function () {
                        if (termino.length === 0) {
                            window.location.href = 'srvVentas?accion=listar';
                        } else if (termino.length >= 2) {
                            window.location.href = 'srvVentas?accion=buscar&termino=' + encodeURIComponent(termino);
                        } else {
                            $loading.hide();
                        }
                    }, 300);
                });

                setTimeout(function () {
                    $loading.hide();
                }, 100);

                setTimeout(function () {
                    $('.alert').fadeOut('slow');
                }, 5000);
            });
        </script>
    </body>
</html>
