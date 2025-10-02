<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="GestionUsuarios.aspx.vb" Inherits="SemgaWapp.GestionUsuarios" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Gestión de Usuarios</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <!-- Script de monitoreo de inactividad -->
    <script src="../../Scripts/inactivity-monitor-final.js?v=2.6"></script>
    
    <style>
        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
            width: 100%;
            overflow: hidden;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: white;
            color: #333;
            margin: 0;
            padding: 0;
            height: 100vh;
            width: 100vw;
            overflow: hidden;
        }

        .user-management-container {
            padding: 8px;
            max-width: none;
            margin: 0;
            height: 100vh;
            width: 100vw;
            display: flex;
            flex-direction: column;
            box-sizing: border-box;
        }

        .add-user-btn {
            background: #28a745;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
            transition: background-color 0.2s ease;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .add-user-btn:hover {
            background: #218838;
        }

        .search-section {
            background: white;
            padding: 12px;
            border-radius: 6px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 12px;
            border: 1px solid #e0e0e0;
        }

        .search-title {
            font-size: 14px;
            font-weight: 600;
            color: #333;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .search-title i {
            color: #87CEEB;
        }

        .search-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
            gap: 12px;
            align-items: end;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            color: #555;
            font-size: 13px;
        }

        .form-label .required {
            color: #dc3545;
            font-weight: bold;
        }

        .form-input {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 13px;
            transition: border-color 0.2s ease;
            background: white;
            color: #333;
        }

        .form-input:focus {
            outline: none;
            border-color: #87CEEB;
            background: white;
        }

        .search-btn {
            background: #87CEEB;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
            transition: background-color 0.2s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            height: 40px;
        }

        .search-btn:hover {
            background: #5bc0de;
        }

        .users-table {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            border: 1px solid #e0e0e0;
            margin-top: 15px;
        }

        .table-container {
            overflow-x: auto;
            flex: 1;
            overflow-y: auto;
        }

        .users-grid {
            width: 100%;
            border-collapse: collapse;
            min-width: 1200px;
        }

        .users-grid th {
            background: #87CEEB;
            color: white;
            padding: 10px 8px;
            text-align: left;
            font-weight: 600;
            font-size: 12px;
            position: sticky;
            top: 0;
            z-index: 10;
            white-space: nowrap;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border: none;
        }

        .users-grid td {
            padding: 8px;
            border-bottom: 1px solid #f0f0f0;
            font-size: 12px;
            vertical-align: middle;
            line-height: 1.3;
        }

        .users-grid tr:nth-child(odd) {
            background: white;
        }

        .users-grid tr:nth-child(even) {
            background: #f8f9fa;
        }

        .users-grid tr:hover {
            background: #e3f2fd;
            transition: background-color 0.2s ease;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
            text-align: center;
            display: inline-block;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            min-width: 60px;
        }

        .status-active {
            background: #28a745;
            color: white;
        }

        .status-inactive {
            background: #dc3545;
            color: white;
        }

        .action-buttons {
            display: flex;
            gap: 4px;
            justify-content: center;
        }

        .btn-edit {
            background: #007bff;
            color: white;
            border: none;
            padding: 4px 8px;
            border-radius: 3px;
            cursor: pointer;
            font-size: 11px;
            transition: background-color 0.2s ease;
            min-width: 32px;
        }

        .btn-edit:hover {
            background: #0056b3;
        }

        .btn-delete {
            background: #dc3545;
            color: white;
            border: none;
            padding: 4px 8px;
            border-radius: 3px;
            cursor: pointer;
            font-size: 11px;
            transition: background-color 0.2s ease;
            min-width: 32px;
        }

        .btn-delete:hover {
            background: #c82333;
        }

        .user-info {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }

        .user-name {
            font-weight: 600;
            color: #333;
            font-size: 12px;
            line-height: 1.1;
        }

        .user-email {
            font-size: 11px;
            color: #666;
            font-style: italic;
        }

        .last-access {
            font-size: 12px;
            color: #666;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .last-access i {
            color: #87CEEB;
            font-size: 12px;
        }

        .user-username {
            font-weight: 600;
            color: #333;
            font-size: 14px;
        }

        .user-role {
            font-weight: 500;
            color: #555;
            font-size: 12px;
            background: #f0f0f0;
            padding: 4px 8px;
            border-radius: 3px;
            display: inline-block;
        }

        .user-department {
            font-size: 12px;
            color: #666;
            font-weight: 500;
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100vw;
            height: 100vh;
            background-color: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(5px);
        }

        .modal-content {
            background-color: white;
            margin: 0 auto;
            padding: 0;
            border-radius: 0;
            width: 100%;
            max-width: 1200px;
            height: 100vh;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            animation: modalSlideIn 0.3s ease-out;
            overflow: hidden;
        }

        @keyframes modalSlideIn {
            from {
                opacity: 0;
                transform: translateY(-50px) scale(0.9);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        .modal-header {
            background: linear-gradient(135deg, #1e3a8a, #3b82f6);
            color: white;
            padding: 8px 15px;
            border-radius: 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-title {
            font-size: 16px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .close {
            color: white;
            font-size: 20px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.2);
        }

        .close:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: scale(1.1);
        }

        .modal-body {
            padding: 20px;
            height: calc(100vh - 120px);
            overflow-y: auto;
            display: flex;
            flex-direction: column;
        }

        .modal-body .form-group {
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            height: 75px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 15px;
            margin-bottom: 15px;
            align-items: end;
        }

        .form-row.full {
            grid-template-columns: 1fr;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #495057;
            font-size: 14px;
        }

        .form-input {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s ease;
            background: #f8f9fa;
            color: #495057;
        }

        .form-input:focus {
            outline: none;
            border-color: #87CEEB;
            background: white;
            box-shadow: 0 0 0 4px rgba(135, 206, 235, 0.1);
            transform: translateY(-1px);
        }

        .form-input.error {
            border-color: #dc3545;
            background: #fff5f5;
        }

        .form-input.success {
            border-color: #28a745;
            background: #f8fff9;
        }

        .error-message {
            color: #dc3545;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }

        .modal-footer {
            padding: 15px 20px;
            background: #f8f9fa;
            border-radius: 0;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            border-top: 1px solid #e0e0e0;
            position: sticky;
            bottom: 0;
            z-index: 10;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            box-shadow: 0 4px 15px rgba(0, 123, 255, 0.2);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 123, 255, 0.3);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #6c757d, #495057);
            color: white;
            box-shadow: 0 4px 15px rgba(108, 117, 125, 0.2);
        }

        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(108, 117, 125, 0.3);
        }

        .btn-danger {
            background: linear-gradient(135deg, #dc3545, #c82333);
            color: white;
            box-shadow: 0 4px 15px rgba(220, 53, 69, 0.2);
        }

        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(220, 53, 69, 0.3);
        }

        .loading {
            display: none;
            text-align: center;
            padding: 20px;
        }

        .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #87CEEB;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: 0 auto 10px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .no-data {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }

        .no-data i {
            font-size: 64px;
            color: #dee2e6;
            margin-bottom: 20px;
        }

        .no-data h3 {
            font-size: 20px;
            margin-bottom: 10px;
            color: #495057;
        }

        .no-data p {
            font-size: 14px;
            color: #6c757d;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .modal-content {
                width: 95%;
                margin: 10% auto;
            }
            
            .modal-header {
                padding: 20px;
            }
            
            .modal-body {
                padding: 20px;
            }
            
            .modal-footer {
                padding: 15px 20px;
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" />
        
        <div class="user-management-container">
            <!-- Header Section -->
            <div style="background: linear-gradient(135deg, #1e3a8a, #3b82f6); color: white; padding: 10px 15px; margin: -8px -8px 15px -8px; display: flex; justify-content: space-between; align-items: center;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <button type="button" onclick="window.location.href='dashboardSistemas.aspx'" style="background: rgba(255,255,255,0.2); border: none; color: white; padding: 8px 12px; border-radius: 5px; cursor: pointer; display: flex; align-items: center; gap: 5px;">
                        <i class="fas fa-arrow-left"></i>
                        Volver
                    </button>
                    <h2 style="margin: 0; font-size: 18px;">
                        <i class="fas fa-user-cog" style="margin-right: 8px;"></i>
                        Gestión de Usuarios
                    </h2>
                </div>
            </div>

            <!-- Search Section -->
            <div class="search-section">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                    <h3 class="search-title">
                        <i class="fas fa-search"></i>
                        B&#250;squeda de Usuarios
                    </h3>
                    <div style="display: flex; gap: 8px;">
                        <button type="button" class="add-user-btn" onclick="showAddUserForm()">
                            <i class="fas fa-plus"></i>
                            Nuevo Usuario
                        </button>
                    </div>
                </div>
                <div class="search-row">
                    <div class="form-group">
                        <label class="form-label">Nombre o Apellido</label>
                        <input type="text" id="filtroNombre" class="form-input" placeholder="Ingrese nombre o apellido" />
                    </div>
                    <div class="form-group">
                        <label class="form-label">Nombre de Usuario</label>
                        <input type="text" id="filtroUsuario" class="form-input" placeholder="Nombre de usuario" />
                    </div>
                    <div class="form-group">
                        <label class="form-label">Estado</label>
                        <select id="filtroEstado" class="form-input">
                            <option value="">Todos los estados</option>
                            <option value="Activo">Activo</option>
                            <option value="Inactivo">Inactivo</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Rol</label>
                        <select id="filtroRol" class="form-input">
                            <option value="">Todos los roles</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Departamento</label>
                        <select id="filtroDepartamento" class="form-input">
                            <option value="">Todos los departamentos</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <button type="button" class="search-btn" onclick="buscarUsuarios()">
                            <i class="fas fa-search"></i>
                            Buscar
                        </button>
                    </div>
                </div>
            </div>

            <!-- Users Table -->
            <div class="users-table">

                
                <div class="loading" id="loadingTable">
                    <div class="spinner"></div>
                    <p>Cargando usuarios...</p>
                </div>
                
                <div class="table-container" id="tableContainer" style="display: none;">
                    <table class="users-grid" id="usersTable">
                        <thead>
                            <tr>
                                <th>Usuario</th>
                                <th>Información Personal</th>
                                <th>Rol</th>
                                <th>Departamento</th>
                                <th>Estado</th>
                                <th>ÚltimoAcceso</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody id="usersTableBody">
                        </tbody>
                    </table>
                </div>

                <div class="no-data" id="noData" style="display: none;">
                    <i class="fas fa-users"></i>
                    <h3>No se encontraron usuarios</h3>
                    <p>Intente ajustar los filtros de búsqueda</p>
                </div>
            </div>
        </div>

        <!-- User Modal -->
        <div id="userModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title">
                        <i class="fas fa-user-edit"></i>
                        <span id="modalTitle">Nuevo Usuario</span>
                    </h3>
                    <span class="close" onclick="closeModal()">&times;</span>
                </div>
                <div class="modal-body">
                    <form id="userForm" style="flex: 1; display: flex; flex-direction: column;">
                        <input type="hidden" id="usuarioId" value="0" />
                        
                        <div style="flex: 1; display: flex; flex-direction: column; justify-content: flex-start; min-height: 0;">
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Nombre <span class="required">*</span></label>
                                <input type="text" id="nombre" class="form-input" required />
                                <div class="error-message" id="nombreError"></div>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Apellido <span class="required">*</span></label>
                                <input type="text" id="apellido" class="form-input" required />
                                <div class="error-message" id="apellidoError"></div>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Nombre de Usuario <span class="required">*</span></label>
                                <input type="text" id="usuario" class="form-input" required />
                                <div class="error-message" id="usuarioError"></div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Email <span class="required">*</span></label>
                                <input type="email" id="email" class="form-input" required />
                                <div class="error-message" id="emailError"></div>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Contraseña <span id="passwordRequired" class="required">*</span></label>
                                <input type="password" id="clave" class="form-input" />
                                <div class="error-message" id="claveError"></div>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Teléfono</label>
                                <input type="text" id="telefono" class="form-input" />
                                <div class="error-message" id="telefonoError"></div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Rol <span class="required">*</span></label>
                                <select id="rol" class="form-input" required>
                                    <option value="">Seleccione un rol</option>
                                </select>
                                <div class="error-message" id="rolError"></div>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Departamento</label>
                                <select id="departamento" class="form-input">
                                    <option value="0">Sin departamento</option>
                                </select>
                                <div class="error-message" id="departamentoError"></div>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Estado <span class="required">*</span></label>
                                <select id="estado" class="form-input" required>
                                    <option value="">Seleccione estado</option>
                                    <option value="Activo">Activo</option>
                                    <option value="Inactivo">Inactivo</option>
                                </select>
                                <div class="error-message" id="estadoError"></div>
                            </div>
                        </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeModal()">
                        <i class="fas fa-times"></i>
                        Cancelar
                    </button>
                    <button type="button" class="btn btn-danger" id="btnEliminar" onclick="eliminarUsuario()" style="display: none;">
                        <i class="fas fa-trash"></i>
                        Eliminar
                    </button>
                    <button type="button" class="btn btn-primary" onclick="guardarUsuario()">
                        <i class="fas fa-save"></i>
                        Guardar
                    </button>
                </div>
            </div>
        </div>
    </form>

    <script type="text/javascript">
        // Variables globales
        let usuarios = [];
        let roles = [];
        let departamentos = [];
        let usuarioActual = null;



        // Función de inicialización
        function initUserManagement() {
            
            // Inicializar monitoreo de inactividad
            if (typeof initializeInactivityMonitoring === 'function') {
                initializeInactivityMonitoring();
            }
            
            // Verificar si PageMethods está disponible
            if (typeof PageMethods === 'undefined') {
                
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'PageMethods no está disponible. Verificar configuración del ScriptManager.'
                });
                return;
            }
            
            
            cargarRoles();
            cargarDepartamentos();
            cargarUsuarios();
            
            // Event listeners para búsqueda en tiempo real
            const filtroNombre = document.getElementById('filtroNombre');
            const filtroUsuario = document.getElementById('filtroUsuario');
            
            if (filtroNombre) {
                filtroNombre.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') buscarUsuarios();
                });
            }
            
            if (filtroUsuario) {
                filtroUsuario.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') buscarUsuarios();
                });
            }
        }

        // Inicialización automática cuando se carga la página
        document.addEventListener('DOMContentLoaded', function() {
            initUserManagement();
        });

        // Función para cargar usuarios
        function cargarUsuarios() {
            
            
            const filtroNombre = document.getElementById('filtroNombre').value;
            const filtroUsuario = document.getElementById('filtroUsuario').value;
            const filtroEstado = document.getElementById('filtroEstado').value;
            const filtroRol = document.getElementById('filtroRol').value;

            

            mostrarLoading(true);

            try {
                PageMethods.CargarUsuarios(filtroNombre, filtroUsuario, filtroEstado, filtroRol, function(result) {
                    
                    mostrarLoading(false);
                    
                    if (result.startsWith('ERROR:')) {
                        
                        Swal.fire({
                            icon: 'error',
                            title: 'Error',
                            text: 'Error al cargar usuarios: ' + result
                        });
                        return;
                    }

                    try {
                        usuarios = JSON.parse(result);
                        
                        renderizarTabla();
                    } catch (e) {
                        
                        
                        Swal.fire({
                            icon: 'error',
                            title: 'Error',
                            text: 'Error al procesar los datos de usuarios'
                        });
                    }
                }, function(error) {
                    
                    mostrarLoading(false);
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: 'Error de comunicación al cargar usuarios: ' + error
                    });
                });
            } catch (e) {
                
                mostrarLoading(false);
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Error al llamar el método del servidor: ' + e.message
                });
            }
        }

        // Función para cargar roles
        function cargarRoles() {
            PageMethods.CargarRoles(function(result) {
                if (result.startsWith('ERROR:')) {
                    
                    return;
                }

                try {
                    roles = JSON.parse(result);
                    
                    // Llenar select de filtro
                    const filtroRol = document.getElementById('filtroRol');
                    filtroRol.innerHTML = '<option value="">Todos los roles</option>';
                    
                    // Llenar select del modal
                    const rolSelect = document.getElementById('rol');
                    rolSelect.innerHTML = '<option value="">Seleccione un rol</option>';
                    
                    roles.forEach(function(rol) {
                        filtroRol.innerHTML += `<option value="${rol.Id}">${rol.Nombre}</option>`;
                        rolSelect.innerHTML += `<option value="${rol.Id}">${rol.Nombre}</option>`;
                    });
                } catch (e) {
                    
                }
            });
        }

        // Función para cargar departamentos
        function cargarDepartamentos() {
            PageMethods.CargarDepartamentos(function(result) {
                if (result.startsWith('ERROR:')) {
                    
                    return;
                }

                try {
                    departamentos = JSON.parse(result);
                    
                    // Llenar select del modal
                    const departamentoSelect = document.getElementById('departamento');
                    departamentoSelect.innerHTML = '<option value="0">Sin departamento</option>';
                    
                    // Llenar select del filtro
                    const filtroSelect = document.getElementById('filtroDepartamento');
                    filtroSelect.innerHTML = '<option value="">Todos los departamentos</option>';
                    
                    departamentos.forEach(function(depto) {
                        // Opción para el formulario
                        departamentoSelect.innerHTML += `<option value="${depto.Id}">${depto.Nombre}</option>`;
                        
                        // Opción para el filtro
                        filtroSelect.innerHTML += `<option value="${depto.Id}">${depto.Nombre}</option>`;
                    });
                } catch (e) {
                    
                }
            });
        }

        // Función para renderizar la tabla
        function renderizarTabla() {
            
            
            const tbody = document.getElementById('usersTableBody');
            const noData = document.getElementById('noData');
            const tableContainer = document.getElementById('tableContainer');

            if (!tbody || !noData || !tableContainer) {
                
                return;
            }

            if (usuarios.length === 0) {
                
                tableContainer.style.display = 'none';
                noData.style.display = 'block';
                return;
            }

            
            tableContainer.style.display = 'block';
            noData.style.display = 'none';

            tbody.innerHTML = '';

            usuarios.forEach(function(user, index) {
                
                
                const row = document.createElement('tr');
                
                const rolNombre = roles.find(r => r.Id === user.Rol)?.Nombre || 'N/A';
                const deptoNombre = user.Departamento ? 
                    (departamentos.find(d => d.Id === user.Departamento)?.Nombre || 'N/A') : 'Sin departamento';
                
                const ultimoAcceso = user.UltimoAcceso ? 
                    new Date(user.UltimoAcceso).toLocaleString('es-ES') : 'Nunca';

                row.innerHTML = `
                    <td><span class="user-username">${user.Usuario || ''}</span></td>
                    <td>
                        <div class="user-info">
                            <span class="user-name">${user.Nombre || ''} ${user.Apellido || ''}</span>
                            <span class="user-email">${user.Email || ''}</span>
                        </div>
                    </td>
                    <td><span class="user-role">${rolNombre}</span></td>
                    <td><span class="user-department">${deptoNombre}</span></td>
                    <td><span class="status-badge status-${(user.Estado || '').toLowerCase()}">${user.Estado || ''}</span></td>
                    <td>
                        <div class="last-access">
                            <i class="fas fa-clock"></i> ${ultimoAcceso}
                        </div>
                    </td>
                    <td>
                        <div class="action-buttons">
                            <button type="button" class="btn-edit" onclick="editarUsuario(${user.Id})" title="Editar usuario">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button type="button" class="btn-delete" onclick="eliminarUsuario(${user.Id})" title="Eliminar usuario">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </td>
                `;
                
                tbody.appendChild(row);
            });
            
            
        }

        // Función para mostrar formulario de nuevo usuario
        function showAddUserForm() {
            usuarioActual = null;
            document.getElementById('modalTitle').textContent = 'Nuevo Usuario';
            document.getElementById('usuarioId').value = '0';
            document.getElementById('passwordRequired').textContent = '*';
            document.getElementById('passwordRequired').className = 'required';
            document.getElementById('clave').required = true;
            document.getElementById('btnEliminar').style.display = 'none';
            
            limpiarFormulario();
            abrirModal();
        }

        // Función para editar usuario
        function editarUsuario(usuarioId) {
            PageMethods.ObtenerUsuario(usuarioId, function(result) {
                if (result.startsWith('ERROR:')) {
                    alert('Error al obtener usuario: ' + result);
                    return;
                }

                try {
                    const usuarios = JSON.parse(result);
                    if (usuarios.length > 0) {
                        usuarioActual = usuarios[0];
                        llenarFormulario(usuarioActual);
                        
                        document.getElementById('modalTitle').textContent = 'Editar Usuario';
                        document.getElementById('usuarioId').value = usuarioActual.Id;
                        document.getElementById('passwordRequired').textContent = '(dejar vacío para mantener)';
                        document.getElementById('passwordRequired').className = '';
                        document.getElementById('clave').required = false;
                        document.getElementById('btnEliminar').style.display = 'inline-flex';
                        
                        abrirModal();
                    }
                } catch (e) {
                    
                    alert('Error al procesar los datos del usuario');
                }
            });
        }

        // Función para llenar formulario
        function llenarFormulario(usuario) {
            document.getElementById('nombre').value = usuario.Nombre || '';
            document.getElementById('apellido').value = usuario.Apellido || '';
            document.getElementById('usuario').value = usuario.Usuario || '';
            document.getElementById('clave').value = '';
            document.getElementById('email').value = usuario.Email || '';
            document.getElementById('telefono').value = usuario.Telefono || '';
            document.getElementById('rol').value = usuario.Rol || '';
            document.getElementById('departamento').value = usuario.Departamento || '0';
            document.getElementById('estado').value = usuario.Estado || '';
        }

        // Función para limpiar formulario
        function limpiarFormulario() {
            document.getElementById('nombre').value = '';
            document.getElementById('apellido').value = '';
            document.getElementById('usuario').value = '';
            document.getElementById('clave').value = '';
            document.getElementById('email').value = '';
            document.getElementById('telefono').value = '';
            document.getElementById('rol').value = '';
            document.getElementById('departamento').value = '0';
            document.getElementById('estado').value = '';
            
            // Limpiar errores
            document.querySelectorAll('.error-message').forEach(function(el) {
                el.style.display = 'none';
            });
            
            document.querySelectorAll('.form-input').forEach(function(el) {
                el.classList.remove('error', 'success');
            });
        }

        // Función para guardar usuario
        function guardarUsuario() {
            if (!validarFormulario()) {
                return;
            }

            const usuarioId = parseInt(document.getElementById('usuarioId').value);
            const nombre = document.getElementById('nombre').value.trim();
            const apellido = document.getElementById('apellido').value.trim();
            const usuario = document.getElementById('usuario').value.trim();
            const clave = document.getElementById('clave').value;
            const email = document.getElementById('email').value.trim();
            const telefono = document.getElementById('telefono').value.trim();
            const rol = parseInt(document.getElementById('rol').value);
            const departamento = parseInt(document.getElementById('departamento').value);
            const estado = document.getElementById('estado').value;

            // Verificar usuario existente
            verificarUsuarioExistente(usuario, usuarioId, function(usuarioExiste) {
                if (usuarioExiste) {
                    mostrarError('usuario', 'Este nombre de usuario ya existe');
                    return;
                }

                // Verificar email existente
                verificarEmailExistente(email, usuarioId, function(emailExiste) {
                    if (emailExiste) {
                        mostrarError('email', 'Este email ya está registrado');
                        return;
                    }

                    // Guardar usuario
                    PageMethods.GuardarUsuario(usuarioId, nombre, apellido, usuario, clave, email, telefono, rol, departamento, estado, function(result) {
                        if (result.startsWith('ERROR:')) {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error',
                                text: 'Error al guardar usuario: ' + result
                            });
                            return;
                        }

                        if (result === 'OK') {
                            Swal.fire({
                                icon: 'success',
                                title: 'Éxito',
                                text: usuarioId === 0 ? 'Usuario creado exitosamente' : 'Usuario actualizado exitosamente'
                            }).then(() => {
                                closeModal();
                                cargarUsuarios();
                            });
                        } else {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error',
                                text: result
                            });
                        }
                    });
                });
            });
        }

        // Función para eliminar usuario
        function eliminarUsuario(usuarioId) {
            if (!usuarioId) {
                usuarioId = parseInt(document.getElementById('usuarioId').value);
            }

            Swal.fire({
                title: '¿Está seguro?',
                text: '¿Está seguro de que desea eliminar este usuario? Esta acción no se puede deshacer.',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Sí, eliminar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    PageMethods.EliminarUsuario(usuarioId, function(result) {
                        if (result.startsWith('ERROR:')) {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error',
                                text: 'Error al eliminar usuario: ' + result
                            });
                            return;
                        }

                        if (result === 'OK') {
                            Swal.fire({
                                icon: 'success',
                                title: 'Éxito',
                                text: 'Usuario eliminado exitosamente'
                            }).then(() => {
                                closeModal();
                                cargarUsuarios();
                            });
                        } else {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error',
                                text: result
                            });
                        }
                    });
                }
            });
        }

        // Función para buscar usuarios
        function buscarUsuarios() {
            const filtroNombre = document.getElementById('filtroNombre').value.trim();
            const filtroUsuario = document.getElementById('filtroUsuario').value.trim();
            const filtroEstado = document.getElementById('filtroEstado').value;
            const filtroRol = document.getElementById('filtroRol').value;
            const filtroDepartamento = document.getElementById('filtroDepartamento').value;
            
            const usuariosFiltrados = usuarios.filter(function(usuario) {
                const cumpleNombre = !filtroNombre || 
                    usuario.Nombre.toLowerCase().includes(filtroNombre.toLowerCase()) ||
                    usuario.Apellido.toLowerCase().includes(filtroNombre.toLowerCase());
                
                const cumpleUsuario = !filtroUsuario || 
                    usuario.Usuario.toLowerCase().includes(filtroUsuario.toLowerCase());
                
                const cumpleEstado = !filtroEstado || usuario.Estado === filtroEstado;
                const cumpleRol = !filtroRol || usuario.RolId == filtroRol;
                const cumpleDepartamento = !filtroDepartamento || usuario.DepartamentoId == filtroDepartamento;
                
                return cumpleNombre && cumpleUsuario && cumpleEstado && cumpleRol && cumpleDepartamento;
            });
            
            renderizarTabla(usuariosFiltrados);
        }

        // Función para validar formulario
        function validarFormulario() {
            let esValido = true;
            
            // Limpiar errores previos
            document.querySelectorAll('.error-message').forEach(function(el) {
                el.style.display = 'none';
            });
            
            document.querySelectorAll('.form-input').forEach(function(el) {
                el.classList.remove('error', 'success');
            });

            // Validar campos requeridos
            const camposRequeridos = ['nombre', 'apellido', 'usuario', 'email', 'rol', 'estado'];
            const usuarioId = parseInt(document.getElementById('usuarioId').value);
            
            if (usuarioId === 0) {
                camposRequeridos.push('clave');
            }

            camposRequeridos.forEach(function(campo) {
                const input = document.getElementById(campo);
                const valor = input.value.trim();
                
                if (!valor) {
                    mostrarError(campo, 'Este campo es requerido');
                    esValido = false;
                } else {
                    input.classList.add('success');
                }
            });

            // Validar email
            const email = document.getElementById('email').value.trim();
            if (email && !isValidEmail(email)) {
                mostrarError('email', 'Formato de email inválido');
                esValido = false;
            }

            // Validar teléfono
            const telefono = document.getElementById('telefono').value.trim();
            if (telefono && !isValidPhone(telefono)) {
                mostrarError('telefono', 'Formato de teléfono inválido');
                esValido = false;
            }

            return esValido;
        }

        // Función para mostrar error
        function mostrarError(campo, mensaje) {
            const input = document.getElementById(campo);
            const error = document.getElementById(campo + 'Error');
            
            input.classList.add('error');
            input.classList.remove('success');
            error.textContent = mensaje;
            error.style.display = 'block';
        }

        // Función para verificar usuario existente
        function verificarUsuarioExistente(usuario, usuarioId, callback) {
            PageMethods.VerificarUsuarioExistente(usuario, usuarioId, function(result) {
                callback(result === 'EXISTE');
            });
        }

        // Función para verificar email existente
        function verificarEmailExistente(email, usuarioId, callback) {
            PageMethods.VerificarEmailExistente(email, usuarioId, function(result) {
                callback(result === 'EXISTE');
            });
        }

        // Función para validar email
        function isValidEmail(email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }

        // Función para validar teléfono
        function isValidPhone(phone) {
            const phoneRegex = /^[\+]?[0-9\s\-\(\)]{7,15}$/;
            return phoneRegex.test(phone);
        }

        // Función para mostrar/ocultar loading
        function mostrarLoading(mostrar) {
            const loading = document.getElementById('loadingTable');
            const tableContainer = document.getElementById('tableContainer');
            const noData = document.getElementById('noData');
            
            if (mostrar) {
                loading.style.display = 'block';
                tableContainer.style.display = 'none';
                noData.style.display = 'none';
            } else {
                loading.style.display = 'none';
            }
        }

        // Funciones del modal
        function abrirModal() {
            document.getElementById('userModal').style.display = 'block';
            document.body.style.overflow = 'hidden';
        }

        function closeModal() {
            document.getElementById('userModal').style.display = 'none';
            document.body.style.overflow = 'auto';
            limpiarFormulario();
        }

        // Cerrar modal al hacer clic fuera
        window.onclick = function(event) {
            const modal = document.getElementById('userModal');
            if (event.target === modal) {
                closeModal();
            }
        }

        // Cerrar modal con ESC
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeModal();
            }
        });


    </script>
</body>
</html>



