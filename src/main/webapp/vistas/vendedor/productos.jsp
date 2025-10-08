<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/vistas/includes/head-resources.jsp" %>

<!DOCTYPE html>
<html lang="es">
    <head>
        <title>Productos</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/custom/css/custom.css">
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
                    <div class="box-header with-border d-flex justify-content-between align-items-center">
                        <h3 class="box-title">Listado de productos</h3>
                        <button class="btn btn-success btn-sm" data-toggle="modal" data-target="#modalAgregar">
                            <i class="fa fa-plus"></i> Agregar producto
                        </button>
                        <a href="srvCategoria?accion=listar" class="btn btn-info btn-sm ml-2">
                            <i class="fa fa-tags"></i> Categorías
                        </a>
                    </div>
                    <div class="box-body">
                        <c:choose>
                            <c:when test="${not empty listaProductos}">
                                <table class="table table-bordered table-hover table-striped">
                                    <thead>
                                        <tr>
                                            <th>Nombre</th>
                                            <th>Categoría</th>
                                            <th>Precio</th>
                                            <th>Imagen</th>
                                            <th>Stock</th>
                                            <th>Estado</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="p" items="${listaProductos}">
                                            <tr>
                                                <td>${p.nombre}</td>
                                                <td>${p.nombreCategoria}</td>
                                                <td>S/. ${p.precio}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty p.imagenUrl}">
                                                            <img src="${p.imagenUrl}" alt="Imagen" class="img-thumbnail" style="max-width: 60px;">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Sin imagen</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:forEach var="inv" items="${inventariosPorProducto[p.idProducto]}">
                                                        <span class="badge ${inv.stock > 0 ? 'badge-success' : 'badge-danger'}">
                                                            ${inv.talla} / ${inv.color}: ${inv.stock}
                                                        </span><br/>
                                                    </c:forEach>
                                                </td>
                                                <td>
                                                    <c:forEach var="inv" items="${inventariosPorProducto[p.idProducto]}">
                                                        <span class="badge ${inv.estado == 'Activo' ? 'badge-success' : 'badge-secondary'}">
                                                            ${inv.talla} / ${inv.color} - ${inv.estado}
                                                        </span><br/>
                                                    </c:forEach>
                                                </td>
                                                <td>
                                                    <button class="btn btn-xs btn-primary" data-toggle="modal" data-target="#modalEditar${p.idProducto}">
                                                        <i class="fa fa-pencil"></i>
                                                    </button>
                                                    <button class="btn btn-xs btn-danger" data-toggle="modal" data-target="#modalEliminar${p.idProducto}">
                                                        <i class="fa fa-trash"></i>
                                                    </button>
                                                    <a href="srvInventario?accion=listar&idProducto=${p.idProducto}" class="btn btn-xs btn-info">
                                                        <i class="fa fa-cubes"></i> Inventario
                                                    </a>
                                                </td>
                                            </tr>

                                            <!-- Modal Editar -->
                                        <div class="modal fade" id="modalEditar${p.idProducto}" tabindex="-1">
                                            <div class="modal-dialog">
                                                <form action="srvProductos?accion=actualizar" method="post" enctype="multipart/form-data">
                                                    <div class="modal-content">
                                                        <div class="modal-header bg-primary text-white">
                                                            <h4 class="modal-title">Editar producto</h4>
                                                            <button type="button" class="close" data-dismiss="modal">&times;</button>
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
                                                                <input type="file" name="imagen" class="form-control-file" accept="image/*">
                                                                <c:if test="${not empty p.imagenUrl}">
                                                                    <img src="${pageContext.request.contextPath}/${p.imagenUrl}" class="img-thumbnail mt-2" style="max-width: 100px;">
                                                                    <input type="hidden" name="imagenUrl" value="${p.imagenUrl}">
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="submit" class="btn btn-primary">Guardar cambios</button>
                                                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
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
                                <img id="preview" class="img-thumbnail mt-2" style="max-width: 100px; display: none;" />
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
        <img id="preview" class="img-thumbnail mt-2" style="max-width: 100px; display: none;" />

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

    </body>
</html>
