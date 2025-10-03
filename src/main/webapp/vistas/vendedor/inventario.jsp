<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/vistas/includes/head-resources.jsp" %>

<!DOCTYPE html>
<html lang="es">
    <head>
        <title>Inventario de ${producto.nombre}</title>
    </head>
    <body>
        <%@ include file="/vistas/includes/header-vendedor.jsp" %>
        <%@ include file="/vistas/includes/sidebar-vendedor.jsp" %>

        <div class="content-wrapper">
            <section class="content-header">
                <h1>Inventario de <strong>${producto.nombre}</strong></h1>
                <small>Gestión por talla y color</small>
            </section>
            <section class="content">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title">Combinaciones registradas</h3>
                    </div>
                    <div class="box-body">
                        <table class="table table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th>Talla</th>
                                    <th>Color</th>
                                    <th>Stock</th>
                                    <th>Estado</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="inv" items="${listaInventario}">
                                    <tr>
                                        <td>${inv.talla}</td>
                                        <td>${inv.color}</td>
                                        <td>${inv.stock}</td>
                                        <td>
                                            <span class="badge ${inv.estado == 'Activo' ? 'badge-success' : 'badge-secondary'}">${inv.estado}</span>
                                        </td>
                                        <td>
                                            <button class="btn btn-sm btn-warning" data-toggle="modal" data-target="#modalEditar${inv.idInventario}">
                                                <i class="fa fa-pencil"></i>
                                            </button>
                                            <form action="srvInventario?accion=eliminar" method="post" style="display:inline;">
                                                <input type="hidden" name="idInventario" value="${inv.idInventario}">
                                                <input type="hidden" name="idProducto" value="${producto.idProducto}">
                                                <button type="submit" class="btn btn-sm btn-danger">
                                                    <i class="fa fa-trash"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>

                                    <!-- Modal de edición justo después del </tr> -->
                                <div class="modal fade" id="modalEditar${inv.idInventario}" tabindex="-1">
                                    <div class="modal-dialog">
                                        <form action="srvInventario?accion=actualizar" method="post">
                                            <div class="modal-content">
                                                <div class="modal-header bg-warning text-white">
                                                    <h4 class="modal-title">Editar combinación</h4>
                                                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                                                </div>
                                                <div class="modal-body">
                                                    <input type="hidden" name="idInventario" value="${inv.idInventario}">
                                                    <input type="hidden" name="idProducto" value="${producto.idProducto}">
                                                    <div class="form-group">
                                                        <label>Talla</label>
                                                        <input type="text" name="talla" class="form-control" value="${inv.talla}" required>
                                                    </div>
                                                    <div class="form-group">
                                                        <label>Color</label>
                                                        <input type="text" name="color" class="form-control" value="${inv.color}" required>
                                                    </div>
                                                    <div class="form-group">
                                                        <label>Stock</label>
                                                        <input type="number" name="stock" class="form-control" value="${inv.stock}" required>
                                                    </div>
                                                    <div class="form-group">
                                                        <label>Estado</label>
                                                        <select name="estado" class="form-control" required>
                                                            <option value="Activo" ${inv.estado == 'Activo' ? 'selected' : ''}>Activo</option>
                                                            <option value="Inactivo" ${inv.estado == 'Inactivo' ? 'selected' : ''}>Inactivo</option>
                                                        </select>
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
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Formulario para agregar inventario -->
                <div class="box box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title">Agregar combinación</h3>
                    </div>
                    <div class="box-body">
                        <form action="srvInventario?accion=guardar" method="post">
                            <input type="hidden" name="idProducto" value="${producto.idProducto}">
                            <div class="form-group">
                                <label>Talla</label>
                                <input type="text" name="talla" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label>Color</label>
                                <input type="text" name="color" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label>Stock</label>
                                <input type="number" name="stock" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label>Estado</label>
                                <select name="estado" class="form-control" required>
                                    <option value="Activo">Activo</option>
                                    <option value="Inactivo">Inactivo</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <div class="d-flex" style="gap: 10px;">
                                    <button type="submit" class="btn btn-success">
                                        <i class="fa fa-plus"></i> Agregar
                                    </button>
                                    <a href="srvProductos?accion=listar" class="btn btn-outline-secondary">
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
    </body>

</html>
