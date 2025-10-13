<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/vistas/includes/head-resources.jsp" %>

<c:set var="pageActive" value="productos" />
<!DOCTYPE html>
<html lang="es">
    <head>
        <title>Gestión de categorías</title>
    </head>
    <body class="hold-transition skin-blue sidebar-mini">
        <div class="wrapper">

            <%@ include file="/vistas/includes/header-vendedor.jsp" %>
            <%@ include file="/vistas/includes/sidebar-vendedor.jsp" %>

            <div class="content-wrapper">
                <section class="content-header">
                    <h1>Categorías</h1>
                    <small>Administración de categorías disponibles</small>
                    <ol class="breadcrumb">
                        <li><a href="srvDashboardVendedor?accion=listar"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                        <li><a href="srvProductos?accion=listar"> Productos</a></li>
                        <li class="active"> Categorias</li>
                    </ol>
                </section>

                <section class="content">
                    <%@ include file="/vistas/includes/alertas.jsp" %>

                    <!-- Listado -->
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">Categorías registradas</h3>
                        </div>
                        <div class="box-body">
                            <table class="table table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th style="width: 30%;">Nombre</th>
                                        <th style="width: 50%;">Descripción</th>
                                        <th style="width: 20%;">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="cat" items="${listaCategorias}">
                                        <tr>
                                            <td>${cat.nombreCategoria}</td>
                                            <td>${cat.descripcion}</td>
                                            <td>
                                                <button class="btn btn-sm btn-warning" style="margin-right: 5px;" data-toggle="modal" data-target="#modalEditar${cat.idCategoria}">
                                                    <i class="fa fa-pencil"></i>
                                                </button>
                                                <button class="btn btn-sm btn-danger" data-toggle="modal" data-target="#modalEliminar${cat.idCategoria}">
                                                    <i class="fa fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                            <c:forEach var="cat" items="${listaCategorias}">
                                <div class="modal fade" id="modalEliminar${cat.idCategoria}" tabindex="-1">
                                    <div class="modal-dialog">
                                        <form action="srvCategoria?accion=eliminar" method="post">
                                            <div class="modal-content">
                                                <div class="modal-header bg-danger text-white">
                                                    <h4 class="modal-title">Eliminar categoría</h4>
                                                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                                                </div>
                                                <div class="modal-body">
                                                    ¿Estás seguro de que deseas eliminar <strong>${cat.nombreCategoria}</strong>?
                                                    <input type="hidden" name="idCategoria" value="${cat.idCategoria}">
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
                        </div>
                    </div>

                    <!-- Modales de edición (fuera del tbody) -->
                    <c:forEach var="cat" items="${listaCategorias}">
                        <div class="modal fade" id="modalEditar${cat.idCategoria}" tabindex="-1">
                            <div class="modal-dialog">
                                <form action="srvCategoria?accion=actualizar" method="post">
                                    <div class="modal-content">
                                        <div class="modal-header bg-warning text-white">
                                            <h4 class="modal-title">Editar categoría</h4>
                                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                                        </div>
                                        <div class="modal-body">
                                            <input type="hidden" name="idCategoria" value="${cat.idCategoria}">
                                            <div class="form-group">
                                                <label>Nombre</label>
                                                <input type="text" name="nombre" class="form-control" value="${cat.nombreCategoria}" required>
                                            </div>
                                            <div class="form-group">
                                                <label>Descripción</label>
                                                <textarea name="descripcion" class="form-control" rows="3">${cat.descripcion}</textarea>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="submit" class="btn btn-warning">Guardar cambios</button>
                                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </c:forEach>

                    <!-- Formulario agregar -->
                    <div class="box box-success">
                        <div class="box-header with-border">
                            <h3 class="box-title">Agregar nueva categoría</h3>
                        </div>
                        <div class="box-body">
                            <form action="srvCategoria?accion=guardar" method="post">
                                <div class="form-group">
                                    <label>Nombre</label>
                                    <input type="text" name="nombre" class="form-control" required autocomplete="off" placeholder="Nueva Categoría">
                                </div>
                                <div class="form-group">
                                    <label>Descripción</label>
                                    <textarea name="descripcion" class="form-control" rows="3" placeholder="Opcional"></textarea>
                                </div>
                                <div class="form-group">
                                    <div class="d-flex" style="gap: 10px;">
                                        <button type="submit" class="btn btn-success">
                                            <i class="fa fa-plus"></i> Agregar
                                        </button>
                                        <a href="srvProductos?accion=listar" class="btn btn-default">
                                            <i class="fa fa-arrow-left"></i> Volver a productos
                                        </a>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </section>
            </div>

            <%@ include file="/vistas/includes/footer.jsp" %>

        </div>
        <!-- Confirmación para eliminar -->
        <script>
            function confirmarEliminacion() {
                return confirm("¿Estás seguro de que deseas eliminar esta categoría?");
            }
        </script>
    </body>
</html>
