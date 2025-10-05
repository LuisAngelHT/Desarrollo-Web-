<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/vistas/includes/head-resources.jsp" %>

<!DOCTYPE html>
<html lang="es">
    <head>
        <title>Gestión de clientes</title>
    </head>
    <body>
        <%@ include file="/vistas/includes/header-vendedor.jsp" %>
        <%@ include file="/vistas/includes/sidebar-vendedor.jsp" %>

        <div class="content-wrapper">
            <section class="content-header">
                <h1>Clientes</h1>
                <small>Administración de tus clientes registrados</small>
            </section>

            <section class="content">
                <%@ include file="/vistas/includes/alertas.jsp" %>

                <!-- Listado -->
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title">Clientes registrados</h3>
                        <button class="btn btn-success mb-3" data-toggle="modal" data-target="#modalAgregar">
                            <i class="fa fa-user-plus"></i> Nuevo Cliente
                        </button>
                    </div>
                    <div class="box-body">
                        <table class="table table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th>Nombre</th>
                                    <th>Email</th>
                                    <th>Teléfono</th>
                                    <th>Estado</th>
                                    <th>Registro</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="c" items="${listaClientes}">
                                    <tr>
                                        <td>${c.nombre} ${c.apellido}</td>
                                        <td>${c.email}</td>
                                        <td>${c.telefono}</td>
                                        <td>
                                            <span class="badge ${c.estado ? 'badge-success' : 'badge-secondary'}">
                                                ${c.estado ? 'Activo' : 'Inactivo'}
                                            </span>
                                        </td>
                                        <td>${c.fechaRegistro}</td>
                                        <td>
                                            <button class="btn btn-sm btn-warning" style="margin-right: 5px;" data-toggle="modal" data-target="#modalEditar${c.idCliente}">
                                                <i class="fa fa-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger" data-toggle="modal" data-target="#modalEliminar${c.idCliente}">
                                                <i class="fa fa-trash"></i>
                                            </button>
                                            <a href="srvClientesVendedor?accion=ver&id=${c.idCliente}" class="btn btn-sm btn-info">
                                                <i class="fa fa-eye"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <!-- Modales de eliminación -->
                        <c:forEach var="c" items="${listaClientes}">
                            <div class="modal fade" id="modalEliminar${c.idCliente}" tabindex="-1">
                                <div class="modal-dialog">
                                    <form action="srvClientesVendedor?accion=eliminar" method="post">
                                        <div class="modal-content">
                                            <div class="modal-header bg-danger text-white">
                                                <h4 class="modal-title">Eliminar cliente</h4>
                                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                            </div>
                                            <div class="modal-body">
                                                ¿Estás seguro de que deseas eliminar a <strong>${c.nombre} ${c.apellido}</strong>?
                                                <input type="hidden" name="idCliente" value="${c.idCliente}">
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

                        <!-- Modales de edición -->
                        <c:forEach var="c" items="${listaClientes}">
                            <div class="modal fade" id="modalEditar${c.idCliente}" tabindex="-1">
                                <div class="modal-dialog">
                                    <form action="srvClientesVendedor?accion=actualizar" method="post">
                                        <div class="modal-content">
                                            <div class="modal-header bg-warning text-white">
                                                <h4 class="modal-title">Editar cliente</h4>
                                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                            </div>
                                            <div class="modal-body">
                                                <input type="hidden" name="idCliente" value="${c.idCliente}">
                                                <div class="form-group">
                                                    <label>Nombre</label>
                                                    <input type="text" name="nombre" class="form-control" value="${c.nombre}" required>
                                                </div>
                                                <div class="form-group">
                                                    <label>Apellido</label>
                                                    <input type="text" name="apellido" class="form-control" value="${c.apellido}" required>
                                                </div>
                                                <div class="form-group">
                                                    <label>Email</label>
                                                    <input type="email" name="email" class="form-control" value="${c.email}" required>
                                                </div>
                                                <div class="form-group">
                                                    <label>Teléfono</label>
                                                    <input type="text" name="telefono" class="form-control" value="${c.telefono}">
                                                </div>
                                                <div class="form-group">
                                                    <label>Dirección</label>
                                                    <textarea name="direccion" class="form-control">${c.direccion}</textarea>
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
                    </div>
                </div>

                <!-- Modal Agregar Cliente -->
                <div class="modal fade" id="modalAgregar" tabindex="-1">
                    <div class="modal-dialog">
                        <form action="srvClientesVendedor?accion=guardar" method="post">
                            <div class="modal-content">
                                <div class="modal-header bg-success text-white">
                                    <h4 class="modal-title">Agregar cliente</h4>
                                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                                </div>
                                <div class="modal-body">
                                    <div class="form-group">
                                        <label>Nombre</label>
                                        <input type="text" name="nombre" class="form-control" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Apellido</label>
                                        <input type="text" name="apellido" class="form-control" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Email</label>
                                        <input type="email" name="email" class="form-control" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Teléfono</label>
                                        <input type="text" name="telefono" class="form-control">
                                    </div>
                                    <div class="form-group">
                                        <label>Dirección</label>
                                        <textarea name="direccion" class="form-control" rows="3" placeholder="Opcional"></textarea>
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

            </section>
        </div>

        <%@ include file="/vistas/includes/footer.jsp" %>
    </body>
</html>
