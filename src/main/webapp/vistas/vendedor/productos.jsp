<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/vistas/includes/head-resources.jsp" %>

<c:set var="pageActive" value="productos" />
<!DOCTYPE html>
<html lang="es">
    <head>
        <title>Productos</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/custom/css/custom.css">
        <style>
            .col-nombre {
                width: 15%;
            }
            .col-categoria {
                width: 15%;
            }
            .col-precio {
                width: 10%;
            }
            .col-imagen {
                width: 10%;
            }
            .col-stock {
                width: 35%;
            }
            .col-acciones {
                width: 15%;
            }
            .align-middle {
                vertical-align: middle !important;
            }
            .btn-xs {
                padding-top: 4px;
                padding-bottom: 4px;
                line-height: 1.2;
            }
            .table-responsive {
                overflow-x: hidden !important;
                overflow-y: visible;
            }
        </style>
    </head>
    <body class="hold-transition skin-blue sidebar-mini">
        <div class="wrapper">
            <%@ include file="/vistas/includes/header-vendedor.jsp" %>
            <%@ include file="/vistas/includes/sidebar-vendedor.jsp" %>

            <div class="content-wrapper">
                <section class="content-header">
                    <h1>Productos</h1>
                    <small>Gestión de productos disponibles</small>
                    <ol class="breadcrumb">
                        <li><a href="srvDashboardVendedor?accion=listar"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                        <li class="active"> Productos</li>
                    </ol>
                </section>

                <section class="content">
                    <!-- ✅ Alertas incluidas -->
                    <%@ include file="/vistas/includes/alertas.jsp" %>

                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <div class="row">
                                <!-- Botones de acción -->
                                <div class="col-md-6">
                                    <h3 class="box-title" style="margin: 0;
                                        padding-right: 15px;">
                                        Listado de productos
                                    </h3>
                                    <button class="btn btn-success btn-sm" data-toggle="modal" data-target="#modalAgregar" style="margin-right: 5px;">
                                        <i class="fa fa-plus"></i> Agregar producto
                                    </button>
                                    <a href="srvCategoria?accion=listar" class="btn btn-info btn-sm">
                                        <i class="fa fa-tags"></i> Categorías
                                    </a>
                                </div>

                                <!-- ✅ Filtro corregido -->
                                <div class="col-md-6 text-right">
                                    <form action="srvProductos" method="get" class="form-inline">
                                        <input type="hidden" name="accion" value="filtrar">

                                        <div class="form-group">
                                            <input type="text" name="nombre" class="form-control" 
                                                   placeholder="Buscar por nombre"
                                                   value="${param.nombre}">
                                        </div>

                                        <div class="form-group">
                                            <select name="idCategoria" class="form-control">
                                                <option value="">Todas las categorías</option>
                                                <c:forEach var="cat" items="${listaCategorias}">
                                                    <option value="${cat.idCategoria}" 
                                                            ${param.idCategoria == cat.idCategoria ? 'selected' : ''}>
                                                        ${cat.nombreCategoria}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <button type="submit" class="btn btn-primary">
                                            <i class="fa fa-filter"></i> Filtrar
                                        </button>
                                        <a href="srvProductos?accion=listar" class="btn btn-default">
                                            <i class="fa fa-times"></i> Limpiar
                                        </a>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Tabla de productos -->
                        <div class="box-body">
                            <c:choose>
                                <c:when test="${not empty listaProductos}">
                                    <table class="table table-bordered table-hover table-striped table-condensed">
                                        <thead class="bg-light-blue">
                                            <tr>
                                                <th class="col-nombre">Nombre</th>
                                                <th class="col-categoria">Categoría</th>
                                                <th class="col-precio">Precio</th>
                                                <th class="col-imagen">Imagen</th>
                                                <th class="col-stock">Stock / Estado</th>
                                                <th class="col-acciones">Acciones</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="p" items="${listaProductos}">
                                                <tr>
                                                    <td class="col-nombre text-left align-middle">${p.nombre}</td>
                                                    <td class="col-categoria text-left align-middle">${p.nombreCategoria}</td>
                                                    <td class="col-precio text-left align-middle">S/. ${p.precio}</td>
                                                    <td class="col-imagen text-center align-middle">
                                                        <c:choose>
                                                            <c:when test="${not empty p.imagenUrl}">
                                                                <img src="${p.imagenUrl}" alt="Imagen" class="img-thumbnail"
                                                                     style="max-width: 60px;
                                                                     height: auto;
                                                                     cursor: pointer;"
                                                                     data-toggle="modal" data-target="#modalImagen${p.idProducto}" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">Sin imagen</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="col-stock text-left align-middle">
                                                        <c:forEach var="inv" items="${inventariosPorProducto[p.idProducto]}" varStatus="status">
                                                            <c:if test="${status.index < 9}">
                                                                <c:set var="badgeClass">
                                                                    <c:choose>
                                                                        <c:when test="${inv.stock > 0 && inv.estado == 'Activo'}">badge-success</c:when>
                                                                        <c:when test="${inv.stock > 0 && inv.estado != 'Activo'}">badge-warning</c:when>
                                                                        <c:otherwise>badge-danger</c:otherwise>
                                                                    </c:choose>
                                                                </c:set>
                                                                <span class="badge ${badgeClass}" 
                                                                      data-toggle="tooltip" 
                                                                      title="Talla: ${inv.talla}, Color: ${inv.color}, Stock: ${inv.stock}, Estado: ${inv.estado}"
                                                                      style="margin-right: 5px;
                                                                      margin-bottom: 3px;
                                                                      display: inline-block;">
                                                                    ${inv.talla} / ${inv.color}
                                                                </span>
                                                                <c:if test="${(status.index + 1) % 6 == 0}">
                                                                    <br/>
                                                                </c:if>
                                                            </c:if>
                                                        </c:forEach>
                                                    </td>
                                                    <td class="col-acciones text-center align-middle">
                                                        <div style="display: flex;
                                                             gap: 5px;">
                                                            <button class="btn btn-xs btn-primary" data-toggle="modal" data-target="#modalEditar${p.idProducto}" title="Editar">
                                                                <i class="fa fa-pencil"></i>
                                                            </button>
                                                            <button class="btn btn-xs btn-danger" data-toggle="modal" data-target="#modalEliminar${p.idProducto}" title="Eliminar">
                                                                <i class="fa fa-trash"></i>
                                                            </button>
                                                            <a href="srvInventario?accion=listar&idProducto=${p.idProducto}" class="btn btn-xs btn-info" title="Inventario" style="white-space: nowrap;">
                                                                <i class="fa fa-cubes"></i> Inventario
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>

                                                <!-- Modal Imagen -->
                                            <div class="modal fade" id="modalImagen${p.idProducto}" tabindex="-1">
                                                <div class="modal-dialog modal-lg">
                                                    <div class="modal-content">
                                                        <div class="modal-header bg-primary text-white">
                                                            <button type="button" class="close text-white" data-dismiss="modal">
                                                                <span>&times;</span>
                                                            </button>
                                                            <h4 class="modal-title">
                                                                <i class="fa fa-image"></i> Producto: ${p.nombre}
                                                            </h4>
                                                        </div>
                                                        <div class="modal-body text-center">
                                                            <img src="${p.imagenUrl}" alt="Imagen ampliada" class="img-thumbnail" style="max-height: 500px;
                                                                 margin: auto;" />
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-default" data-dismiss="modal">
                                                                <i class="fa fa-times"></i> Cerrar
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Modal Editar -->
                                            <div class="modal fade" id="modalEditar${p.idProducto}" tabindex="-1">
                                                <div class="modal-dialog">
                                                    <form action="srvProductos?accion=actualizar" method="post" enctype="multipart/form-data">
                                                        <div class="modal-content">
                                                            <div class="modal-header bg-primary text-white">
                                                                <button type="button" class="close text-white" data-dismiss="modal">
                                                                    <span>&times;</span>
                                                                </button>
                                                                <h4 class="modal-title">
                                                                    <i class="fa fa-edit"></i> Editar producto
                                                                </h4>
                                                            </div>
                                                            <div class="modal-body">
                                                                <input type="hidden" name="id" value="${p.idProducto}">
                                                                <div class="form-group">
                                                                    <label>Nombre</label>
                                                                    <input type="text" name="nombre" class="form-control" value="${p.nombre}" required>
                                                                </div>
                                                                <div class="form-group">
                                                                    <label>Categoría</label>
                                                                    <select name="idCategoria" class="form-control" required>
                                                                        <c:forEach var="cat" items="${listaCategorias}">
                                                                            <option value="${cat.idCategoria}" ${cat.idCategoria == p.idCategoria ? 'selected' : ''}>
                                                                                ${cat.nombreCategoria}
                                                                            </option>
                                                                        </c:forEach>
                                                                    </select>
                                                                </div>
                                                                <div class="form-group">
                                                                    <label>Precio</label>
                                                                    <input type="number" name="precio" class="form-control" value="${p.precio}" step="0.01" required>
                                                                </div>
                                                                <div class="form-group">
                                                                    <label>Imagen del producto</label>
                                                                    <input type="file" name="imagen" class="form-control" accept="image/*">
                                                                    <c:if test="${not empty p.imagenUrl}">
                                                                        <small class="text-muted">Imagen actual:</small><br/>
                                                                        <img src="${pageContext.request.contextPath}/${p.imagenUrl}" class="img-thumbnail" style="max-width: 100px;">
                                                                        <input type="hidden" name="imagenUrl" value="${p.imagenUrl}">
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="submit" class="btn btn-primary">
                                                                    <i class="fa fa-save"></i> Guardar cambios
                                                                </button>
                                                                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                                                                    <i class="fa fa-times"></i> Cancelar
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>

                                            <!-- Modal Eliminar -->
                                            <div class="modal fade" id="modalEliminar${p.idProducto}" tabindex="-1">
                                                <div class="modal-dialog">
                                                    <form action="srvProductos?accion=eliminar&id=${p.idProducto}" method="post">
                                                        <div class="modal-content">
                                                            <div class="modal-header bg-danger text-white">
                                                                <button type="button" class="close text-white" data-dismiss="modal">
                                                                    <span>&times;</span>
                                                                </button>
                                                                <h4 class="modal-title">
                                                                    <i class="fa fa-trash"></i> Eliminar producto
                                                                </h4>
                                                            </div>
                                                            <div class="modal-body">
                                                                <p>¿Estás seguro de que deseas eliminar <strong>${p.nombre}</strong>?</p>
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="submit" class="btn btn-danger">
                                                                    <i class="fa fa-check"></i> Eliminar
                                                                </button>
                                                                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                                                                    <i class="fa fa-times"></i> Cancelar
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </c:forEach>
                                        </tbody>
                                    </table>

                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-info">No hay productos registrados.</div>
                                </c:otherwise>
                            </c:choose>
                            <!-- Paginación -->
                            <c:if test="${totalPaginas > 1}">
                                <div class="box-footer clearfix">
                                    <div class="row">
                                        <!-- Información de registros -->
                                        <div class="col-sm-5">
                                            <div class="dataTables_info">
                                                Mostrando ${(paginaActual - 1) * 7 + 1} a 
                                                ${paginaActual * 7 > totalProductos ? totalProductos : paginaActual * 7} 
                                                de ${totalProductos} productos
                                            </div>
                                        </div>

                                        <!-- Controles de paginación -->
                                        <div class="col-sm-7">
                                            <ul class="pagination pagination-sm no-margin pull-right">
                                                <!-- Botón Primera página -->
                                                <li class="${paginaActual == 1 ? 'disabled' : ''}">
                                                    <c:choose>
                                                        <c:when test="${not empty filtroNombre || not empty filtroCategoria}">
                                                            <a href="srvProductos?accion=filtrar&nombre=${filtroNombre}&idCategoria=${filtroCategoria}&pagina=1">
                                                                <i class="fa fa-angle-double-left"></i>
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="srvProductos?accion=listar&pagina=1">
                                                                <i class="fa fa-angle-double-left"></i>
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </li>

                                                <!-- Botón Anterior -->
                                                <li class="${paginaActual == 1 ? 'disabled' : ''}">
                                                    <c:choose>
                                                        <c:when test="${not empty filtroNombre || not empty filtroCategoria}">
                                                            <a href="srvProductos?accion=filtrar&nombre=${filtroNombre}&idCategoria=${filtroCategoria}&pagina=${paginaActual - 1}">
                                                                <i class="fa fa-angle-left"></i>
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="srvProductos?accion=listar&pagina=${paginaActual - 1}">
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
                                                                    <c:when test="${not empty filtroNombre || not empty filtroCategoria}">
                                                                        <a href="srvProductos?accion=filtrar&nombre=${filtroNombre}&idCategoria=${filtroCategoria}&pagina=${i}">${i}</a>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <a href="srvProductos?accion=listar&pagina=${i}">${i}</a>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </li>
                                                        </c:when>
                                                    </c:choose>
                                                </c:forEach>

                                                <!-- Botón Siguiente -->
                                                <li class="${paginaActual == totalPaginas ? 'disabled' : ''}">
                                                    <c:choose>
                                                        <c:when test="${not empty filtroNombre || not empty filtroCategoria}">
                                                            <a href="srvProductos?accion=filtrar&nombre=${filtroNombre}&idCategoria=${filtroCategoria}&pagina=${paginaActual + 1}">
                                                                <i class="fa fa-angle-right"></i>
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="srvProductos?accion=listar&pagina=${paginaActual + 1}">
                                                                <i class="fa fa-angle-right"></i>
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </li>

                                                <!-- Botón Última página -->
                                                <li class="${paginaActual == totalPaginas ? 'disabled' : ''}">
                                                    <c:choose>
                                                        <c:when test="${not empty filtroNombre || not empty filtroCategoria}">
                                                            <a href="srvProductos?accion=filtrar&nombre=${filtroNombre}&idCategoria=${filtroCategoria}&pagina=${totalPaginas}">
                                                                <i class="fa fa-angle-double-right"></i>
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="srvProductos?accion=listar&pagina=${totalPaginas}">
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
                    </div>
                </section>
                <!-- Modal Agregar -->
                <div class="modal fade" id="modalAgregar" tabindex="-1">
                    <div class="modal-dialog">
                        <form action="srvProductos?accion=guardar" method="post" enctype="multipart/form-data">
                            <div class="modal-content">
                                <div class="modal-header bg-success text-white">
                                    <button type="button" class="close text-white" data-dismiss="modal">
                                        <span>&times;</span>
                                    </button>
                                    <h4 class="modal-title">
                                        <i class="fa fa-plus-circle"></i> Agregar producto
                                    </h4>
                                </div>
                                <div class="modal-body">
                                    <div class="form-group">
                                        <label>Nombre</label>
                                        <input type="text" name="nombre" class="form-control" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Categoría</label>
                                        <select name="idCategoria" class="form-control" required>
                                            <c:forEach var="cat" items="${listaCategorias}">
                                                <option value="${cat.idCategoria}">${cat.nombreCategoria}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label>Precio</label>
                                        <input type="number" name="precio" class="form-control" step="0.01" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Imagen del producto</label>
                                        <input type="file" name="imagen" class="form-control" accept="image/*" onchange="mostrarVistaPrevia(this)">
                                        <img id="preview" class="img-thumbnail" style="max-width: 100px;
                                             margin-top: 10px;
                                             display: none;" />
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="submit" class="btn btn-success">
                                        <i class="fa fa-save"></i> Guardar
                                    </button>
                                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                                        <i class="fa fa-times"></i> Cancelar
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <%@ include file="/vistas/includes/footer.jsp" %>
        </div>
        <!-- ✅ Scripts al final -->
        <script>
            $(document).ready(function () {
                // Inicializar tooltips
                $('[data-toggle="tooltip"]').tooltip();

                // Auto-ocultar alertas después de 3.5 segundos
                setTimeout(function () {
                    $(".alert").fadeOut("slow");
                }, 3500);
            });

            // Vista previa de imagen
            function mostrarVistaPrevia(input) {
                if (input.files && input.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        var preview = document.getElementById('preview');
                        if (preview) {
                            preview.src = e.target.result;
                            preview.style.display = 'block';
                        }
                    };
                    reader.readAsDataURL(input.files[0]);
                }
            }
        </script>
    </body>
</html>