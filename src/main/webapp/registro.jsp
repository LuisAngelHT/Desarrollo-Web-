<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/vistas/includes/head-resources.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Registro de Cliente - E-commerce</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <style>
        /* Estilos personalizados para el registro */
        .register-page {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .register-box {
            width: 400px;
            margin: 20px auto;
        }
        
        .register-logo b {
            font-size: 32px;
            color: #333;
        }
        
        .register-logo {
            font-size: 28px;
            text-align: center;
            margin-bottom: 25px;
            font-weight: 300;
            color: #333;
        }
        
        .register-box-body {
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        
        .login-box-msg {
            font-weight: 600;
            font-size: 16px;
            color: #666;
            letter-spacing: 1px;
            text-align: center;
            margin-bottom: 20px;
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
        
        .password-strength {
            margin-top: 5px;
            font-size: 12px;
        }
        
        .strength-bar {
            height: 4px;
            background: #eee;
            border-radius: 2px;
            margin-top: 5px;
            overflow: hidden;
        }
        
        .strength-bar-fill {
            height: 100%;
            width: 0%;
            transition: all 0.3s;
            border-radius: 2px;
        }
        
        .strength-weak { background: #dc3545; width: 33%; }
        .strength-medium { background: #ffc107; width: 66%; }
        .strength-strong { background: #28a745; width: 100%; }
        
        .btn-register {
            height: 45px;
            font-weight: 600;
            letter-spacing: 1px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 5px;
            transition: all 0.3s ease;
            margin-top: 10px;
        }
        
        .btn-register:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-register:disabled {
            opacity: 0.7;
            cursor: not-allowed;
        }
        
        .btn-register.loading::after {
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
            color: #667eea;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .extra-links a:hover {
            color: #764ba2;
            text-decoration: none;
        }
        
        .extra-links i {
            margin-right: 5px;
        }
        
        .alert {
            border-radius: 5px;
            border: none;
            animation: slideDown 0.3s ease;
            margin-bottom: 20px;
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
        
        .form-group {
            margin-bottom: 20px;
        }
    </style>
</head>
<body class="hold-transition register-page">

    <div class="register-box">
        <div class="register-logo">
            <b>E-commerce</b> Registro
        </div>

        <div class="register-box-body">
            <p class="login-box-msg">CREA TU CUENTA</p>

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

            <!-- Formulario de Registro -->
            <form id="registroForm" action="srvClienteRegistro" method="post" novalidate>
                <input type="hidden" name="accion" value="registrar" />
                
                <!-- Campo Nombre -->
                <div class="form-group has-feedback">
                    <div class="input-container">
                        <input type="text" 
                               name="nombre" 
                               id="nombre" 
                               class="form-control" 
                               placeholder="Nombres"
                               aria-describedby="nombre-error" 
                               required
                               value="<c:out value="${param.nombre}"/>">
                        <span class="form-control-feedback" aria-hidden="true">
                            <i class="fa fa-user"></i>
                        </span>
                    </div>
                    <small id="nombre-error" class="error-msg" role="alert">
                        <i class="fa fa-exclamation-triangle"></i> Nombre requerido
                    </small>
                </div>

                <!-- Campo Apellido -->
                <div class="form-group has-feedback">
                    <div class="input-container">
                        <input type="text" 
                               name="apellido" 
                               id="apellido" 
                               class="form-control" 
                               placeholder="Apellidos"
                               aria-describedby="apellido-error" 
                               required
                               value="<c:out value="${param.apellido}"/>">
                        <span class="form-control-feedback" aria-hidden="true">
                            <i class="fa fa-user"></i>
                        </span>
                    </div>
                    <small id="apellido-error" class="error-msg" role="alert">
                        <i class="fa fa-exclamation-triangle"></i> Apellido requerido
                    </small>
                </div>

                <!-- Campo Email -->
                <div class="form-group has-feedback">
                    <div class="input-container">
                        <input type="email" 
                               name="correo" 
                               id="correo" 
                               class="form-control" 
                               placeholder="Correo electrónico"
                               aria-describedby="correo-error" 
                               required
                               value="<c:out value="${param.correo}"/>">
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
                               name="contrasena" 
                               id="contrasena" 
                               class="form-control" 
                               placeholder="Contraseña (mínimo 6 caracteres)"
                               aria-describedby="contrasena-error" 
                               required 
                               minlength="6">
                        <span class="toggle-password fa fa-eye" 
                              aria-label="Mostrar contraseña" 
                              role="button" 
                              tabindex="0"
                              data-target="contrasena"></span>
                    </div>
                    <div class="password-strength">
                        <div class="strength-bar">
                            <div class="strength-bar-fill" id="strength-bar"></div>
                        </div>
                        <small id="strength-text" style="display:none; margin-top:5px; display:block;"></small>
                    </div>
                    <small id="contrasena-error" class="error-msg" role="alert">
                        <i class="fa fa-exclamation-triangle"></i> Contraseña requerida (mínimo 6 caracteres)
                    </small>
                </div>

                <!-- Campo Confirmar Contraseña -->
                <div class="form-group has-feedback">
                    <div class="input-container">
                        <input type="password" 
                               name="confirmarContrasena" 
                               id="confirmarContrasena" 
                               class="form-control" 
                               placeholder="Confirmar contraseña"
                               aria-describedby="confirmar-error" 
                               required 
                               minlength="6">
                        <span class="toggle-password fa fa-eye" 
                              aria-label="Mostrar contraseña" 
                              role="button" 
                              tabindex="0"
                              data-target="confirmarContrasena"></span>
                    </div>
                    <small id="confirmar-error" class="error-msg" role="alert">
                        <i class="fa fa-exclamation-triangle"></i> Las contraseñas no coinciden
                    </small>
                </div>

                <!-- Campo Teléfono -->
                <div class="form-group has-feedback">
                    <div class="input-container">
                        <input type="tel" 
                               name="telefono" 
                               id="telefono" 
                               class="form-control" 
                               placeholder="Teléfono (9 dígitos)"
                               aria-describedby="telefono-error" 
                               pattern="[0-9]{9}"
                               required
                               value="<c:out value="${param.telefono}"/>">
                        <span class="form-control-feedback" aria-hidden="true">
                            <i class="fa fa-phone"></i>
                        </span>
                    </div>
                    <small id="telefono-error" class="error-msg" role="alert">
                        <i class="fa fa-exclamation-triangle"></i> Teléfono debe tener 9 dígitos
                    </small>
                </div>

                <!-- Botón de Envío -->
                <div class="row">
                    <div class="col-xs-12">
                        <button type="submit" class="btn btn-primary btn-block btn-flat btn-register" id="btnRegistro">
                            REGISTRARSE
                        </button>
                    </div>
                </div>
            </form>

            <!-- Enlaces Extra -->
            <div class="extra-links">
                <a href="identificar.jsp"><i class="fa fa-sign-in"></i> ¿Ya tienes cuenta? Inicia sesión</a>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="${pageContext.request.contextPath}/bower_components/jquery/dist/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/bower_components/bootstrap/dist/js/bootstrap.min.js"></script>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            
            // Elementos del formulario
            const form = document.getElementById("registroForm");
            const nombre = document.getElementById("nombre");
            const correo = document.getElementById("correo");
            const contrasena = document.getElementById("contrasena");
            const confirmarContrasena = document.getElementById("confirmarContrasena");
            const telefono = document.getElementById("telefono");
            const btn = document.getElementById("btnRegistro");
            const togglePasswords = document.querySelectorAll(".toggle-password");
            
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            const phoneRegex = /^[0-9]{9}$/;
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
            
            // Toggle de Contraseña (mejorado para múltiples campos)
            togglePasswords.forEach(toggle => {
                toggle.addEventListener("click", function() {
                    const targetId = this.getAttribute("data-target");
                    const targetInput = document.getElementById(targetId);
                    
                    if (targetInput.type === "password") {
                        targetInput.type = "text";
                        this.classList.remove("fa-eye");
                        this.classList.add("fa-eye-slash");
                        this.setAttribute("aria-label", "Ocultar contraseña");
                    } else {
                        targetInput.type = "password";
                        this.classList.remove("fa-eye-slash");
                        this.classList.add("fa-eye");
                        this.setAttribute("aria-label", "Mostrar contraseña");
                    }
                });
                
                toggle.addEventListener("keydown", function(e) {
                    if (e.key === "Enter" || e.key === " ") {
                        e.preventDefault();
                        this.click();
                    }
                });
            });
            
            // Indicador de fortaleza de contraseña
            function checkPasswordStrength(password) {
                const strengthBar = document.getElementById("strength-bar");
                const strengthText = document.getElementById("strength-text");
                
                if (password.length === 0) {
                    strengthBar.className = "strength-bar-fill";
                    strengthText.textContent = "";
                    return;
                }
                
                let strength = 0;
                if (password.length >= 6) strength++;
                if (password.length >= 8) strength++;
                if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
                if (/[0-9]/.test(password)) strength++;
                if (/[^a-zA-Z0-9]/.test(password)) strength++;
                
                strengthBar.className = "strength-bar-fill";
                
                if (strength <= 2) {
                    strengthBar.classList.add("strength-weak");
                    strengthText.textContent = "Débil";
                    strengthText.style.color = "#dc3545";
                } else if (strength <= 4) {
                    strengthBar.classList.add("strength-medium");
                    strengthText.textContent = "Media";
                    strengthText.style.color = "#ffc107";
                } else {
                    strengthBar.classList.add("strength-strong");
                    strengthText.textContent = "Fuerte";
                    strengthText.style.color = "#28a745";
                }
            }

            // ===================================
            // Validaciones
            // ===================================

            function validateNombre() {
                const nombreError = document.getElementById("nombre-error");
                if (nombre.value.trim().length < 3) {
                    showFieldError(nombre, nombreError, "Nombre debe tener al menos 3 caracteres");
                    return false;
                } else if (!/^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/.test(nombre.value)) {
                    showFieldError(nombre, nombreError, "Nombre solo debe contener letras");
                    return false;
                } else {
                    showFieldSuccess(nombre, nombreError);
                    return true;
                }
            }

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
                const contrasenaError = document.getElementById("contrasena-error");
                if (contrasena.value.length < 6) {
                    showFieldError(contrasena, contrasenaError, "Contraseña debe tener al menos 6 caracteres");
                    return false;
                } else {
                    showFieldSuccess(contrasena, contrasenaError);
                    return true;
                }
            }
            
            function validateConfirmPassword() {
                const confirmarError = document.getElementById("confirmar-error");
                if (confirmarContrasena.value !== contrasena.value) {
                    showFieldError(confirmarContrasena, confirmarError, "Las contraseñas no coinciden");
                    return false;
                } else if (confirmarContrasena.value.length < 6) {
                    showFieldError(confirmarContrasena, confirmarError, "Contraseña debe tener al menos 6 caracteres");
                    return false;
                } else {
                    showFieldSuccess(confirmarContrasena, confirmarError);
                    return true;
                }
            }

            function validateTelefono() {
                const telefonoError = document.getElementById("telefono-error");
                if (!phoneRegex.test(telefono.value)) {
                    showFieldError(telefono, telefonoError, "Teléfono debe tener 9 dígitos");
                    return false;
                } else {
                    showFieldSuccess(telefono, telefonoError);
                    return true;
                }
            }

            // ===================================
            // Event Listeners
            // ===================================
            
            // Validación en tiempo real
            nombre.addEventListener("blur", validateNombre);
            nombre.addEventListener("input", function() { 
                if (nombre.classList.contains("error")) validateNombre(); 
            });

            correo.addEventListener("blur", validateEmail);
            correo.addEventListener("input", function() { 
                if (correo.classList.contains("error")) validateEmail(); 
            });

            contrasena.addEventListener("input", function() {
                checkPasswordStrength(this.value);
                if (contrasena.classList.contains("error")) validatePassword();
                if (confirmarContrasena.value.length > 0) validateConfirmPassword();
            });
            contrasena.addEventListener("blur", validatePassword);
            
            confirmarContrasena.addEventListener("blur", validateConfirmPassword);
            confirmarContrasena.addEventListener("input", function() { 
                if (confirmarContrasena.classList.contains("error")) validateConfirmPassword(); 
            });

            telefono.addEventListener("blur", validateTelefono);
            telefono.addEventListener("input", function() { 
                // Solo permitir números
                this.value = this.value.replace(/[^0-9]/g, '');
                if (telefono.classList.contains("error")) validateTelefono(); 
            });

            // Manejo del envío del formulario
            form.addEventListener("submit", function (e) {
                if (isSubmitting) {
                    e.preventDefault();
                    return;
                }

                const nombreValid = validateNombre();
                const emailValid = validateEmail();
                const passValid = validatePassword();
                const confirmValid = validateConfirmPassword();
                const telefonoValid = validateTelefono();

                if (!nombreValid || !emailValid || !passValid || !confirmValid || !telefonoValid) {
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
                btn.innerHTML = 'REGISTRANDO'; 

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