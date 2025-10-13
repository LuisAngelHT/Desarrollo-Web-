<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/vistas/includes/head-resources.jsp" %>

<c:set var="pageActive" value="clientes" />
<!DOCTYPE html>
<html lang="es">
    <head>
        <title>Gestión de clientes</title>
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
        </style>
    </head>
    <body class="hold-transition skin-blue sidebar-mini">
        <div class="wrapper">

            <%@ include file="/vistas/includes/header-vendedor.jsp" %>
            <%@ include file="/vistas/includes/sidebar-vendedor.jsp" %>

            <div class="content-wrapper">
                <section class="content-header">
                    <h1>Clientes</h1>
                    <small>Gestión de clientes registrados</small>
                    <ol class="breadcrumb">
                        <li><a href="srvDashboardVendedor?accion=listar"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                        <li class="active"> Clientes</li>
                    </ol>
                </section>

                <section class="content">
                    <%@ include file="/vistas/includes/alertas.jsp" %>

                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <div class="row">
                                <!-- Título y badge -->
                                <div class="col-md-6">
                                    <h3 class="box-title" style="margin: 0;">
                                        Listado de clientes
                                    </h3>
                                </div>

                                <!-- Búsqueda en tiempo real -->
                                <div class="col-md-6 text-right">
                                    <div class="search-box" style="display: inline-block; position: relative; width: 300px;">
                                        <input type="text" 
                                               id="buscarCliente" 
                                               class="form-control" 
                                               placeholder="Buscar por nombre, apellido o email..."
                                               value="${terminoBusqueda}"
                                               autocomplete="off">
                                        <i class="fa fa-spinner fa-spin search-loading"></i>
                                    </div>
                                    <span class="badge bg-blue" style="font-size: 14px; padding: 8px 12px; margin-left: 10px;">
                                        ${totalClientes} cliente(s)
                                    </span>
                                </div>
                            </div>
                        </div>

                        <div class="box-body">
                            <c:choose>
                                <c:when test="${empty listaClientes}">
                                    <div class="alert alert-info">
                                        <i class="fa fa-info-circle"></i> 
                                        <c:choose>
                                            <c:when test="${not empty terminoBusqueda}">
                                                No se encontraron clientes que coincidan con "<strong>${terminoBusqueda}</strong>".
                                            </c:when>
                                            <c:otherwise>
                                                No hay clientes registrados en el sistema.
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <table class="table table-bordered table-hover table-striped table-condensed">
                                        <thead class="bg-light-blue">
                                            <tr>
                                                <th style="width: 20%;">Nombre completo</th>
                                                <th style="width: 20%;">Email</th>
                                                <th style="width: 15%;">Teléfono</th>
                                                <th style="width: 30%;">Dirección</th>
                                                <th style="width: 8%;">Estado</th>
                                                <th style="width: 7%;">Acciones</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="c" items="${listaClientes}">
                                                <tr>
                                                    <td><strong>${c.nombre} ${c.apellido}</strong></td>
                                                    <td>${c.email}</td>
                                                    <td>${c.telefono != null ? c.telefono : '-'}</td>
                                                    <td>${c.direccion != null ? c.direccion : '-'}</td>
                                                    <td class="text-center">
                                                        <c:choose>
                                                            <c:when test="${c.estado}">
                                                                <span class="label label-success">Activo</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="label label-default">Inactivo</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-center">
                                                        <a href="srvClientes?accion=ver&id=${c.idUsuario}" 
                                                           class="btn btn-xs btn-info" 
                                                           title="Ver detalle">
                                                            <i class="fa fa-eye"></i>
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
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
                                            ${paginaActual * 10 > totalClientes ? totalClientes : paginaActual * 10} 
                                            de ${totalClientes} clientes
                                        </div>
                                    </div>

                                    <!-- Controles de paginación -->
                                    <div class="col-sm-7">
                                        <ul class="pagination pagination-sm no-margin pull-right">
                                            <!-- Primera página -->
                                            <li class="${paginaActual == 1 ? 'disabled' : ''}">
                                                <c:choose>
                                                    <c:when test="${not empty terminoBusqueda}">
                                                        <a href="srvClientes?accion=buscar&termino=${terminoBusqueda}&pagina=1">
                                                            <i class="fa fa-angle-double-left"></i>
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="srvClientes?accion=listar&pagina=1">
                                                            <i class="fa fa-angle-double-left"></i>
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </li>

                                            <!-- Anterior -->
                                            <li class="${paginaActual == 1 ? 'disabled' : ''}">
                                                <c:choose>
                                                    <c:when test="${not empty terminoBusqueda}">
                                                        <a href="srvClientes?accion=buscar&termino=${terminoBusqueda}&pagina=${paginaActual - 1}">
                                                            <i class="fa fa-angle-left"></i>
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="srvClientes?accion=listar&pagina=${paginaActual - 1}">
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
                                                                    <a href="srvClientes?accion=buscar&termino=${terminoBusqueda}&pagina=${i}">${i}</a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <a href="srvClientes?accion=listar&pagina=${i}">${i}</a>
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
                                                        <a href="srvClientes?accion=buscar&termino=${terminoBusqueda}&pagina=${paginaActual + 1}">
                                                            <i class="fa fa-angle-right"></i>
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="srvClientes?accion=listar&pagina=${paginaActual + 1}">
                                                            <i class="fa fa-angle-right"></i>
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </li>

                                            <!-- Última página -->
                                            <li class="${paginaActual == totalPaginas ? 'disabled' : ''}">
                                                <c:choose>
                                                    <c:when test="${not empty terminoBusqueda}">
                                                        <a href="srvClientes?accion=buscar&termino=${terminoBusqueda}&pagina=${totalPaginas}">
                                                            <i class="fa fa-angle-double-right"></i>
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="srvClientes?accion=listar&pagina=${totalPaginas}">
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
        <!-- Script de búsqueda en tiempo real -->
        <script>
            $(document).ready(function () {
                var timeout = null;
                var $input = $('#buscarCliente');
                var $loading = $('.search-loading');

                $input.on('keyup', function () {
                    clearTimeout(timeout);
                    var termino = $(this).val().trim();

                    // Mostrar spinner
                    $loading.show();

                    // Delay de 300ms antes de buscar
                    timeout = setTimeout(function () {
                        if (termino.length === 0) {
                            // Si está vacío, redirigir a listar
                            window.location.href = 'srvClientes?accion=listar';
                        } else if (termino.length >= 2) {
                            // Buscar si tiene al menos 2 caracteres
                            window.location.href = 'srvClientes?accion=buscar&termino=' + encodeURIComponent(termino);
                        } else {
                            $loading.hide();
                        }
                    }, 300);
                });

                // Ocultar spinner al cargar
                setTimeout(function () {
                    $loading.hide();
                }, 100);

                // Auto-ocultar alertas después de 5 segundos
                setTimeout(function () {
                    $('.alert').fadeOut('slow');
                }, 5000);
            });
        </script>
    </body>
</html>