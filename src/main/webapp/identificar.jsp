<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/vistas/includes/head-resources.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Iniciar Sesión - E-commerce</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <style>
        /* Estilos personalizados para el login */
        .login-page {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .login-logo img {
            max-width: 80px;
            margin-bottom: 10px;
        }
        
        .login-logo h2 {
            font-size: 24px;
            font-weight: 600;
            color: #333;
            margin: 10px 0;
        }
        
        .login-box-body {
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        
        .login-box-msg {
            font-weight: 600;
            font-size: 16px;
            color: #666;
            letter-spacing: 1px;
        }
        
        .input-container {
            position: relative;
        }
        
        .form-control {
            padding-right: 40px;
            height: 45px;
            border-radius: 5px;
            border: 1px solid #ddd;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .form-control.error {
            border-color: #dc3545;
            background-color: #fff5f5;
        }
        
        .form-control.success {
            border-color: #28a745;
            background-color: #f0fff4;
        }
        
        .form-control-feedback {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
            pointer-events: none;
            font-size: 18px;
        }
        
        .toggle-password {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
            cursor: pointer;
            font-size: 18px;
            transition: color 0.3s;
            z-index: 10;
        }
        
        .toggle-password:hover {
            color: #667eea;
        }
        
        .error-msg {
            display: none;
            color: #dc3545;
            font-size: 12px;
            margin-top: 5px;
            margin-left: 2px;
        }
        
        .error-msg i {
            margin-right: 3px;
        }
        
        .btn-login {
            height: 45px;
            font-weight: 600;
            letter-spacing: 1px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 5px;
            transition: all 0.3s ease;
        }
        
        .btn-login:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-login:disabled {
            opacity: 0.7;
            cursor: not-allowed;
        }
        
        .btn-login.loading::after {
            content: "";
            display: inline-block;
            width: 16px;
            height: 16px;
            margin-left: 10px;
            border: 2px solid #fff;
            border-radius: 50%;
            border-top-color: transparent;
            animation: spinner 0.6s linear infinite;
        }
        
        @keyframes spinner {
            to { transform: rotate(360deg); }
        }
        
        .extra-links {
            margin-top: 20px;
            text-align: center;
            border-top: 1px solid #eee;
            padding-top: 15px;
        }
        
        .extra-links a {
            display: block;
            margin: 10px 0;
            color: #667eea;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .extra-links a:hover {
            color: #764ba2;
            text-decoration: none;
            transform: translateX(5px);
        }
        
        .extra-links i {
            margin-right: 5px;
        }
        
        .alert {
            border-radius: 5px;
            border: none;
            animation: slideDown 0.3s ease;
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .alert-danger {
            background-color: #fee;
            color: #c33;
        }
        
        .alert-success {
            background-color: #efe;
            color: #3c3;
        }
    </style>
</head>
<body class="hold-transition login-page">

    <div class="login-box">
        <div class="login-logo">
            <b>E-commerce</b> Login
        </div>

        <div class="login-box-body">
            <p class="login-box-msg">INICIAR SESIÓN</p>

            <!-- Mensajes de Error y Éxito -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    <i class="fa fa-exclamation-triangle"></i> ${error}
                </div>
            </c:if>

            <c:if test="${not empty mensaje}">
                <div class="alert alert-success" role="alert">
                    <i class="fa fa-check-circle"></i> ${mensaje}
                </div>
            </c:if>

            <!-- Formulario de Login -->
            <form id="loginForm" action="srvUsuario" method="post" novalidate>
                <input type="hidden" name="accion" value="verificar" />
                
                <!-- Campo Email -->
                <div class="form-group has-feedback">
                    <div class="input-container">
                        <input type="email" 
                               name="txtCorreo" 
                               id="txtCorreo" 
                               class="form-control" 
                               placeholder="Correo electrónico"
                               aria-describedby="correo-error" 
                               required
                               value="<c:out value="${param.txtCorreo}"/>">
                        <span class="form-control-feedback" aria-hidden="true">
                            <i class="fa fa-envelope"></i>
                        </span>
                    </div>
                    <small id="correo-error" class="error-msg" role="alert">
                        <i class="fa fa-exclamation-triangle"></i> Email requerido
                    </small>
                </div>

                <!-- Campo Contraseña -->
                <div class="form-group has-feedback">
                    <div class="input-container">
                        <input type="password" 
                               name="txtPass" 
                               id="txtPass" 
                               class="form-control" 
                               placeholder="Contraseña"
                               aria-describedby="pass-error" 
                               required 
                               minlength="6">
                        <span class="toggle-password fa fa-eye" 
                              aria-label="Mostrar contraseña" 
                              role="button" 
                              tabindex="0"></span>
                    </div>
                    <small id="pass-error" class="error-msg" role="alert">
                        <i class="fa fa-exclamation-triangle"></i> Contraseña requerida (mínimo 6 caracteres)
                    </small>
                </div>

                <!-- Botón de Envío -->
                <div class="row">
                    <div class="col-xs-12">
                        <button type="submit" class="btn btn-primary btn-block btn-flat btn-login" id="btnLogin">
                            INGRESAR
                        </button>
                    </div>
                </div>
            </form>

            <!-- Enlaces Extra -->
            <div class="extra-links">
                <a href="registro.jsp"><i class="fa fa-user-plus"></i> ¿No tienes cuenta? Regístrate</a>
                <a href="recuperar.jsp"><i class="fa fa-unlock-alt"></i> ¿Olvidaste tu contraseña?</a>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="${pageContext.request.contextPath}/bower_components/jquery/dist/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/bower_components/bootstrap/dist/js/bootstrap.min.js"></script>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            
            // Elementos del formulario
            const form = document.getElementById("loginForm");
            const correo = document.getElementById("txtCorreo");
            const pass = document.getElementById("txtPass");
            const btn = document.getElementById("btnLogin");
            const togglePassword = document.querySelector(".toggle-password");
            
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            let isSubmitting = false;
            const originalBtnText = btn.innerHTML;
            
            // ===================================
            // Funciones de Utilidad
            // ===================================

            function showFieldError(field, errorElement, message) {
                field.classList.add("error");
                field.classList.remove("success");
                errorElement.innerHTML = '<i class="fa fa-exclamation-triangle"></i> ' + message;
                errorElement.style.display = "block";
            }

            function showFieldSuccess(field, errorElement) {
                field.classList.remove("error");
                field.classList.add("success");
                errorElement.style.display = "none";
            }

            function resetFormState() {
                btn.disabled = false;
                btn.classList.remove("loading");
                btn.innerHTML = originalBtnText;
                isSubmitting = false;
            }
            
            // Toggle de Contraseña
            function togglePasswordVisibility() {
                if (pass.type === "password") {
                    pass.type = "text";
                    togglePassword.classList.remove("fa-eye");
                    togglePassword.classList.add("fa-eye-slash");
                    togglePassword.setAttribute("aria-label", "Ocultar contraseña");
                } else {
                    pass.type = "password";
                    togglePassword.classList.remove("fa-eye-slash");
                    togglePassword.classList.add("fa-eye");
                    togglePassword.setAttribute("aria-label", "Mostrar contraseña");
                }
            }

            // ===================================
            // Validaciones
            // ===================================

            function validateEmail() {
                const correoError = document.getElementById("correo-error");
                if (correo.value.trim() === "") {
                    showFieldError(correo, correoError, "Email requerido");
                    return false;
                } else if (!emailRegex.test(correo.value)) {
                    showFieldError(correo, correoError, "Formato de email inválido");
                    return false;
                } else {
                    showFieldSuccess(correo, correoError);
                    return true;
                }
            }

            function validatePassword() {
                const passError = document.getElementById("pass-error");
                if (pass.value.length < 6) {
                    showFieldError(pass, passError, "Contraseña requerida (mínimo 6 caracteres)");
                    return false;
                } else {
                    showFieldSuccess(pass, passError);
                    return true;
                }
            }

            // ===================================
            // Event Listeners
            // ===================================
            
            // Toggle de Contraseña
            if (togglePassword) {
                togglePassword.addEventListener("click", togglePasswordVisibility);
                togglePassword.addEventListener("keydown", function(e) {
                    if (e.key === "Enter" || e.key === " ") {
                        e.preventDefault();
                        togglePasswordVisibility();
                    }
                });
            }
            
            // Validación en tiempo real
            correo.addEventListener("blur", validateEmail);
            correo.addEventListener("input", function() { 
                if (correo.classList.contains("error")) validateEmail(); 
            });

            pass.addEventListener("blur", validatePassword);
            pass.addEventListener("input", function() { 
                if (pass.classList.contains("error")) validatePassword(); 
            });

            // Manejo del envío del formulario
            form.addEventListener("submit", function (e) {
                if (isSubmitting) {
                    e.preventDefault();
                    return;
                }

                const emailValid = validateEmail();
                const passValid = validatePassword();

                if (!emailValid || !passValid) {
                    e.preventDefault();
                    const firstError = form.querySelector(".error");
                    if (firstError) {
                        firstError.focus();
                    }
                    return;
                }

                // Activar estado de carga
                isSubmitting = true;
                btn.disabled = true;
                btn.classList.add("loading");
                btn.innerHTML = 'INGRESANDO'; 

                // Timeout de seguridad
                setTimeout(function() {
                    if (isSubmitting) {
                        console.warn("Tiempo de espera excedido. Restableciendo formulario.");
                        resetFormState();
                    }
                }, 30000); 
            });

            // Resetear si hay errores del servidor
            if (document.querySelector(".alert-danger")) {
                resetFormState();
            }

            // Auto-dismiss alerts después de 5 segundos
            setTimeout(function() {
                $(".alert").fadeOut(500, function() {
                    $(this).remove(); 
                });
            }, 5000);
        });
    </script>

</body>
</html>