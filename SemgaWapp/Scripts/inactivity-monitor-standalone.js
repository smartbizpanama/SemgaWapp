/**
 * Sistema de Monitoreo de Inactividad del Usuario - Versión Standalone
 * No depende de Bootstrap ni jQuery - CSS puro y JavaScript vanilla
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
        
        // Eventos que resetean el timer de inactividad (SIN mousemove)
        this.resetEvents = [
            'mousedown', 'keypress', 'scroll', 'touchstart', 'click'
        ];
        
        this.init();
    }

    /**
     * Inicializa el sistema de monitoreo
     */
    init() {
        ...');
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
            if (currentPage.includes('/Forms/')) {
                webMethodUrl = "../../Dashboard.aspx/ObtenerParametrosInactividad";
            } else {
                webMethodUrl = "Dashboard.aspx/ObtenerParametrosInactividad";
            }
        }
        
        
        
        // Usar fetch en lugar de jQuery
        fetch(webMethodUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=utf-8'
            },
            body: JSON.stringify({})
        })
        .then(response => response.json())
        .then(data => {
            
            
            let responseData = data.d;
            if (typeof responseData === 'string') {
                responseData = JSON.parse(responseData);
            }
            
            if (responseData.Success) {
                const params = responseData.Data;
                const isEnabled = params.MONITOREAR_INACTIVIDAD === '1';
                const timeMinutes = parseInt(params.TIEMPO_MONITOREAR_INACTIVIDAD) || 5;
                
                
                
                if (isEnabled) {
                    this.inactivityTime = timeMinutes;
                    this.startMonitoring();
                } else {
                    
                }
            } else {
                
            }
        })
        .catch(error => {
            
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
                position: fixed !important;
                top: 0 !important;
                left: 0 !important;
                width: 100vw !important;
                height: 100vh !important;
                background: rgba(0, 0, 0, 0.7) !important;
                z-index: 99999 !important;
                display: flex !important;
                align-items: center !important;
                justify-content: center !important;
                backdrop-filter: blur(5px) !important;
                -webkit-backdrop-filter: blur(5px) !important;
            ">
                <div style="
                    background: white !important;
                    border-radius: 15px !important;
                    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4) !important;
                    max-width: 450px !important;
                    width: 90% !important;
                    overflow: hidden !important;
                    position: relative !important;
                ">
                    <!-- Header -->
                    <div style="
                        background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%) !important;
                        color: white !important;
                        padding: 20px !important;
                        border-radius: 15px 15px 0 0 !important;
                    ">
                        <h5 style="margin: 0 !important; font-weight: 500 !important; display: flex !important; align-items: center !important; font-size: 18px !important;">
                            <i class="fas fa-clock" style="margin-right: 10px !important; color: #ecf0f1 !important;"></i>
                            Sesión por Expirar
                        </h5>
                    </div>
                    
                    <!-- Body -->
                    <div style="padding: 25px !important; text-align: center !important;">
                        <div style="margin-bottom: 20px !important;">
                            <div style="
                                display: inline-flex !important;
                                align-items: center !important;
                                justify-content: center !important;
                                width: 60px !important;
                                height: 60px !important;
                                background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%) !important;
                                border-radius: 50% !important;
                                margin-bottom: 20px !important;
                            ">
                                <i class="fas fa-exclamation" style="color: white !important; font-size: 24px !important;"></i>
                            </div>
                            <p style="color: #666 !important; margin: 0 0 15px 0 !important; font-size: 16px !important; font-weight: 500 !important;">Tu sesión expirará en:</p>
                        </div>
                        
                        <div style="margin-bottom: 20px !important;">
                            <span id="countdownDisplay" style="
                                background: #dc3545 !important;
                                color: white !important;
                                padding: 12px 24px !important;
                                border-radius: 25px !important;
                                font-size: 24px !important;
                                font-weight: 600 !important;
                                letter-spacing: 2px !important;
                                display: inline-block !important;
                            ">1:00</span>
                        </div>
                        
                        <p style="color: #666 !important; margin: 0 !important; font-size: 15px !important;">¿Deseas continuar trabajando?</p>
                    </div>
                    
                    <!-- Footer -->
                    <div style="
                        padding: 20px 25px !important;
                        border-top: 1px solid #eee !important;
                        display: flex !important;
                        justify-content: center !important;
                        gap: 15px !important;
                        background: #f8f9fa !important;
                    ">
                        <button id="continueSessionBtn" style="
                            background: #28a745 !important;
                            border: none !important;
                            color: white !important;
                            padding: 12px 24px !important;
                            border-radius: 25px !important;
                            font-size: 14px !important;
                            font-weight: 500 !important;
                            cursor: pointer !important;
                            transition: all 0.3s ease !important;
                            display: flex !important;
                            align-items: center !important;
                            gap: 8px !important;
                            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3) !important;
                        " onmouseover="this.style.background='#218838' !important; this.style.transform='translateY(-2px)' !important;" onmouseout="this.style.background='#28a745' !important; this.style.transform='translateY(0)' !important;">
                            <i class="fas fa-check"></i>
                            Continuar
                        </button>
                        <button id="logoutBtn" style="
                            background: #6c757d !important;
                            border: none !important;
                            color: white !important;
                            padding: 12px 24px !important;
                            border-radius: 25px !important;
                            font-size: 14px !important;
                            font-weight: 500 !important;
                            cursor: pointer !important;
                            transition: all 0.3s ease !important;
                            display: flex !important;
                            align-items: center !important;
                            gap: 8px !important;
                            box-shadow: 0 4px 12px rgba(108, 117, 125, 0.3) !important;
                        " onmouseover="this.style.background='#5a6268' !important; this.style.transform='translateY(-2px)' !important;" onmouseout="this.style.background='#6c757d' !important; this.style.transform='translateY(0)' !important;">
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
        document.getElementById('continueSessionBtn').addEventListener('click', (e) => {
            e.preventDefault();
            e.stopPropagation();
            this.continueSession();
        });
        
        document.getElementById('logoutBtn').addEventListener('click', (e) => {
            e.preventDefault();
            e.stopPropagation();
            this.logout();
        });
        
        // Prevenir que el overlay se cierre cuando el usuario interactúa con él
        const overlayElement = document.getElementById('inactivityWarningOverlay');
        if (overlayElement) {
            overlayElement.addEventListener('mousemove', (e) => {
                e.preventDefault();
                e.stopPropagation();
            });
            
            overlayElement.addEventListener('click', (e) => {
                e.preventDefault();
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
        fetch(closeSessionUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=utf-8'
            },
            body: JSON.stringify({})
        })
        .then(response => response.json())
        .then(data => {
            
        })
        .catch(error => {
            
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
                position: fixed !important;
                top: 20px !important;
                left: 50% !important;
                transform: translateX(-50%) !important;
                z-index: 100000 !important;
                background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%) !important;
                color: white !important;
                padding: 15px 25px !important;
                border-radius: 10px !important;
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.4) !important;
                display: flex !important;
                align-items: center !important;
                gap: 10px !important;
                font-size: 15px !important;
                font-weight: 500 !important;
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
document.addEventListener('DOMContentLoaded', function() {
    // Solo inicializar si no estamos en la página de login
    if (!window.location.pathname.includes('Login.aspx')) {
        ...');
        window.inactivityMonitor = new InactivityMonitor();
    }
});







