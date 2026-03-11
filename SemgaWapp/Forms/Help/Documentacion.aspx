<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Documentacion.aspx.vb" Inherits="SemgaWapp.Documentacion" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Documentación</title>
    
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
            height: calc(100vh - 200px);
            max-height: calc(100vh - 200px);
            overflow-y: auto;
            overflow-x: hidden;
        }
        
        .method-card {
            border: 1px solid #e9ecef;
            border-radius: 6px;
            padding: 15px;
            margin-bottom: 15px;
            background: #f8f9fa;
        }
        
        .method-card h5 {
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .sql-definition {
            background: #282c34;
            color: #abb2bf;
            padding: 15px;
            border-radius: 6px;
            font-family: 'Courier New', monospace;
            font-size: 13px;
            overflow-x: auto;
            white-space: pre-wrap;
            word-wrap: break-word;
            max-height: 400px;
            overflow-y: auto;
            border: 1px solid #3e4451;
        }
        
        .results-table {
            margin-top: 15px;
        }
        
        .btn-primary {
            background: #2c3e50;
            border: 1px solid #2c3e50;
            border-radius: 4px;
            padding: 8px 16px;
            font-weight: 500;
        }
        
        .btn-primary:hover {
            background: #34495e;
            border-color: #34495e;
        }
        
        .btn-success {
            background: #28a745;
            border: 1px solid #28a745;
        }
        
        .badge-sp {
            background: #dc3545;
            color: white;
            padding: 5px 10px;
            border-radius: 4px;
        }
        
        .badge-select {
            background: #28a745;
            color: white;
            padding: 5px 10px;
            border-radius: 4px;
        }
        
        .badge-update {
            background: #ffc107;
            color: #212529;
            padding: 5px 10px;
            border-radius: 4px;
            font-weight: 600;
        }
        
        .badge-method {
            background: #6c757d;
            color: white;
            padding: 5px 10px;
            border-radius: 4px;
        }
        
        .badge-secondary {
            background: #6c757d;
            color: white;
            padding: 5px 10px;
            border-radius: 4px;
        }
        
        .badge-view {
            background: #17a2b8;
            color: white;
            padding: 5px 10px;
            border-radius: 4px;
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
        
        .breadcrumb {
            background: transparent;
            padding: 0;
            margin-bottom: 15px;
        }
        
        .table {
            font-size: 12px;
        }
        
        .table thead th {
            background: #34495e;
            color: white;
            border: none;
            font-weight: 600;
        }
        
        .search-in-sidebar {
            padding: 10px;
            border-bottom: 1px solid #dee2e6;
        }
        
        .search-in-sidebar .input-group {
            width: 100%;
        }
        
        .search-in-sidebar .form-control {
            border-radius: 4px 0 0 4px;
        }
        
        .search-in-sidebar .btn {
            border-radius: 0 4px 4px 0;
        }
        
        .search-results {
            margin-top: 20px;
        }
        
        .result-item {
            border-left: 4px solid #007bff;
            padding: 15px;
            margin-bottom: 15px;
            background: #f8f9fa;
            border-radius: 4px;
        }
        
        .result-item h6 {
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .result-item .method-list {
            margin-top: 10px;
        }
        
        .result-item .method-item {
            padding: 8px 12px;
            background: white;
            border-radius: 4px;
            margin-bottom: 8px;
            border-left: 3px solid #28a745;
        }
        
        .result-item .method-item strong {
            color: #2c3e50;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="main-container">
            <!-- Header -->
            <div class="header-section d-flex justify-content-between align-items-center">
                <h4 class="mb-0"><i class="fas fa-book"></i> Documentación de Sistema</h4>
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
                        <!-- Búsqueda de SP/Vista/Tabla -->
                        <div class="search-in-sidebar mb-2">
                            <div class="input-group">
                                <input type="text" class="form-control form-control-sm" id="txtBuscarSP" placeholder="SP, vista o tabla...">
                                <button type="button" class="btn btn-primary btn-sm" id="btnBuscarSP" title="Buscar">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
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
                                <h5>Búsqueda por objeto</h5>
                                <p>Utiliza el campo de búsqueda en el menú lateral para buscar SP, vista o tabla, o selecciona un formulario para ver sus métodos</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <!-- Modal para Ver SQL -->
    <div class="modal fade" id="modalSQL" tabindex="-1" aria-labelledby="modalSQLLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header" style="background: #2c3e50; color: white;">
                    <h5 class="modal-title" id="modalSQLLabel"><i class="fas fa-code"></i> Definición SQL</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <strong>Tipo:</strong> <span id="sqlTypeBadge" class="badge"></span>
                    </div>
                    <div class="sql-definition" id="sqlDefinitionContent"></div>
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

    <!-- Modal para Resultados -->
    <div class="modal fade" id="modalResultados" tabindex="-1" aria-labelledby="modalResultadosLabel" aria-hidden="true">
        <div class="modal-dialog modal-fullscreen">
            <div class="modal-content">
                <div class="modal-header" style="background: #28a745; color: white;">
                    <h5 class="modal-title" id="modalResultadosLabel"><i class="fas fa-table"></i> Resultados de la Consulta</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="resultadosContent"></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
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
            
            // Toggle sidebar
            $('#btnToggleSidebar').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                toggleSidebar();
                return false;
            });
            
            // Búsqueda de SP/Vista
            $('#btnBuscarSP').on('click', function() {
                buscarSPVista();
            });
            
            $('#txtBuscarSP').on('keypress', function(e) {
                if (e.which === 13) { // Enter
                    buscarSPVista();
                }
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
                        // Cerrar folder del item que estaba activo
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
                    // Scroll al inicio antes de cargar
                    const contentWrapper = $("#contentContainer .content-area-wrapper");
                    if (contentWrapper.length > 0) {
                        contentWrapper.scrollTop(0);
                    } else {
                        const contentArea = $("#contentContainer .content-area");
                        contentArea.scrollTop(0);
                    }
                    cargarMetodosFormulario(formulario.Nombre, formulario.Ruta);
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
                url: "Documentacion.aspx/ObtenerListaFormularios",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: "{}",
                success: function(response) {
                    try {
                        // Si response.d es un string, parsearlo primero
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
                    let errorMsg = "Error al cargar formularios: " + error;
                    if (xhr.responseText) {
                        try {
                            const errorResponse = JSON.parse(xhr.responseText);
                            if (errorResponse.Message) {
                                errorMsg = errorResponse.Message;
                            }
                        } catch (e) {
                            errorMsg += " | Respuesta: " + xhr.responseText.substring(0, 100);
                        }
                    }
                    mostrarError(errorMsg);
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

        function cargarMetodosFormulario(nombreFormulario, rutaFormulario) {
            formularioActual = nombreFormulario;
            rutaFormularioActual = rutaFormulario;
            
            $.ajax({
                type: "POST",
                url: "Documentacion.aspx/ObtenerMetodosFormulario",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ rutaFormulario: rutaFormulario }),
                success: function(response) {
                    try {
                        // Si response.d es un string, parsearlo primero
                        let respuesta = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        
                        if (respuesta && respuesta.Resultado === "SUCCESS") {
                            metodosCargados = JSON.parse(respuesta.Data);
                            mostrarMetodos(metodosCargados, nombreFormulario, rutaFormulario);
                            // Scroll al inicio después de cargar los métodos
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
                    let errorMsg = "Error al cargar métodos: " + error;
                    if (xhr.responseText) {
                        try {
                            const errorResponse = JSON.parse(xhr.responseText);
                            if (errorResponse.Message) {
                                errorMsg = errorResponse.Message;
                            }
                        } catch (e) {
                            errorMsg += " | Respuesta: " + xhr.responseText.substring(0, 100);
                        }
                    }
                    mostrarError(errorMsg);
                }
            });
        }

        let metodosCargados = [];
        let metodosBusqueda = []; // Para almacenar métodos de búsqueda

        function mostrarMetodos(metodos, nombreFormulario, rutaFormulario) {
            metodosCargados = metodos; // Guardar métodos globalmente
            const contentWrapper = $("#contentContainer .content-area-wrapper");
            let contentElement;
            
            if (contentWrapper.length === 0) {
                // Si no existe el wrapper, usar directamente content-area
                contentElement = $("#contentContainer .content-area");
                contentElement.empty();
                mostrarMetodosEnContenedor(contentElement, metodos, nombreFormulario, rutaFormulario);
                // Scroll al inicio
                contentElement.scrollTop(0);
            } else {
                contentElement = contentWrapper.find('.content-area');
                if (contentElement.length === 0) {
                    contentWrapper.html('<div class="content-area"></div>');
                    contentElement = contentWrapper.find('.content-area');
                }
                contentElement.empty();
                mostrarMetodosEnContenedor(contentElement, metodos, nombreFormulario, rutaFormulario);
                // Scroll al inicio del wrapper que contiene el scroll
                contentWrapper.scrollTop(0);
            }
        }
        
        function mostrarMetodosEnContenedor(content, metodos, nombreFormulario, rutaFormulario) {
            if (metodos.length === 0) {
                // Crear encabezado con nombre y ruta del formulario
                const headerSection = $('<div class="mb-4"></div>');
                const title = $('<h5 class="mb-2"><i class="fas fa-code"></i> Métodos de: ' + nombreFormulario + '</h5>');
                const rutaInfo = $('<div class="text-muted mb-3" style="font-size: 13px; background: #f8f9fa; padding: 10px; border-radius: 4px; border-left: 3px solid #2c3e50;">' +
                    '<i class="fas fa-folder-open me-2"></i><strong>Ruta del formulario:</strong> ' +
                    '<code style="background: white; padding: 2px 6px; border-radius: 3px; font-size: 12px;">' + rutaFormulario + '</code>' +
                    '</div>');
                
                headerSection.append(title);
                headerSection.append(rutaInfo);
                
                const emptyState = $('<div class="empty-state"></div>');
                emptyState.html('<i class="fas fa-folder-open"></i><h5>Formulario Menú</h5><p>Sin métodos definidos...</p>');
                
                content.append(headerSection);
                content.append(emptyState);
                return;
            }

            // Crear encabezado con nombre y ruta del formulario
            const headerSection = $('<div class="mb-4"></div>');
            const title = $('<h5 class="mb-2"><i class="fas fa-code"></i> Métodos de: ' + nombreFormulario + '</h5>');
            const rutaInfo = $('<div class="text-muted mb-3" style="font-size: 13px; background: #f8f9fa; padding: 10px; border-radius: 4px; border-left: 3px solid #2c3e50;">' +
                '<i class="fas fa-folder-open me-2"></i><strong>Ruta del formulario:</strong> ' +
                '<code style="background: white; padding: 2px 6px; border-radius: 3px; font-size: 12px;">' + rutaFormulario + '</code>' +
                '</div>');
            
            headerSection.append(title);
            headerSection.append(rutaInfo);
            content.append(headerSection);

            metodos.forEach(function(metodo, index) {
                const card = crearCardMetodo(metodo, index);
                content.append(card);
            });
        }

        function crearCardMetodo(metodo, index) {
            let tipoBadge = '';
            if (metodo.Tipo === 'SP') {
                tipoBadge = '<span class="badge-sp">STORED PROCEDURE</span>';
            } else if (metodo.Tipo === 'VIEW') {
                tipoBadge = '<span class="badge-view">VISTA</span>';
            } else if (metodo.Tipo === 'SELECT') {
                tipoBadge = '<span class="badge-select">SELECT</span>';
            } else if (metodo.Tipo === 'UPDATE') {
                tipoBadge = '<span class="badge-update">UPDATE</span>';
            } else if (metodo.Tipo === 'METHOD') {
                tipoBadge = '<span class="badge-method">MÉTODO SIN BD</span>';
            } else {
                tipoBadge = '<span class="badge-secondary">' + (metodo.Tipo || 'GENERICO') + '</span>';
            }

            const card = $('<div class="method-card"></div>');
            
            // Solo mostrar botones si no es un método sin BD o desconocido
            let btnVerDef = '';
            let btnEjecutar = '';
            
            if (metodo.Tipo !== 'METHOD' && metodo.Tipo !== 'GENERICO') {
                btnVerDef = '<button type="button" class="btn btn-primary btn-sm btn-ver-def" data-index="' + index + '">' +
                    '<i class="fas fa-eye"></i> Ver Definición</button>';
                
                // Solo permitir ejecutar SELECTs y VIEWs, no UPDATEs ni SPs
                if ((metodo.Tipo === 'SELECT' || metodo.Tipo === 'VIEW') && metodo.Tipo !== 'SP' && metodo.Tipo !== 'UPDATE') {
                    btnEjecutar = '<button type="button" class="btn btn-success btn-sm btn-ejecutar-sql" data-index="' + index + '">' +
                        '<i class="fas fa-play"></i> Ejecutar</button>';
                }
            }
            
            card.html(
                '<h5><i class="fas fa-cog"></i> ' + metodo.Nombre + ' ' + tipoBadge + '</h5>' +
                '<p class="mb-3"><strong>Descripción:</strong> ' + (metodo.Descripcion || 'Sin descripción') + '</p>' +
                (metodo.ObjetoSQL && metodo.ObjetoSQL !== '' && metodo.ObjetoSQL !== 'No identificado' ? 
                    '<p class="mb-3"><strong>Objeto SQL:</strong> <code>' + metodo.ObjetoSQL + '</code></p>' : '') +
                (btnVerDef || btnEjecutar ? 
                    '<div class="d-flex gap-2">' + btnVerDef + btnEjecutar + '</div>' : 
                    '<p class="text-muted mb-0"><small><i class="fas fa-info-circle"></i> Este método no accede a la base de datos</small></p>')
            );

            card.data('metodo', metodo);
            
            // Agregar event listeners en lugar de onclick
            card.find('.btn-ver-def').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                verDefinicionSQL($(this).data('index'));
                return false;
            });
            
            card.find('.btn-ejecutar-sql').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                ejecutarSQL($(this).data('index'));
                return false;
            });
            
            return card;
        }


        function verDefinicionSQL(index) {
            if (!metodosCargados || metodosCargados.length === 0 || index >= metodosCargados.length) {
                mostrarError("No hay métodos cargados o el índice es inválido");
                return;
            }

            const metodo = metodosCargados[index];
            if (!metodo || !metodo.ObjetoSQL || metodo.ObjetoSQL === 'No identificado') {
                mostrarError("No hay definición SQL disponible para este método");
                return;
            }

            $.ajax({
                type: "POST",
                url: "Documentacion.aspx/ObtenerDefinicionSQL",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ 
                    nombreObjeto: metodo.ObjetoSQL, 
                    tipo: metodo.Tipo || 'SP'
                }),
                success: function(response) {
                    try {
                        // Si response.d es un string, parsearlo primero
                        let respuesta = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        
                        if (respuesta && respuesta.Resultado === "SUCCESS") {
                            const definicion = respuesta.Data;
                            $("#sqlDefinitionContent").text(definicion);
                            $("#sqlTypeBadge").text(metodo.Tipo || 'SP');
                            
                            if (metodo.Tipo === 'SP' || metodo.Tipo === 'UPDATE') {
                                if (metodo.Tipo === 'SP') {
                                    $("#sqlTypeBadge").removeClass().addClass("badge badge-sp");
                                } else {
                                    $("#sqlTypeBadge").removeClass().addClass("badge badge-update");
                                }
                                $("#btnEjecutarSQL").hide();
                            } else {
                                $("#sqlTypeBadge").removeClass().addClass(metodo.Tipo === 'VIEW' ? "badge badge-view" : "badge badge-select");
                                $("#btnEjecutarSQL").show().data('objeto', metodo.ObjetoSQL).data('tipo', metodo.Tipo);
                            }

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
                    let errorMsg = "Error al obtener definición: " + error;
                    if (xhr.responseText) {
                        try {
                            const errorResponse = JSON.parse(xhr.responseText);
                            if (errorResponse.Message) {
                                errorMsg = errorResponse.Message;
                            }
                        } catch (e) {
                            errorMsg += " | Respuesta: " + xhr.responseText.substring(0, 100);
                        }
                    }
                    mostrarError(errorMsg);
                }
            });
        }

        function ejecutarSQL(index) {
            if (!metodosCargados || metodosCargados.length === 0 || index >= metodosCargados.length) {
                mostrarError("No hay métodos cargados o el índice es inválido");
                return;
            }

            const metodo = metodosCargados[index];
            if (!metodo || !metodo.ObjetoSQL || metodo.ObjetoSQL === 'No identificado') {
                mostrarError("No hay consulta SQL disponible para ejecutar");
                return;
            }

            // Construir comando SQL según el tipo
            let comandoSQL = metodo.ObjetoSQL;
            if (metodo.Tipo === 'VIEW') {
                comandoSQL = "SELECT * FROM " + metodo.ObjetoSQL;
            } else if (metodo.Tipo === 'SELECT' && !metodo.ObjetoSQL.toUpperCase().trim().startsWith('SELECT')) {
                comandoSQL = metodo.ObjetoSQL; // Ya es un SELECT completo
            }

            $.ajax({
                type: "POST",
                url: "Documentacion.aspx/EjecutarSelect",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ 
                    comandoSQL: comandoSQL 
                }),
                success: function(response) {
                    try {
                        // Si response.d es un string, parsearlo primero
                        let respuesta = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        
                        if (respuesta && respuesta.Resultado === "SUCCESS") {
                            const resultados = JSON.parse(respuesta.Data);
                            mostrarResultados(resultados);
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
                    let errorMsg = "Error al ejecutar consulta: " + error;
                    if (xhr.responseText) {
                        try {
                            const errorResponse = JSON.parse(xhr.responseText);
                            if (errorResponse.Message) {
                                errorMsg = errorResponse.Message;
                            }
                        } catch (e) {
                            errorMsg += " | Respuesta: " + xhr.responseText.substring(0, 100);
                        }
                    }
                    mostrarError(errorMsg);
                }
            });
        }

        $("#btnEjecutarSQL").click(function() {
            const objetoSQL = $(this).data('objeto');
            const tipo = $(this).data('tipo') || 'SELECT';
            
            if (!objetoSQL) {
                mostrarError("No hay consulta SQL para ejecutar");
                return;
            }

            // Construir comando SQL según el tipo
            let comandoSQL = objetoSQL;
            if (tipo === 'VIEW') {
                comandoSQL = "SELECT * FROM " + objetoSQL;
            } else if (tipo === 'SELECT' && !objetoSQL.toUpperCase().trim().startsWith('SELECT')) {
                comandoSQL = objetoSQL; // Ya es un SELECT completo
            }

            $.ajax({
                type: "POST",
                url: "Documentacion.aspx/EjecutarSelect",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ comandoSQL: comandoSQL }),
                success: function(response) {
                    try {
                        // Si response.d es un string, parsearlo primero
                        let respuesta = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        
                        if (respuesta && respuesta.Resultado === "SUCCESS") {
                            $("#modalSQL").modal('hide');
                            const resultados = JSON.parse(respuesta.Data);
                            mostrarResultados(resultados);
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
                    let errorMsg = "Error al ejecutar consulta: " + error;
                    if (xhr.responseText) {
                        try {
                            const errorResponse = JSON.parse(xhr.responseText);
                            if (errorResponse.Message) {
                                errorMsg = errorResponse.Message;
                            }
                        } catch (e) {
                            errorMsg += " | Respuesta: " + xhr.responseText.substring(0, 100);
                        }
                    }
                    mostrarError(errorMsg);
                }
            });
        });

        function mostrarResultados(resultados) {
            const content = $("#resultadosContent");
            content.empty();

            if (!resultados || resultados.length === 0) {
                content.html('<div class="alert alert-info">La consulta no devolvió resultados</div>');
            } else {
                let tabla = '<table class="table table-striped table-bordered table-hover" id="tablaResultados"><thead><tr>';
                
                // Obtener columnas del primer objeto
                const columnas = Object.keys(resultados[0]);
                columnas.forEach(function(col) {
                    tabla += '<th>' + col + '</th>';
                });
                tabla += '</tr></thead><tbody>';

                resultados.forEach(function(fila) {
                    tabla += '<tr>';
                    columnas.forEach(function(col) {
                        const valor = fila[col] !== null && fila[col] !== undefined ? fila[col] : '';
                        tabla += '<td>' + valor + '</td>';
                    });
                    tabla += '</tr>';
                });

                tabla += '</tbody></table>';
                content.html(tabla);

                // Inicializar DataTables
                $('#tablaResultados').DataTable({
                    language: {
                        url: 'https://cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json'
                    },
                    pageLength: 25,
                    responsive: true
                });
            }

            $("#modalResultados").modal('show');
        }


        function volverAlMenu() {
            const sidebar = $("#sidebarContainer");
            const contentContainer = $("#contentContainer");
            
            // Asegurar que el sidebar esté visible
            sidebar.removeClass('collapsed');
            contentContainer.removeClass('expanded col-md-12').addClass('col-md-9');
            $('#btnShowSidebar').hide();
            
            let content = $("#contentContainer .content-area-wrapper .content-area");
            if (content.length === 0) {
                content = $("#contentContainer .content-area");
            }
            content.html(
                '<div class="empty-state">' +
                '<i class="fas fa-hand-pointer"></i>' +
                '<h5>Búsqueda por objeto</h5>' +
                '<p>Utiliza el campo de búsqueda en el menú lateral para buscar SP, vista o tabla, o selecciona un formulario para ver sus métodos</p>' +
                '</div>'
            );
            formularioActual = null;
            rutaFormularioActual = null;
            metodosCargados = [];
            
            // Remover active de todos los items y cerrar todos los folders
            $('#listaFormularios .list-group-item').each(function() {
                $(this).removeClass('active');
                const icon = $(this).find('i');
                icon.removeClass('fa-folder-open').addClass('fa-folder');
            });
            
            return false;
        }

        function mostrarError(mensaje) {
            alert("Error: " + mensaje);
        }
        
        function buscarSPVista() {
            const nombreSP = $('#txtBuscarSP').val().trim();
            
            if (!nombreSP) {
                mostrarError('Por favor ingresa el nombre del SP, vista o tabla a buscar');
                return;
            }
            
            // Mostrar loading
            const contentWrapper = $("#contentContainer .content-area-wrapper");
            let contentElement = contentWrapper.find('.content-area');
            if (contentElement.length === 0) {
                contentWrapper.html('<div class="content-area"></div>');
                contentElement = contentWrapper.find('.content-area');
            }
            contentElement.html('<div class="loading-spinner"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Buscando...</span></div><p class="mt-2">Buscando referencias de <strong>' + nombreSP + '</strong>...</p></div>');
            
            $.ajax({
                type: "POST",
                url: "Documentacion.aspx/BuscarSPVista",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ nombreSP: nombreSP }),
                success: function(response) {
                    try {
                        let respuesta = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        
                        if (respuesta && respuesta.Resultado === "SUCCESS") {
                            const resultados = JSON.parse(respuesta.Data);
                            mostrarResultadosBusqueda(resultados, nombreSP);
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
                    mostrarError("Error al buscar: " + error);
                }
            });
        }
        
        function mostrarResultadosBusqueda(resultados, nombreSP) {
            const contentWrapper = $("#contentContainer .content-area-wrapper");
            let contentElement = contentWrapper.find('.content-area');
            if (contentElement.length === 0) {
                contentWrapper.html('<div class="content-area"></div>');
                contentElement = contentWrapper.find('.content-area');
            }
            
            if (resultados.length === 0) {
                contentElement.html(
                    '<div class="empty-state">' +
                    '<i class="fas fa-search"></i>' +
                    '<h5>No se encontraron resultados</h5>' +
                    '<p>No se encontraron métodos o formularios que utilicen: <strong>' + nombreSP + '</strong></p>' +
                    '</div>'
                );
                return;
            }
            
            // Almacenar métodos para poder acceder a ellos desde los botones
            metodosBusqueda = [];
            let metodoIndex = 0;
            
            let html = '<div class="search-results">';
            html += '<h5 class="mb-4"><i class="fas fa-search"></i> Resultados de búsqueda: <strong>' + nombreSP + '</strong></h5>';
            
            resultados.forEach(function(resultado) {
                html += '<div class="result-item">';
                html += '<h6><i class="fas fa-file-alt"></i> ' + resultado.NombreFormulario + '</h6>';
                html += '<p class="text-muted mb-2"><small><i class="fas fa-folder-open"></i> ' + resultado.RutaFormulario + '</small></p>';
                html += '<div class="method-list">';
                
                resultado.Metodos.forEach(function(metodo) {
                    // Almacenar método con su índice
                    metodosBusqueda.push(metodo);
                    const currentIndex = metodoIndex++;
                    
                    // Determinar tipo y badges
                    let tipoBadge = '';
                    if (metodo.Tipo === 'SP') {
                        tipoBadge = '<span class="badge-sp">STORED PROCEDURE</span>';
                    } else if (metodo.Tipo === 'VIEW') {
                        tipoBadge = '<span class="badge-view">VISTA</span>';
                    } else if (metodo.Tipo === 'SELECT') {
                        tipoBadge = '<span class="badge-select">SELECT</span>';
                    } else if (metodo.Tipo === 'UPDATE') {
                        tipoBadge = '<span class="badge-update">UPDATE</span>';
                    } else if (metodo.Tipo === 'METHOD') {
                        tipoBadge = '<span class="badge-method">MÉTODO SIN BD</span>';
                    } else {
                        tipoBadge = '<span class="badge-secondary">' + (metodo.Tipo || 'DESCONOCIDO') + '</span>';
                    }
                    
                    // Crear botones según el tipo
                    let btnVerDef = '';
                    let btnEjecutar = '';
                    
                    if (metodo.Tipo !== 'METHOD' && metodo.Tipo !== 'GENERICO' && metodo.ObjetoSQL && metodo.ObjetoSQL !== '' && metodo.ObjetoSQL !== 'No identificado') {
                        btnVerDef = '<button type="button" class="btn btn-primary btn-sm btn-ver-def-search" data-index="' + currentIndex + '">' +
                            '<i class="fas fa-eye"></i> Ver Definición</button>';
                        
                        // Solo permitir ejecutar SELECTs y VIEWs
                        if (metodo.Tipo === 'SELECT' || metodo.Tipo === 'VIEW') {
                            btnEjecutar = '<button type="button" class="btn btn-success btn-sm btn-ejecutar-search" data-index="' + currentIndex + '">' +
                                '<i class="fas fa-play"></i> Ejecutar</button>';
                        }
                    }
                    
                    html += '<div class="method-item">';
                    html += '<strong><i class="fas fa-cog"></i> ' + metodo.Nombre + ' ' + tipoBadge + '</strong>';
                    if (metodo.Descripcion) {
                        html += '<p class="mb-2 mt-1"><small>' + metodo.Descripcion + '</small></p>';
                    }
                    if (metodo.ObjetoSQL && metodo.ObjetoSQL !== '' && metodo.ObjetoSQL !== 'No identificado') {
                        html += '<p class="mb-2"><small><strong>Objeto SQL:</strong> <code>' + metodo.ObjetoSQL + '</code></small></p>';
                    }
                    if (btnVerDef || btnEjecutar) {
                        html += '<div class="d-flex gap-2 mt-2">' + btnVerDef + btnEjecutar + '</div>';
                    }
                    html += '</div>';
                });
                
                html += '</div>';
                html += '</div>';
            });
            
            html += '</div>';
            contentElement.html(html);
            
            // Agregar event listeners a los botones de búsqueda
            contentElement.find('.btn-ver-def-search').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                const index = $(this).data('index');
                verDefinicionSQLBusqueda(index);
                return false;
            });
            
            contentElement.find('.btn-ejecutar-search').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                const index = $(this).data('index');
                ejecutarSQLBusqueda(index);
                return false;
            });
            
            // Scroll al inicio
            contentWrapper.scrollTop(0);
        }
        
        function verDefinicionSQLBusqueda(index) {
            if (!metodosBusqueda || metodosBusqueda.length === 0 || index >= metodosBusqueda.length) {
                mostrarError("No hay métodos cargados o el índice es inválido");
                return;
            }

            const metodo = metodosBusqueda[index];
            if (!metodo || !metodo.ObjetoSQL || metodo.ObjetoSQL === 'No identificado' || metodo.ObjetoSQL === '') {
                mostrarError("No hay definición SQL disponible para este método");
                return;
            }

            $.ajax({
                type: "POST",
                url: "Documentacion.aspx/ObtenerDefinicionSQL",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ 
                    nombreObjeto: metodo.ObjetoSQL, 
                    tipo: metodo.Tipo || 'SP'
                }),
                success: function(response) {
                    try {
                        let respuesta = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        
                        if (respuesta && respuesta.Resultado === "SUCCESS") {
                            const definicion = respuesta.Data;
                            $("#sqlDefinitionContent").text(definicion);
                            $("#sqlTypeBadge").text(metodo.Tipo || 'SP');
                            
                            if (metodo.Tipo === 'SP' || metodo.Tipo === 'UPDATE') {
                                if (metodo.Tipo === 'SP') {
                                    $("#sqlTypeBadge").removeClass().addClass("badge badge-sp");
                                } else {
                                    $("#sqlTypeBadge").removeClass().addClass("badge badge-update");
                                }
                                $("#btnEjecutarSQL").hide();
                            } else {
                                $("#sqlTypeBadge").removeClass().addClass(metodo.Tipo === 'VIEW' ? "badge badge-view" : "badge badge-select");
                                $("#btnEjecutarSQL").show().data('objeto', metodo.ObjetoSQL).data('tipo', metodo.Tipo);
                            }

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
        
        function ejecutarSQLBusqueda(index) {
            if (!metodosBusqueda || metodosBusqueda.length === 0 || index >= metodosBusqueda.length) {
                mostrarError("No hay métodos cargados o el índice es inválido");
                return;
            }

            const metodo = metodosBusqueda[index];
            if (!metodo || !metodo.ObjetoSQL || metodo.ObjetoSQL === 'No identificado' || metodo.ObjetoSQL === '') {
                mostrarError("No hay SQL disponible para ejecutar");
                return;
            }

            // Verificar que sea SELECT o VIEW
            if (metodo.Tipo !== 'SELECT' && metodo.Tipo !== 'VIEW') {
                mostrarError("Solo se pueden ejecutar consultas SELECT o VIEW");
                return;
            }

            $.ajax({
                type: "POST",
                url: "Documentacion.aspx/EjecutarSelect",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ 
                    sql: metodo.ObjetoSQL
                }),
                success: function(response) {
                    try {
                        let respuesta = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        
                        if (respuesta && respuesta.Resultado === "SUCCESS") {
                            const resultados = JSON.parse(respuesta.Data);
                            mostrarResultados(resultados);
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
                    mostrarError("Error al ejecutar consulta: " + error);
                }
            });
        }
    </script>
</body>
</html>
