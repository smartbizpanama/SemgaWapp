<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="Login.aspx.vb" Inherits="SemgaWapp.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Segma - Inicio de Sesi&#243;n Seguro</title>
    <meta charset="utf-8" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="Portal cooperativo seguro de Segma" />
    <meta name="robots" content="noindex, nofollow" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <!-- Estilos CSS -->
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #87CEEB 0%, #B0E0E6 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .login-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 40px;
            width: 100%;
            max-width: 400px;
            position: relative;
            overflow: hidden;
        }

        .login-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #87CEEB, #B0E0E6);
        }

        .logo-section {
            text-align: center;
            margin-bottom: 30px;
        }

        

        .bank-name {
            font-size: 24px;
            font-weight: 700;
            color: #333;
            margin-bottom: 5px;
        }

        .bank-subtitle {
            font-size: 14px;
            color: #666;
            font-weight: 400;
        }

        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
            font-size: 14px;
        }

        .form-input {
            width: 100%;
            padding: 15px 20px;
            border: 2px solid #e1e5e9;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: #f8f9fa;
            outline: none;
        }

        .form-input:focus {
            border-color: #87CEEB;
            background: white;
            box-shadow: 0 0 0 3px rgba(135, 206, 235, 0.1);
        }

        .form-input.error {
            border-color: #87CEEB;
            background: #f0f8ff;
        }

        .form-input.success {
            border-color: #87CEEB;
            background: #f0f8ff;
        }

        .password-container {
            position: relative;
        }

        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
            color: #666;
            font-size: 18px;
            padding: 5px;
            border-radius: 5px;
            transition: all 0.3s ease;
        }

        .password-toggle:hover {
            color: #87CEEB;
            background: rgba(135, 206, 235, 0.1);
        }

        .login-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
            position: relative;
            overflow: hidden;
            min-height: 54px;
            box-shadow: 0 4px 15px rgba(0, 123, 255, 0.2);
            text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
        }

        .login-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s ease;
        }

        .login-btn:hover::before {
            left: 100%;
        }

        .login-btn:hover {
            background: linear-gradient(135deg, #0056b3, #004085);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 123, 255, 0.4);
        }

        .login-btn:active {
            transform: translateY(0);
            box-shadow: 0 4px 15px rgba(0, 123, 255, 0.3);
        }

        .login-btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .login-btn .btn-content {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            min-height: 24px;
            white-space: nowrap;
        }

        .loading-spinner {
            width: 18px;
            height: 18px;
            border: 2px solid #ffffff;
            border-top: 2px solid transparent;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            flex-shrink: 0;
            margin-right: 8px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .error-message {
            background: #fee;
            color: #c33;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #c33;
            font-size: 14px;
            display: none;
            animation: slideIn 0.3s ease;
        }

        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #28a745;
            font-size: 14px;
            display: none;
            animation: slideIn 0.3s ease;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .attempts-warning {
            background: #ffe6e6;
            color: #721c24;
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 15px;
            border-left: 4px solid #dc3545;
            font-size: 13px;
            display: none;
            animation: slideIn 0.3s ease;
        }

        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #666;
            font-size: 16px;
        }

        .form-input.with-icon {
            padding-left: 45px;
        }

        .progress-bar {
            width: 100%;
            height: 4px;
            background: #e1e5e9;
            border-radius: 2px;
            margin-top: 5px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #87CEEB, #B0E0E6);
            width: 0%;
            transition: width 0.3s ease;
        }

        .password-strength {
            font-size: 12px;
            margin-top: 5px;
            color: #666;
        }

        .strength-weak { color: #dc3545; }
        .strength-medium { color: #ffc107; }
        .strength-strong { color: #28a745; }

        @media (max-width: 480px) {
            .login-container {
                padding: 30px 20px;
                margin: 10px;
            }
            
            .bank-name {
                font-size: 20px;
            }
        }

        /* Animaciones adicionales */
        .shake {
            animation: shake 0.5s ease-in-out;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        .pulse {
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(135, 206, 235, 0.7); }
            70% { box-shadow: 0 0 0 10px rgba(135, 206, 235, 0); }
            100% { box-shadow: 0 0 0 0 rgba(135, 206, 235, 0); }
        }
    </style>
    
   
</head>
<body>
    <form id="loginForm" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" />
        <div class="login-container">
            <!-- Logo y nombre del banco -->
            <div class="logo-section">
                 <div >
                     <i class="fa-solid fa-vault" style="font-size: 50px; color: #DAA520;"></i>
                 </div>
                <h1 class="bank-name">Segma</h1>
                <p class="bank-subtitle">La cooperativa del pueblo</p>
            </div>

            <!-- Mensaje de error -->
            <div id="errorMessage" class="error-message">
                <i class="fas fa-exclamation-triangle"></i>
                <span id="errorText"></span>
            </div>

            <!-- Mensaje de Éxito -->
            <div id="successMessage" class="success-message">
                <i class="fas fa-check-circle"></i>
                <span id="successText"></span>
            </div>

            <!-- Advertencia de intentos -->
            <div id="attemptsWarning" class="attempts-warning">
                <i class="fas fa-exclamation-circle"></i>
                <span id="attemptsText"></span>
            </div>

            <!-- Formulario de login -->
            <div class="form-group">
                <label for="username" class="form-label">
                    <i class="fas fa-user"></i> Usuario
                </label>
                <div style="position: relative;">
                    <i class="fas fa-user input-icon"></i>
                    <input type="text" id="username" name="username" class="form-input with-icon" 
                           placeholder="Ingrese su usuario" 
                           maxlength="50" autocomplete="username" />
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" id="usernameProgress"></div>
                </div>
            </div>

            <div class="form-group">
                <label for="password" class="form-label">
                    <i class="fas fa-lock"></i> Contraseña
                </label>
                <div class="password-container">
                    <i class="fas fa-lock input-icon"></i>
                    <input type="password" id="password" name="password" class="form-input with-icon" 
                           placeholder="Ingrese su contraseña" maxlength="128" autocomplete="current-password" />
                    <button type="button" class="password-toggle" onclick="togglePassword()">
                        <i class="fas fa-eye" id="passwordIcon"></i>
                    </button>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" id="passwordProgress"></div>
                </div>
                <div class="password-strength" id="passwordStrength"></div>
            </div>

            <!-- Botón de login -->
            <button type="button" id="loginBtn" class="login-btn" onclick="performLogin()">
                <div class="btn-content">
                    <i class="fas fa-sign-in-alt"></i>
                    <span id="loginBtnText">Iniciar Sesión</span>
                </div>
            </button>
        </div>
    </form>

    <!-- JavaScript para funcionalidad -->
    <script type="text/javascript">
        // Función para hacer llamada AJAX al WebMethod usando PageMethods
        function callWebMethod(methodName, parameters, successCallback, errorCallback) {
            // Usar PageMethods si está disponible, sino usar fetch como fallback
            if (typeof PageMethods !== 'undefined' && PageMethods[methodName]) {
                // Llamar directamente al PageMethod
                PageMethods[methodName](parameters, successCallback, errorCallback);
            } else {
                // Fallback a fetch
                const data = JSON.stringify(parameters);
                
                fetch('Login.aspx/' + methodName, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=utf-8',
                    },
                    body: data
                })
                .then(response => response.json())
                .then(result => {
                    if (result.d) {
                        successCallback(result.d);
                    } else {
                        successCallback(result);
                    }
                })
                .catch(error => {
                    
                    errorCallback(error);
                });
            }
        }

        
        // Variables globales
        let isSubmitting = false;
        let failedAttempts = 0;
        const maxAttempts = 3;

        // Función para mostrar/ocultar contraseña
        function togglePassword() {
            const passwordField = document.getElementById('password');
            const passwordIcon = document.getElementById('passwordIcon');
            
            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                passwordIcon.className = 'fas fa-eye-slash';
            } else {
                passwordField.type = 'password';
                passwordIcon.className = 'fas fa-eye';
            }
        }

        // Función para validar entrada en tiempo real
        function validateInput(input, type) {
            const value = input.value.trim();
            const progressBar = document.getElementById(type + 'Progress');
            const inputElement = input;
            
            let isValid = false;
            let progress = 0;
            
            switch(type) {
                case 'username':
                    if (value.length >= 3) {
                        isValid = /^[a-zA-Z0-9_]+$/.test(value);
                        progress = Math.min((value.length / 10) * 100, 100);
                    }
                    break;
                case 'password':
                    if (value.length >= 8) {
                        const hasUpper = /[A-Z]/.test(value);
                        const hasLower = /[a-z]/.test(value);
                        const hasNumber = /\d/.test(value);
                        const hasSpecial = /[!@#$%^&*(),.?":{}|<>]/.test(value);
                        
                        const strength = [hasUpper, hasLower, hasNumber, hasSpecial].filter(Boolean).length;
                        progress = (strength / 4) * 100;
                        isValid = strength >= 3;
                        
                        updatePasswordStrength(value);
                    }
                    break;
            }
            
            // Actualizar barra de progreso
            progressBar.style.width = progress + '%';
            
            // Actualizar clases CSS - siempre aplicar estilo celeste cuando hay contenido
            inputElement.classList.remove('error', 'success');
            if (value.length > 0) {
                inputElement.classList.add('success');
            }
            
            return isValid;
        }

        // Función para actualizar indicador de fortaleza de contraseña
        function updatePasswordStrength(password) {
            const strengthElement = document.getElementById('passwordStrength');
            const hasUpper = /[A-Z]/.test(password);
            const hasLower = /[a-z]/.test(password);
            const hasNumber = /\d/.test(password);
            const hasSpecial = /[!@#$%^&*(),.?":{}|<>]/.test(password);
            
            const strength = [hasUpper, hasLower, hasNumber, hasSpecial].filter(Boolean).length;
            
            let strengthText = '';
            let strengthClass = '';
            
            if (password.length < 8) {
                strengthText = 'Muy débil';
                strengthClass = 'strength-weak';
            } else if (strength <= 2) {
                strengthText = 'Débil';
                strengthClass = 'strength-weak';
            } else if (strength === 3) {
                strengthText = 'Media';
                strengthClass = 'strength-medium';
            } else {
                strengthText = 'Fuerte';
                strengthClass = 'strength-strong';
            }
            
            strengthElement.textContent = `Fortaleza: ${strengthText}`;
            strengthElement.className = `password-strength ${strengthClass}`;
        }

        // Función para mostrar errores
        function showError(message) {
            const errorDiv = document.getElementById('errorMessage');
            const errorText = document.getElementById('errorText');
            
            errorText.textContent = message;
            errorDiv.style.display = 'block';
            
            // Ocultar otros mensajes
            document.getElementById('successMessage').style.display = 'none';
            document.getElementById('attemptsWarning').style.display = 'none';
            
            // Efecto de shake
            document.querySelector('.login-container').classList.add('shake');
            setTimeout(() => {
                document.querySelector('.login-container').classList.remove('shake');
            }, 500);
            
            // Ocultar después de 5 segundos
            setTimeout(() => {
                errorDiv.style.display = 'none';
            }, 5000);
        }

        // Función para mostrar Éxito
        function showSuccess(message) {
            const successDiv = document.getElementById('successMessage');
            const successText = document.getElementById('successText');
            
            successText.textContent = message;
            successDiv.style.display = 'block';
            
            // Ocultar otros mensajes
            document.getElementById('errorMessage').style.display = 'none';
            document.getElementById('attemptsWarning').style.display = 'none';
        }

        // Función para mostrar advertencia de intentos
        function showAttemptsWarning(message) {
            const warningDiv = document.getElementById('attemptsWarning');
            const warningText = document.getElementById('attemptsText');
            
            warningText.textContent = message;
            warningDiv.style.display = 'block';
            
            // Ocultar otros mensajes
            document.getElementById('errorMessage').style.display = 'none';
            document.getElementById('successMessage').style.display = 'none';
        }

        // Función para mostrar loading
        function showLoading() {
            const btn = document.getElementById('loginBtn');
            const btnContent = btn.querySelector('.btn-content');
            
            btn.disabled = true;
            btnContent.innerHTML = '<div class="loading-spinner"></div><span>Iniciando Sesión...</span>';
        }

        // Función para ocultar loading
        function hideLoading() {
            const btn = document.getElementById('loginBtn');
            const btnContent = btn.querySelector('.btn-content');
            
            btn.disabled = false;
            btnContent.innerHTML = '<i class="fas fa-sign-in-alt"></i><span id="loginBtnText">Iniciar Sesión</span>';
        }

        // Función principal de login
        function performLogin() {
            if (isSubmitting) return;
            
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value;
            
            // Validar entrada
            if (!username) {
                showError('Por favor ingrese su usuario');
                document.getElementById('username').focus();
                return;
            }
            
            if (!password) {
                showError('Por favor ingrese su contraseña');
                document.getElementById('password').focus();
                return;
            }
            
            if (!validateInput(document.getElementById('username'), 'username')) {
                showError('El usuario solo puede contener letras, números y guiones bajos');
                return;
            }
            
            // Mostrar loading
            showLoading();
            isSubmitting = true;
            
            // Llamar WebMethod usando PageMethods
            PageMethods.ValidateLogin(username, password, onLoginSuccess, onLoginError);
        }

        // Callback de Éxito
        function onLoginSuccess(result) {
            isSubmitting = false;
            hideLoading();
            
            if (result === "SUCCESS") {
                showSuccess('Inicio de Sesión exitoso. Redirigiendo...');
                failedAttempts = 0;
                
                // Redirigir después de 1 segundo
                setTimeout(() => {
                    window.location.href = 'Dashboard.aspx';
                }, 1000);
            } else {
                failedAttempts++;
                // Mostrar el mensaje que viene del stored procedure
                showAttemptsWarning(result || 'Usuario o contraseña incorrectos');
                
                if (failedAttempts >= maxAttempts) {
                    showError('Su cuenta ha sido bloqueada por múltiples intentos fallidos.');
                    document.getElementById('loginBtn').disabled = true;
                }
            }
        }

        // Callback de error
        function onLoginError(error) {
            isSubmitting = false;
            hideLoading();
            showError('Error de conexión. Por favor intente nuevamente.');
            
        }

        // Event listeners
        document.addEventListener('DOMContentLoaded', function() {
            // Validación en tiempo real
            document.getElementById('username').addEventListener('input', function() {
                validateInput(this, 'username');
            });
            
            document.getElementById('password').addEventListener('input', function() {
                validateInput(this, 'password');
            });
            
            // Limpiar mensajes al escribir
            document.getElementById('username').addEventListener('input', function() {
                document.getElementById('errorMessage').style.display = 'none';
                document.getElementById('successMessage').style.display = 'none';
                document.getElementById('attemptsWarning').style.display = 'none';
            });
            
            document.getElementById('password').addEventListener('input', function() {
                document.getElementById('errorMessage').style.display = 'none';
                document.getElementById('successMessage').style.display = 'none';
                document.getElementById('attemptsWarning').style.display = 'none';
            });
            
            // Prevenir copiar/pegar en contraseña
            document.getElementById('password').addEventListener('paste', function(e) {
                e.preventDefault();
                showError('Por razones de seguridad, no se permite pegar en el campo de contraseña');
            });
            
            // Detectar tecla Enter
            document.addEventListener('keypress', function(e) {
                if (e.key === 'Enter' && !isSubmitting) {
                    performLogin();
                }
            });
            
            // Efecto de focus en inputs
            const inputs = document.querySelectorAll('.form-input');
            inputs.forEach(input => {
                input.addEventListener('focus', function() {
                    this.parentElement.style.transform = 'scale(1.02)';
                });
                
                input.addEventListener('blur', function() {
                    this.parentElement.style.transform = 'scale(1)';
                });
            });
        });
    </script>
</body>
</html>



