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
        </style>

    </head>
    <body class="hold-transition skin-blue sidebar-mini">
        <%@ include file="/vistas/includes/header-vendedor.jsp" %>
        <%@ include file="/vistas/includes/sidebar-vendedor.jsp" %>

        <div class="content-wrapper">
            <section class="content-header">
                <h1>Productos</h1>
                <small>Gestión de productos disponibles</small>
            </section>

            <section class="content">
                <div class="box box-primary">
                    <div class="box-header with-border clearfix">
                        <div class="pull-left">
                            <h3 class="box-title" style="margin: 0;
                                padding-right: 15px;">Listado de productos</h3>
                        </div>
                        <div class="pull-left">
                            <button class="btn btn-success btn-sm" data-toggle="modal" data-target="#modalAgregar" style="margin-right: 5px;">
                                <i class="fa fa-plus"></i> Agregar producto
                            </button>
                            <a href="srvCategoria?accion=listar" class="btn btn-info btn-sm">
                                <i class="fa fa-tags"></i> Categorías
                            </a>
                        </div>
                    </div>
                    <div class="table-responsive">
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
                                                <!-- Nombre del producto -->
                                                <td class="col-nombre text-left align-middle">${p.nombre}</td>
                                                <!-- Categoría -->
                                                <td class="col-categoria text-left align-middle">${p.nombreCategoria}</td>
                                                <!-- Precio -->
                                                <td class="col-precio text-left align-middle">S/. ${p.precio}</td>
                                                <!-- Imagen -->
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
                                                    <div style="display: flex; gap: 5px;">
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
                                        <div class="modal fade" id="modalImagen${p.idProducto}" tabindex="-1" role="dialog" aria-labelledby="imagenModalLabel${p.idProducto}">
                                            <div class="modal-dialog modal-lg" role="document">
                                                <div class="modal-content">
                                                    <!-- Encabezado del modal -->
                                                    <div class="modal-header bg-primary text-white">
                                                        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Cerrar">
                                                            <span aria-hidden="true">&times;</span>
                                                        </button>
                                                        <h4 class="modal-title" id="imagenModalLabel${p.idProducto}">
                                                            <i class="fa fa-image"></i> Producto: ${p.nombre}
                                                        </h4>
                                                    </div>

                                                    <!-- Cuerpo del modal -->
                                                    <div class="modal-body text-center">
                                                        <img src="${p.imagenUrl}" alt="Imagen ampliada" class="img-thumbnail" style="max-height: 500px; margin: auto;" />
                                                    </div>

                                                    <!-- Pie del modal -->
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
                                                    <div class="modal-content box box-primary">
                                                        <div class="modal-header with-border">
                                                            <button type="button" class="close" data-dismiss="modal" aria-label="Cerrar">
                                                                <span aria-hidden="true">&times;</span>
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
                                                                <label for="imagen">Imagen del producto</label>
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
                                                            <h4 class="modal-title">Eliminar producto</h4>
                                                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                                                        </div>
                                                        <div class="modal-body">
                                                            ¿Estás seguro de que deseas eliminar <strong>${p.nombre}</strong>?
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="submit" class="btn btn-danger">Eliminar</button>
                                                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
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
                    </div>
                </div>
            </section>
        </div>
        <!-- Modal Agregar -->
        <div class="modal fade" id="modalAgregar" tabindex="-1">
            <div class="modal-dialog">
                <form action="srvProductos?accion=guardar" method="post" enctype="multipart/form-data">
                    <div class="modal-content">
                        <div class="modal-header bg-success text-white">
                            <h4 class="modal-title">Agregar producto</h4>
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
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
                                <label for="imagen">Imagen del producto</label>
                                <input type="file" name="imagen" class="form-control-file" accept="image/*" onchange="mostrarVistaPrevia(this)">
                                <img id="preview" class="img-thumbnail mt-2" style="max-width: 100px;
                                     display: none;" />
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-success">Guardar</button>
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <%@ include file="/vistas/includes/footer.jsp" %>

        <!-- Vista previa de imagen -->
        <img id="preview" class="img-thumbnail mt-2" style="max-width: 100px;
             display: none;" />

        <script>
            function mostrarVistaPrevia(input) {
                const file = input.files[0];
                const preview = document.getElementById('preview');
                if (file && file.type.startsWith('image/')) {
                    preview.src = URL.createObjectURL(file);
                    preview.style.display = 'block';
                } else {
                    preview.src = '';
                    preview.style.display = 'none';
                }
            }
        </script>
        <script>
            $(function () {
                $('[data-toggle="tooltip"]').tooltip();
            });
        </script>

    </body>
</html>
