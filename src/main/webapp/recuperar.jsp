<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/vistas/includes/head-resources.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Recuperar Contraseña - E-commerce</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <style>
        /* Estilos personalizados para recuperar contraseña */
        .login-page {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .login-box {
            width: 400px;
            margin: 20px auto;
        }
        
        .login-logo b {
            font-size: 32px;
            color: #333;
        }
        
        .login-logo {
            font-size: 28px;
            text-align: center;
            margin-bottom: 25px;
            font-weight: 300;
            color: #666;
        }
        
        .login-box-body {
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        
        .recovery-icon {
            text-align: center;
            margin-bottom: 20px;
        }
        
        .recovery-icon i {
            font-size: 60px;
            color: #667eea;
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0%, 100% { transform: scale(1); opacity: 1; }
            50% { transform: scale(1.1); opacity: 0.8; }
        }
        
        .login-box-msg {
            font-weight: 600;
            font-size: 16px;
            color: #666;
            letter-spacing: 1px;
            text-align: center;
            margin-bottom: 10px;
        }
        
        .recovery-description {
            text-align: center;
            color: #999;
            font-size: 14px;
            margin-bottom: 25px;
            line-height: 1.6;
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
        
        .btn-recovery {
            height: 45px;
            font-weight: 600;
            letter-spacing: 1px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 5px;
            transition: all 0.3s ease;
            margin-top: 10px;
        }
        
        .btn-recovery:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-recovery:disabled {
            opacity: 0.7;
            cursor: not-allowed;
        }
        
        .btn-recovery.loading::after {
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
            display: inline-block;
            margin: 5px 10px;
        }
        
        .extra-links a:hover {
            color: #764ba2;
            text-decoration: none;
            transform: translateX(3px);
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
        
        .alert-info {
            background-color: #e7f3ff;
            color: #0066cc;
        }
        
        .success-icon {
            text-align: center;
            margin-bottom: 20px;
        }
        
        .success-icon i {
            font-size: 60px;
            color: #28a745;
            animation: checkmark 0.5s ease;
        }
        
        @keyframes checkmark {
            0% { transform: scale(0); opacity: 0; }
            50% { transform: scale(1.2); }
            100% { transform: scale(1); opacity: 1; }
        }
        
        .success-message {
            text-align: center;
            padding: 20px;
        }
        
        .success-message h3 {
            color: #28a745;
            margin-bottom: 15px;
        }
        
        .success-message p {
            color: #666;
            line-height: 1.6;
        }
        
        .timer {
            font-size: 14px;
            color: #999;
            text-align: center;
            margin-top: 10px;
        }
        
        .timer.disabled {
            color: #ccc;
        }
        
        .btn-resend {
            background: transparent;
            border: 2px solid #667eea;
            color: #667eea;
            margin-top: 10px;
        }
        
        .btn-resend:hover:not(:disabled) {
            background: #667eea;
            color: #fff;
        }
        
        .btn-resend:disabled {
            border-color: #ccc;
            color: #ccc;
            cursor: not-allowed;
        }
    </style>
</head>
<body class="hold-transition login-page">

    <div class="login-box">
        <div class="login-logo">
            <b>E-commerce</b> Recuperar
        </div>

        <div class="login-box-body">
            
            <!-- Estado: Formulario inicial -->
            <div id="recovery-form-section">
                <div class="recovery-icon">
                    <i class="fa fa-unlock-alt"></i>
                </div>
                
                <p class="login-box-msg">¿OLVIDASTE TU CONTRASEÑA?</p>
                <p class="recovery-description">
                    No te preocupes, ingresa tu correo electrónico y te enviaremos las instrucciones para recuperar tu contraseña.
                </p>

                <!-- Mensajes de Error -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        <i class="fa fa-exclamation-triangle"></i> ${error}
                    </div>
                </c:if>

                <!-- Formulario de Recuperación -->
                <form id="recoveryForm" action="srvRecuperarPassword" method="post" novalidate>
                    <input type="hidden" name="accion" value="enviar" />
                    
                    <!-- Campo Email -->
                    <div class="form-group has-feedback">
                        <div class="input-container">
                            <input type="email" 
                                   name="correo" 
                                   id="correo" 
                                   class="form-control" 
                                   placeholder="Correo electrónico registrado"
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

                    <!-- Botón de Envío -->
                    <div class="row">
                        <div class="col-xs-12">
                            <button type="submit" class="btn btn-primary btn-block btn-flat btn-recovery" id="btnRecovery">
                                <i class="fa fa-paper-plane"></i> ENVIAR INSTRUCCIONES
                            </button>
                        </div>
                    </div>
                    
                    <!-- Timer para reenvío (oculto inicialmente) -->
                    <div class="timer" id="resendTimer" style="display:none;">
                        Podrás reenviar el correo en <span id="countdown">60</span> segundos
                    </div>
                </form>
            </div>

            <!-- Estado: Mensaje de éxito (oculto por defecto) -->
            <div id="success-section" style="display:none;">
                <div class="success-icon">
                    <i class="fa fa-check-circle"></i>
                </div>
                
                <div class="success-message">
                    <h3>¡Correo enviado exitosamente!</h3>
                    <p>
                        Hemos enviado un correo electrónico a <strong id="sent-email"></strong> con las instrucciones para recuperar tu contraseña.
                    </p>
                    <p style="margin-top:15px; font-size:13px;">
                        <i class="fa fa-info-circle"></i> Si no lo recibes en los próximos minutos, revisa tu carpeta de spam.
                    </p>
                </div>
                
                <button type="button" class="btn btn-block btn-resend" id="btnResend" disabled>
                    <i class="fa fa-refresh"></i> REENVIAR CORREO (<span id="countdown2">60</span>s)
                </button>
            </div>

            <!-- Enlaces Extra -->
            <div class="extra-links">
                <a href="identificar.jsp"><i class="fa fa-sign-in"></i> Volver al login</a>
                <a href="registro.jsp"><i class="fa fa-user-plus"></i> Crear cuenta</a>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="${pageContext.request.contextPath}/bower_components/jquery/dist/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/bower_components/bootstrap/dist/js/bootstrap.min.js"></script>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            
            // Elementos del formulario
            const form = document.getElementById("recoveryForm");
            const correo = document.getElementById("correo");
            const btn = document.getElementById("btnRecovery");
            const btnResend = document.getElementById("btnResend");
            const recoverySection = document.getElementById("recovery-form-section");
            const successSection = document.getElementById("success-section");
            const resendTimer = document.getElementById("resendTimer");
            
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            let isSubmitting = false;
            const originalBtnText = btn.innerHTML;
            let countdownInterval;
            
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
            
            function startCountdown(seconds, countdownElement, buttonElement) {
                let timeLeft = seconds;
                
                if (countdownInterval) {
                    clearInterval(countdownInterval);
                }
                
                countdownInterval = setInterval(function() {
                    timeLeft--;
                    countdownElement.textContent = timeLeft;
                    
                    if (timeLeft <= 0) {
                        clearInterval(countdownInterval);
                        buttonElement.disabled = false;
                        buttonElement.innerHTML = '<i class="fa fa-refresh"></i> REENVIAR CORREO';
                        if (resendTimer) {
                            resendTimer.style.display = 'none';
                        }
                    }
                }, 1000);
            }
            
            function showSuccessState(email) {
                recoverySection.style.display = 'none';
                successSection.style.display = 'block';
                document.getElementById('sent-email').textContent = email;
                
                // Iniciar countdown
                btnResend.disabled = true;
                startCountdown(60, document.getElementById('countdown2'), btnResend);
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

            // ===================================
            // Event Listeners
            // ===================================
            
            // Validación en tiempo real
            correo.addEventListener("blur", validateEmail);
            correo.addEventListener("input", function() { 
                if (correo.classList.contains("error")) validateEmail(); 
            });

            // Manejo del envío del formulario
            form.addEventListener("submit", function (e) {
                e.preventDefault();
                
                if (isSubmitting) {
                    return;
                }

                const emailValid = validateEmail();

                if (!emailValid) {
                    correo.focus();
                    return;
                }

                // Activar estado de carga
                isSubmitting = true;
                btn.disabled = true;
                btn.classList.add("loading");
                btn.innerHTML = '<i class="fa fa-spinner fa-spin"></i> ENVIANDO'; 

                // Simulación de envío (reemplazar con llamada real al servidor)
                setTimeout(function() {
                    // AQUÍ IRÍA LA LLAMADA AJAX AL SERVIDOR
                    // Por ahora simulamos éxito
                    
                    // Ocultar alertas previas
                    $('.alert').remove();
                    
                    // Mostrar estado de éxito
                    showSuccessState(correo.value);
                    
                    resetFormState();
                }, 2000);
                
                // Para envío real, descomentar esto:
                /*
                $.ajax({
                    url: 'srvRecuperarPassword',
                    type: 'POST',
                    data: {
                        accion: 'enviar',
                        correo: correo.value
                    },
                    success: function(response) {
                        if (response.success) {
                            showSuccessState(correo.value);
                        } else {
                            // Mostrar error
                            recoverySection.insertAdjacentHTML('afterbegin', 
                                '<div class="alert alert-danger"><i class="fa fa-exclamation-triangle"></i> ' + 
                                response.message + '</div>');
                        }
                        resetFormState();
                    },
                    error: function() {
                        recoverySection.insertAdjacentHTML('afterbegin', 
                            '<div class="alert alert-danger"><i class="fa fa-exclamation-triangle"></i> ' + 
                            'Error al enviar el correo. Intenta nuevamente.</div>');
                        resetFormState();
                    }
                });
                */
            });
            
            // Botón reenviar
            btnResend.addEventListener("click", function() {
                if (this.disabled) return;
                
                const email = document.getElementById('sent-email').textContent;
                
                this.disabled = true;
                this.innerHTML = '<i class="fa fa-spinner fa-spin"></i> REENVIANDO...';
                
                // Simulación de reenvío
                setTimeout(function() {
                    btnResend.innerHTML = '<i class="fa fa-refresh"></i> REENVIAR CORREO (<span id="countdown2">60</span>s)';
                    startCountdown(60, document.getElementById('countdown2'), btnResend);
                    
                    // Mostrar mensaje de confirmación
                    successSection.insertAdjacentHTML('afterbegin', 
                        '<div class="alert alert-success"><i class="fa fa-check"></i> Correo reenviado exitosamente</div>');
                    
                    setTimeout(function() {
                        $('.alert').fadeOut(500, function() { $(this).remove(); });
                    }, 3000);
                }, 2000);
            });

            // Si hay mensaje de éxito del servidor, mostrar pantalla de éxito
            <c:if test="${not empty mensaje}">
                const emailSent = correo.value || '${param.correo}';
                if (emailSent) {
                    showSuccessState(emailSent);
                }
            </c:if>

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