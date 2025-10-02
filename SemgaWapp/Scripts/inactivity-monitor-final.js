/**
 * Sistema de Monitoreo de Inactividad - Versión Final
 * Monitorea la inactividad del usuario y muestra alerta antes de cerrar sesión
 * v=2.6 - Parámetros cargados una sola vez al inicio
 */


// Variables globales
let inactivityTimer = null;
let warningTimer = null;
let countdownInterval = null;
let isWarningActive = false;
let isRequestInProgress = false;

// Parámetros de inactividad cargados una sola vez
let inactivityParams = {
    monitorear: false,
    timeMinutes: 5
};
let paramsLoaded = false;

// Función para crear el overlay de advertencia
function createInactivityOverlay() {
    
    // Remover overlay existente
    const existingOverlay = document.getElementById('inactivityOverlay');
    if (existingOverlay) {
        existingOverlay.remove();
    }
    
    // Crear overlay
    const overlay = document.createElement('div');
    overlay.id = 'inactivityOverlay';
    overlay.style.cssText = `
        position: fixed !important;
        top: 0 !important;
        left: 0 !important;
        width: 100% !important;
        height: 100% !important;
        background: rgba(0, 0, 0, 0.5) !important;
        z-index: 99999 !important;
        display: flex !important;
        align-items: center !important;
        justify-content: center !important;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif !important;
    `;
    
    // Crear modal
    const modal = document.createElement('div');
    modal.style.cssText = `
        background: white !important;
        border-radius: 12px !important;
        padding: 30px !important;
        text-align: center !important;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3) !important;
        max-width: 400px !important;
        width: 90% !important;
        border: 1px solid #e9ecef !important;
    `;
    
    modal.innerHTML = `
        <div style="margin-bottom: 20px;">
            <div style="
                width: 80px;
                height: 80px;
                background: linear-gradient(135deg, #4a90e2 0%, #357abd 100%);
                border-radius: 50%;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 20px;
                box-shadow: 0 6px 20px rgba(74, 144, 226, 0.3);
                border: 3px solid #2c5aa0;
            ">
                <i class="fas fa-clock" style="color: white; font-size: 32px;"></i>
            </div>
            <h3 style="color: #2c3e50; margin: 0 0 15px 0; font-weight: 600; font-size: 24px;">¡Tu sesión está a punto de expirar!</h3>
            <p style="color: #5a6c7d; margin: 0 0 25px 0; font-size: 16px; line-height: 1.5;">He detectado inactividad por más tiempo del establecido. Tu sesión terminará en:</p>
        </div>
        
        <div style="margin-bottom: 30px;">
            <div style="
                background: transparent;
                color: #4a90e2;
                padding: 20px 30px;
                border-radius: 15px;
                font-size: 36px;
                font-weight: 700;
                letter-spacing: 3px;
                display: inline-flex;
                align-items: center;
                gap: 12px;
            ">
                <i class="fas fa-stopwatch" style="font-size: 28px; color: #4a90e2;"></i>
                <span id="inactivityCountdown">1:00</span>
            </div>
        </div>
        
        <div style="display: flex; gap: 20px; justify-content: center;">
            <button id="logoutBtn" style="
                background: white;
                color: #4a90e2;
                border: 2px solid #4a90e2;
                padding: 14px 28px;
                border-radius: 12px;
                font-size: 15px;
                font-weight: 600;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 8px;
                box-shadow: 0 4px 12px rgba(74, 144, 226, 0.2);
                transition: all 0.3s ease;
            " onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 6px 16px rgba(74, 144, 226, 0.3)'; this.style.background='#f8f9fa';" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 4px 12px rgba(74, 144, 226, 0.2)'; this.style.background='white';">
                <i class="fas fa-sign-out-alt"></i>
                Cerrar Sesión
            </button>
            <button id="continueBtn" style="
                background: linear-gradient(135deg, #4a90e2 0%, #357abd 100%);
                color: white;
                border: 2px solid #2c5aa0;
                padding: 14px 28px;
                border-radius: 12px;
                font-size: 15px;
                font-weight: 600;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 8px;
                box-shadow: 0 4px 12px rgba(74, 144, 226, 0.3);
                transition: all 0.3s ease;
            " onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 6px 16px rgba(74, 144, 226, 0.4)'; this.style.background='linear-gradient(135deg, #357abd 0%, #2c5aa0 100%)';" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 4px 12px rgba(74, 144, 226, 0.3)'; this.style.background='linear-gradient(135deg, #4a90e2 0%, #357abd 100%)';">
                <i class="fas fa-check"></i>
                Seguir Conectado
            </button>
        </div>
    `;
    
    overlay.appendChild(modal);
    document.body.appendChild(overlay);
    
    // Configurar eventos
    setupInactivityEvents();
    
    return overlay;
}

// Función para configurar eventos del modal
function setupInactivityEvents() {
    const continueBtn = document.getElementById('continueBtn');
    const logoutBtn = document.getElementById('logoutBtn');
    
    if (continueBtn) {
        continueBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            continueSession();
        });
    }
    
    if (logoutBtn) {
        logoutBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            closeSession();
        });
    }
    
    // Prevenir que el modal se cierre al hacer clic fuera
    const overlay = document.getElementById('inactivityOverlay');
    if (overlay) {
        overlay.addEventListener('click', function(e) {
            e.stopPropagation();
        });
    }
}

// Función para continuar la sesión
function continueSession() {
    
    // Detener el countdown del modal si está ejecutándose
    if (countdownInterval) {
        clearInterval(countdownInterval);
        countdownInterval = null;
    }
    
    // Remover overlay
    const overlay = document.getElementById('inactivityOverlay');
    if (overlay) {
        overlay.remove();
    }
    
    // Limpiar todos los timers existentes
    if (inactivityTimer) {
        clearTimeout(inactivityTimer);
        inactivityTimer = null;
    }
    if (warningTimer) {
        clearTimeout(warningTimer);
        warningTimer = null;
    }
    
    isWarningActive = false;
    
    // Reiniciar monitoreo usando parámetros ya cargados
    if (inactivityParams.monitorear) {
        startInactivityMonitoring(inactivityParams.timeMinutes);
    }
}

// Función para cerrar sesión
function closeSession() {
    
    // Llamar WebMethod para cerrar sesión
    // Determinar la ruta correcta según la ubicación actual
    var url = '';
    if (window.location.pathname.includes('/Forms/Auxiliares/')) {
        url = window.location.origin + '/Dashboard.aspx/CerrarSesionPorInactividad';
    } else if (window.location.pathname.includes('/Forms/Socios/')) {
        url = window.location.origin + '/Dashboard.aspx/CerrarSesionPorInactividad';
    } else if (window.location.pathname.includes('/Forms/Transacciones/')) {
        url = window.location.origin + '/Dashboard.aspx/CerrarSesionPorInactividad';
    } else {
        url = window.location.origin + '/Dashboard.aspx/CerrarSesionPorInactividad';
    }
    
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=utf-8'
        }
    })
    .then(response => response.json())
    .then(data => {
        // Redirigir al login
        // Redirigir al login con la ruta correcta
        var loginPath = '';
        if (window.location.pathname.includes('/Forms/Auxiliares/')) {
            loginPath = '../../Login.aspx';
        } else if (window.location.pathname.includes('/Forms/Socios/')) {
            loginPath = '../Login.aspx';
        } else {
            loginPath = 'Login.aspx';
        }
        window.location.href = loginPath;
    })
    .catch(error => {
        // Redirigir al login de todas formas
        // Redirigir al login con la ruta correcta
        var loginPath = '';
        if (window.location.pathname.includes('/Forms/Auxiliares/')) {
            loginPath = '../../Login.aspx';
        } else if (window.location.pathname.includes('/Forms/Socios/')) {
            loginPath = '../Login.aspx';
        } else {
            loginPath = 'Login.aspx';
        }
        window.location.href = loginPath;
    });
}

// Función para cargar parámetros de inactividad una sola vez
function loadInactivityParams() {
    if (paramsLoaded) {
        return;
    }
    
    // Hacer petición para obtener parámetros de la sesión del servidor
    var url = '';
    if (window.location.pathname.includes('/Forms/Auxiliares/')) {
        url = window.location.origin + '/Dashboard.aspx/ObtenerParametrosInactividadSesion';
    } else if (window.location.pathname.includes('/Forms/Socios/')) {
        url = window.location.origin + '/Dashboard.aspx/ObtenerParametrosInactividadSesion';
    } else if (window.location.pathname.includes('/Forms/Transacciones/')) {
        url = window.location.origin + '/Dashboard.aspx/ObtenerParametrosInactividadSesion';
    } else {
        url = window.location.origin + '/Dashboard.aspx/ObtenerParametrosInactividadSesion';
    }
    
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=utf-8'
        }
    })
    .then(response => response.json())
    .then(data => {
        if (!data || !data.d) {
            paramsLoaded = true;
            return;
        }
        
        if (typeof data.d === 'string') {
            try {
                data.d = JSON.parse(data.d);
            } catch (e) {
                paramsLoaded = true;
                return;
            }
        }
        
        // Manejar estructura anidada doble (.d.d)
        let responseData = data.d;
        if (responseData.d) {
            responseData = responseData.d;
        }
        
        if (responseData && responseData.Success) {
            const params = responseData.Data;
            if (params) {
                inactivityParams.monitorear = params.MONITOREAR_INACTIVIDAD === '1';
                inactivityParams.timeMinutes = parseInt(params.TIEMPO_MONITOREAR_INACTIVIDAD) || 5;
            }
        }
        
        paramsLoaded = true;
        
        // Iniciar monitoreo si está habilitado
        if (inactivityParams.monitorear) {
            startInactivityMonitoring(inactivityParams.timeMinutes);
        }
    })
    .catch(error => {
        paramsLoaded = true;
    });
}

// Función para iniciar el monitoreo de inactividad
function startInactivityMonitoring(timeMinutes) {
    
    // Limpiar timers existentes
    if (inactivityTimer) {
        clearTimeout(inactivityTimer);
        inactivityTimer = null;
    }
    if (warningTimer) {
        clearTimeout(warningTimer);
        warningTimer = null;
    }
    
    // Calcular tiempo de advertencia (1 minuto antes del timeout)
    const warningTimeSeconds = Math.max((timeMinutes - 1) * 60, 10);
    
    // Configurar timer para mostrar advertencia
    inactivityTimer = setTimeout(() => {
        if (!isWarningActive) {
            showInactivityWarning();
        }
    }, warningTimeSeconds * 1000);
    
    // Configurar eventos que resetean el timer
    resetInactivityEvents();
}

// Función para mostrar advertencia de inactividad
function showInactivityWarning() {
    isWarningActive = true;
    createInactivityOverlay();
    
    // Limpiar countdown anterior si existe
    if (countdownInterval) {
        clearInterval(countdownInterval);
        countdownInterval = null;
    }
    
    // Iniciar countdown de 1 minuto
    let countdownSeconds = 60;
    const countdownElement = document.getElementById('inactivityCountdown');
    
    countdownInterval = setInterval(() => {
        const minutes = Math.floor(countdownSeconds / 60);
        const seconds = countdownSeconds % 60;
        const timeString = `${minutes}:${seconds.toString().padStart(2, '0')}`;
        
        if (countdownElement) {
            countdownElement.textContent = timeString;
        }
        
        countdownSeconds--;
        
        if (countdownSeconds < 0) {
            clearInterval(countdownInterval);
            countdownInterval = null;
            closeSession();
        }
    }, 1000);
}

// Función para reiniciar el timer de inactividad
function resetInactivityTimer() {
    // Solo reiniciar si el monitoreo está habilitado y no hay advertencia activa
    if (inactivityParams.monitorear && !isWarningActive) {
        startInactivityMonitoring(inactivityParams.timeMinutes);
    }
}

// Función para configurar eventos que resetean el timer
function resetInactivityEvents() {
    const events = ['mousedown', 'mousemove', 'keypress', 'scroll', 'touchstart', 'click'];
    let lastActivityTime = Date.now();
    const debounceDelay = 2000; // 2 segundos de debounce para evitar spam
    
    events.forEach(event => {
        document.addEventListener(event, function() {
            if (!isWarningActive && !isRequestInProgress) {
                const now = Date.now();
                // Solo reiniciar si han pasado al menos 2 segundos desde la última actividad
                if (now - lastActivityTime > debounceDelay) {
                    lastActivityTime = now;
                    resetInactivityTimer();
                }
            }
        }, true);
    });
}

// Función para inicializar el monitoreo de inactividad
function initializeInactivityMonitoring() {
    // Esperar un poco para que la página se cargue completamente
    setTimeout(() => {
        loadInactivityParams();
    }, 1000);
}

// Inicializar cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', function() {
    initializeInactivityMonitoring();
});



