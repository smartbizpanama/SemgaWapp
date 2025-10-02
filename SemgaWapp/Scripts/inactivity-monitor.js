/**
 * Sistema de Monitoreo de Inactividad del Usuario
 * Detecta cuando el usuario está inactivo y muestra una alerta antes de cerrar la sesión
 */

class InactivityMonitor {
    constructor() {
        this.isMonitoring = false;
        this.inactivityTimer = null;
        this.warningTimer = null;
        this.warningModal = null;
        this.warningCountdown = null;
        this.countdownInterval = null;
        this.inactivityTime = 5; // minutos por defecto
        this.warningTime = 1; // minuto de advertencia por defecto
        this.isWarningShown = false;
        
        // Eventos que resetean el timer de inactividad
        this.resetEvents = [
            'mousedown', 'mousemove', 'keypress', 'scroll', 'touchstart', 'click'
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
        if (window.location.pathname.includes('GestionSocios.aspx')) {
            webMethodUrl = "GestionSocios.aspx/ObtenerParametrosInactividad";
        } else if (window.location.pathname.includes('Dashboard.aspx')) {
            webMethodUrl = "Dashboard.aspx/ObtenerParametrosInactividad";
        } else {
            // URL por defecto para otras páginas - usar ruta absoluta
            webMethodUrl = "/Dashboard.aspx/ObtenerParametrosInactividad";
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
        
        // Cerrar modal de advertencia si está abierto
        this.closeWarningModal();
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
        
        // Cerrar modal de advertencia si está abierto
        this.closeWarningModal();
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
        
        
        this.createWarningModal();
        this.startCountdown();
    }

    /**
     * Crea el modal de advertencia
     */
    createWarningModal() {
        // Crear el HTML del modal
        const modalHtml = `
            <div class="modal fade" id="inactivityWarningModal" tabindex="-1" aria-labelledby="inactivityWarningModalLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content border-warning">
                        <div class="modal-header bg-warning text-dark">
                            <h5 class="modal-title" id="inactivityWarningModalLabel">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                Sesión por Expirar
                            </h5>
                        </div>
                        <div class="modal-body text-center">
                            <div class="mb-3">
                                <i class="fas fa-clock fa-3x text-warning mb-3"></i>
                                <h6>Tu sesión está a punto de expirar por inactividad</h6>
                                <p class="text-muted mb-0">La sesión se cerrará automáticamente en:</p>
                            </div>
                            <div class="alert alert-warning">
                                <h4 class="mb-0" id="countdownDisplay">1:00</h4>
                            </div>
                            <p class="small text-muted">Haz clic en "Continuar" para mantener tu sesión activa</p>
                        </div>
                        <div class="modal-footer justify-content-center">
                            <button type="button" class="btn btn-success" id="continueSessionBtn">
                                <i class="fas fa-check me-2"></i>
                                Continuar Sesión
                            </button>
                            <button type="button" class="btn btn-secondary" id="logoutBtn">
                                <i class="fas fa-sign-out-alt me-2"></i>
                                Cerrar Sesión
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        `;
        
        // Agregar el modal al DOM si no existe
        if (!document.getElementById('inactivityWarningModal')) {
            document.body.insertAdjacentHTML('beforeend', modalHtml);
        }
        
        // Mostrar el modal
        this.warningModal = new bootstrap.Modal(document.getElementById('inactivityWarningModal'));
        this.warningModal.show();
        
        // Configurar event listeners
        document.getElementById('continueSessionBtn').addEventListener('click', () => {
            this.continueSession();
        });
        
        document.getElementById('logoutBtn').addEventListener('click', () => {
            this.logout();
        });
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
        
        this.closeWarningModal();
        this.resetInactivityTimer();
    }

    /**
     * Cierra la sesión (usuario hizo clic en cerrar sesión o se agotó el tiempo)
     */
    logout() {
        
        this.closeWarningModal();
        this.stopMonitoring();
        
        // Mostrar mensaje de cierre de sesión
        this.showLogoutMessage();
        
        // Redirigir al login después de un breve delay
        setTimeout(() => {
            window.location.href = 'Login.aspx';
        }, 2000);
    }

    /**
     * Cierra la sesión automáticamente
     */
    closeSession() {
        
        this.closeWarningModal();
        this.stopMonitoring();
        
        // Determinar la URL correcta para cerrar sesión
        let closeSessionUrl;
        if (window.location.pathname.includes('GestionSocios.aspx')) {
            closeSessionUrl = "GestionSocios.aspx/CerrarSesionPorInactividad";
        } else if (window.location.pathname.includes('Dashboard.aspx')) {
            closeSessionUrl = "Dashboard.aspx/CerrarSesionPorInactividad";
        } else {
            closeSessionUrl = "/Dashboard.aspx/CerrarSesionPorInactividad";
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
            window.location.href = 'Login.aspx';
        }, 2000);
    }

    /**
     * Cierra el modal de advertencia
     */
    closeWarningModal() {
        if (this.warningModal) {
            this.warningModal.hide();
            this.warningModal = null;
        }
        
        if (this.countdownInterval) {
            clearInterval(this.countdownInterval);
            this.countdownInterval = null;
        }
        
        // Remover el modal del DOM
        const modalElement = document.getElementById('inactivityWarningModal');
        if (modalElement) {
            modalElement.remove();
        }
    }

    /**
     * Muestra mensaje de cierre de sesión
     */
    showLogoutMessage() {
        // Crear toast de notificación
        const toastHtml = `
            <div class="toast align-items-center text-white bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true" id="logoutToast">
                <div class="d-flex">
                    <div class="toast-body">
                        <i class="fas fa-sign-out-alt me-2"></i>
                        Sesión cerrada por inactividad. Redirigiendo al login...
                    </div>
                </div>
            </div>
        `;
        
        // Agregar toast al contenedor
        const toastContainer = document.querySelector('.toast-container') || document.body;
        toastContainer.insertAdjacentHTML('beforeend', toastHtml);
        
        // Mostrar toast
        const toastElement = document.getElementById('logoutToast');
        const toast = new bootstrap.Toast(toastElement, {
            autohide: false
        });
        toast.show();
    }
}

// Inicializar el sistema cuando el DOM esté listo
$(document).ready(function() {
    // Solo inicializar si no estamos en la página de login
    if (!window.location.pathname.includes('Login.aspx')) {
        window.inactivityMonitor = new InactivityMonitor();
    }
});


