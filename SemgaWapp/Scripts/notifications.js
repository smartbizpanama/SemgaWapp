/**
 * Sistema de Notificaciones Toast Global
 * Funciones para mostrar notificaciones y confirmaciones usando Bootstrap 5
 */

/**
 * Muestra una notificación toast
 * @param {string} type - Tipo de toast: 'success', 'error', 'warning', 'info'
 * @param {string} title - Título del toast
 * @param {string} message - Mensaje del toast
 * @param {number} duration - Duración en milisegundos (default: 4000)
 */
function showToast(type, title, message, duration = 4000) {
    // Obtener o crear el contenedor de toasts
    let toastContainer = document.getElementById('toastContainer');
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.id = 'toastContainer';
        toastContainer.className = 'toast-container position-fixed top-0 end-0 p-3';
        toastContainer.style.zIndex = '1060';
        document.body.appendChild(toastContainer);
    }

    const toastId = 'toast-' + Date.now();
    const iconClass = getToastIcon(type);
    const toastClass = 'toast-' + type;
    
    const toastHtml = `
        <div class="toast ${toastClass}" id="${toastId}" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="toast-header">
                <i class="${iconClass} me-2"></i>
                <strong class="me-auto">${title}</strong>
                <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body">
                ${message}
            </div>
        </div>
    `;
    
    $(toastContainer).append(toastHtml);
    
    const toastElement = new bootstrap.Toast(document.getElementById(toastId), {
        delay: duration
    });
    
    toastElement.show();
    
    // Remover el toast del DOM después de que se oculte
    document.getElementById(toastId).addEventListener('hidden.bs.toast', function() {
        this.remove();
    });
}

/**
 * Obtiene el icono correspondiente al tipo de toast
 * @param {string} type - Tipo de toast
 * @returns {string} Clase del icono
 */
function getToastIcon(type) {
    switch(type) {
        case 'success': return 'fas fa-check-circle text-success';
        case 'error': return 'fas fa-exclamation-circle text-danger';
        case 'warning': return 'fas fa-exclamation-triangle text-warning';
        case 'info': return 'fas fa-info-circle text-info';
        default: return 'fas fa-bell text-primary';
    }
}

/**
 * Muestra un toast de confirmación con botones de acción
 * @param {string} type - Tipo de toast: 'success', 'error', 'warning', 'info'
 * @param {string} title - Título del toast
 * @param {string} message - Mensaje del toast
 * @param {function} onConfirm - Función a ejecutar al confirmar
 * @param {function} onCancel - Función a ejecutar al cancelar (opcional)
 */
function showConfirmToast(type, title, message, onConfirm, onCancel) {
    // Obtener o crear el contenedor de toasts
    let toastContainer = document.getElementById('toastContainer');
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.id = 'toastContainer';
        toastContainer.className = 'toast-container position-fixed top-0 end-0 p-3';
        toastContainer.style.zIndex = '1060';
        document.body.appendChild(toastContainer);
    }

    const toastId = 'confirm-toast-' + Date.now();
    const iconClass = getToastIcon(type);
    const toastClass = 'toast-' + type;
    
    const toastHtml = `
        <div class="toast ${toastClass} toast-confirm" id="${toastId}" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="toast-header">
                <i class="${iconClass} me-2"></i>
                <strong class="me-auto">${title}</strong>
            </div>
            <div class="toast-body">
                <div class="mb-3">${message}</div>
                <div class="d-flex gap-2 justify-content-end">
                    <button type="button" class="btn btn-sm btn-outline-secondary" onclick="cancelConfirmToast('${toastId}')">
                        <i class="fas fa-times me-1"></i>Cancelar
                    </button>
                    <button type="button" class="btn btn-sm btn-primary" onclick="confirmToast('${toastId}')">
                        <i class="fas fa-check me-1"></i>Confirmar
                    </button>
                </div>
            </div>
        </div>
    `;
    
    $(toastContainer).append(toastHtml);
    
    // Almacenar las funciones de callback en el elemento
    document.getElementById(toastId).onConfirm = onConfirm;
    document.getElementById(toastId).onCancel = onCancel || function() {};
    
    const toastElement = new bootstrap.Toast(document.getElementById(toastId), {
        autohide: false,
        delay: 0
    });
    
    toastElement.show();
}

/**
 * Confirma el toast y ejecuta la función de confirmación
 * @param {string} toastId - ID del toast
 */
function confirmToast(toastId) {
    const toastElement = document.getElementById(toastId);
    if (toastElement && toastElement.onConfirm) {
        toastElement.onConfirm();
    }
    const toastInstance = bootstrap.Toast.getInstance(toastElement);
    if (toastInstance) {
        toastInstance.hide();
    }
}

/**
 * Cancela el toast y ejecuta la función de cancelación
 * @param {string} toastId - ID del toast
 */
function cancelConfirmToast(toastId) {
    const toastElement = document.getElementById(toastId);
    if (toastElement && toastElement.onCancel) {
        toastElement.onCancel();
    }
    const toastInstance = bootstrap.Toast.getInstance(toastElement);
    if (toastInstance) {
        toastInstance.hide();
    }
}







