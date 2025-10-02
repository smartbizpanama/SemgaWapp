/**
 * Sistema de Monitoreo de Inactividad del Usuario - Versión Corregida
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
            let baseUrl = window.location.origin + window.location.pathname.substring(0, window.location.pathname.lastIndexOf('/'));
            if (baseUrl.includes('/Forms/')) {
                // Estamos en una subcarpeta, necesitamos ir hacia atrás
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
        // Remover modal existente si existe
        const existingModal = document.getElementById('inactivityWarningModal');
        if (existingModal) {
            existingModal.remove();
        }
        
        // Crear el HTML del modal
        const modalHtml = `
            <div class="modal fade" id="inactivityWarningModal" tabindex="-1" aria-labelledby="inactivityWarningModalLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false" style="z-index: 9999;">
                <div class="modal-dialog modal-dialog-centered modal-sm">
                    <div class="modal-content shadow-lg border-0" style="border-radius: 12px;">
                        <div class="modal-header border-0 pb-0" style="background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%); border-radius: 12px 12px 0 0;">
                            <h6 class="modal-title text-white fw-normal" id="inactivityWarningModalLabel">
                                <i class="fas fa-clock me-2" style="color: #ecf0f1;"></i>
                                Sesión por Expirar
                            </h6>
                        </div>
                        <div class="modal-body text-center py-4">
                            <div class="mb-3">
                                <div class="d-inline-flex align-items-center justify-content-center rounded-circle mb-3" style="width: 50px; height: 50px; background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);">
                                    <i class="fas fa-exclamation text-white" style="font-size: 18px;"></i>
                                </div>
                                <p class="text-muted mb-2 small">Tu sesión expirará en:</p>
                            </div>
                            <div class="mb-3">
                                <span class="badge bg-danger fs-6 px-3 py-2" id="countdownDisplay" style="font-weight: 500; letter-spacing: 1px;">1:00</span>
                            </div>
                            <p class="text-muted small mb-0">¿Deseas continuar trabajando?</p>
                        </div>
                        <div class="modal-footer border-0 pt-0 justify-content-center">
                            <button type="button" class="btn btn-outline-success btn-sm me-2" id="continueSessionBtn" style="border-radius: 20px; padding: 6px 16px;">
                                <i class="fas fa-check me-1"></i>
                                Continuar
                            </button>
                            <button type="button" class="btn btn-outline-secondary btn-sm" id="logoutBtn" style="border-radius: 20px; padding: 6px 16px;">
                                <i class="fas fa-sign-out-alt me-1"></i>
                                Salir
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        `;
        
        // Agregar el modal al DOM
        document.body.insertAdjacentHTML('beforeend', modalHtml);
        
        // Esperar un momento para que el DOM se actualice
        setTimeout(() => {
            // Mostrar el modal
            const modalElement = document.getElementById('inactivityWarningModal');
            if (modalElement) {
                this.warningModal = new bootstrap.Modal(modalElement, {
                    backdrop: 'static',
                    keyboard: false
                });
                this.warningModal.show();
                
                // Configurar event listeners
                document.getElementById('continueSessionBtn').addEventListener('click', () => {
                    this.continueSession();
                });
                
                document.getElementById('logoutBtn').addEventListener('click', () => {
                    this.logout();
                });
                
                // Prevenir que el modal se cierre cuando el usuario interactúa con él
                modalElement.addEventListener('mousemove', (e) => {
                    e.stopPropagation();
                });
                
                modalElement.addEventListener('click', (e) => {
                    e.stopPropagation();
                });
            }
        }, 100);
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
            window.location.href = this.getLoginUrl();
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
            <div class="toast-container position-fixed top-0 start-50 translate-middle-x p-3" style="z-index: 9999;">
                <div class="toast align-items-center text-white border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true" id="logoutToast" style="background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%); border-radius: 12px;">
                    <div class="d-flex">
                        <div class="toast-body d-flex align-items-center">
                            <i class="fas fa-sign-out-alt me-2"></i>
                            <span>Sesión cerrada por inactividad. Redirigiendo...</span>
                        </div>
                    </div>
                </div>
            </div>
        `;
        
        // Agregar toast al body
        document.body.insertAdjacentHTML('beforeend', toastHtml);
        
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


