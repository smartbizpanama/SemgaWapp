/**
 * Sistema de Notificaciones Toast Global
 * Funciones para mostrar notificaciones y confirmaciones usando Bootstrap 5.
 *
 * Clase global: .toast-container
 * Posición del contenedor: usar modificador en el contenedor
 *   - .toast-container--top-end  → esquina superior derecha (toasts informativos)
 *   - .toast-container--center   → centro de la ventana (confirms)
 * Incluir en la página: <link href="Scripts/toast-global.css" rel="stylesheet" />
 */

/**
 * Muestra una notificación toast
 * @param {string} type - Tipo de toast: 'success', 'error', 'warning', 'info'
 * @param {string} title - Título del toast
 * @param {string} message - Mensaje del toast
 * @param {number} duration - Duración en milisegundos (default: 4000)
 */
function showToast(type, title, message, duration = 4000) {
    // Obtener o crear el contenedor global de toasts (posición: top-end)
    var toastContainer = document.getElementById('toastContainer');
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.id = 'toastContainer';
        toastContainer.className = 'toast-container toast-container--top-end';
        document.body.appendChild(toastContainer);
    } else if (!toastContainer.classList.contains('toast-container--top-end')) {
        toastContainer.classList.add('toast-container--top-end');
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
    // Overlay fijo en toda la ventana, centrado con flex (no usa Bootstrap Toast para evitar que se mueva)
    var overlay = document.createElement('div');
    overlay.id = 'confirmToastOverlay-' + Date.now();
    overlay.setAttribute('role', 'dialog');
    overlay.setAttribute('aria-modal', 'true');
    overlay.setAttribute('aria-labelledby', overlay.id + '-title');
    overlay.style.cssText = 'position:fixed;top:0;left:0;right:0;bottom:0;width:100%;height:100%;display:flex;justify-content:center;align-items:center;z-index:9999;background:rgba(0,0,0,0.25);padding:1rem;box-sizing:border-box;';
    overlay.style.pointerEvents = 'auto';

    var iconClass = getToastIcon(type);
    var toastClass = 'toast-' + type;
    var boxId = 'confirmToastBox-' + Date.now();

    var boxHtml = '<div id="' + boxId + '" class="toast show ' + toastClass + ' toast-confirm shadow" style="min-width:320px;max-width:90vw;pointer-events:auto;">' +
        '<div class="toast-header">' +
        '<i class="' + iconClass + ' me-2"></i>' +
        '<strong class="me-auto" id="' + overlay.id + '-title">' + (title || '') + '</strong>' +
        '</div>' +
        '<div class="toast-body">' +
        '<div class="mb-3">' + (message || '') + '</div>' +
        '<div class="d-flex gap-2 justify-content-end">' +
        '<button type="button" class="btn btn-sm btn-outline-secondary btn-cancel-confirm">' +
        '<i class="fas fa-times me-1"></i>Cancelar</button>' +
        '<button type="button" class="btn btn-sm btn-primary btn-ok-confirm">' +
        '<i class="fas fa-check me-1"></i>Confirmar</button>' +
        '</div></div></div>';

    overlay.innerHTML = boxHtml;
    document.body.appendChild(overlay);

    var box = document.getElementById(boxId);
    box.onConfirm = onConfirm;
    box.onCancel = onCancel || function() {};

    function closeConfirm() {
        if (overlay.parentNode) {
            overlay.parentNode.removeChild(overlay);
        }
    }

    overlay.querySelector('.btn-ok-confirm').addEventListener('click', function() {
        if (typeof box.onConfirm === 'function') box.onConfirm();
        closeConfirm();
    });
    overlay.querySelector('.btn-cancel-confirm').addEventListener('click', function() {
        if (typeof box.onCancel === 'function') box.onCancel();
        closeConfirm();
    });
    overlay.addEventListener('click', function(e) {
        if (e.target === overlay) {
            if (typeof box.onCancel === 'function') box.onCancel();
            closeConfirm();
        }
    });
}

/**
 * Confirma el toast y ejecuta la función de confirmación
 * @param {string} toastId - ID del toast
 */
function confirmToast(toastId) {
    var toastElement = document.getElementById(toastId);
    if (!toastElement) return;
    if (toastElement.onConfirm) {
        try { toastElement.onConfirm(); } catch (e) {}
    }
    var inst = bootstrap.Toast.getInstance(toastElement);
    if (inst) inst.hide(); else { toastElement.classList.remove('show'); setTimeout(function() { if (toastElement.parentNode) toastElement.parentNode.removeChild(toastElement); }, 300); }
}

function cancelConfirmToast(toastId) {
    var toastElement = document.getElementById(toastId);
    if (toastElement && toastElement.onCancel) toastElement.onCancel();
    var inst = bootstrap.Toast.getInstance(toastElement);
    if (inst) inst.hide();
}








