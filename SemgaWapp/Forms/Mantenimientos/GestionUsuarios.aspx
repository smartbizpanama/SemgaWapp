<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="GestionUsuarios.aspx.vb" Inherits="SemgaWapp.GestionUsuarios" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Gestión de Usuarios</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
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
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 11px;
            font-weight: 600;
            transition: background-color 0.2s ease;
            display: flex;
            align-items: center;
            gap: 4px;
            height: 32px;
            min-width: 70px;
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
            display: flex;
            gap: 12px;
            align-items: end;
            justify-content: space-between;
            flex-wrap: nowrap;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            flex: 1;
            min-width: 0;
        }

        .form-label {
            display: block;
            margin-bottom: 4px;
            font-weight: 600;
            color: #555;
            font-size: 12px;
        }

        .form-label .required {
            color: #dc3545;
            font-weight: bold;
        }

        .form-input {
            width: 100%;
            padding: 8px 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 13px;
            transition: border-color 0.2s ease;
            background: white;
            color: #333;
            height: 36px;
            box-sizing: border-box;
            overflow: visible;
        }

        .form-input select {
            width: 100%;
            height: 100%;
            border: none;
            outline: none;
            background: transparent;
            font-size: 13px;
            color: #333;
            padding: 0;
            margin: 0;
        }

        .form-input:focus {
            outline: none;
            border-color: #87CEEB;
            background: white;
        }

        /* Estilos para form-select de Bootstrap */
        .form-select {
            height: 36px;
            font-size: 13px;
            border-radius: 4px;
            border: 1px solid #ddd;
            transition: border-color 0.2s ease;
            background: white;
            color: #333;
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%23343a40' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m1 6 7 7 7-7'/%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 0.75rem center;
            background-size: 16px 12px;
            padding-right: 2.25rem;
        }

        .form-select:focus {
            border-color: #87CEEB;
            box-shadow: 0 0 0 0.2rem rgba(135, 206, 235, 0.25);
        }

        .search-btn {
            background: #87CEEB;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 11px;
            font-weight: 600;
            transition: background-color 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 4px;
            height: 32px;
            min-width: 70px;
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
            text-align: center;
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
            text-align: center;
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
            padding: 6px 12px !important;
            border-radius: 20px !important;
            font-size: 11px !important;
            font-weight: 600 !important;
            text-align: center !important;
            display: inline-flex !important;
            align-items: center !important;
            justify-content: center !important;
            text-transform: uppercase !important;
            letter-spacing: 0.5px !important;
            min-width: 70px !important;
            gap: 4px !important;
            transition: all 0.3s ease !important;
            border: 2px solid transparent !important;
            background: #6c757d !important;
            color: white !important;
        }

        .status-badge:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }

        .status-active {
            background: linear-gradient(135deg, #28a745, #20c997) !important;
            color: white !important;
            border-color: #28a745 !important;
        }

        .status-active::before {
            content: '●' !important;
            font-size: 8px !important;
            animation: pulse 2s infinite !important;
        }

        .status-inactive {
            background: linear-gradient(135deg, #dc3545, #fd7e14) !important;
            color: white !important;
            border-color: #dc3545 !important;
        }

        .status-inactive::before {
            content: '●' !important;
            font-size: 8px !important;
            opacity: 0.7 !important;
        }

        .status-n-a {
            background: linear-gradient(135deg, #6c757d, #495057) !important;
            color: white !important;
            border-color: #6c757d !important;
        }

        .status-n-a::before {
            content: '?' !important;
            font-size: 8px !important;
            opacity: 0.7 !important;
        }

        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.5; }
            100% { opacity: 1; }
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
            align-items: center;
            text-align: center;
        }

        .user-name {
            font-weight: 600;
            color: #333;
            font-size: 12px;
            line-height: 1.1;
        }

        .user-email {
            font-size: 11px;
            color: #007bff;
            font-style: italic;
            transition: color 0.2s ease;
        }

        .user-email:hover {
            color: #0056b3;
            text-decoration: underline;
        }

        .last-access {
            font-size: 12px;
            color: #666;
            display: flex;
            align-items: center;
            justify-content: center;
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
            padding: 4px 12px;
            border-radius: 20px;
            display: inline-block;
            transition: all 0.2s ease;
            border: 1px solid #e0e0e0;
        }

        .user-role:hover {
            background: #e8e8e8;
            transform: translateY(-1px);
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .user-department {
            font-size: 12px;
            color: #666;
            font-weight: 500;
            background: #f8f9fa;
            padding: 3px 10px;
            border-radius: 15px;
            display: inline-block;
            border: 1px solid #e9ecef;
            transition: all 0.2s ease;
        }

        .user-department:hover {
            background: #e9ecef;
            transform: translateY(-1px);
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
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

        /* Status Badge Styles - Elegant and compact */
        .users-grid .status-badge {
            padding: 4px 8px !important;
            border-radius: 12px !important;
            font-size: 10px !important;
            font-weight: 500 !important;
            text-align: center !important;
            display: inline-flex !important;
            align-items: center !important;
            justify-content: center !important;
            text-transform: uppercase !important;
            letter-spacing: 0.3px !important;
            min-width: 50px !important;
            gap: 3px !important;
            transition: all 0.2s ease !important;
            border: 1px solid transparent !important;
            background: #6c757d !important;
            color: white !important;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1) !important;
        }

        .users-grid .status-badge:hover {
            transform: translateY(-0.5px) !important;
            box-shadow: 0 2px 6px rgba(0,0,0,0.15) !important;
        }

        .users-grid .status-active {
            background: #28a745 !important;
            color: white !important;
            border-color: #1e7e34 !important;
        }

        .users-grid .status-active::before {
            content: '●' !important;
            font-size: 6px !important;
            animation: pulse 2s infinite !important;
            margin-right: 3px !important;
        }

        .users-grid .status-inactive {
            background: #6c757d !important;
            color: white !important;
            border-color: #545b62 !important;
        }

        .users-grid .status-inactive::before {
            content: '●' !important;
            font-size: 6px !important;
            opacity: 0.8 !important;
            margin-right: 3px !important;
        }

        .users-grid .status-n-a {
            background: #6c757d !important;
            color: white !important;
            border-color: #545b62 !important;
        }

        .users-grid .status-n-a::before {
            content: '?' !important;
            font-size: 6px !important;
            opacity: 0.8 !important;
            margin-right: 3px !important;
        }

        /* Toast Notifications */
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
        }

        .toast {
            min-width: 300px;
            max-width: 400px;
            margin-bottom: 10px;
            border: none;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            opacity: 0;
            transform: translateX(100%);
            transition: opacity 0.3s ease, transform 0.3s ease;
        }

        .toast.show {
            opacity: 1;
            transform: translateX(0);
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
            display: flex;
            align-items: center;
            padding: 8px 12px;
            border-bottom: 1px solid rgba(0,0,0,0.1);
            border-top-left-radius: 8px;
            border-top-right-radius: 8px;
        }

        .toast-body {
            padding: 12px;
        }

        .btn-close {
            background: none;
            border: none;
            font-size: 18px;
            cursor: pointer;
            margin-left: auto;
            padding: 0;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0.5;
        }

        .btn-close:hover {
            opacity: 1;
        }

        .btn-close::before {
            content: '×';
            font-size: 20px;
            line-height: 1;
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
            
            .toast-container {
                top: 10px;
                right: 10px;
                left: 10px;
            }
            
            .toast {
                min-width: auto;
                max-width: none;
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
                    <h2 style="margin: 0; font-size: 18px;">
                        <i class="fas fa-user-cog" style="margin-right: 8px;"></i>
                        Gestión de Usuarios
                    </h2>
                </div>
                <div>
                    <button type="button" onclick="window.location.href='dashboardSistemas.aspx'" style="background: rgba(255,255,255,0.2); border: none; color: white; padding: 8px 12px; border-radius: 5px; cursor: pointer; display: flex; align-items: center; gap: 5px;">
                        <i class="fas fa-arrow-left"></i>
                        Volver
                    </button>
                </div>
            </div>

            <!-- Search Section -->
            <div class="search-section">
                <div class="search-row">
                    <div class="form-group">
                        <label class="form-label">Nombre o Apellido</label>
                        <input type="text" id="filtroNombre" class="form-input" placeholder="Ingrese nombre o apellido" />
                    </div>
                    <div class="form-group">
                        <label class="form-label">Nombre de Usuario</label>
                        <input type="text" id="filtroUsuario" class="form-input" placeholder="Nombre de usuario" autocomplete="new-password" data-lpignore="true" readonly onfocus="this.removeAttribute('readonly')" />
                    </div>
                    <div class="form-group">
                        <label class="form-label">Estado</label>
                        <select id="filtroEstado" class="form-select">
                            <option value="">Todos los estados</option>
                            <option value="Activo">Activo</option>
                            <option value="Inactivo">Inactivo</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Rol</label>
                        <select id="filtroRol" class="form-select">
                            <option value="">Todos los roles</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Departamento</label>
                        <select id="filtroDepartamento" class="form-select">
                            <option value="">Todos los departamentos</option>
                        </select>
                    </div>
                    <div style="display: inline-flex; gap: 8px; align-items: center; flex-shrink: 0;">
                        <button type="button" class="search-btn" onclick="buscarUsuarios()">
                            <i class="fas fa-search"></i>
                            Buscar
                        </button>
                        <button type="button" class="add-user-btn" onclick="showAddUserForm()">
                            <i class="fas fa-plus"></i>
                            Agregar
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
                        <span id="modalTitle">Agregar Usuario</span>
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
                                <input type="text" id="usuario" class="form-input" required autocomplete="new-password" data-lpignore="true" readonly onfocus="this.removeAttribute('readonly')" />
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
                                <select id="rol" class="form-select" required>
                                    <option value="">Seleccione un rol</option>
                                </select>
                                <div class="error-message" id="rolError"></div>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Departamento</label>
                                <select id="departamento" class="form-select">
                                    <option value="0">Sin departamento</option>
                                </select>
                                <div class="error-message" id="departamentoError"></div>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Estado <span class="required">*</span></label>
                                <select id="estado" class="form-select" required>
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

        <!-- Toast Container -->
        <div class="toast-container" id="toastContainer"></div>
    </form>

    <script type="text/javascript">
        // Variables globales
        let usuarios = [];
        let roles = [];
        let departamentos = [];
        let usuarioActual = null;

        // Funciones de Toast Notifications
        function showToast(type, title, message, duration = 4000) {
            const toastContainer = document.getElementById('toastContainer');
            const toastId = 'toast-' + Date.now();
            const iconClass = getToastIcon(type);
            const toastClass = 'toast-' + type;
            
            const toast = document.createElement('div');
            toast.id = toastId;
            toast.className = `toast ${toastClass}`;
            toast.setAttribute('role', 'alert');
            toast.setAttribute('aria-live', 'assertive');
            toast.setAttribute('aria-atomic', 'true');
            
            toast.innerHTML = `
                <div class="toast-header">
                    <i class="${iconClass} me-2"></i>
                    <strong class="me-auto">${title}</strong>
                    <button type="button" class="btn-close" onclick="closeToast('${toastId}')" aria-label="Close"></button>
                </div>
                <div class="toast-body">
                    ${message}
                </div>
            `;
            
            toastContainer.appendChild(toast);
            
            // Mostrar toast con animación
            setTimeout(() => toast.classList.add('show'), 100);
            
            // Auto-ocultar toast después del tiempo especificado
            setTimeout(() => {
                closeToast(toastId);
            }, duration);
        }

        function closeToast(toastId) {
            const toast = document.getElementById(toastId);
            if (toast) {
                toast.classList.remove('show');
                setTimeout(() => {
                    if (toast.parentNode) {
                        toast.parentNode.removeChild(toast);
                    }
                }, 300);
            }
        }

        function getToastIcon(type) {
            switch(type) {
                case 'success': return 'fas fa-check-circle text-success';
                case 'error': return 'fas fa-exclamation-circle text-danger';
                case 'warning': return 'fas fa-exclamation-triangle text-warning';
                case 'info': return 'fas fa-info-circle text-info';
                default: return 'fas fa-bell text-primary';
            }
        }

        // Función para convertir fecha de .NET a JavaScript
        function parseNetDate(dateString) {
            if (!dateString) return null;
            
            // Verificar si es formato .NET /Date(timestamp)/
            const match = dateString.match(/\/Date\((-?\d+)\)\//);
            if (match) {
                const timestamp = parseInt(match[1]);
                return new Date(timestamp);
            }
            
            // Si no es formato .NET, intentar parsear como fecha normal
            return new Date(dateString);
        }

        // Función de inicialización
        function initUserManagement() {
            
            // Inicializar monitoreo de inactividad
            if (typeof initializeInactivityMonitoring === 'function') {
                initializeInactivityMonitoring();
            }
            
            // Verificar si PageMethods está disponible
            if (typeof PageMethods === 'undefined') {
                showToast('error', 'Error', 'PageMethods no está disponible. Verificar configuración del ScriptManager.');
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
                        showToast('error', 'Error', 'Error al cargar usuarios: ' + result);
                        return;
                    }

                    try {
                        usuarios = JSON.parse(result);
                        
                        renderizarTabla();
                    } catch (e) {
                        showToast('error', 'Error', 'Error al procesar los datos de usuarios');
                    }
                }, function(error) {
                    mostrarLoading(false);
                    showToast('error', 'Error', 'Error de comunicación al cargar usuarios: ' + error);
                });
            } catch (e) {
                mostrarLoading(false);
                showToast('error', 'Error', 'Error al llamar el método del servidor: ' + e.message);
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
                const deptoNombre = user.DepartamentoNombre || 'Sin departamento';
                
                // Manejar el estado con mejor lógica
                const estado = user.Estado || 'N/A';
                let estadoClass;
                
                if (estado.toLowerCase() === 'activo') {
                    estadoClass = 'active';
                } else if (estado.toLowerCase() === 'inactivo') {
                    estadoClass = 'inactive';
                } else {
                    estadoClass = 'n-a';
                }
                
                let ultimoAcceso;
                if (user.UltimoAcceso) {
                    try {
                        const fecha = parseNetDate(user.UltimoAcceso);
                        
                        if (fecha && !isNaN(fecha.getTime())) {
                            ultimoAcceso = fecha.toLocaleString('es-ES', {
                                year: 'numeric',
                                month: '2-digit',
                                day: '2-digit',
                                hour: '2-digit',
                                minute: '2-digit',
                                second: '2-digit',
                                hour12: true
                            });
                        } else {
                            ultimoAcceso = 'Fecha inválida';
                        }
                    } catch (error) {
                        ultimoAcceso = 'Error en fecha';
                    }
                } else {
                    ultimoAcceso = 'Nunca';
                }

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
                    <td><span class="status-badge status-${estadoClass}">${estado}</span></td>
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
            document.getElementById('modalTitle').textContent = 'Agregar Usuario';
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
                            showToast('error', 'Error', 'Error al guardar usuario: ' + result);
                            return;
                        }

                        if (result === 'OK' || result === 'SUCCESS' || result.includes('éxito') || result.includes('exitosamente')) {
                            showToast('success', 'Éxito', usuarioId === 0 ? 'Usuario creado exitosamente' : 'Usuario actualizado exitosamente');
                            closeModal();
                            cargarUsuarios();
                        } else {
                            // Solo mostrar como error si no contiene palabras de éxito
                            if (!result.includes('éxito') && !result.includes('exitosamente') && !result.includes('success')) {
                                showToast('error', 'Error', result);
                            } else {
                                showToast('success', 'Éxito', usuarioId === 0 ? 'Usuario creado exitosamente' : 'Usuario actualizado exitosamente');
                                closeModal();
                                cargarUsuarios();
                            }
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

            // Usar confirmación nativa del navegador
            if (confirm('¿Está seguro de que desea eliminar este usuario? Esta acción no se puede deshacer.')) {
                PageMethods.EliminarUsuario(usuarioId, function(result) {
                    if (result.startsWith('ERROR:')) {
                        showToast('error', 'Error', 'Error al eliminar usuario: ' + result);
                        return;
                    }

                    if (result === 'OK' || result === 'SUCCESS' || result.includes('éxito') || result.includes('exitosamente')) {
                        showToast('success', 'Éxito', 'Usuario eliminado exitosamente');
                        closeModal();
                        cargarUsuarios();
                    } else {
                        // Solo mostrar como error si no contiene palabras de éxito
                        if (!result.includes('éxito') && !result.includes('exitosamente') && !result.includes('success')) {
                            showToast('error', 'Error', result);
                        } else {
                            showToast('success', 'Éxito', 'Usuario eliminado exitosamente');
                            closeModal();
                            cargarUsuarios();
                        }
                    }
                });
            }
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

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>



