<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Respaldos.aspx.vb" Inherits="SemgaWapp.Respaldos" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Respaldo de Datos - Cooperativa Coopsemga</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Script de monitoreo de inactividad -->
    <script src="../../Scripts/inactivity-monitor-final.js?v=2.6"></script>
    
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
        }

        .header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 12px 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .logo-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #87CEEB, #B0E0E6);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
        }

        .logo-text {
            font-size: 24px;
            font-weight: 700;
            color: #333;
        }

        .breadcrumb {
            color: #666;
            font-size: 14px;
        }

        .back-btn {
            background: linear-gradient(135deg, #87CEEB, #5F9EA0);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .back-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(135, 206, 235, 0.4);
        }

        .main-content {
            padding: 20px;
            max-width: 95%;
            margin: 0 auto;
        }


        .card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }

        .card-back-btn {
            padding: 8px 16px;
            border-radius: 8px;
            text-decoration: none;
        }

        .card-icon {
            width: 38px;
            height: 38px;
            background: linear-gradient(135deg, #dc3545, #c82333);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 16px;
        }

        .card-title {
            font-size: 24px;
            font-weight: 600;
            color: #333;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: #87CEEB;
            box-shadow: 0 0 0 3px rgba(135, 206, 235, 0.1);
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }

        .btn-primary {
            background: linear-gradient(135deg, #87CEEB, #5F9EA0);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(135, 206, 235, 0.4);
        }

        .btn-success {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
        }

        .btn-warning {
            background: linear-gradient(135deg, #ffc107, #e0a800);
            color: #333;
        }

        .btn-warning:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 193, 7, 0.4);
        }

        .btn-danger {
            background: linear-gradient(135deg, #dc3545, #c82333);
            color: white;
        }

        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #6c757d, #5a6268);
            color: white;
        }

        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(108, 117, 125, 0.4);
        }

        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .alert-info {
            background: linear-gradient(135deg, #d1ecf1, #bee5eb);
            color: #0c5460;
            border-left: 4px solid #17a2b8;
        }

        .alert-success {
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            color: #155724;
            border-left: 4px solid #28a745;
        }

        .alert-warning {
            background: linear-gradient(135deg, #fff3cd, #ffeaa7);
            color: #856404;
            border-left: 4px solid #ffc107;
        }

        .alert-danger {
            background: linear-gradient(135deg, #f8d7da, #f5c6cb);
            color: #721c24;
            border-left: 4px solid #dc3545;
        }

        .progress {
            width: 100%;
            height: 20px;
            background-color: #e9ecef;
            border-radius: 10px;
            overflow: hidden;
            margin: 15px 0;
        }

        .progress-bar {
            height: 100%;
            background: linear-gradient(135deg, #28a745, #20c997);
            transition: width 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 12px;
            font-weight: 600;
        }

        .table {
            width: 100%;
            min-width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            table-layout: fixed;
        }

        .table th,
        .table td {
            padding: 8px;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
        }

        .table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #333;
        }

        .table tbody tr:hover {
            background-color: #f8f9fa;
        }

        /* Estilos para la columna de acciones */
        .table th:last-child,
        .table td:last-child {
            min-width: 120px;
            width: 120px;
            text-align: center;
            vertical-align: middle;
            white-space: nowrap;
        }

        .table td:last-child .btn {
            margin: 2px 4px;
            padding: 8px 12px;
            font-size: 13px;
            min-width: 45px;
            display: inline-block;
        }

        /* Anchos específicos para cada columna */
        .table th:nth-child(1), .table td:nth-child(1) { width: 18%; } /* Nombre */
        .table th:nth-child(2), .table td:nth-child(2) { width: 10%; } /* Usuario */
        .table th:nth-child(3), .table td:nth-child(3) { width: 12%; } /* Fecha */
        .table th:nth-child(4), .table td:nth-child(4) { width: 8%; } /* Tamaño */
        .table th:nth-child(5), .table td:nth-child(5) { width: 42%; } /* Descripción */
        .table th:nth-child(6), .table td:nth-child(6) { width: 10%; } /* Acciones */

        /* Contenedor de la tabla */
        .table-container {
            margin-top: 20px;
        }

        /* Manejo de texto largo en columnas específicas */
        .table td:nth-child(1) { /* Nombre */
            word-wrap: break-word;
            word-break: break-all;
            max-width: 200px;
        }

        .table td:nth-child(2) { /* Usuario */
            word-wrap: break-word;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .table td:nth-child(3) { /* Fecha */
            white-space: nowrap;
            font-size: 12px;
        }

        .table td:nth-child(5) { /* Descripción */
            word-wrap: break-word;
            max-width: none;
        }

        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }

        /* Chip para el tamaño del respaldo */
        .size-chip {
            background: linear-gradient(135deg, #17a2b8, #138496);
            color: white;
            padding: 6px 14px;
            border-radius: 18px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
            text-align: center;
            min-width: 70px;
        }

        .status-success {
            background-color: #d4edda;
            color: #155724;
        }

        .status-warning {
            background-color: #fff3cd;
            color: #856404;
        }

        .status-danger {
            background-color: #f8d7da;
            color: #721c24;
        }

        .text-sm {
            font-size: 12px;
            color: #999;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 10px;
                text-align: center;
                padding: 10px 15px;
            }

            .main-content {
                padding: 15px;
            }


            .card {
                padding: 20px;
            }

            .card-header {
                flex-direction: column;
                text-align: center;
                gap: 10px;
            }

            .btn {
                width: 100%;
                justify-content: center;
                margin-bottom: 10px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Main Content -->
        <div class="main-content">

            <!-- Modal para crear respaldo -->
            <div id="modalCrearRespaldo" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000;">
                <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); background: white; padding: 30px; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.3); min-width: 400px; max-width: 500px;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                        <h3 style="margin: 0; color: #333;">Crear Nuevo Respaldo</h3>
                        <button type="button" onclick="cerrarModal()" style="background: none; border: none; font-size: 24px; cursor: pointer; color: #666;">&times;</button>
                    </div>
                    
                    <div class="alert alert-info" style="margin-bottom: 20px;">
                        <i class="fas fa-info-circle"></i>
        <div>
                            <strong>Información:</strong> Los respaldos incluyen todos los datos del sistema. 
                            Se recomienda crear respaldos periódicos para proteger la información.
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Nombre del Respaldo</label>
                        <input type="text" id="txtNombreRespaldo" class="form-control" readonly="true" style="background-color: #f8f9fa;" />
                    </div>

                    <div class="form-group">
                        <label class="form-label">Ruta del Respaldo</label>
                        <input type="text" id="txtRutaRespaldo" class="form-control" readonly="true" style="background-color: #f8f9fa;" />
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="txtDescripcion">Descripción (Opcional)</label>
                        <textarea id="txtDescripcion" class="form-control" rows="3" placeholder="Descripción del respaldo..."></textarea>
                    </div>

                    <div style="display: flex; gap: 10px; justify-content: flex-end;">
                        <button type="button" class="btn btn-secondary" onclick="cerrarModal()">
                            <i class="fas fa-times"></i>
                            Cancelar
                        </button>
                        <button type="button" class="btn btn-success" onclick="crearRespaldo()">
                            <i class="fas fa-save"></i>
                            Crear Respaldo
                        </button>
                    </div>

                    <!-- Progress Bar (oculto inicialmente) -->
                    <div id="divProgress" style="display: none; margin-top: 20px;">
                        <div class="progress">
                            <div id="progressBar" class="progress-bar" style="width: 0%">0%</div>
                        </div>
                        <div id="progressText" class="text-center text-muted">Preparando respaldo...</div>
                    </div>
                </div>
            </div>

            <!-- Card de Respaldos Existentes -->
            <div class="card">
                <div class="card-header">
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <div class="card-icon">
                            <i class="fas fa-history"></i>
                        </div>
                        <div class="card-title">Respaldos</div>
                    </div>
                    <a href="../Mantenimientos/dashboardSistemas.aspx" class="back-btn card-back-btn">
                        <i class="fas fa-arrow-left"></i>
                        Volver
                    </a>
                </div>

                <div style="display: flex; gap: 10px; margin-bottom: 20px;">
                    <button type="button" class="btn btn-success" onclick="abrirModalCrearRespaldo()">
                        <i class="fas fa-plus"></i>
                        Agregar Respaldo
                    </button>
                    <button type="button" class="btn btn-primary" onclick="cargarRespaldos()">
                        <i class="fas fa-sync"></i>
                        Actualizar Lista
                    </button>
                </div>

                <div id="divRespaldos">
                    <div class="text-center text-muted">
                        <i class="fas fa-spinner fa-spin"></i>
                        Cargando respaldos...
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal de Confirmación -->
        <div id="modalConfirmacion" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 2000;">
            <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); background: white; padding: 30px; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.3); min-width: 400px; max-width: 500px; text-align: center;">
                <div style="margin-bottom: 20px;">
                    <i class="fas fa-question-circle" style="font-size: 48px; color: #ffc107;"></i>
                </div>
                <h3 style="margin: 0 0 15px 0; color: #333;">Confirmar Acción</h3>
                <p id="mensajeConfirmacion" style="margin: 0 0 25px 0; color: #666; font-size: 16px;"></p>
                <div style="display: flex; gap: 10px; justify-content: center;">
                    <button type="button" class="btn btn-secondary" onclick="cancelarConfirmacion()">
                        <i class="fas fa-times"></i>
                        Cancelar
                    </button>
                    <button type="button" class="btn btn-danger" onclick="confirmarAccion()">
                        <i class="fas fa-check"></i>
                        Confirmar
                    </button>
                </div>
            </div>
        </div>
    </form>

    <script type="text/javascript">
        // Variables globales para confirmación
        let accionConfirmacion = null;
        let parametrosConfirmacion = null;

        // Inicializar monitoreo de inactividad cuando el DOM esté listo
        document.addEventListener('DOMContentLoaded', function() {
            if (typeof initializeInactivityMonitoring === 'function') {
                initializeInactivityMonitoring();
            }
            
            // Cargar respaldos al inicializar
            cargarRespaldos();
        });

        function abrirModalCrearRespaldo() {
            // Generar nombre automático con fecha y hora
            const ahora = new Date();
            const fechaHora = ahora.getFullYear().toString() + 
                             (ahora.getMonth() + 1).toString().padStart(2, '0') + 
                             ahora.getDate().toString().padStart(2, '0') + '_' +
                             ahora.getHours().toString().padStart(2, '0') + 
                             ahora.getMinutes().toString().padStart(2, '0') + 
                             ahora.getSeconds().toString().padStart(2, '0');
            
            // Obtener la ruta real del servidor
            $.ajax({
                type: "POST",
                url: "Respaldos.aspx/ObtenerRutaRespaldos",
                data: "{}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    try {
                        let responseData;
                        if (typeof response.d === 'string') {
                            responseData = JSON.parse(response.d);
                        } else {
                            responseData = response.d;
                        }
                        
                        let rutaBase = 'C:\\Respaldos\\'; // Ruta por defecto
                        if (responseData && responseData.Success && responseData.Ruta) {
                            rutaBase = responseData.Ruta;
                        }
                        
                        const nombreRespaldo = `Respaldo_${fechaHora}`;
                        const nombreArchivo = `${nombreRespaldo}.bak`;
                        const rutaCompleta = rutaBase + nombreArchivo;
                        
                        // Establecer campos por separado
                        document.getElementById('txtNombreRespaldo').value = nombreRespaldo;
                        document.getElementById('txtRutaRespaldo').value = rutaCompleta;
                        document.getElementById('txtDescripcion').value = '';
                        
                        // Mostrar modal
                        document.getElementById('modalCrearRespaldo').style.display = 'block';
                    } catch (parseError) {
                        // Usar ruta por defecto
                        const nombreRespaldo = `Respaldo_${fechaHora}`;
                        const nombreArchivo = `${nombreRespaldo}.bak`;
                        const rutaCompleta = 'C:\\Respaldos\\' + nombreArchivo;
                        
                        document.getElementById('txtNombreRespaldo').value = nombreRespaldo;
                        document.getElementById('txtRutaRespaldo').value = rutaCompleta;
                        document.getElementById('txtDescripcion').value = '';
                        document.getElementById('modalCrearRespaldo').style.display = 'block';
                    }
                },
                error: function() {
                    // En caso de error, usar ruta por defecto
                    const nombreRespaldo = `Respaldo_${fechaHora}`;
                    const nombreArchivo = `${nombreRespaldo}.bak`;
                    const rutaCompleta = 'C:\\Respaldos\\' + nombreArchivo;
                    
                    document.getElementById('txtNombreRespaldo').value = nombreRespaldo;
                    document.getElementById('txtRutaRespaldo').value = rutaCompleta;
                    document.getElementById('txtDescripcion').value = '';
                    document.getElementById('modalCrearRespaldo').style.display = 'block';
                }
            });
        }

        function cerrarModal() {
            document.getElementById('modalCrearRespaldo').style.display = 'none';
            document.getElementById('divProgress').style.display = 'none';
        }

        // Funciones de confirmación personalizada
        function mostrarConfirmacion(mensaje, accion, parametros) {
            document.getElementById('mensajeConfirmacion').textContent = mensaje;
            accionConfirmacion = accion;
            parametrosConfirmacion = parametros;
            document.getElementById('modalConfirmacion').style.display = 'block';
        }

        function cancelarConfirmacion() {
            document.getElementById('modalConfirmacion').style.display = 'none';
            accionConfirmacion = null;
            parametrosConfirmacion = null;
        }

        function confirmarAccion() {
            if (accionConfirmacion && typeof accionConfirmacion === 'function') {
                accionConfirmacion(parametrosConfirmacion);
            }
            document.getElementById('modalConfirmacion').style.display = 'none';
            accionConfirmacion = null;
            parametrosConfirmacion = null;
        }

        function crearRespaldo() {
            const nombre = document.getElementById('txtNombreRespaldo').value.trim();
            const descripcion = document.getElementById('txtDescripcion').value.trim();

            if (!nombre) {
                mostrarAlerta('Error: No se pudo generar el nombre del respaldo', 'danger');
                return;
            }

            // Mostrar confirmación personalizada
            const mensaje = `¿Está seguro de que desea crear el respaldo "${nombre}"?\n\nEsto puede tomar varios minutos dependiendo del tamaño de la base de datos.`;
            mostrarConfirmacion(mensaje, procederConCrearRespaldo, { nombre: nombre, descripcion: descripcion });
        }

        function procederConCrearRespaldo(parametros) {
            // Mostrar progress bar
            document.getElementById('divProgress').style.display = 'block';
            actualizarProgress(0, 'Iniciando respaldo...');

            // Crear respaldo real
            crearRespaldoReal(parametros.nombre, parametros.descripcion);
        }

        function crearRespaldoReal(nombre, descripcion) {
            // Llamar al WebMethod para crear el respaldo
            $.ajax({
                type: "POST",
                url: "Respaldos.aspx/CrearRespaldo",
                data: JSON.stringify({
                    nombreRespaldo: nombre,
                    descripcion: descripcion
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    try {
                        // Parsear la respuesta si viene como string
                        let responseData;
                        if (typeof response.d === 'string') {
                            responseData = JSON.parse(response.d);
                        } else {
                            responseData = response.d;
                        }
                        
                        if (responseData.Success) {
                            actualizarProgress(100, 'Respaldo completado exitosamente');
                            mostrarAlerta('Respaldo creado exitosamente', 'success');
                            setTimeout(() => {
                                document.getElementById('divProgress').style.display = 'none';
                                cerrarModal();
                                cargarRespaldos();
                            }, 2000);
                        } else {
                            document.getElementById('divProgress').style.display = 'none';
                            mostrarAlerta('Error al crear respaldo: ' + responseData.Message, 'danger');
                        }
                    } catch (parseError) {
                        document.getElementById('divProgress').style.display = 'none';
                        mostrarAlerta('Error al procesar respuesta del servidor', 'danger');
                    }
                },
                error: function() {
                    document.getElementById('divProgress').style.display = 'none';
                    mostrarAlerta('Error al crear respaldo', 'danger');
                }
            });
        }

        function actualizarProgress(porcentaje, texto) {
            const progressBar = document.getElementById('progressBar');
            const progressText = document.getElementById('progressText');
            
            progressBar.style.width = porcentaje + '%';
            progressBar.textContent = Math.round(porcentaje) + '%';
            progressText.textContent = texto;
        }

        function cargarRespaldos() {
            const divRespaldos = document.getElementById('divRespaldos');
            
            // Mostrar loading
            divRespaldos.innerHTML = `
                <div class="text-center text-muted">
                    <i class="fas fa-spinner fa-spin"></i>
                    Cargando respaldos...
                </div>
            `;
            
            // Llamar al WebMethod para obtener respaldos
            $.ajax({
                type: "POST",
                url: "Respaldos.aspx/ObtenerRespaldos",
                data: "{}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    try {
                        // Parsear la respuesta si viene como string
                        let responseData;
                        if (typeof response.d === 'string') {
                            responseData = JSON.parse(response.d);
                        } else {
                            responseData = response.d;
                        }
                        
                        if (responseData && responseData.Success) {
                            // Verificar si Data es una cadena vacía o un array
                            const data = responseData.Data;
                            if (data === "" || data === null || data === undefined) {
                                mostrarRespaldos([]);
                            } else {
                                mostrarRespaldos(data);
                            }
                        } else {
                            const mensaje = responseData && responseData.Message ? responseData.Message : 'Error desconocido';
                            divRespaldos.innerHTML = `
                                <div class="alert alert-danger">
                                    <i class="fas fa-exclamation-triangle"></i>
                                    Error al cargar respaldos: ${mensaje}
                                </div>
                            `;
                        }
                    } catch (parseError) {
                        divRespaldos.innerHTML = `
                            <div class="alert alert-danger">
                                <i class="fas fa-exclamation-triangle"></i>
                                Error al procesar respuesta del servidor
                            </div>
                        `;
                    }
                },
                error: function(xhr, status, error) {
                    divRespaldos.innerHTML = `
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-triangle"></i>
                            Error al cargar respaldos: ${error}
                        </div>
                    `;
                }
            });
        }

        function formatearFechaRespaldo(fechaTexto) {
            if (!fechaTexto) {
                return '-';
            }

            // Intentar parsear formato DD/MM/YYYY HH:mm:ss con o sin AM/PM
            const regex = /(\d{1,2})\/(\d{1,2})\/(\d{4})\s+(\d{1,2}):(\d{2})(?::(\d{2}))?\s*(a\.?m\.?|p\.?m\.?)?/i;
            const match = fechaTexto.match(regex);

            try {
                if (match) {
                    let dia = parseInt(match[1], 10);
                    let mes = parseInt(match[2], 10) - 1;
                    let anio = parseInt(match[3], 10);
                    let hora = parseInt(match[4], 10);
                    let minuto = parseInt(match[5], 10);
                    let segundo = match[6] ? parseInt(match[6], 10) : 0;
                    const ampm = match[7] ? match[7].toLowerCase() : null;

                    if (ampm) {
                        if (ampm.includes('p') && hora < 12) {
                            hora += 12;
                        }
                        if (ampm.includes('a') && hora === 12) {
                            hora = 0;
                        }
                    }

                    const fecha = new Date(anio, mes, dia, hora, minuto, segundo);
                    if (!isNaN(fecha.getTime())) {
                        return fecha.toLocaleString('es-ES', {
                            year: 'numeric',
                            month: '2-digit',
                            day: '2-digit',
                            hour: '2-digit',
                            minute: '2-digit',
                            second: '2-digit'
                        });
                    }
                }

                // Intentar parseo directo (ISO u otros formatos compatibles)
                const fechaDirecta = new Date(fechaTexto);
                if (!isNaN(fechaDirecta.getTime())) {
                    return fechaDirecta.toLocaleString('es-ES', {
                        year: 'numeric',
                        month: '2-digit',
                        day: '2-digit',
                        hour: '2-digit',
                        minute: '2-digit',
                        second: '2-digit'
                    });
                }
            } catch (error) {
                // Si no se pudo formatear, retornar texto original
            }

            // Si no se pudo formatear, retornar texto original
            return fechaTexto;
        }

        function mostrarRespaldos(respaldos) {
            const divRespaldos = document.getElementById('divRespaldos');
            
            // Verificar si respaldos es null, undefined, cadena vacía o no es un array
            if (!respaldos || respaldos === "" || !Array.isArray(respaldos) || respaldos.length === 0) {
                divRespaldos.innerHTML = `
                    <div class="text-center text-muted">
                        <i class="fas fa-database"></i>
                        <p>No hay respaldos disponibles</p>
                        <p class="text-sm">Haga clic en "Agregar Respaldo" para crear el primer respaldo del sistema</p>
                    </div>
                `;
                return;
            }
            
            let html = `
                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Nombre</th>
                                <th>Usuario</th>
                                <th>Fecha</th>
                                <th>Tamaño</th>
                                <th>Descripción</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
            `;
            
            respaldos.forEach(function(respaldo) {
                const fecha = formatearFechaRespaldo(respaldo.FechaHora);
                
                const descripcion = respaldo.Descripcion || '-';
                
                html += `
                    <tr>
                        <td>${respaldo.NombreRespaldo}</td>
                        <td>${respaldo.NombreUsuario || 'Administrador'}</td>
                        <td>${fecha}</td>
                        <td><span class="size-chip">${respaldo.SizeFormateado}</span></td>
                        <td>${descripcion}</td>
                        <td>
                            ${!respaldo.SnEliminado ? `
                                <button type="button" class="btn btn-primary btn-sm" onclick="descargarRespaldo(${respaldo.ID}, '${respaldo.NombreRespaldo}')">
                                    <i class="fas fa-download"></i>
                                </button>
                            ` : ''}
                            <button type="button" class="btn btn-danger btn-sm" onclick="eliminarRespaldo(${respaldo.ID}, '${respaldo.NombreRespaldo}')">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                `;
            });
            
            html += `
                        </tbody>
                    </table>
                </div>
            `;
            
            divRespaldos.innerHTML = html;
        }

        function descargarRespaldo(id, nombre) {
            mostrarAlerta(`Iniciando descarga de ${nombre}`, 'info');
            
            // Crear un enlace temporal para la descarga
            const link = document.createElement('a');
            link.href = `Respaldos.aspx?action=download&id=${id}`;
            link.download = `${nombre}.bak`;
            link.target = '_blank';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            
            return false;
        }

        function eliminarRespaldo(id, nombre) {
            const mensaje = `¿Está seguro de que desea eliminar el respaldo "${nombre}"?`;
            mostrarConfirmacion(mensaje, procederConEliminarRespaldo, { id: id, nombre: nombre });
            return false;
        }

        function procederConEliminarRespaldo(parametros) {
            $.ajax({
                type: "POST",
                url: "Respaldos.aspx/EliminarRespaldo",
                data: JSON.stringify({ id: parametros.id }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    try {
                        // Parsear la respuesta si viene como string
                        let responseData;
                        if (typeof response.d === 'string') {
                            responseData = JSON.parse(response.d);
                        } else {
                            responseData = response.d;
                        }
                        
                        if (responseData.Success) {
                            mostrarAlerta(`Respaldo "${parametros.nombre}" eliminado exitosamente`, 'success');
                            cargarRespaldos();
                        } else {
                            mostrarAlerta('Error al eliminar respaldo: ' + responseData.Message, 'danger');
                        }
                    } catch (parseError) {
                        mostrarAlerta('Error al procesar respuesta del servidor', 'danger');
                    }
                },
                error: function() {
                    mostrarAlerta('Error al eliminar respaldo', 'danger');
                }
            });
            return false;
        }


        function mostrarAlerta(mensaje, tipo) {
            const alertDiv = document.createElement('div');
            alertDiv.className = `alert alert-${tipo}`;
            alertDiv.innerHTML = `
                <i class="fas fa-${tipo === 'success' ? 'check-circle' : tipo === 'warning' ? 'exclamation-triangle' : tipo === 'danger' ? 'times-circle' : 'info-circle'}"></i>
                <div>${mensaje}</div>
            `;
            
            // Insertar al inicio del main-content
            const mainContent = document.querySelector('.main-content');
            mainContent.insertBefore(alertDiv, mainContent.firstChild);
            
            // Auto-ocultar después de 5 segundos
            setTimeout(() => {
                alertDiv.remove();
            }, 5000);
        }
    </script>
</body>
</html>
