<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/vistas/includes/head-resources.jsp" %>

<!DOCTYPE html>
<html lang="es">
    <head>
        <title>Mi Perfil | E-Commerce Urbano</title>
        <style>
            .profile-user-img {
                border: 3px solid #d2d6de;
            }
            .box-profile {
                text-align: center;
            }
            .list-group-item b {
                display: inline-block;
                width: 100px;
            }
        </style>
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
                <c:otherwise>
                    <!-- Redirigir si no tiene rol válido -->
                    <c:redirect url="identificar.jsp"/>
                </c:otherwise>
            </c:choose>

            <!-- Content Wrapper -->
            <div class="content-wrapper">
                <!-- Content Header -->
                <section class="content-header">
                    <h1>
                        Mi Perfil 
                        <small>${usuario.rol.nombreRol}</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="#"><i class="fa fa-user"></i> Inicio</a></li>
                        <li class="active">Mi Perfil</li>
                    </ol>
                </section>

                <!-- Main content -->
                <section class="content">
                    <!-- ✅ ALERTAS AGREGADAS -->
                    <%@ include file="/vistas/includes/alertas.jsp" %>

                    <div class="row">
                        <!-- Columna izquierda: Foto de perfil -->
                        <div class="col-md-3">
                            <div class="box box-primary">
                                <div class="box-body box-profile">
                                    <!-- Foto de perfil -->
                                    <img class="profile-user-img img-responsive img-circle" 
                                         id="imagenPerfil"
                                         src="${pageContext.request.contextPath}/${not empty usuario.fotoPerfil ? usuario.fotoPerfil : 'dist/img/user2-160x160.jpg'}" 
                                         alt="Foto de perfil"
                                         style="cursor: pointer;"
                                         data-toggle="modal" 
                                         data-target="#modalCambiarFoto">

                                    <!-- Botón cambiar foto -->
                                    <button class="btn btn-primary btn-block btn-sm" 
                                            data-toggle="modal" 
                                            data-target="#modalCambiarFoto"
                                            style="margin-top: 10px;">
                                        <i class="fa fa-camera"></i> Cambiar foto
                                    </button>

                                    <!-- Nombre completo -->
                                    <h3 class="profile-username text-center" style="margin-top: 15px;">
                                        ${usuario.nombre} ${usuario.apellido}
                                    </h3>

                                    <!-- Rol -->
                                    <p class="text-muted text-center">${usuario.rol.nombreRol}</p>

                                    <!-- Información adicional -->
                                    <ul class="list-group list-group-unbordered text-left">
                                        <li class="list-group-item">
                                            <b>Correo</b>
                                            <a class="pull-right" style="font-size: 15px; word-break: break-all;">
                                                ${usuario.correo}
                                            </a>
                                        </li>
                                        <li class="list-group-item">
                                            <b>Teléfono</b>
                                            <span class="pull-right" style="font-size: 15px">
                                                ${not empty usuario.telefono ? usuario.telefono : 'No registrado'}
                                            </span>
                                        </li>
                                        <c:if test="${not empty usuario.ultimoAcceso}">
                                            <li class="list-group-item">
                                                <b>Último acceso</b>
                                                <span class="pull-right" style="font-size: 15px;">
                                                    ${usuario.ultimoAcceso}
                                                </span>
                                            </li>
                                        </c:if>
                                    </ul>

                                    <!-- Estado de cuenta -->
                                    <c:choose >
                                        <c:when test="${usuario.estado}">
                                            <span class="label label-success">
                                                <i class="fa fa-check-circle"></i> Cuenta Activa
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="label label-danger">
                                                <i class="fa fa-times-circle"></i> Cuenta Inactiva
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Box de información adicional -->
                            <div class="box box-primary">
                                <div class="box-header with-border">
                                    <h3 class="box-title">Acerca de mí</h3>
                                </div>
                                <div class="box-body">
                                    <strong><i class="fa fa-map-marker margin-r-5"></i> Dirección</strong>
                                    <p class="text-muted">
                                        ${not empty usuario.direccion ? usuario.direccion : 'No registrada'}
                                    </p>
                                </div>
                            </div>
                        </div>

                        <!-- Columna derecha: Formularios -->
                        <div class="col-md-9">
                            <!-- Editar Datos Personales -->
                            <div class="box box-primary">
                                <div class="box-header with-border">
                                    <h3 class="box-title">
                                        <i class="fa fa-user"></i> Editar Datos Personales
                                    </h3>
                                </div>
                                <form action="${pageContext.request.contextPath}/srvUsuario" method="POST">
                                    <input type="hidden" name="accion" value="actualizarDatos">
                                    
                                    <div class="box-body">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>
                                                        <i class="fa fa-user"></i> Nombre *
                                                    </label>
                                                    <input type="text" 
                                                           class="form-control" 
                                                           name="txtNombre" 
                                                           value="${usuario.nombre}" 
                                                           placeholder="Ingrese su nombre"
                                                           required>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>
                                                        <i class="fa fa-user"></i> Apellido *
                                                    </label>
                                                    <input type="text" 
                                                           class="form-control" 
                                                           name="txtApellido" 
                                                           value="${usuario.apellido}" 
                                                           placeholder="Ingrese su apellido"
                                                           required>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>
                                                        <i class="fa fa-envelope"></i> Correo Electrónico
                                                    </label>
                                                    <input type="email" 
                                                           class="form-control" 
                                                           name="txtCorreo" 
                                                           value="${usuario.correo}" 
                                                           readonly
                                                           style="background-color: #f4f4f4;">
                                                    <small class="text-muted">
                                                        <i class="fa fa-info-circle"></i> 
                                                        El correo no se puede modificar
                                                    </small>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>
                                                        <i class="fa fa-phone"></i> Teléfono
                                                    </label>
                                                    <input type="text" 
                                                           class="form-control" 
                                                           name="txtTelefono" 
                                                           value="${usuario.telefono}"
                                                           placeholder="Ej: 987654321"
                                                           maxlength="15">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-12">
                                                <div class="form-group">
                                                    <label>
                                                        <i class="fa fa-map-marker"></i> Dirección
                                                    </label>
                                                    <input type="text" 
                                                           class="form-control" 
                                                           name="txtDireccion" 
                                                           value="${usuario.direccion}"
                                                           placeholder="Ej: Av. Principal 123, Lima">
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="box-footer">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fa fa-save"></i> Guardar Cambios
                                        </button>
                                        <button type="reset" class="btn btn-default">
                                            <i class="fa fa-undo"></i> Restablecer
                                        </button>
                                    </div>
                                </form>
                            </div>

                            <!-- Cambiar Contraseña -->
                            <div class="box box-warning">
                                <div class="box-header with-border">
                                    <h3 class="box-title">
                                        <i class="fa fa-lock"></i> Cambiar Contraseña
                                    </h3>
                                </div>
                                <form action="${pageContext.request.contextPath}/srvUsuario" 
                                      method="POST" 
                                      id="formPassword">
                                    <input type="hidden" name="accion" value="cambiarPassword">
                                    
                                    <div class="box-body">
                                        <div class="form-group">
                                            <label>
                                                <i class="fa fa-key"></i> Contraseña Actual *
                                            </label>
                                            <input type="password" 
                                                   class="form-control" 
                                                   name="txtPasswordActual" 
                                                   id="passwordActual" 
                                                   placeholder="Ingrese su contraseña actual"
                                                   required>
                                        </div>

                                        <div class="form-group">
                                            <label>
                                                <i class="fa fa-lock"></i> Nueva Contraseña *
                                            </label>
                                            <input type="password" 
                                                   class="form-control" 
                                                   name="txtPasswordNueva" 
                                                   id="passwordNueva" 
                                                   placeholder="Mínimo 6 caracteres"
                                                   required 
                                                   minlength="6">
                                            <small class="text-muted">
                                                <i class="fa fa-info-circle"></i> 
                                                Mínimo 6 caracteres
                                            </small>
                                        </div>

                                        <div class="form-group">
                                            <label>
                                                <i class="fa fa-lock"></i> Confirmar Nueva Contraseña *
                                            </label>
                                            <input type="password" 
                                                   class="form-control" 
                                                   name="txtPasswordConfirmar" 
                                                   id="passwordConfirmar" 
                                                   placeholder="Repita la nueva contraseña"
                                                   required 
                                                   minlength="6">
                                        </div>

                                        <!-- Mensaje de validación -->
                                        <div id="mensajePassword" class="alert" style="display: none;"></div>
                                    </div>

                                    <div class="box-footer">
                                        <button type="submit" class="btn btn-warning">
                                            <i class="fa fa-key"></i> Cambiar Contraseña
                                        </button>
                                        <button type="reset" class="btn btn-default">
                                            <i class="fa fa-times"></i> Cancelar
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

        <!-- Modal para cambiar foto de perfil -->
        <div class="modal fade" id="modalCambiarFoto" tabindex="-1">
            <div class="modal-dialog modal-sm">
                <div class="modal-content">
                    <div class="modal-header bg-primary">
                        <button type="button" class="close text-white" data-dismiss="modal">
                            <span>&times;</span>
                        </button>
                        <h4 class="modal-title">
                            <i class="fa fa-camera"></i> Cambiar foto de perfil
                        </h4>
                    </div>
                    <form action="${pageContext.request.contextPath}/srvUsuario" 
                          method="POST" 
                          enctype="multipart/form-data"
                          id="formFotoPerfil">
                        <input type="hidden" name="accion" value="cambiarFoto">
                        
                        <div class="modal-body text-center">
                            <!-- Vista previa -->
                            <img id="vistaPrevia" 
                                 src="${pageContext.request.contextPath}/${not empty usuario.fotoPerfil ? usuario.fotoPerfil : 'dist/img/user2-160x160.jpg'}"
                                 class="img-circle"
                                 style="width: 150px; height: 150px; object-fit: cover; margin-bottom: 15px;">
                            
                            <!-- Input file -->
                            <div class="form-group">
                                <label class="btn btn-default btn-file">
                                    <i class="fa fa-upload"></i> Seleccionar imagen
                                    <input type="file" 
                                           name="fotoPerfil" 
                                           id="inputFoto"
                                           accept="image/*"
                                           style="display: none;"
                                           required>
                                </label>
                            </div>
                            
                            <small class="text-muted">
                                <i class="fa fa-info-circle"></i> 
                                Máximo 2MB (JPG, PNG, GIF)
                            </small>
                        </div>
                        
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-primary">
                                <i class="fa fa-save"></i> Guardar
                            </button>
                            <button type="button" class="btn btn-default" data-dismiss="modal">
                                <i class="fa fa-times"></i> Cancelar
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script>
            $(document).ready(function() {
                // Validar que las contraseñas coincidan
                $('#formPassword').on('submit', function(e) {
                    var nueva = $('#passwordNueva').val();
                    var confirmar = $('#passwordConfirmar').val();
                    var mensaje = $('#mensajePassword');

                    if (nueva !== confirmar) {
                        e.preventDefault();
                        mensaje.removeClass('alert-success')
                               .addClass('alert-danger')
                               .html('<i class="fa fa-times-circle"></i> Las contraseñas no coinciden')
                               .show();
                        return false;
                    }

                    if (nueva.length < 6) {
                        e.preventDefault();
                        mensaje.removeClass('alert-success')
                               .addClass('alert-danger')
                               .html('<i class="fa fa-times-circle"></i> La contraseña debe tener al menos 6 caracteres')
                               .show();
                        return false;
                    }

                    return true;
                });

                // Limpiar mensaje al escribir
                $('#passwordNueva, #passwordConfirmar').on('keyup', function() {
                    $('#mensajePassword').hide();
                });

                // Indicador de fortaleza de contraseña
                $('#passwordNueva').on('keyup', function() {
                    var pass = $(this).val();
                    var fortaleza = '';
                    var clase = '';

                    if (pass.length >= 8 && /[A-Z]/.test(pass) && /[0-9]/.test(pass)) {
                        fortaleza = 'Fuerte';
                        clase = 'text-success';
                    } else if (pass.length >= 6) {
                        fortaleza = 'Media';
                        clase = 'text-warning';
                    } else if (pass.length > 0) {
                        fortaleza = 'Débil';
                        clase = 'text-danger';
                    }

                    if (fortaleza) {
                        $(this).next('small').html(
                            '<i class="fa fa-info-circle"></i> Fortaleza: <span class="' + clase + '">' + fortaleza + '</span>'
                        );
                    }
                });

                // Auto-ocultar alertas después de 4 segundos
                setTimeout(function() {
                    $('.alert').fadeOut('slow');
                }, 4000);

                // ✅ Vista previa de la foto de perfil
                $('#inputFoto').on('change', function(e) {
                    var file = e.target.files[0];
                    
                    if (file) {
                        // Validar tamaño
                        if (file.size > 2 * 1024 * 1024) {
                            alert('La imagen no debe superar los 2MB');
                            $(this).val('');
                            return;
                        }
                        
                        // Validar tipo
                        if (!file.type.match('image.*')) {
                            alert('Solo se permiten imágenes');
                            $(this).val('');
                            return;
                        }
                        
                        // Mostrar vista previa
                        var reader = new FileReader();
                        reader.onload = function(e) {
                            $('#vistaPrevia').attr('src', e.target.result);
                        };
                        reader.readAsDataURL(file);
                    }
                });

                // Validar formulario de foto
                $('#formFotoPerfil').on('submit', function(e) {
                    var file = $('#inputFoto')[0].files[0];
                    
                    if (!file) {
                        e.preventDefault();
                        alert('Debe seleccionar una imagen');
                        return false;
                    }
                    
                    // Mostrar loading
                    var btn = $(this).find('button[type="submit"]');
                    btn.html('<i class="fa fa-spinner fa-spin"></i> Subiendo...')
                       .prop('disabled', true);
                });
            });
        </script>
    </body>
</html>