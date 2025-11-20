<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="appParams.aspx.vb" Inherits="SemgaWapp.appParams" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Parámetros del Sistema - Cooperativa Coopsemga</title>
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
    <!-- Script de monitoreo de inactividad -->
    <script src="../../Scripts/inactivity-monitor-final.js?v=2.6"></script>
    
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
        
        .param-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 8px;
        }
        
        .param-table th {
            background: #f8f9fa;
            color: #495057;
            font-weight: 600;
            padding: 8px;
            border: 1px solid #dee2e6;
            text-align: left;
        }
        
        .param-table td {
            padding: 6px 8px;
            border: 1px solid #dee2e6;
            vertical-align: top;
        }
        
        .param-table td:first-child {
            text-align: center;
        }
        
        .param-table tr:nth-child(even) {
            background: #f8f9fa;
        }
        
        .param-table tr:hover {
            background: #e9ecef;
        }
        
        .param-description {
            font-size: 14px;
            color: #495057;
            line-height: 1.4;
        }
        
        .param-value {
            width: 100%;
            padding: 4px 8px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 13px;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
        }
        
        .param-value:focus {
            border-color: #80bdff;
            outline: 0;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }
        
        .param-value.saving {
            border-color: #28a745;
            background-color: #d4edda;
        }
        
        .param-value.error {
            border-color: #dc3545;
            background-color: #f8d7da;
        }
        
        .param-value.changed {
            border-color: #ffc107;
            background-color: #fff3cd;
        }
        
        .loading-spinner {
            display: none;
            text-align: center;
            padding: 20px;
        }
        
        .filter-section {
            background: #f8f9fa;
            padding: 8px 15px;
            border-radius: 6px;
            margin-bottom: 15px;
            border: 1px solid #dee2e6;
        }
        
        .group-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
            margin: 0 auto;
        }
        
        .group-badge i {
            margin-right: 4px;
            font-size: 10px;
        }
        
        .group-badge.asociados {
            background: #28a745;
        }
        
        .group-badge.seguridad {
            background: #17a2b8;
        }
        
        .group-badge.sistema {
            background: #6f42c1;
        }
        
        .group-badge.otros {
            background: #343a40;
        }
        
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1050;
        }
        
        .toast {
            background: #28a745;
            color: white;
            padding: 12px 20px;
            border-radius: 6px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            margin-bottom: 10px;
            opacity: 0;
            transform: translateX(100%);
            transition: all 0.3s ease;
        }
        
        .toast.show {
            opacity: 1;
            transform: translateX(0);
        }
        
        .toast.error {
            background: #dc3545;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" />
        
        <div class="main-container">
            <!-- Header Section -->
            <div style="background: linear-gradient(135deg, #1e3a8a, #3b82f6); color: white; padding: 10px 15px; margin: -15px -15px 15px -15px; display: flex; justify-content: space-between; align-items: center;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <h2 style="margin: 0; font-size: 18px;">
                        <i class="fas fa-cogs" style="margin-right: 8px;"></i>
                        Parámetros del Sistema
                    </h2>
                </div>
                <div>
                    <button type="button" onclick="window.location.href='dashboardSistemas.aspx'" style="background: rgba(255,255,255,0.2); border: none; color: white; padding: 8px 12px; border-radius: 5px; cursor: pointer; display: flex; align-items: center; gap: 5px;">
                        <i class="fas fa-arrow-left"></i>
                        Volver
                    </button>
                </div>
            </div>

            <!-- Filter Section -->
            <div class="filter-section">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <div class="d-flex align-items-center gap-3">
                            <label for="ddlParamGroup" class="form-label fw-bold mb-0">Filtrar por Grupo:</label>
                            <select id="ddlParamGroup" class="form-select" onchange="filtrarParametros()" style="width: 200px;">
                                <option value="">Todos los grupos</option>
                            </select>
                            <button type="button" id="btnGuardar" class="btn btn-primary" onclick="guardarCambios()" disabled style="min-width: 100px;">
                                <i class="fas fa-save me-1"></i>Guardar
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Loading Spinner -->
            <div id="loadingSpinner" class="loading-spinner">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Cargando...</span>
                </div>
                <p class="mt-2">Cargando parámetros...</p>
            </div>

            <!-- Parameters Table -->
            <div id="parametrosContainer">
                <table class="param-table" id="tablaParametros">
                    <thead>
                        <tr>
                            <th style="width: 7.5%; text-align: center;">Grupo</th>
                            <th style="width: 75%; text-align: center;">Descripción</th>
                            <th style="width: 17.5%; text-align: center;">Valor</th>
                        </tr>
                    </thead>
                    <tbody id="parametrosBody">
                        <!-- Los parámetros se cargarán aquí dinámicamente -->
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Toast Container -->
        <div class="toast-container" id="toastContainer"></div>
    </form>

    <script type="text/javascript">
        let parametros = [];
        let grupos = [];

        $(document).ready(function() {
            // Inicializar monitoreo de inactividad
            if (typeof initializeInactivityMonitoring === 'function') {
                initializeInactivityMonitoring();
            }
            
            cargarGrupos();
            cargarParametros();
        });

        function cargarGrupos() {
            $.ajax({
                type: "POST",
                url: "appParams.aspx/ListarGrupos",
                data: "{}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    console.log("Respuesta grupos:", response);
                    
                    // Verificar si response.d es un string que necesita ser parseado
                    let responseData = response.d;
                    if (typeof responseData === 'string') {
                        responseData = JSON.parse(responseData);
                    }
                    
                    if (responseData && responseData.Resultado === "SUCCESS") {
                        grupos = JSON.parse(responseData.Datos);
                        llenarDropdownGrupos();
                    } else {
                        console.log("Error cargando grupos:", responseData);
                    }
                },
                error: function(xhr, status, error) {
                    console.error("Error cargando grupos:", error);
                }
            });
        }

        function llenarDropdownGrupos() {
            const ddl = document.getElementById('ddlParamGroup');
            ddl.innerHTML = '<option value="">Todos los grupos</option>';
            
            grupos.forEach(function(grupo) {
                const option = document.createElement('option');
                option.value = grupo.ParamGroup;
                option.textContent = grupo.ParamGroup;
                ddl.appendChild(option);
            });
        }

        function cargarParametros() {
            mostrarLoading(true);
            
            $.ajax({
                type: "POST",
                url: "appParams.aspx/ListarParametros",
                data: JSON.stringify({ filtros: {} }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    mostrarLoading(false);
                    console.log("Respuesta completa:", response);
                    console.log("response.d:", response.d);
                    
                    // Verificar si response.d es un string que necesita ser parseado
                    let responseData = response.d;
                    if (typeof responseData === 'string') {
                        responseData = JSON.parse(responseData);
                    }
                    
                    if (responseData && responseData.Resultado === "SUCCESS") {
                        console.log("Datos recibidos:", responseData.Datos);
                        parametros = JSON.parse(responseData.Datos);
                        mostrarParametros();
                    } else {
                        console.log("Error en respuesta:", responseData);
                        mostrarError("Error cargando parámetros: " + (responseData ? responseData.Mensaje : "Error desconocido"));
                    }
                },
                error: function(xhr, status, error) {
                    mostrarLoading(false);
                    console.error("Error cargando parámetros:", error);
                    mostrarError("Error de conexión al cargar parámetros");
                }
            });
        }

        function mostrarParametros() {
            const tbody = document.getElementById('parametrosBody');
            tbody.innerHTML = '';

            parametros.forEach(function(param) {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>
                        <span class="group-badge ${getGroupClass(param.ParamGroup)}">
                            <i class="${getGroupIcon(param.ParamGroup)}"></i>
                            ${param.ParamGroup || 'Sin grupo'}
                        </span>
                    </td>
                    <td>
                        <div class="param-description">${param.ParamDescription || 'Sin descripción'}</div>
                    </td>
                    <td>
                        <input type="text" 
                               class="param-value" 
                               value="${param.ParamValue || ''}" 
                               data-param-key="${param.ParamKey}"
                               data-original-value="${param.ParamValue || ''}"
                               onchange="detectarCambio(this)"
                               placeholder="Ingrese el valor del parámetro">
                    </td>
                `;
                tbody.appendChild(row);
            });
        }

        function filtrarParametros() {
            const grupoSeleccionado = document.getElementById('ddlParamGroup').value;
            const tbody = document.getElementById('parametrosBody');
            const rows = tbody.getElementsByTagName('tr');

            for (let i = 0; i < rows.length; i++) {
                const row = rows[i];
                const grupoBadge = row.querySelector('.group-badge');
                const grupo = grupoBadge ? grupoBadge.textContent.trim() : '';
                
                if (grupoSeleccionado === '' || grupo === grupoSeleccionado) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            }
        }

        let cambiosPendientes = new Map();

        function getGroupClass(groupName) {
            if (!groupName) return 'otros';
            
            const group = groupName.toLowerCase();
            if (group === 'asociados') return 'asociados';
            if (group === 'seguridad') return 'seguridad';
            if (group === 'sistema') return 'sistema';
            
            return 'otros';
        }

        function getGroupIcon(groupName) {
            if (!groupName) return 'fas fa-tag';
            
            const group = groupName.toLowerCase();
            if (group === 'asociados') return 'fas fa-users';
            if (group === 'seguridad') return 'fas fa-shield-alt';
            if (group === 'sistema') return 'fas fa-cogs';
            
            return 'fas fa-tag';
        }

        function detectarCambio(inputElement) {
            const paramKey = inputElement.getAttribute('data-param-key');
            const valorOriginal = inputElement.getAttribute('data-original-value');
            const valorActual = inputElement.value;
            
            if (valorActual !== valorOriginal) {
                // Hay un cambio
                cambiosPendientes.set(paramKey, valorActual);
                inputElement.classList.add('changed');
                document.getElementById('btnGuardar').disabled = false;
            } else {
                // No hay cambio, remover de la lista
                cambiosPendientes.delete(paramKey);
                inputElement.classList.remove('changed');
                
                // Si no hay más cambios, deshabilitar botón
                if (cambiosPendientes.size === 0) {
                    document.getElementById('btnGuardar').disabled = true;
                }
            }
        }

        function guardarCambios() {
            if (cambiosPendientes.size === 0) {
                mostrarToast("No hay cambios para guardar", "info");
                return;
            }

            const btnGuardar = document.getElementById('btnGuardar');
            btnGuardar.disabled = true;
            btnGuardar.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Guardando...';

            let guardados = 0;
            let errores = 0;
            const total = cambiosPendientes.size;

            cambiosPendientes.forEach((valor, paramKey) => {
                $.ajax({
                    type: "POST",
                    url: "appParams.aspx/GuardarParametro",
                    data: JSON.stringify({ 
                        paramKey: paramKey, 
                        paramValue: valor 
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function(response) {
                        // Verificar si response.d es un string que necesita ser parseado
                        let responseData = response.d;
                        if (typeof responseData === 'string') {
                            responseData = JSON.parse(responseData);
                        }
                        
                        if (responseData && responseData.Resultado === "SUCCESS") {
                            guardados++;
                            // Actualizar el valor original
                            const input = document.querySelector(`[data-param-key="${paramKey}"]`);
                            if (input) {
                                input.setAttribute('data-original-value', valor);
                                input.classList.remove('changed');
                            }
                        } else {
                            errores++;
                        }
                        
                        // Verificar si terminaron todos
                        if (guardados + errores === total) {
                            if (errores === 0) {
                                mostrarToast(`${guardados} parámetros guardados exitosamente`, "success");
                                cambiosPendientes.clear();
                            } else {
                                mostrarToast(`${guardados} guardados, ${errores} errores`, "error");
                            }
                            
                            btnGuardar.innerHTML = '<i class="fas fa-save me-2"></i>Guardar Cambios';
                            btnGuardar.disabled = cambiosPendientes.size === 0;
                        }
                    },
                    error: function(xhr, status, error) {
                        errores++;
                        console.error("Error guardando parámetro:", error);
                        
                        if (guardados + errores === total) {
                            mostrarToast(`${guardados} guardados, ${errores} errores`, "error");
                            btnGuardar.innerHTML = '<i class="fas fa-save me-2"></i>Guardar Cambios';
                            btnGuardar.disabled = cambiosPendientes.size === 0;
                        }
                    }
                });
            });
        }

        function mostrarLoading(mostrar) {
            const spinner = document.getElementById('loadingSpinner');
            const container = document.getElementById('parametrosContainer');
            
            if (mostrar) {
                spinner.style.display = 'block';
                container.style.display = 'none';
            } else {
                spinner.style.display = 'none';
                container.style.display = 'block';
            }
        }

        function mostrarToast(mensaje, tipo = "success") {
            const toastContainer = document.getElementById('toastContainer');
            const toast = document.createElement('div');
            toast.className = `toast ${tipo === "error" ? "error" : ""}`;
            toast.innerHTML = `
                <i class="fas ${tipo === "error" ? "fa-exclamation-circle" : "fa-check-circle"} me-2"></i>
                ${mensaje}
            `;
            
            toastContainer.appendChild(toast);
            
            // Mostrar toast
            setTimeout(() => toast.classList.add('show'), 100);
            
            // Ocultar y remover toast después de 3 segundos
            setTimeout(() => {
                toast.classList.remove('show');
                setTimeout(() => {
                    if (toast.parentNode) {
                        toast.parentNode.removeChild(toast);
                    }
                }, 300);
            }, 3000);
        }

        function mostrarError(mensaje) {
            const tbody = document.getElementById('parametrosBody');
            tbody.innerHTML = `
                <tr>
                    <td colspan="3" style="text-align: center; color: #dc3545; padding: 20px;">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        ${mensaje}
                    </td>
                </tr>
            `;
        }
    </script>
</body>
</html>