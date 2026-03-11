<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="procesosTecnicos.aspx.vb" Inherits="SemgaWapp.procesosTecnicos" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Manual</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet"/>
    
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
            padding: 15px 20px;
            border-radius: 6px;
            margin-bottom: 20px;
        }
        
        .sidebar-menu {
            background: #ffffff;
            border: 1px solid #e9ecef;
            border-radius: 6px;
            padding: 15px;
            height: calc(100vh - 200px);
            max-height: calc(100vh - 200px);
            overflow-y: auto;
            transition: all 0.3s ease;
        }
        
        .sidebar-menu.collapsed {
            display: none;
        }
        
        .sidebar-toggle {
            background: #2c3e50;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 4px;
            cursor: pointer;
            margin-bottom: 10px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
        }
        
        .sidebar-toggle:hover {
            background: #34495e;
            transform: translateX(-2px);
        }
        
        .sidebar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .sidebar-menu .list-group-item {
            cursor: pointer;
            border: 1px solid #e9ecef;
            margin-bottom: 5px;
            border-radius: 4px;
            padding: 10px 15px;
            transition: all 0.2s;
        }
        
        .sidebar-menu .list-group-item:hover {
            background-color: #f8f9fa;
            border-color: #2c3e50;
            transform: translateX(5px);
        }
        
        .sidebar-menu .list-group-item.active {
            background-color: #2c3e50;
            border-color: #2c3e50;
            color: white;
        }
        
        #sidebarContainer.collapsed {
            display: none;
        }
        
        #contentContainer.expanded {
            width: 100%;
        }
        
        .content-area {
            background: #ffffff;
            border: 1px solid #e9ecef;
            border-radius: 6px;
            padding: 20px;
            height: calc(100vh - 250px);
            max-height: calc(100vh - 250px);
            overflow-y: auto;
            overflow-x: hidden;
        }
        
        body {
            overflow-x: hidden;
        }
        
        html {
            overflow-x: hidden;
        }
        
        .process-section {
            border: 1px solid #e9ecef;
            border-radius: 6px;
            padding: 20px;
            margin-bottom: 20px;
            background: #ffffff;
        }
        
        .process-section h4 {
            color: #2c3e50;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #2c3e50;
        }
        
        .process-section h5 {
            color: #34495e;
            margin-top: 20px;
            margin-bottom: 10px;
        }
        
        .code-block {
            background: #282c34;
            color: #abb2bf;
            padding: 15px;
            border-radius: 6px;
            font-family: 'Courier New', monospace;
            font-size: 12px;
            overflow-x: auto;
            white-space: pre-wrap;
            word-wrap: break-word;
            max-height: 400px;
            overflow-y: auto;
            border: 1px solid #3e4451;
            margin-top: 10px;
        }
        
        .flow-diagram {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 6px;
            border-left: 4px solid #2c3e50;
            margin: 15px 0;
        }
        
        .flow-step {
            padding: 10px;
            margin: 5px 0;
            background: white;
            border-radius: 4px;
            border-left: 3px solid #28a745;
        }
        
        .flow-step.validation {
            border-left-color: #ffc107;
        }
        
        .flow-step.error {
            border-left-color: #dc3545;
        }
        
        .flow-step.database {
            border-left-color: #17a2b8;
        }
        
        .badge-client {
            background: #28a745;
            color: white;
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 11px;
        }
        
        .badge-server {
            background: #dc3545;
            color: white;
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 11px;
        }
        
        .badge-database {
            background: #17a2b8;
            color: white;
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 11px;
        }
        
        .badge-sp {
            background: #dc3545;
            color: white;
            padding: 5px 10px;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.2s ease;
            display: inline-block;
        }
        
        .badge-sp:hover {
            background: #c82333;
            transform: scale(1.05);
            box-shadow: 0 2px 4px rgba(220, 53, 69, 0.3);
        }
        
        .badge-table {
            background: #6c757d;
            color: white;
            padding: 5px 10px;
            border-radius: 4px;
        }
        
        .badge-function {
            background: #ffc107;
            color: #212529;
            padding: 5px 10px;
            border-radius: 4px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            display: inline-block;
        }
        
        .badge-function:hover {
            background: #e0a800;
            transform: scale(1.05);
            box-shadow: 0 2px 4px rgba(255, 193, 7, 0.3);
        }
        
        .badge-trigger {
            background: #9b59b6;
            color: white;
            padding: 5px 10px;
            border-radius: 4px;
        }
        
        .object-list {
            list-style: none;
            padding: 0;
        }
        
        .object-list li {
            padding: 8px;
            margin: 5px 0;
            background: #f8f9fa;
            border-radius: 4px;
            border-left: 3px solid #2c3e50;
        }
        
        .loading-spinner {
            text-align: center;
            padding: 40px;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }
        
        .empty-state i {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        /* Asegurar que el modal de tabla esté por encima del modal de SQL */
        #modalTablaEstructura {
            z-index: 1060 !important;
        }
        
        #modalTablaEstructura + .modal-backdrop {
            z-index: 1055 !important;
        }
        
        /* Estilo mejorado para el contenido de lógica */
        #sqlLogicContent {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        #sqlLogicContent code {
            font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
        }
        
        .tabs-container {
            margin-top: 20px;
        }
        
        .nav-tabs {
            position: sticky;
            top: 0;
            background: #ffffff;
            z-index: 1000;
            padding-top: 10px;
            margin-bottom: 0;
            border-bottom: 2px solid #dee2e6;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .nav-tabs .nav-link {
            color: #2c3e50;
            border: 1px solid #dee2e6;
            border-bottom: none;
            margin-bottom: -2px;
        }
        
        .nav-tabs .nav-link.active {
            background: #2c3e50;
            color: white;
            border-color: #2c3e50;
            border-bottom-color: #2c3e50;
        }
        
        .tab-content {
            padding: 20px;
            border: 1px solid #dee2e6;
            border-top: none;
            border-radius: 0 0 6px 6px;
            margin-top: 0;
            position: relative;
            z-index: 1;
        }
        
        .btn-ver-def {
            margin-left: 10px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="main-container">
            <!-- Header -->
            <div class="header-section d-flex justify-content-between align-items-center">
                <h4 class="mb-0"><i class="fas fa-cogs"></i> Manual de Procesos Técnicos</h4>
                <a href="helpDashboard.aspx" class="btn btn-secondary btn-sm">
                    <i class="fas fa-arrow-left"></i> Volver
                </a>
            </div>
            
            <!-- Main Content -->
            <div class="row">
                <!-- Sidebar - Lista de Formularios -->
                <div class="col-md-3" id="sidebarContainer">
                    <div class="sidebar-menu">
                        <div class="sidebar-header">
                            <h6 class="mb-0"><i class="fas fa-list"></i> Formularios del Sistema</h6>
                            <button type="button" class="btn btn-sm sidebar-toggle" id="btnToggleSidebar" title="Ocultar menú">
                                <i class="fas fa-chevron-left"></i>
                            </button>
                        </div>
                        <div id="listaFormularios" class="list-group">
                            <div class="loading-spinner">
                                <div class="spinner-border text-primary" role="status">
                                    <span class="visually-hidden">Cargando...</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Content Area -->
                <div class="col-md-9" id="contentContainer">
                    <button type="button" class="btn btn-sm sidebar-toggle" id="btnShowSidebar" style="display: none; margin-bottom: 10px;" title="Mostrar menú">
                        <i class="fas fa-chevron-right"></i> Mostrar Menú
                    </button>
                    <div class="content-area-wrapper">
                        <div class="content-area">
                            <div class="empty-state">
                                <i class="fas fa-hand-pointer"></i>
                                <h5>Selecciona un formulario</h5>
                                <p>Selecciona un formulario del menú lateral para ver su documentación técnica completa</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <!-- Modal para Ver Estructura de Tabla -->
    <div class="modal fade" id="modalTablaEstructura" tabindex="-1" aria-labelledby="modalTablaEstructuraLabel" aria-hidden="true" style="z-index: 1060;">
        <div class="modal-dialog modal-lg modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header" style="background: #2c3e50; color: white;">
                    <h5 class="modal-title" id="modalTablaEstructuraLabel"><i class="fas fa-table"></i> Estructura de <span id="modalTablaEstructuraNombre"></span></h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="tablaEstructuraContent" style="max-height: 500px; overflow-y: auto;">
                        <div class="text-center">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Cargando...</span>
                            </div>
                            <p class="mt-2">Cargando estructura de tabla...</p>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal para Ver SQL -->
    <div class="modal fade" id="modalSQL" tabindex="-1" aria-labelledby="modalSQLLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header" style="background: #2c3e50; color: white;">
                    <h5 class="modal-title" id="modalSQLLabel"><i class="fas fa-code"></i> <span id="modalSQLNombreObjeto"></span></h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <strong>Tipo:</strong> <span id="sqlTypeBadge" class="badge"></span>
                    </div>
                    
                    <!-- Pestañas -->
                    <ul class="nav nav-tabs" id="sqlModalTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="codigo-tab" data-bs-toggle="tab" data-bs-target="#codigo-pane" type="button" role="tab" aria-controls="codigo-pane" aria-selected="true">
                                <i class="fas fa-code"></i> Código
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="logica-tab" data-bs-toggle="tab" data-bs-target="#logica-pane" type="button" role="tab" aria-controls="logica-pane" aria-selected="false">
                                <i class="fas fa-brain"></i> Lógica
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="dependencias-tab" data-bs-toggle="tab" data-bs-target="#dependencias-pane" type="button" role="tab" aria-controls="dependencias-pane" aria-selected="false">
                                <i class="fas fa-link"></i> Dependencias
                            </button>
                        </li>
                    </ul>
                    
                    <!-- Contenido de pestañas -->
                    <div class="tab-content" id="sqlModalTabContent">
                        <div class="tab-pane fade show active" id="codigo-pane" role="tabpanel" aria-labelledby="codigo-tab">
                            <div class="code-block" id="sqlDefinitionContent" style="max-height: 500px; overflow-y: auto; margin-top: 15px;"></div>
                        </div>
                        <div class="tab-pane fade" id="logica-pane" role="tabpanel" aria-labelledby="logica-tab">
                            <div id="sqlLogicContent" style="max-height: 500px; overflow-y: auto; margin-top: 15px; padding: 15px; background-color: #f8f9fa; border-radius: 4px; white-space: pre-wrap; font-family: inherit;">
                                <div class="text-center">
                                    <div class="spinner-border text-primary" role="status">
                                        <span class="visually-hidden">Cargando...</span>
                                    </div>
                                    <p class="mt-2">Cargando descripción...</p>
                                </div>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="dependencias-pane" role="tabpanel" aria-labelledby="dependencias-tab">
                            <div id="sqlDependenciasContent" style="max-height: 500px; overflow-y: auto; margin-top: 15px; padding: 15px;">
                                <div class="text-center">
                                    <div class="spinner-border text-primary" role="status">
                                        <span class="visually-hidden">Cargando...</span>
                                    </div>
                                    <p class="mt-2">Cargando dependencias...</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                    <button type="button" class="btn btn-success" id="btnEjecutarSQL" style="display: none;">
                        <i class="fas fa-play"></i> Ejecutar Consulta
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

    <script>
        let formularioActual = null;
        let rutaFormularioActual = null;

        $(document).ready(function() {
            cargarFormularios();
            
            // Manejar el cierre del modal de estructura de tabla para limpiar backdrops
            $('#modalTablaEstructura').on('hidden.bs.modal', function () {
                // Limpiar backdrops sobrantes correctamente
                setTimeout(function() {
                    const backdrops = $('.modal-backdrop');
                    const modalSQL = $('#modalSQL');
                    const isSQLModalOpen = modalSQL.hasClass('show');
                    
                    if (!isSQLModalOpen) {
                        // Si el modal SQL no está abierto, limpiar todos los backdrops
                        backdrops.remove();
                        $('body').removeClass('modal-open').css('padding-right', '');
                    } else if (backdrops.length > 1) {
                        // Si hay más de un backdrop y el SQL está abierto, eliminar solo el último
                        backdrops.last().remove();
                    }
                }, 50);
            });
            
            // Toggle sidebar
            $('#btnToggleSidebar').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                toggleSidebar();
                return false;
            });
            
            $('#btnShowSidebar').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                toggleSidebar();
                return false;
            });
            
            // Delegación de eventos para items del menú dinámico
            $(document).on('click', '#listaFormularios .list-group-item', function(e) {
                e.preventDefault();
                e.stopPropagation();
                const item = $(this);
                
                // Cambiar iconos: cerrar todos los folders y abrir el seleccionado
                $('#listaFormularios .list-group-item').each(function() {
                    const icon = $(this).find('i');
                    if ($(this).hasClass('active')) {
                        icon.removeClass('fa-folder-open').addClass('fa-folder');
                    }
                });
                
                // Remover active de todos y agregar al seleccionado
                item.siblings().removeClass('active');
                item.addClass('active');
                
                // Abrir folder del item seleccionado
                const icon = item.find('i');
                icon.removeClass('fa-folder').addClass('fa-folder-open');
                
                const formulario = item.data('formulario');
                if (formulario) {
                    const contentWrapper = $("#contentContainer .content-area-wrapper");
                    if (contentWrapper.length > 0) {
                        contentWrapper.scrollTop(0);
                    } else {
                        const contentArea = $("#contentContainer .content-area");
                        contentArea.scrollTop(0);
                    }
                    cargarProcesosTecnicos(formulario.Nombre, formulario.Ruta);
                }
                return false;
            });
        });
        
        function toggleSidebar() {
            const sidebar = $('#sidebarContainer');
            const content = $('#contentContainer');
            const btnToggle = $('#btnToggleSidebar');
            const btnShow = $('#btnShowSidebar');
            
            sidebar.toggleClass('collapsed');
            content.toggleClass('expanded');
            
            if (sidebar.hasClass('collapsed')) {
                content.removeClass('col-md-9').addClass('col-md-12');
                btnShow.show();
            } else {
                content.removeClass('col-md-12').addClass('col-md-9');
                btnShow.hide();
            }
        }

        function cargarFormularios() {
            $.ajax({
                type: "POST",
                url: "procesosTecnicos.aspx/ObtenerListaFormularios",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: "{}",
                success: function(response) {
                    try {
                        let respuesta = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        
                        if (respuesta && respuesta.Resultado === "SUCCESS") {
                            const formularios = JSON.parse(respuesta.Data);
                            mostrarFormularios(formularios);
                        } else {
                            mostrarError(respuesta ? (respuesta.Mensaje || "Error desconocido") : "Error al procesar respuesta del servidor");
                        }
                    } catch (e) {
                        console.error("Error al procesar respuesta:", e, response);
                        mostrarError("Error al procesar respuesta: " + e.message);
                    }
                },
                error: function(xhr, status, error) {
                    console.error("Error AJAX:", xhr, status, error);
                    mostrarError("Error al cargar formularios: " + error);
                }
            });
        }

        function mostrarFormularios(formularios) {
            const lista = $("#listaFormularios");
            lista.empty();

            if (formularios.length === 0) {
                lista.html('<div class="empty-state"><p>No se encontraron formularios</p></div>');
                return;
            }

            formularios.forEach(function(formulario) {
                const item = $('<a href="#" class="list-group-item list-group-item-action">' +
                    '<i class="fas fa-folder me-2"></i>' + formulario.Nombre +
                    '</a>');
                item.data('formulario', formulario);
                lista.append(item);
            });
        }

        function cargarProcesosTecnicos(nombreFormulario, rutaFormulario) {
            formularioActual = nombreFormulario;
            rutaFormularioActual = rutaFormulario;
            
            $.ajax({
                type: "POST",
                url: "procesosTecnicos.aspx/ObtenerProcesosTecnicos",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ rutaFormulario: rutaFormulario }),
                success: function(response) {
                    try {
                        let respuesta = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        
                        if (respuesta && respuesta.Resultado === "SUCCESS") {
                            const procesos = JSON.parse(respuesta.Data);
                            mostrarProcesosTecnicos(procesos, nombreFormulario, rutaFormulario);
                            setTimeout(function() {
                                const contentWrapper = $("#contentContainer .content-area-wrapper");
                                if (contentWrapper.length > 0) {
                                    contentWrapper.scrollTop(0);
                                } else {
                                    const contentArea = $("#contentContainer .content-area");
                                    if (contentArea.length > 0) {
                                        contentArea.scrollTop(0);
                                    }
                                }
                            }, 100);
                        } else {
                            mostrarError(respuesta ? (respuesta.Mensaje || "Error desconocido") : "Error al procesar respuesta del servidor");
                        }
                    } catch (e) {
                        console.error("Error al procesar respuesta:", e, response);
                        mostrarError("Error al procesar respuesta: " + e.message);
                    }
                },
                error: function(xhr, status, error) {
                    console.error("Error AJAX:", xhr, status, error);
                    mostrarError("Error al cargar procesos técnicos: " + error);
                }
            });
        }

        function mostrarProcesosTecnicos(procesos, nombreFormulario, rutaFormulario) {
            const contentWrapper = $("#contentContainer .content-area-wrapper");
            let contentElement;
            
            if (contentWrapper.length === 0) {
                contentElement = $("#contentContainer .content-area");
                contentElement.empty();
                mostrarProcesosEnContenedor(contentElement, procesos, nombreFormulario, rutaFormulario);
                contentElement.scrollTop(0);
            } else {
                contentElement = contentWrapper.find('.content-area');
                if (contentElement.length === 0) {
                    contentWrapper.html('<div class="content-area"></div>');
                    contentElement = contentWrapper.find('.content-area');
                }
                contentElement.empty();
                mostrarProcesosEnContenedor(contentElement, procesos, nombreFormulario, rutaFormulario);
                contentWrapper.scrollTop(0);
            }
        }
        
        function mostrarProcesosEnContenedor(content, procesos, nombreFormulario, rutaFormulario) {
            // Encabezado
            const headerSection = $('<div class="mb-4"></div>');
            const title = $('<h3 class="mb-2"><i class="fas fa-file-code"></i> ' + nombreFormulario + '</h3>');
            const rutaInfo = $('<div class="text-muted mb-3" style="font-size: 13px; background: #f8f9fa; padding: 10px; border-radius: 4px; border-left: 3px solid #2c3e50;">' +
                '<i class="fas fa-folder-open me-2"></i><strong>Ruta:</strong> ' +
                '<code style="background: white; padding: 2px 6px; border-radius: 3px; font-size: 12px;">' + rutaFormulario + '</code>' +
                '</div>');
            
            headerSection.append(title);
            headerSection.append(rutaInfo);
            content.append(headerSection);

            // Tabs para diferentes secciones
            const tabsContainer = $('<div class="tabs-container"></div>');
            const navTabs = $('<ul class="nav nav-tabs" id="procesosTabs" role="tablist"></ul>');
            const tabContent = $('<div class="tab-content" id="procesosTabContent"></div>');

            // Tab: Flujo de Procesos
            navTabs.append('<li class="nav-item" role="presentation">' +
                '<button class="nav-link active" id="flujo-tab" data-bs-toggle="tab" data-bs-target="#flujo" type="button" role="tab">' +
                '<i class="fas fa-project-diagram"></i> Flujo de Procesos</button></li>');

            // Tab: Lógica Cliente
            navTabs.append('<li class="nav-item" role="presentation">' +
                '<button class="nav-link" id="cliente-tab" data-bs-toggle="tab" data-bs-target="#cliente" type="button" role="tab">' +
                '<i class="fas fa-code"></i> Lógica Cliente (JavaScript)</button></li>');

            // Tab: Lógica Servidor
            navTabs.append('<li class="nav-item" role="presentation">' +
                '<button class="nav-link" id="servidor-tab" data-bs-toggle="tab" data-bs-target="#servidor" type="button" role="tab">' +
                '<i class="fas fa-server"></i> Lógica Servidor (VB.NET)</button></li>');

            // Tab: Base de Datos
            navTabs.append('<li class="nav-item" role="presentation">' +
                '<button class="nav-link" id="database-tab" data-bs-toggle="tab" data-bs-target="#database" type="button" role="tab">' +
                '<i class="fas fa-database"></i> Base de Datos</button></li>');

            tabsContainer.append(navTabs);

            // Contenido de tabs
            // Tab Flujo de Procesos
            const flujoTab = $('<div class="tab-pane fade show active" id="flujo" role="tabpanel"></div>');
            if (procesos.FlujoProcesos && procesos.FlujoProcesos.length > 0) {
                procesos.FlujoProcesos.forEach(function(proceso) {
                    const procesoSection = crearSeccionFlujo(proceso);
                    flujoTab.append(procesoSection);
                });
            } else {
                flujoTab.append('<div class="empty-state"><p>No hay flujos de procesos documentados</p></div>');
            }
            tabContent.append(flujoTab);

            // Tab Lógica Cliente
            const clienteTab = $('<div class="tab-pane fade" id="cliente" role="tabpanel"></div>');
            if (procesos.LogicaCliente && procesos.LogicaCliente.length > 0) {
                procesos.LogicaCliente.forEach(function(logica) {
                    const logicaSection = crearSeccionLogicaCliente(logica);
                    clienteTab.append(logicaSection);
                });
            } else {
                clienteTab.append('<div class="empty-state"><p>No hay lógica de cliente documentada</p></div>');
            }
            tabContent.append(clienteTab);

            // Tab Lógica Servidor
            const servidorTab = $('<div class="tab-pane fade" id="servidor" role="tabpanel"></div>');
            if (procesos.LogicaServidor && procesos.LogicaServidor.length > 0) {
                procesos.LogicaServidor.forEach(function(logica) {
                    const logicaSection = crearSeccionLogicaServidor(logica);
                    servidorTab.append(logicaSection);
                });
            } else {
                servidorTab.append('<div class="empty-state"><p>No hay lógica de servidor documentada</p></div>');
            }
            tabContent.append(servidorTab);

            // Tab Base de Datos
            const databaseTab = $('<div class="tab-pane fade" id="database" role="tabpanel"></div>');
            if (procesos.BaseDatos) {
                const dbSection = crearSeccionBaseDatos(procesos.BaseDatos);
                databaseTab.append(dbSection);
            } else {
                databaseTab.append('<div class="empty-state"><p>No hay información de base de datos documentada</p></div>');
            }
            tabContent.append(databaseTab);

            tabsContainer.append(tabContent);
            content.append(tabsContainer);
        }

        function crearSeccionFlujo(proceso) {
            const section = $('<div class="process-section"></div>');
            section.append('<h4><i class="fas fa-sitemap"></i> ' + proceso.Nombre + '</h4>');
            
            if (proceso.Descripcion) {
                section.append('<p>' + proceso.Descripcion + '</p>');
            }

            const flowDiagram = $('<div class="flow-diagram"></div>');
            if (proceso.Pasos && proceso.Pasos.length > 0) {
                proceso.Pasos.forEach(function(paso, index) {
                    let stepClass = 'flow-step';
                    if (paso.Tipo === 'validacion') stepClass += ' validation';
                    else if (paso.Tipo === 'error') stepClass += ' error';
                    else if (paso.Tipo === 'database') stepClass += ' database';
                    
                    const step = $('<div class="' + stepClass + '"></div>');
                    step.append('<strong>' + (index + 1) + '. ' + paso.Nombre + '</strong>');
                    if (paso.Descripcion) {
                        step.append('<p class="mb-0 mt-2">' + paso.Descripcion + '</p>');
                    }
                    if (paso.ObjetosBD && paso.ObjetosBD.length > 0) {
                        const objetosList = $('<ul class="object-list mt-2"></ul>');
                        paso.ObjetosBD.forEach(function(obj) {
                            let badge = '';
                            if (obj.Tipo === 'SP') badge = '<span class="badge-sp">SP</span>';
                            else if (obj.Tipo === 'TABLE') badge = '<span class="badge-table">TABLE</span>';
                            else if (obj.Tipo === 'FUNCTION') badge = '<span class="badge-function">FUNCTION</span>';
                            else if (obj.Tipo === 'TRIGGER') badge = '<span class="badge-trigger">TRIGGER</span>';
                            
                            objetosList.append('<li>' + badge + ' <code>' + obj.Nombre + '</code></li>');
                        });
                        step.append(objetosList);
                    }
                    flowDiagram.append(step);
                });
            }
            section.append(flowDiagram);

            return section;
        }

        function crearSeccionLogicaCliente(logica) {
            const section = $('<div class="process-section"></div>');
            section.append('<h4><span class="badge-client">CLIENTE</span> ' + logica.Nombre + '</h4>');
            
            if (logica.Proceso) {
                section.append('<div class="flow-diagram"><div class="flow-step"><p>' + logica.Proceso + '</p></div></div>');
            } else if (logica.Descripcion) {
                section.append('<div class="flow-diagram"><div class="flow-step"><p>' + logica.Descripcion + '</p></div></div>');
            }

            if (logica.Eventos && logica.Eventos.length > 0) {
                section.append('<h5>Eventos asociados:</h5>');
                const eventosList = $('<ul></ul>');
                logica.Eventos.forEach(function(evento) {
                    eventosList.append('<li>' + evento + '</li>');
                });
                section.append(eventosList);
            }

            return section;
        }

        function crearSeccionLogicaServidor(logica) {
            const section = $('<div class="process-section"></div>');
            section.append('<h4><span class="badge-server">SERVIDOR</span> ' + logica.Nombre + '</h4>');
            
            if (logica.Proceso) {
                section.append('<div class="flow-diagram"><div class="flow-step"><p>' + logica.Proceso + '</p></div></div>');
            } else if (logica.Descripcion) {
                section.append('<div class="flow-diagram"><div class="flow-step"><p>' + logica.Descripcion + '</p></div></div>');
            }

            if (logica.Validaciones && logica.Validaciones.length > 0) {
                section.append('<h5>Validaciones realizadas:</h5>');
                const validacionesList = $('<ul></ul>');
                logica.Validaciones.forEach(function(validacion) {
                    validacionesList.append('<li>' + validacion + '</li>');
                });
                section.append(validacionesList);
            }

            if (logica.ObjetosBD && logica.ObjetosBD.length > 0) {
                section.append('<h5>Objetos de Base de Datos Utilizados:</h5>');
                const objetosList = $('<ul class="object-list"></ul>');
                logica.ObjetosBD.forEach(function(obj) {
                    let badge = '';
                    let badgeClass = '';
                    if (obj.Tipo === 'SP') {
                        badgeClass = 'badge-sp';
                        badge = '<span class="' + badgeClass + '" data-nombre="' + obj.Nombre + '" data-tipo="SP" title="Click para ver definición" style="cursor: pointer;">SP</span>';
                    }
                    else if (obj.Tipo === 'TABLE') {
                        badgeClass = 'badge-table';
                        badge = '<span class="' + badgeClass + '" data-nombre="' + obj.Nombre + '" data-tipo="TABLE" title="Click para ver definición" style="cursor: pointer;">TABLE</span>';
                    }
                    else if (obj.Tipo === 'FUNCTION') {
                        badgeClass = 'badge-function';
                        badge = '<span class="' + badgeClass + '" data-nombre="' + obj.Nombre + '" data-tipo="FUNCTION" title="Click para ver definición" style="cursor: pointer;">FUNCTION</span>';
                    }
                    else if (obj.Tipo === 'TRIGGER') {
                        badgeClass = 'badge-trigger';
                        badge = '<span class="' + badgeClass + '">TRIGGER</span>';
                    }
                    
                    objetosList.append('<li>' + badge + ' <code>' + obj.Nombre + '</code></li>');
                });
                section.append(objetosList);
                
                // Agregar event handler para badges clicables
                section.find('.badge-sp, .badge-function, .badge-table').on('click', function() {
                    const nombre = $(this).data('nombre');
                    const tipo = $(this).data('tipo');
                    verDefinicionSQL(nombre, tipo);
                });
            }

            return section;
        }

        function crearSeccionBaseDatos(baseDatos) {
            const section = $('<div class="process-section"></div>');
            section.append('<h4><i class="fas fa-database"></i> Objetos de Base de Datos</h4>');

            // Stored Procedures
            if (baseDatos.StoredProcedures && baseDatos.StoredProcedures.length > 0) {
                section.append('<h5>Stored Procedures:</h5>');
                const spList = $('<ul class="object-list"></ul>');
                baseDatos.StoredProcedures.forEach(function(sp) {
                    const li = $('<li></li>');
                    const badgeSP = $('<span class="badge-sp" data-nombre="' + sp.Nombre + '" data-tipo="SP" title="Click para ver definición">SP</span>');
                    li.append(badgeSP);
                    li.append(' <code>' + sp.Nombre + '</code>');
                    spList.append(li);
                });
                section.append(spList);
            }

            // Tablas
            if (baseDatos.Tablas && baseDatos.Tablas.length > 0) {
                section.append('<h5>Tablas:</h5>');
                const tablasList = $('<ul class="object-list"></ul>');
                baseDatos.Tablas.forEach(function(tabla) {
                    tablasList.append('<li><span class="badge-table">TABLE</span> <code>' + tabla.Nombre + '</code> - ' + (tabla.Descripcion || '') + '</li>');
                });
                section.append(tablasList);
            }

            // Funciones
            if (baseDatos.Funciones && baseDatos.Funciones.length > 0) {
                section.append('<h5>Funciones:</h5>');
                const funcionesList = $('<ul class="object-list"></ul>');
                baseDatos.Funciones.forEach(function(funcion) {
                    const li = $('<li></li>');
                    const badgeFunc = $('<span class="badge-function" data-nombre="' + funcion.Nombre + '" data-tipo="FUNCTION" title="Click para ver definición" style="cursor: pointer;">FUNCTION</span>');
                    li.append(badgeFunc);
                    li.append(' <code>' + funcion.Nombre + '</code>');
                    if (funcion.Descripcion) {
                        li.append(' - ' + funcion.Descripcion);
                    }
                    funcionesList.append(li);
                });
                section.append(funcionesList);
            }

            // Triggers
            if (baseDatos.Triggers && baseDatos.Triggers.length > 0) {
                section.append('<h5>Triggers:</h5>');
                const triggersList = $('<ul class="object-list"></ul>');
                baseDatos.Triggers.forEach(function(trigger) {
                    const li = $('<li></li>');
                    li.append('<span class="badge-trigger">TRIGGER</span> <code>' + trigger.Nombre + '</code> en tabla <code>' + trigger.Tabla + '</code>');
                    if (trigger.Descripcion) {
                        li.append(' - ' + trigger.Descripcion);
                    }
                    triggersList.append(li);
                });
                section.append(triggersList);
            }

            // Event handler para badges clicables
            section.find('.badge-sp, .badge-function, .badge-table').on('click', function() {
                const nombre = $(this).data('nombre');
                const tipo = $(this).data('tipo');
                if (nombre && tipo) {
                    verDefinicionSQL(nombre, tipo);
                }
            });

            return section;
        }
        
        function verDefinicionSQL(nombreObjeto, tipo) {
            // Establecer nombre del objeto en el modal
            $("#modalSQLNombreObjeto").text(nombreObjeto);
            
            // Resetear pestañas - mostrar Código por defecto
            $("#codigo-tab").tab('show');
            $("#sqlLogicContent").html('<div class="text-center"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Cargando...</span></div><p class="mt-2">Cargando descripción...</p></div>');
            $("#sqlDependenciasContent").html('<div class="text-center"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Cargando...</span></div><p class="mt-2">Cargando dependencias...</p></div>');
            
            // Cargar código SQL
            $.ajax({
                type: "POST",
                url: "procesosTecnicos.aspx/ObtenerDefinicionSQL",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ 
                    nombreObjeto: nombreObjeto, 
                    tipo: tipo 
                }),
                success: function(response) {
                    try {
                        let respuesta = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        
                        if (respuesta && respuesta.Resultado === "SUCCESS") {
                            const definicion = respuesta.Data;
                            $("#sqlDefinitionContent").text(definicion);
                            $("#sqlTypeBadge").text(tipo);
                            $("#sqlTypeBadge").removeClass().addClass("badge badge-sp");
                            
                            // Cargar descripción lógica
                            cargarDescripcionLogica(nombreObjeto, tipo);
                            
                            $("#modalSQL").modal('show');
                        } else {
                            mostrarError(respuesta ? (respuesta.Mensaje || "Error desconocido") : "Error al procesar respuesta del servidor");
                        }
                    } catch (e) {
                        console.error("Error al procesar respuesta:", e, response);
                        mostrarError("Error al procesar respuesta: " + e.message);
                    }
                },
                error: function(xhr, status, error) {
                    console.error("Error AJAX:", xhr, status, error);
                    mostrarError("Error al obtener definición: " + error);
                }
            });
        }
        
        function cargarDescripcionLogica(nombreObjeto, tipo) {
            $.ajax({
                type: "POST",
                url: "procesosTecnicos.aspx/ObtenerDescripcionLogica",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ 
                    nombreObjeto: nombreObjeto, 
                    tipoObjeto: tipo 
                }),
                success: function(response) {
                    try {
                        let respuesta = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        
                        if (respuesta && respuesta.Resultado === "SUCCESS") {
                            const descripcionHTML = respuesta.Data.Descripcion || "<p class='text-muted'>No hay descripción disponible para este objeto.</p>";
                            const spsLlamados = respuesta.Data.SPsLlamados || "";
                            
                            // Renderizar directamente el HTML almacenado en la BD
                            $("#sqlLogicContent").html(descripcionHTML);
                            
                            // Cargar dependencias en la pestaña correspondiente
                            cargarDependencias(nombreObjeto, tipo, spsLlamados, respuesta.Data.TablasUtilizadas || "");
                        } else {
                            $("#sqlLogicContent").html('<p class="text-muted">No hay descripción disponible para este objeto.</p>');
                        }
                    } catch (e) {
                        console.error("Error al procesar respuesta de lógica:", e, response);
                        $("#sqlLogicContent").html('<p class="text-danger">Error al cargar la descripción.</p>');
                    }
                },
                error: function(xhr, status, error) {
                    console.error("Error AJAX al cargar lógica:", xhr, status, error);
                    $("#sqlLogicContent").html('<p class="text-danger">Error al cargar la descripción.</p>');
                }
            });
        }

        function cargarDependencias(nombreObjeto, tipo, spsLlamados, tablasUtilizadas) {
            let htmlContent = '<div style="line-height: 1.8;">';
            
            // Stored Procedures llamados
            if (spsLlamados && spsLlamados.trim() !== "") {
                htmlContent += '<div style="margin-bottom: 25px;">';
                htmlContent += '<h5><i class="fas fa-code-branch"></i> Stored Procedures Llamados</h5>';
                htmlContent += '<div style="padding: 10px; background-color: #f8f9fa; border-radius: 4px; border-left: 4px solid #dc3545;">';
                const spsArray = spsLlamados.split(',').map(s => s.trim()).filter(s => s !== "");
                spsArray.forEach(function(sp) {
                    htmlContent += '<span class="badge-sp" data-nombre="' + sp + '" data-tipo="SP" style="cursor: pointer; margin-right: 5px; margin-bottom: 5px;">SP</span> ';
                    htmlContent += '<code style="margin-right: 15px;">' + sp + '</code>';
                });
                htmlContent += '</div>';
                htmlContent += '</div>';
            } else {
                htmlContent += '<div style="margin-bottom: 25px;">';
                htmlContent += '<h5><i class="fas fa-code-branch"></i> Stored Procedures Llamados</h5>';
                htmlContent += '<p class="text-muted">Este objeto no llama a otros stored procedures.</p>';
                htmlContent += '</div>';
            }
            
            // Tablas utilizadas
            if (tablasUtilizadas && tablasUtilizadas.trim() !== "") {
                htmlContent += '<div style="margin-bottom: 25px;">';
                htmlContent += '<h5><i class="fas fa-table"></i> Tablas Utilizadas</h5>';
                htmlContent += '<div style="padding: 10px; background-color: #f8f9fa; border-radius: 4px; border-left: 4px solid #007bff;">';
                const tablasArray = tablasUtilizadas.split(',').map(t => t.trim()).filter(t => t !== "");
                tablasArray.forEach(function(tabla) {
                    // Determinar si es una vista o tabla
                    const esVista = tabla.toLowerCase().startsWith('vw');
                    const badgeClass = esVista ? 'badge-view' : 'badge-table';
                    const badgeText = esVista ? 'VIEW' : 'TABLE';
                    
                    htmlContent += '<span class="' + badgeClass + ' clickable-table" data-nombre-tabla="' + tabla + '" style="cursor: pointer; margin-right: 5px; margin-bottom: 5px;" title="Click para ver estructura">' + badgeText + '</span> ';
                    htmlContent += '<code class="clickable-table" data-nombre-tabla="' + tabla + '" style="cursor: pointer; margin-right: 15px; color: #e83e8c;" title="Click para ver estructura">' + tabla + '</code>';
                });
                htmlContent += '</div>';
                htmlContent += '</div>';
            } else {
                htmlContent += '<div style="margin-bottom: 25px;">';
                htmlContent += '<h5><i class="fas fa-table"></i> Tablas Utilizadas</h5>';
                htmlContent += '<p class="text-muted">No hay información de tablas utilizadas disponible.</p>';
                htmlContent += '</div>';
            }
            
            htmlContent += '</div>';
            $("#sqlDependenciasContent").html(htmlContent);
            
            // Agregar event handlers para los badges de SP
            $("#sqlDependenciasContent").find('.badge-sp').on('click', function() {
                const nombre = $(this).data('nombre');
                const tipoSP = $(this).data('tipo');
                if (nombre && tipoSP) {
                    verDefinicionSQL(nombre, tipoSP);
                }
            });
            
            // Agregar event handlers para las tablas (solo si no son vistas)
            $("#sqlDependenciasContent").find('.clickable-table').on('click', function() {
                const nombreTabla = $(this).data('nombre-tabla');
                if (nombreTabla && !nombreTabla.toLowerCase().startsWith('vw')) {
                    verEstructuraTabla(nombreTabla);
                }
            });
        }
        
        function verEstructuraTabla(nombreTabla) {
            $("#modalTablaEstructuraNombre").text(nombreTabla);
            $("#tablaEstructuraContent").html('<div class="text-center"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Cargando...</span></div><p class="mt-2">Cargando estructura...</p></div>');
            
            $.ajax({
                type: "POST",
                url: "procesosTecnicos.aspx/ObtenerEstructuraTabla",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ 
                    nombreTabla: nombreTabla
                }),
                success: function(response) {
                    try {
                        let respuesta = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        
                        if (respuesta && respuesta.Resultado === "SUCCESS") {
                            const columnas = respuesta.Data.Columnas || [];
                            
                            let htmlContent = '<table class="table table-striped table-bordered table-sm">';
                            htmlContent += '<thead class="table-dark">';
                            htmlContent += '<tr>';
                            htmlContent += '<th>Campo</th>';
                            htmlContent += '<th>Tipo de Dato</th>';
                            htmlContent += '<th>Permite Null</th>';
                            htmlContent += '<th>Valor por Defecto</th>';
                            htmlContent += '<th>Clave Primaria</th>';
                            htmlContent += '</tr>';
                            htmlContent += '</thead>';
                            htmlContent += '<tbody>';
                            
                            if (columnas.length > 0) {
                                columnas.forEach(function(col) {
                                    htmlContent += '<tr>';
                                    htmlContent += '<td><strong>' + col.NombreCampo + '</strong></td>';
                                    htmlContent += '<td><code>' + col.TipoDatoCompleto + '</code></td>';
                                    htmlContent += '<td>' + col.PermiteNull + '</td>';
                                    htmlContent += '<td><small>' + (col.ValorPorDefecto || '-') + '</small></td>';
                                    htmlContent += '<td>' + (col.EsClavePrimaria === 'Sí' ? '<span class="badge bg-primary">PK</span>' : '-') + '</td>';
                                    htmlContent += '</tr>';
                                });
                            } else {
                                htmlContent += '<tr><td colspan="5" class="text-center text-muted">No se encontraron columnas</td></tr>';
                            }
                            
                            htmlContent += '</tbody>';
                            htmlContent += '</table>';
                            
                            $("#tablaEstructuraContent").html(htmlContent);
                            // Asegurar que el modal de tabla esté por encima del modal de SQL
                            const modalTabla = $("#modalTablaEstructura");
                            modalTabla.css('z-index', '1060');
                            
                            // Mostrar el modal
                            const modalTablaBootstrap = new bootstrap.Modal(modalTabla[0], {
                                backdrop: true,
                                keyboard: true
                            });
                            modalTablaBootstrap.show();
                            
                            // Ajustar z-index del backdrop del modal de tabla después de que se muestre
                            setTimeout(function() {
                                const backdrops = $('.modal-backdrop');
                                if (backdrops.length > 1) {
                                    backdrops.last().css('z-index', '1055');
                                }
                            }, 100);
                        } else {
                            $("#tablaEstructuraContent").html('<p class="text-danger">Error: ' + (respuesta ? (respuesta.Mensaje || "Error desconocido") : "Error al procesar respuesta") + '</p>');
                        }
                    } catch (e) {
                        console.error("Error al procesar respuesta de estructura:", e, response);
                        $("#tablaEstructuraContent").html('<p class="text-danger">Error al cargar la estructura de la tabla.</p>');
                    }
                },
                error: function(xhr, status, error) {
                    console.error("Error AJAX al cargar estructura:", xhr, status, error);
                    $("#tablaEstructuraContent").html('<p class="text-danger">Error al cargar la estructura de la tabla.</p>');
                }
            });
        }
        
        
        function mostrarError(mensaje) {
            alert("Error: " + mensaje);
        }
    </script>
</body>
</html>
