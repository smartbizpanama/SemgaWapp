/**
 * Sistema de Monitoreo de Inactividad del Usuario - Versión con Overlay Personalizado
 * Detecta cuando el usuario está inactivo y muestra una alerta antes de cerrar la sesión
 */

class InactivityMonitor {
    constructor() {
        this.isMonitoring = false;
        this.inactivityTimer = null;
        this.warningTimer = null;
        this.warningOverlay = null;
        this.countdownInterval = null;
        this.inactivityTime = 5; // minutos por defecto
        this.warningTime = 1; // minuto de advertencia por defecto
        this.isWarningShown = false;
        
        // Eventos que resetean el timer de inactividad
        this.resetEvents = [
            'mousedown', 'keypress', 'scroll', 'touchstart', 'click'
        ];
        
        this.init();
    }

    /**
     * Inicializa el sistema de monitoreo
     */
    init() {
        
        this.checkMonitoringEnabled();
    }

    /**
     * Verifica si el monitoreo está habilitado desde el servidor
     */
    checkMonitoringEnabled() {
        // Determinar la URL correcta según la página actual
        let webMethodUrl;
        let currentPage = window.location.pathname;
        
        
        
        if (currentPage.includes('GestionSocios.aspx')) {
            webMethodUrl = "GestionSocios.aspx/ObtenerParametrosInactividad";
        } else if (currentPage.includes('Dashboard.aspx')) {
            webMethodUrl = "Dashboard.aspx/ObtenerParametrosInactividad";
        } else {
            // Para otras páginas, construir ruta absoluta al Dashboard
            if (currentPage.includes('/Forms/')) {
                webMethodUrl = "../../Dashboard.aspx/ObtenerParametrosInactividad";
            } else {
                webMethodUrl = "Dashboard.aspx/ObtenerParametrosInactividad";
            }
        }
        
        
        
        $.ajax({
            type: "POST",
            url: webMethodUrl,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: (response) => {
                
                
                if (typeof response.d === 'string') {
                    response.d = JSON.parse(response.d);
                }
                
                if (response.d.Success) {
                    const params = response.d.Data;
                    const isEnabled = params.MONITOREAR_INACTIVIDAD === '1';
                    const timeMinutes = parseInt(params.TIEMPO_MONITOREAR_INACTIVIDAD) || 5;
                    
                    
                    
                    if (isEnabled) {
                        this.inactivityTime = timeMinutes;
                        this.startMonitoring();
                    } else {
                        
                    }
                } else {
                    
                }
            },
            error: (xhr, status, error) => {
                
                
            }
        });
    }

    /**
     * Inicia el monitoreo de inactividad
     */
    startMonitoring() {
        if (this.isMonitoring) return;
        
        this.isMonitoring = true;
        `);
        
        // Agregar event listeners para resetear el timer
        this.resetEvents.forEach(event => {
            document.addEventListener(event, () => this.resetInactivityTimer(), true);
        });
        
        // Iniciar el timer
        this.resetInactivityTimer();
    }

    /**
     * Detiene el monitoreo de inactividad
     */
    stopMonitoring() {
        if (!this.isMonitoring) return;
        
        this.isMonitoring = false;
        
        
        // Limpiar timers
        if (this.inactivityTimer) {
            clearTimeout(this.inactivityTimer);
            this.inactivityTimer = null;
        }
        
        if (this.warningTimer) {
            clearTimeout(this.warningTimer);
            this.warningTimer = null;
        }
        
        if (this.countdownInterval) {
            clearInterval(this.countdownInterval);
            this.countdownInterval = null;
        }
        
        // Remover event listeners
        this.resetEvents.forEach(event => {
            document.removeEventListener(event, () => this.resetInactivityTimer(), true);
        });
        
        // Cerrar overlay de advertencia si está abierto
        this.closeWarningOverlay();
    }

    /**
     * Resetea el timer de inactividad
     */
    resetInactivityTimer() {
        if (!this.isMonitoring) return;
        
        // Limpiar timers existentes
        if (this.inactivityTimer) {
            clearTimeout(this.inactivityTimer);
        }
        
        if (this.warningTimer) {
            clearTimeout(this.warningTimer);
        }
        
        if (this.countdownInterval) {
            clearInterval(this.countdownInterval);
        }
        
        // Cerrar overlay de advertencia si está abierto
        this.closeWarningOverlay();
        this.isWarningShown = false;
        
        // Configurar nuevo timer de advertencia (1 minuto antes del timeout)
        const warningTimeMs = (this.inactivityTime - 1) * 60 * 1000;
        this.warningTimer = setTimeout(() => {
            this.showInactivityWarning();
        }, warningTimeMs);
        
        // Configurar timer de cierre de sesión
        const inactivityTimeMs = this.inactivityTime * 60 * 1000;
        this.inactivityTimer = setTimeout(() => {
            this.closeSession();
        }, inactivityTimeMs);
        
        `);
    }

    /**
     * Muestra la advertencia de inactividad
     */
    showInactivityWarning() {
        if (this.isWarningShown) return;
        
        this.isWarningShown = true;
        
        
        this.createWarningOverlay();
        this.startCountdown();
    }

    /**
     * Crea el overlay de advertencia
     */
    createWarningOverlay() {
        // Remover overlay existente si existe
        this.closeWarningOverlay();
        
        // Crear el HTML del overlay
        const overlayHtml = `
            <div id="inactivityWarningOverlay" style="
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                z-index: 9999;
                display: flex;
                align-items: center;
                justify-content: center;
                backdrop-filter: blur(3px);
            ">
                <div style="
                    background: white;
                    border-radius: 12px;
                    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
                    max-width: 400px;
                    width: 90%;
                    overflow: hidden;
                ">
                    <!-- Header -->
                    <div style="
                        background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
                        color: white;
                        padding: 15px 20px;
                        border-radius: 12px 12px 0 0;
                    ">
                        <h6 style="margin: 0; font-weight: 500; display: flex; align-items: center;">
                            <i class="fas fa-clock" style="margin-right: 8px; color: #ecf0f1;"></i>
                            Sesión por Expirar
                        </h6>
                    </div>
                    
                    <!-- Body -->
                    <div style="padding: 20px; text-align: center;">
                        <div style="margin-bottom: 15px;">
                            <div style="
                                display: inline-flex;
                                align-items: center;
                                justify-content: center;
                                width: 50px;
                                height: 50px;
                                background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
                                border-radius: 50%;
                                margin-bottom: 15px;
                            ">
                                <i class="fas fa-exclamation" style="color: white; font-size: 18px;"></i>
                            </div>
                            <p style="color: #666; margin: 0 0 10px 0; font-size: 14px;">Tu sesión expirará en:</p>
                        </div>
                        
                        <div style="margin-bottom: 15px;">
                            <span id="countdownDisplay" style="
                                background: #dc3545;
                                color: white;
                                padding: 8px 16px;
                                border-radius: 20px;
                                font-size: 18px;
                                font-weight: 500;
                                letter-spacing: 1px;
                            ">1:00</span>
                        </div>
                        
                        <p style="color: #666; margin: 0; font-size: 14px;">¿Deseas continuar trabajando?</p>
                    </div>
                    
                    <!-- Footer -->
                    <div style="
                        padding: 15px 20px;
                        border-top: 1px solid #eee;
                        display: flex;
                        justify-content: center;
                        gap: 10px;
                    ">
                        <button id="continueSessionBtn" style="
                            background: transparent;
                            border: 2px solid #28a745;
                            color: #28a745;
                            padding: 8px 16px;
                            border-radius: 20px;
                            font-size: 14px;
                            cursor: pointer;
                            transition: all 0.3s ease;
                            display: flex;
                            align-items: center;
                            gap: 5px;
                        " onmouseover="this.style.background='#28a745'; this.style.color='white';" onmouseout="this.style.background='transparent'; this.style.color='#28a745';">
                            <i class="fas fa-check"></i>
                            Continuar
                        </button>
                        <button id="logoutBtn" style="
                            background: transparent;
                            border: 2px solid #6c757d;
                            color: #6c757d;
                            padding: 8px 16px;
                            border-radius: 20px;
                            font-size: 14px;
                            cursor: pointer;
                            transition: all 0.3s ease;
                            display: flex;
                            align-items: center;
                            gap: 5px;
                        " onmouseover="this.style.background='#6c757d'; this.style.color='white';" onmouseout="this.style.background='transparent'; this.style.color='#6c757d';">
                            <i class="fas fa-sign-out-alt"></i>
                            Salir
                        </button>
                    </div>
                </div>
            </div>
        `;
        
        // Agregar el overlay al DOM
        document.body.insertAdjacentHTML('beforeend', overlayHtml);
        
        // Configurar event listeners
        document.getElementById('continueSessionBtn').addEventListener('click', () => {
            this.continueSession();
        });
        
        document.getElementById('logoutBtn').addEventListener('click', () => {
            this.logout();
        });
        
        // Prevenir que el overlay se cierre cuando el usuario interactúa con él
        const overlayElement = document.getElementById('inactivityWarningOverlay');
        if (overlayElement) {
            overlayElement.addEventListener('mousemove', (e) => {
                e.stopPropagation();
            });
            
            overlayElement.addEventListener('click', (e) => {
                e.stopPropagation();
            });
        }
    }

    /**
     * Inicia el countdown de 1 minuto
     */
    startCountdown() {
        let secondsLeft = 60; // 1 minuto
        
        this.countdownInterval = setInterval(() => {
            const minutes = Math.floor(secondsLeft / 60);
            const seconds = secondsLeft % 60;
            const display = `${minutes}:${seconds.toString().padStart(2, '0')}`;
            
            const countdownElement = document.getElementById('countdownDisplay');
            if (countdownElement) {
                countdownElement.textContent = display;
            }
            
            secondsLeft--;
            
            if (secondsLeft < 0) {
                clearInterval(this.countdownInterval);
                this.closeSession();
            }
        }, 1000);
    }

    /**
     * Continúa la sesión (usuario hizo clic en continuar)
     */
    continueSession() {
        
        this.closeWarningOverlay();
        this.resetInactivityTimer();
    }

    /**
     * Cierra la sesión (usuario hizo clic en cerrar sesión o se agotó el tiempo)
     */
    logout() {
        
        this.closeWarningOverlay();
        this.stopMonitoring();
        
        // Mostrar mensaje de cierre de sesión
        this.showLogoutMessage();
        
        // Redirigir al login después de un breve delay
        setTimeout(() => {
            window.location.href = this.getLoginUrl();
        }, 2000);
    }

    /**
     * Cierra la sesión automáticamente
     */
    closeSession() {
        
        this.closeWarningOverlay();
        this.stopMonitoring();
        
        // Determinar la URL correcta para cerrar sesión
        let closeSessionUrl;
        let currentPage = window.location.pathname;
        
        if (currentPage.includes('GestionSocios.aspx')) {
            closeSessionUrl = "GestionSocios.aspx/CerrarSesionPorInactividad";
        } else if (currentPage.includes('Dashboard.aspx')) {
            closeSessionUrl = "Dashboard.aspx/CerrarSesionPorInactividad";
        } else {
            if (currentPage.includes('/Forms/')) {
                closeSessionUrl = "../../Dashboard.aspx/CerrarSesionPorInactividad";
            } else {
                closeSessionUrl = "Dashboard.aspx/CerrarSesionPorInactividad";
            }
        }
        
        // Llamar al WebMethod para cerrar la sesión
        $.ajax({
            type: "POST",
            url: closeSessionUrl,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: (response) => {
                
            },
            error: (xhr, status, error) => {
                
            }
        });
        
        // Mostrar mensaje y redirigir
        this.showLogoutMessage();
        setTimeout(() => {
            window.location.href = this.getLoginUrl();
        }, 2000);
    }

    /**
     * Obtiene la URL del login según la página actual
     */
    getLoginUrl() {
        let currentPage = window.location.pathname;
        if (currentPage.includes('/Forms/')) {
            return '../../Login.aspx';
        } else {
            return 'Login.aspx';
        }
    }

    /**
     * Cierra el overlay de advertencia
     */
    closeWarningOverlay() {
        if (this.countdownInterval) {
            clearInterval(this.countdownInterval);
            this.countdownInterval = null;
        }
        
        // Remover el overlay del DOM
        const overlayElement = document.getElementById('inactivityWarningOverlay');
        if (overlayElement) {
            overlayElement.remove();
        }
    }

    /**
     * Muestra mensaje de cierre de sesión
     */
    showLogoutMessage() {
        // Crear toast de notificación
        const toastHtml = `
            <div style="
                position: fixed;
                top: 20px;
                left: 50%;
                transform: translateX(-50%);
                z-index: 10000;
                background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
                color: white;
                padding: 12px 20px;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 14px;
            " id="logoutToast">
                <i class="fas fa-sign-out-alt"></i>
                <span>Sesión cerrada por inactividad. Redirigiendo...</span>
            </div>
        `;
        
        // Agregar toast al body
        document.body.insertAdjacentHTML('beforeend', toastHtml);
        
        // Remover el toast después de 3 segundos
        setTimeout(() => {
            const toastElement = document.getElementById('logoutToast');
            if (toastElement) {
                toastElement.remove();
            }
        }, 3000);
    }
}

// Inicializar el sistema cuando el DOM esté listo
$(document).ready(function() {
    // Solo inicializar si no estamos en la página de login
    if (!window.location.pathname.includes('Login.aspx')) {
        ...');
        window.inactivityMonitor = new InactivityMonitor();
    }
});







