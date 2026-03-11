<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="comprobanteText.aspx.vb" Inherits="SemgaWapp.comprobanteText" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Prueba de Comprobante</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
    
    <style>
        body {
            background: #f8f9fa;
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .main-container {
            background: #ffffff;
            border-radius: 6px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin: 15px;
            padding: 15px;
            border: 1px solid #e9ecef;
        }
        
        .header-section {
            background: #2c3e50;
            color: white;
            padding: 10px 15px;
            border-radius: 6px;
            margin-bottom: 15px;
        }
        
        .test-section {
            background: #ffffff;
            padding: 20px;
            border-radius: 6px;
            border: 1px solid #e9ecef;
            margin-bottom: 15px;
        }
        
        .form-control {
            font-size: 13px;
            border-radius: 4px;
        }
        
        .form-label {
            font-size: 12px;
            font-weight: 500;
            margin-bottom: 4px;
        }
        
        .btn {
            border-radius: 4px;
            font-size: 13px;
        }
        
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1055;
        }
        
        .toast {
            min-width: 300px;
            margin-bottom: 10px;
            border: none;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
        
        .toast-success {
            background-color: #d4edda;
            border-left: 4px solid #28a745;
        }
        
        .toast-error {
            background-color: #f8d7da;
            border-left: 4px solid #dc3545;
        }
        
        .toast-warning {
            background-color: #fff3cd;
            border-left: 4px solid #ffc107;
        }
        
        .toast-info {
            background-color: #d1ecf1;
            border-left: 4px solid #17a2b8;
        }
        
        .toast-header {
            background: transparent;
            border-bottom: 1px solid rgba(0, 0, 0, 0.1);
            font-weight: 600;
        }
        
        .toast-body {
            padding: 12px 16px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="main-container">
            <!-- Header Section -->
            <div class="header-section">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h6 class="mb-0" style="font-size: 16px;"><i class="fas fa-print me-2"></i>Prueba de Comprobante</h6>
                    </div>
                    <div class="col-md-6 text-end">
                        <button type="button" class="btn btn-secondary" onclick="volverDashboard()">
                            <i class="fas fa-arrow-left me-1"></i>Volver
                        </button>
                    </div>
                </div>
            </div>

            <!-- Sección de Prueba -->
            <div class="test-section">
                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="txtMovimientoID" class="form-label fw-bold">ID del Movimiento <span class="text-danger">*</span></label>
                            <input type="number" id="txtMovimientoID" class="form-control" value="5" min="1" required>
                            <div class="form-text">Ingrese el ID del movimiento para generar el comprobante</div>
                        </div>
                    </div>
                    <div class="col-md-6 d-flex align-items-end">
                        <div class="mb-3 w-100">
                            <button type="button" id="btnImprimirComprobante" class="btn btn-primary btn-lg w-100">
                                <i class="fas fa-print me-2"></i>Imprimir Comprobante
                            </button>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-12">
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i>
                            <strong>Instrucciones:</strong> Ingrese el ID del movimiento que desea probar y haga clic en "Imprimir Comprobante". 
                            El comprobante se abrirá en una nueva ventana para su revisión.
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Toast Container -->
        <div id="toastContainer" class="toast-container"></div>
    </form>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="../../Scripts/inactivity-monitor-final.js?v=2.6"></script>

    <script>
        $(document).ready(function() {
            // Inicializar monitoreo de inactividad
            if (typeof initializeInactivityMonitoring === 'function') {
                initializeInactivityMonitoring();
            }

            // Escuchar mensajes de la ventana del comprobante
            window.addEventListener('message', function(event) {
                if (event.data && event.data.tipo === 'marcarImpreso') {
                    marcarComprobanteComoImpreso(event.data.movimientoId);
                }
            });

            // Event listener para el botón de imprimir
            $('#btnImprimirComprobante').on('click', function() {
                imprimirComprobante();
            });
        });

        function imprimirComprobante() {
            const movimientoId = $('#txtMovimientoID').val();
            
            // Validar que se haya ingresado un ID
            if (!movimientoId || movimientoId <= 0) {
                showToast('warning', 'Validación', 'Por favor ingrese un ID de movimiento válido');
                return;
            }

            // Mostrar loading en el botón
            const btnOriginal = $('#btnImprimirComprobante').html();
            $('#btnImprimirComprobante').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Generando...');

            // Llamar al WebMethod para generar el comprobante
            $.ajax({
                type: 'POST',
                url: 'comprobanteText.aspx/GenerarComprobante',
                data: JSON.stringify({ movimientoId: movimientoId.toString() }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function(response) {
                    if (response.d.Resultado === 'SUCCESS') {
                        // Abrir el comprobante en una nueva ventana
                        var ventanaComprobante = window.open('', '_blank', 'width=800,height=600,scrollbars=yes,resizable=yes');
                        ventanaComprobante.document.write(response.d.Html);
                        ventanaComprobante.document.close();
                        
                        // Enfocar la ventana para que aparezca al frente
                        ventanaComprobante.focus();
                        
                        showToast('success', 'Éxito', 'Comprobante generado correctamente');
                    } else {
                        showToast('error', 'Error', 'Error al generar el comprobante: ' + response.d.Mensaje);
                    }
                },
                error: function(xhr, status, error) {
                    showToast('error', 'Error', 'Error al generar el comprobante: ' + error);
                },
                complete: function() {
                    // Restaurar botón original
                    $('#btnImprimirComprobante').prop('disabled', false).html(btnOriginal);
                }
            });
        }

        function volverDashboard() {
            window.location.href = '../../Dashboard.aspx';
        }

        // Funciones de Toast Notifications
        function showToast(type, title, message, duration = 4000) {
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
            
            $('#toastContainer').append(toastHtml);
            
            const toastElement = new bootstrap.Toast(document.getElementById(toastId), {
                delay: duration
            });
            
            toastElement.show();
        }

        function getToastIcon(type) {
            switch(type) {
                case 'success': return 'fas fa-check-circle text-success';
                case 'error': return 'fas fa-exclamation-circle text-danger';
                case 'warning': return 'fas fa-exclamation-triangle text-warning';
                case 'info': return 'fas fa-info-circle text-info';
                default: return 'fas fa-info-circle text-info';
            }
        }

        // Función para marcar el comprobante como impreso
        function marcarComprobanteComoImpreso(movimientoId) {
            $.ajax({
                type: 'POST',
                url: 'comprobanteText.aspx/MarcarComprobanteImpreso',
                data: JSON.stringify({ movimientoId: movimientoId }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function(response) {
                    if (response.d.Resultado === 'SUCCESS') {
                        showToast('success', 'Éxito', 'Comprobante marcado como impreso');
                    } else {
                        showToast('error', 'Error', 'Error al marcar comprobante como impreso: ' + response.d.Mensaje);
                    }
                },
                error: function(xhr, status, error) {
                    showToast('error', 'Error', 'Error al marcar comprobante como impreso: ' + error);
                }
            });
        }
    </script>
</body>
</html>


