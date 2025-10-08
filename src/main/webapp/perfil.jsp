<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Mi Perfil | E-Commerce Urbano</title>
        <%@ include file="/vistas/includes/head-resources.jsp" %>
    </head>
    <body class="hold-transition skin-blue sidebar-mini">
        <div class="wrapper"> 
            <!-- Header según el rol -->
            <c:choose>
                <c:when test="${usuario.rol.nombreRol eq 'Vendedor'}">
                    <%@ include file="/vistas/includes/header-vendedor.jsp" %>
                    <%@ include file="/vistas/includes/sidebar-vendedor.jsp" %>
                </c:when>
                <c:when test="${usuario.rol.nombreRol eq 'Cliente'}">
                    <%@ include file="/vistas/includes/header-cliente.jsp" %>
                    <%@ include file="/vistas/includes/sidebar-cliente.jsp" %>
                </c:when>
            </c:choose>

            <!-- Content Wrapper -->
            <div class="content-wrapper">
                <!-- Content Header -->
                <section class="content-header">
                    <h1>Mi Perfil <small>${usuario.rol.nombreRol}</small></h1>
                </section>

                <!-- Main content -->
                <section class="content">
                    <div class="row">
                        <!-- Columna izquierda: Foto de perfil -->
                        <div class="col-md-3">
                            <div class="box box-primary">
                                <div class="box-body box-profile">
                                    <img class="profile-user-img img-responsive img-circle" 
                                         src="${pageContext.request.contextPath}/dist/img/user2-160x160.jpg" 
                                         alt="Foto de perfil">

                                    <h3 class="profile-username text-center">${usuario.nombre} ${usuario.apellido}</h3>
                                    <p class="text-muted text-center">${usuario.rol.nombreRol}</p>

                                    <ul class="list-group list-group-unbordered">
                                        <li class="list-group-item">
                                            <b>Correo</b>
                                            <p class="pull-right text-muted" style="margin: 0; font-size: 12px; max-width: 150px; word-wrap: break-word;">
                                                ${usuario.correo}
                                            </p>
                                        </li>
                                        <li class="list-group-item">
                                            <b>Teléfono</b>
                                            <span class="pull-right">${usuario.telefono != null ? usuario.telefono : 'N/A'}</span>
                                        </li>
                                        <c:if test="${usuario.ultimoAcceso != null}">
                                            <li class="list-group-item">
                                                <b>Último acceso</b>
                                                <span class="pull-right">${usuario.ultimoAcceso}</span>
                                            </li>
                                        </c:if>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- Columna derecha: Formularios -->
                        <div class="col-md-9">
                            <!-- Editar Datos Personales -->
                            <div class="box box-primary">
                                <div class="box-header with-border">
                                    <h3 class="box-title"><i class="fa fa-user"></i> Editar Datos Personales</h3>
                                </div>
                                <form action="${pageContext.request.contextPath}/srvUsuario" method="POST">
                                    <input type="hidden" name="accion" value="actualizarDatos">
                                    <div class="box-body">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Nombre</label>
                                                    <input type="text" class="form-control" name="txtNombre" 
                                                           value="${usuario.nombre}" required>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Apellido</label>
                                                    <input type="text" class="form-control" name="txtApellido" 
                                                           value="${usuario.apellido}" required>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Correo</label>
                                                    <input type="email" class="form-control" name="txtCorreo" 
                                                           value="${usuario.correo}" readonly>
                                                    <small class="text-muted">El correo no se puede modificar</small>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Teléfono</label>
                                                    <input type="text" class="form-control" name="txtTelefono" 
                                                           value="${usuario.telefono}">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-12">
                                                <div class="form-group">
                                                    <label>Dirección</label>
                                                    <input type="text" class="form-control" name="txtDireccion" 
                                                           value="${usuario.direccion}">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="box-footer">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fa fa-save"></i> Guardar Cambios
                                        </button>
                                    </div>
                                </form>
                            </div>

                            <!-- Cambiar Contraseña -->
                            <div class="box box-warning">
                                <div class="box-header with-border">
                                    <h3 class="box-title"><i class="fa fa-lock"></i> Cambiar Contraseña</h3>
                                </div>
                                <form action="${pageContext.request.contextPath}/srvUsuario" method="POST" id="formPassword">
                                    <input type="hidden" name="accion" value="cambiarPassword">
                                    <div class="box-body">
                                        <div class="form-group">
                                            <label>Contraseña Actual</label>
                                            <input type="password" class="form-control" name="txtPasswordActual" 
                                                   id="passwordActual" required>
                                        </div>
                                        <div class="form-group">
                                            <label>Nueva Contraseña</label>
                                            <input type="password" class="form-control" name="txtPasswordNueva" 
                                                   id="passwordNueva" required minlength="6">
                                            <small class="text-muted">Mínimo 6 caracteres</small>
                                        </div>
                                        <div class="form-group">
                                            <label>Confirmar Nueva Contraseña</label>
                                            <input type="password" class="form-control" name="txtPasswordConfirmar" 
                                                   id="passwordConfirmar" required minlength="6">
                                        </div>
                                        <div id="mensajePassword" class="alert" style="display: none;"></div>
                                    </div>
                                    <div class="box-footer">
                                        <button type="submit" class="btn btn-warning">
                                            <i class="fa fa-key"></i> Cambiar Contraseña
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </section>
            </div>

            <%@ include file="/vistas/includes/footer.jsp" %>
        </div>

        <script>
            // Validar que las contraseñas coincidan
            $('#formPassword').on('submit', function (e) {
                var nueva = $('#passwordNueva').val();
                var confirmar = $('#passwordConfirmar').val();
                var mensaje = $('#mensajePassword');

                if (nueva !== confirmar) {
                    e.preventDefault();
                    mensaje.removeClass('alert-success').addClass('alert-danger')
                            .text('Las contraseñas no coinciden').show();
                    return false;
                }

                if (nueva.length < 6) {
                    e.preventDefault();
                    mensaje.removeClass('alert-success').addClass('alert-danger')
                            .text('La contraseña debe tener al menos 6 caracteres').show();
                    return false;
                }

                return true;
            });

            // Limpiar mensaje al escribir
            $('#passwordNueva, #passwordConfirmar').on('keyup', function () {
                $('#mensajePassword').hide();
            });
        </script>
    </body>
</html>