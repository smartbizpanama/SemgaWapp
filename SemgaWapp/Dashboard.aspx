<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="Dashboard.aspx.vb" Inherits="SemgaWapp.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Panel de Control</title>
    <meta charset="utf-8" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    
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

        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .welcome-text {
            color: #666;
            font-size: 14px;
        }

        /* Estilos para el tooltip de ID de sesión */
        .user-name-tooltip {
            cursor: pointer;
            position: relative;
            transition: all 0.3s ease;
        }

        .user-name-tooltip:hover {
            color: #007bff;
            text-shadow: 0 0 5px rgba(0, 123, 255, 0.3);
        }

        .session-tooltip {
            position: absolute;
            top: -10px;
            right: 0;
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(15px);
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 0;
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px) scale(0.95);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            z-index: 1000;
            min-width: 280px;
            max-width: 350px;
        }

        .session-tooltip.show {
            opacity: 1;
            visibility: visible;
            transform: translateY(0) scale(1);
        }

        .tooltip-content {
            padding: 0;
            overflow: hidden;
            border-radius: 12px;
        }

        .tooltip-header {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            padding: 12px 16px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            font-size: 14px;
        }

        .tooltip-header i {
            font-size: 16px;
        }

        .tooltip-body {
            padding: 16px;
            background: white;
        }

        .session-id-container {
            display: flex;
            align-items: center;
            gap: 8px;
            background: #f8f9fa;
            border-radius: 8px;
            padding: 8px;
            border: 1px solid #e9ecef;
        }

        .session-id-input {
            flex: 1;
            border: none;
            background: transparent;
            font-family: 'Courier New', monospace;
            font-size: 12px;
            color: #495057;
            padding: 4px 8px;
            outline: none;
            cursor: text;
        }

        .copy-btn {
            background: #007bff;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 6px 10px;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
        }

        .copy-btn:hover {
            background: #0056b3;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0, 123, 255, 0.3);
        }

        .copy-btn:active {
            transform: translateY(0);
        }

        .copy-btn.copied {
            background: #28a745;
        }

        .copy-btn.copied i::before {
            content: "\f00c";
        }

        .logout-btn {
            background: linear-gradient(135deg, #dc3545, #c82333);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .logout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.3);
        }

        .main-content {
            padding: 10px;
            max-width: 1600px;
            margin: 0 auto;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 280px));
            gap: 12px;
            margin-top: 12px;
            justify-content: start;
        }

        .card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 12px;
            padding: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            cursor: pointer;
            max-width: 280px;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }

        .card-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
        }

        .card-icon {
            width: 35px;
            height: 35px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            color: white;
        }

        .card-title {
            font-size: 14px;
            font-weight: 600;
            color: #333;
        }

        .card-content {
            color: #666;
            line-height: 1.6;
        }

        .members-card .card-icon {
            background: linear-gradient(135deg, #28a745, #20c997);
        }

        .loans-card .card-icon {
            background: linear-gradient(135deg, #007bff, #0056b3);
        }

        .auxiliares-card .card-icon {
            background: linear-gradient(135deg, #6f42c1, #5a2d91);
        }

        .savings-card .card-icon {
            background: linear-gradient(135deg, #ffc107, #e0a800);
        }

        .reports-card .card-icon {
            background: linear-gradient(135deg, #3498db, #2980b9);
        }

        .finanzas-card .card-icon {
            background: linear-gradient(135deg, #ffd700, #ffa500);
        }

        .logs-card .card-icon {
            background: linear-gradient(135deg, #17a2b8, #138496);
        }

        .admin-card .card-icon {
            background: linear-gradient(135deg, #dc3545, #c82333);
        }

        .help-card .card-icon {
            background: linear-gradient(135deg, #17a2b8, #138496);
        }

        .cambio-pass-card .card-icon {
            background: linear-gradient(135deg, #e67e22, #d35400);
        }

        /* Modal Cambio de contraseña */
        .modal-cambiopass-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 9998;
            backdrop-filter: blur(4px);
        }
        .modal-cambiopass-overlay.show { display: block; }
        .modal-cambiopass-window {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 100%;
            max-width: 420px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            z-index: 9999;
            overflow: hidden;
        }
        .modal-cambiopass-titlebar {
            background: linear-gradient(180deg, #f0f0f0 0%, #e0e0e0 100%);
            border-bottom: 1px solid #ccc;
            padding: 10px 14px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 15px;
            font-weight: 600;
            color: #333;
        }
        .modal-cambiopass-titlebar .modal-cambiopass-close {
            width: 28px;
            height: 28px;
            border: 1px solid #999;
            background: linear-gradient(180deg, #fff 0%, #e8e8e8 100%);
            border-radius: 4px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            line-height: 1;
            color: #333;
            padding: 0;
        }
        .modal-cambiopass-close:hover {
            background: linear-gradient(180deg, #e8e8e8 0%, #d0d0d0 100%);
        }
        .modal-cambiopass-body {
            padding: 24px;
        }
        .modal-cambiopass-body .form-group { margin-bottom: 16px; }
        .modal-cambiopass-body .form-label { display: block; margin-bottom: 6px; font-weight: 600; color: #333; font-size: 14px; }
        .modal-cambiopass-body .form-control {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            box-sizing: border-box;
        }
        .modal-cambiopass-body .btn-cambiar-wrap {
            text-align: center;
            margin-top: 8px;
        }
        .modal-cambiopass-body .btn-cambiar {
            padding: 10px 20px;
            background: linear-gradient(135deg, #e67e22, #d35400);
            color: #fff;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
        }
        .modal-cambiopass-body .btn-cambiar:hover { opacity: 0.9; }
        .modal-cambiopass-msg { margin-top: 12px; padding: 10px 12px; border-radius: 6px; font-size: 13px; display: none; }
        .modal-cambiopass-msg.ok { background: #d4edda; color: #155724; display: block; }
        .modal-cambiopass-msg.error { background: #f8d7da; color: #721c24; display: block; }

        .welcome-banner {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 12px;
            padding: 12px;
            text-align: center;
            margin-bottom: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .welcome-title {
            font-size: 20px;
            font-weight: 700;
            color: #333;
            margin-bottom: 8px;
        }

        .welcome-subtitle {
            display: none;
        }

        .user-role {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #d4edda;
            color: #155724;
            padding: 6px 12px;
            border-radius: 18px;
            font-size: 12px;
            font-weight: 500;
        }

        .user-role i {
            color: #28a745;
        }

        .admin-badge {
            background: #f8d7da;
            color: #721c24;
        }

        .admin-badge i {
            color: #dc3545;
        }

        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }

            .dashboard-grid {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .welcome-title {
                font-size: 20px;
            }

            .card {
                padding: 15px;
            }

            .card-icon {
                width: 40px;
                height: 40px;
                font-size: 20px;
            }

            .card-title {
                font-size: 15px;
            }
        }
    </style>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
</head>
<body>
    <form id="form1" runat="server">
        <!-- Header -->
        <div class="header">
            <div class="logo">
                <div class="logo-icon">
                    <i class="fa-solid fa-vault"></i>
                </div>
                <div class="logo-text">Cooperativa Coopsemga</div>
            </div>
            
            <div class="user-info">
                <div class="welcome-text">
                    Bienvenido, <strong id="userName" class="user-name-tooltip" data-session-id="<%= Session("LogID") %>"><%= Session("Nombre") & " " & Session("Apellido") %></strong>
                </div>
                <div id="sessionTooltip" class="session-tooltip">
                    <div class="tooltip-content">
                        <div class="tooltip-header">
                            <i class="fas fa-id-card"></i>
                            <span>ID de Sesión</span>
                        </div>
                        <div class="tooltip-body">
                            <div class="session-id-container">
                                <input type="text" id="sessionIdInput" readonly class="session-id-input" />
                                <button type="button" class="copy-btn" onclick="copySessionId()" title="Copiar ID">
                                    <i class="fas fa-copy"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <asp:Button ID="btnLogout" runat="server" Text="Cerrar Sesi&#243;n" 
                           CssClass="logout-btn" OnClick="btnLogout_Click" />
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">

            <!-- Dashboard Grid -->
            <div class="dashboard-grid">
                <!-- Members Card -->
                <div class="card members-card" data-url="forms/socios/gestionsocios.aspx" onclick="window.location.href='Forms/Socios/GestionSocios.aspx'">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-users"></i>
                        </div>
                                                 <div class="card-title">Gesti&#243;n de Socios</div>
                    </div>
                                        <div class="card-content">
                        <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px;">
                            <h3 id="sociosActivosCount" style="color: #28a745; font-size: 24px; margin: 0; font-weight: 700;">-</h3>
                            <span style="font-size: 12px; color: #666;">Socios activos</span>
                        </div>
                        <div id="miniGraficoTipos" style="padding: 8px; background: rgba(40, 167, 69, 0.1); border-radius: 6px; min-height: 50px;">
                            <div id="graficoBarras" style="display: flex; align-items: end; gap: 8px; height: 40px; justify-content: center; width: 100%;">
                                <div style="color: #999; font-size: 10px; text-align: center;">Cargando...</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Movimientos Card -->
                <div class="card loans-card" data-url="forms/transacciones/transacciones.aspx" onclick="window.location.href='Forms/Transacciones/Transacciones.aspx'">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-exchange-alt"></i>
                        </div>
                        <div class="card-title">Movimientos de Cuentas</div>
                    </div>
                    <div class="card-content">
                        <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px;">
                            <h3 id="totalMovimientosCount" style="color: #007bff; font-size: 24px; margin: 0; font-weight: 700;">-</h3>
                            <span style="font-size: 12px; color: #666;">Movimientos esta semana</span>
                        </div>
                        <div id="miniGraficoMovimientos" style="padding: 8px; background: rgba(0, 123, 255, 0.1); border-radius: 6px; min-height: 50px;">
                            <div id="graficoBarrasMovimientos" style="display: flex; align-items: end; gap: 8px; height: 40px; justify-content: center; width: 100%;">
                                <div style="color: #999; font-size: 10px; text-align: center;">Cargando...</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Auxiliares Card -->
                <div class="card auxiliares-card" data-url="forms/auxiliares/auxiliaresasociados.aspx" onclick="window.location.href='Forms/Auxiliares/AuxiliaresAsociados.aspx'">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-users-cog"></i>
                        </div>
                        <div class="card-title">Gesti&#243;n de Auxiliares</div>
                    </div>
                    <div class="card-content">
                        <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px;">
                            <h3 id="auxiliaresActivosCount" style="color: #6f42c1; font-size: 24px; margin: 0; font-weight: 700;">-</h3>
                            <span style="font-size: 12px; color: #666;">Auxiliares activos</span>
                        </div>
                        <div id="miniGraficoAuxiliares" style="padding: 8px; background: rgba(111, 66, 193, 0.1); border-radius: 6px; min-height: 50px;">
                            <div id="graficoBarrasAuxiliares" style="display: flex; align-items: end; gap: 8px; height: 40px; justify-content: center; width: 100%;">
                                <div style="color: #999; font-size: 10px; text-align: center;">Cargando...</div>
                            </div>
                        </div>
                    </div>
                </div>

                                <!-- Reports Card -->
                <div class="card reports-card" data-url="forms/reportes/dashboardreportes.aspx" onclick="window.location.href='Forms/Reportes/dashboardReportes.aspx'">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-chart-bar"></i>
                        </div>
                        <div class="card-title">Reportes y Estad&#237;sticas</div>
                    </div>
                    <div class="card-content">
                        <div style="margin-bottom: 8px;">
                            <a href="#" style="display: block; color: #666; text-decoration: none; padding: 3px 0; border-bottom: 1px solid #eee;">
                                <i class="fas fa-chart-line" style="margin-right: 5px;"></i>
                                Reporte mensual
                            </a>
                        </div>
                        <div style="margin-bottom: 8px;">
                            <a href="#" style="display: block; color: #666; text-decoration: none; padding: 3px 0; border-bottom: 1px solid #eee;">
                                <i class="fas fa-chart-pie" style="margin-right: 5px;"></i>
                                Estad&#237;sticas de socios
                            </a>
                        </div>
                        <div style="margin-bottom: 8px;">
                            <a href="#" style="display: block; color: #666; text-decoration: none; padding: 3px 0; border-bottom: 1px solid #eee;">
                                <i class="fas fa-file-invoice-dollar" style="margin-right: 5px;"></i>
                                Reporte financiero
                            </a>
                        </div>
                        <div>
                            <a href="#" style="display: block; color: #666; text-decoration: none; padding: 3px 0;">
                                <i class="fas fa-download" style="margin-right: 5px;"></i>
                                Exportar datos
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Finanzas Card (solo para Gerentes y Administradores) -->
                <div class="card finanzas-card" id="finanzasCard" data-url="forms/finanzas/finanzas.aspx" onclick="window.location.href='Forms/Finanzas/Finanzas.aspx'" style="display: none;">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                        <div class="card-title">Finanzas</div>
                    </div>
                    <div class="card-content">
                        <div>
                            <a href="#" style="display: block; color: #666; text-decoration: none; padding: 3px 0;">
                                <i class="fas fa-money-bill-wave" style="margin-right: 5px;"></i>
                                Transacciones
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Logs and Audit Card -->
                <div class="card logs-card" id="logsCard" data-url="forms/logs/detallelogs.aspx" onclick="accederLogs()" style="display: none;">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-clipboard-list"></i>
                        </div>
                        <div class="card-title">Logs y Auditor&#237;as</div>
                    </div>
                    <div class="card-content">
                        <div style="margin-bottom: 8px;">
                            <a href="#" style="display: block; color: #666; text-decoration: none; padding: 3px 0; border-bottom: 1px solid #eee;">
                                <i class="fas fa-history" style="margin-right: 5px;"></i>
                                Historial de accesos
                            </a>
                        </div>
                        <div style="margin-bottom: 8px;">
                            <a href="#" style="display: block; color: #666; text-decoration: none; padding: 3px 0; border-bottom: 1px solid #eee;">
                                <i class="fas fa-exclamation-triangle" style="margin-right: 5px;"></i>
                                Alertas de seguridad
                            </a>
                        </div>
                        <div style="margin-bottom: 8px;">
                            <a href="#" style="display: block; color: #666; text-decoration: none; padding: 3px 0; border-bottom: 1px solid #eee;">
                                <i class="fas fa-user-clock" style="margin-right: 5px;"></i>
                                Actividad de usuarios
                            </a>
                        </div>
                        <div>
                            <a href="#" style="display: block; color: #666; text-decoration: none; padding: 3px 0;">
                                <i class="fas fa-file-alt" style="margin-right: 5px;"></i>
                                Reportes de auditor&#237;a
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Admin Settings Card (visibilidad solo por permisos de menú) -->
                <div class="card admin-card" data-url="forms/mantenimientos/dashboardsistemas.aspx" onclick="window.location.href='Forms/Mantenimientos/dashboardSistemas.aspx'">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-cogs"></i>
                        </div>
                        <div class="card-title">Configuraciones del Sistema</div>
                    </div>
                                        <div class="card-content">
                        <div style="margin-bottom: 8px;">
                            <a href="#" style="display: block; color: #666; text-decoration: none; padding: 3px 0; border-bottom: 1px solid #eee;">
                                <i class="fas fa-user-cog" style="margin-right: 5px;"></i>
                                Gesti&#243;n de usuarios
                            </a>
                        </div>
                        <div style="margin-bottom: 8px;">
                            <a href="#" style="display: block; color: #666; text-decoration: none; padding: 3px 0; border-bottom: 1px solid #eee;">
                                <i class="fas fa-shield-alt" style="margin-right: 5px;"></i>
                                Configuraci&#243;n de seguridad
                            </a>
                        </div>
                        <div style="margin-bottom: 8px;">
                            <a href="#" style="display: block; color: #666; text-decoration: none; padding: 3px 0; border-bottom: 1px solid #eee;">
                                <i class="fas fa-database" style="margin-right: 5px;"></i>
                                Respaldo de datos
                            </a>
                        </div>
                        <div>
                            <a href="#" style="display: block; color: #666; text-decoration: none; padding: 3px 0;">
                                <i class="fas fa-tools" style="margin-right: 5px;"></i>
                                Mantenimiento del sistema
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Cambio de contraseña (visible para todos) -->
                <div class="card cambio-pass-card" onclick="abrirModalCambioPass(event)">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-key"></i>
                        </div>
                        <div class="card-title">Cambio de contraseña</div>
                    </div>
                    <div class="card-content">
                        <div style="color: #666; font-size: 13px;">
                            Actualizar su contraseña de acceso.
                        </div>
                    </div>
                </div>

                <!-- Help Card -->
                <div class="card help-card" data-url="forms/help/helpdashboard.aspx" onclick="window.location.href='Forms/Help/helpDashboard.aspx'">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-question-circle"></i>
                        </div>
                        <div class="card-title">Ayuda</div>
                    </div>
                    <div class="card-content">
                        <div>
                            <a href="#" style="display: block; color: #666; text-decoration: none; padding: 3px 0;">
                                <i class="fas fa-life-ring" style="margin-right: 5px;"></i>
                                Centro de ayuda
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal Cambio de contraseña (overlay + ventana) -->
            <div id="modalCambioPassOverlay" class="modal-cambiopass-overlay"></div>
            <div id="modalCambioPassWindow" class="modal-cambiopass-window" style="display: none;" onclick="event.stopPropagation()">
                <div class="modal-cambiopass-titlebar">
                    <span>Cambio de contraseña</span>
                    <button type="button" class="modal-cambiopass-close" onclick="cerrarModalCambioPass()" title="Cerrar">&#215;</button>
                </div>
                <div class="modal-cambiopass-body">
                    <div class="form-group">
                        <label class="form-label" for="modalNuevaClave">Nueva contraseña</label>
                        <input type="password" id="modalNuevaClave" class="form-control" placeholder="Nueva contraseña" />
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="modalRepetirClave">Repetir contraseña</label>
                        <input type="password" id="modalRepetirClave" class="form-control" placeholder="Repetir contraseña" />
                    </div>
                    <div class="btn-cambiar-wrap">
                        <button type="button" class="btn-cambiar" id="btnModalCambiarPass">Cambiar contraseña</button>
                    </div>
                    <div id="modalCambioPassMsg" class="modal-cambiopass-msg"></div>
                </div>
            </div>
        </div>
    </form>
    
    <!-- Scripts necesarios para el monitoreo de inactividad -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    
    <!-- Script de monitoreo de inactividad -->
    <script src="Scripts/smart-chips.js"></script>
    <script src="Scripts/inactivity-monitor-final.js?v=2.6"></script>
    
    <!-- Script para cargar datos del dashboard -->
    <script>
        $(document).ready(function() {
            cargarDatosDashboard();
        });

        function cargarDatosDashboard() {
            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/ObtenerDatosDashboard",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }
                    
                    if (response.d.Success) {
                        // Actualizar el número de socios activos
                        var sociosActivos = response.d.Data.SociosActivos;
                        $('#sociosActivosCount').text(sociosActivos.toLocaleString());
                        
                        // Actualizar el número de auxiliares activos
                        var auxiliaresActivos = response.d.Data.AuxiliaresActivos;
                        $('#auxiliaresActivosCount').text(auxiliaresActivos.toLocaleString());
                        
                        // Procesar y mostrar el minigráfico de tipos de asociados
                        var jsonTiposAsociados = response.d.Data.JsonTiposAsociados;
                        
                        if (jsonTiposAsociados && jsonTiposAsociados !== '[]' && jsonTiposAsociados !== 'null') {
                            try {
                                var tiposAsociados = JSON.parse(jsonTiposAsociados);
                                
                                crearMiniGrafico(tiposAsociados);
                            } catch (e) {
                                
                                
                            }
                        } else {
                            
                            $('#graficoBarras').html('<div style="color: #999; font-size: 10px; text-align: center;">Sin datos disponibles</div>');
                        }
                        
                        // Procesar y mostrar los movimientos por día
                        var jsonUltimosMovimientos = response.d.Data.JsonUltimosMovimientos;
                        
                        
                        if (jsonUltimosMovimientos && jsonUltimosMovimientos !== '[]' && jsonUltimosMovimientos !== 'null') {
                            try {
                                var movimientosPorDia = JSON.parse(jsonUltimosMovimientos);
                                
                                mostrarMovimientosPorDia(movimientosPorDia);
                            } catch (e) {
                                
                                
                            }
                        } else {
                            
                            $('#totalMovimientosCount').text('0');
                            $('#graficoBarrasMovimientos').html('<div style="color: #999; font-size: 10px; text-align: center;">Sin datos disponibles</div>');
                        }
                        
                        // Procesar y mostrar el minigráfico de tipos de auxiliares
                        var jsonTiposAuxiliares = response.d.Data.JsonTiposAuxiliares;
                        
                        
                        if (jsonTiposAuxiliares && jsonTiposAuxiliares !== '[]' && jsonTiposAuxiliares !== 'null') {
                            try {
                                var tiposAuxiliares = JSON.parse(jsonTiposAuxiliares);
                                
                                crearMiniGraficoAuxiliares(tiposAuxiliares);
                            } catch (e) {
                                
                                
                                $('#graficoBarrasAuxiliares').html('<div style="color: #999; font-size: 10px; text-align: center;">Error al cargar datos</div>');
                            }
                        } else {
                            
                            $('#graficoBarrasAuxiliares').html('<div style="color: #999; font-size: 10px; text-align: center;">Sin datos disponibles</div>');
                        }
                    } else {
                        
                        $('#sociosActivosCount').text('Error');
                    }
                },
                error: function(xhr, status, error) {
                    
                    $('#sociosActivosCount').text('Error');
                }
            });
        }

        function crearMiniGrafico(tiposAsociados) {
            
            
            var graficoBarras = $('#graficoBarras');
            if (graficoBarras.length === 0) {
                
                return;
            }
            
            // Limpiar contenido anterior
            graficoBarras.empty();
            
            // Verificar si hay datos válidos
            if (!tiposAsociados || tiposAsociados.length === 0 || !Array.isArray(tiposAsociados)) {
                
                graficoBarras.html('<div style="color: #999; font-size: 10px; text-align: center;">Sin datos</div>');
                return;
            }
            
            // Ajustar el justify-content dinámicamente
            var justificarContenido = tiposAsociados.length <= 3 ? 'center' : 'space-between';
            graficoBarras.css('justify-content', justificarContenido);
            
            // Verificar que los datos tengan la estructura correcta
            var datosValidos = tiposAsociados.filter(function(tipo) {
                return tipo && tipo.TipoAsociado && typeof tipo.Cantidad === 'number' && tipo.Cantidad >= 0;
            });
            
            if (datosValidos.length === 0) {
                
                graficoBarras.html('<div style="color: #999; font-size: 10px; text-align: center;">Sin datos</div>');
                return;
            }
            
            
            
            // Calcular el máximo para normalizar las barras
            var maxCantidad = Math.max(...datosValidos.map(t => t.Cantidad));
            
            
            // Colores para las barras
            var colores = ['#28a745', '#17a2b8', '#ffc107', '#dc3545', '#6c757d', '#fd7e14'];
            
            datosValidos.forEach(function(tipo, index) {
                var altura = maxCantidad > 0 ? (tipo.Cantidad / maxCantidad) * 35 : 0;
                var color = colores[index % colores.length];
                
                
                
                var barra = $('<div>').css({
                    'width': datosValidos.length <= 3 ? '16px' : 'auto',
                    'flex': datosValidos.length > 3 ? '1' : 'none',
                    'max-width': '20px',
                    'height': altura + 'px',
                    'background': color,
                    'border-radius': '2px 2px 0 0',
                    'position': 'relative',
                    'transition': 'all 0.3s ease',
                    'min-height': '2px'
                }).attr('title', tipo.TipoAsociado + ': ' + tipo.Cantidad);
                
                // Agregar etiqueta con el número
                var etiqueta = $('<div>').css({
                    'position': 'absolute',
                    'top': '-15px',
                    'left': '50%',
                    'transform': 'translateX(-50%)',
                    'font-size': '8px',
                    'color': '#333',
                    'font-weight': 'bold',
                    'white-space': 'nowrap'
                }).text(tipo.Cantidad);
                
                barra.append(etiqueta);
                graficoBarras.append(barra);
            });
            
            // Limpiar etiquetas anteriores si existen
            graficoBarras.next('.etiquetas-tipos').remove();
            
            // Agregar etiquetas de tipos debajo del gráfico
            var etiquetasContainer = $('<div>').addClass('etiquetas-tipos').css({
                'display': 'flex',
                'justify-content': datosValidos.length <= 3 ? 'center' : 'space-between',
                'gap': '8px',
                'margin-top': '4px',
                'flex-wrap': 'wrap',
                'width': '100%'
            });
            
            datosValidos.forEach(function(tipo, index) {
                var color = colores[index % colores.length];
                var etiqueta = $('<div>').css({
                    'font-size': '8px',
                    'color': '#666',
                    'display': 'flex',
                    'align-items': 'center',
                    'gap': '2px'
                });
                
                var punto = $('<div>').css({
                    'width': '6px',
                    'height': '6px',
                    'background': color,
                    'border-radius': '50%'
                });
                
                etiqueta.append(punto).append(tipo.TipoAsociado);
                etiquetasContainer.append(etiqueta);
            });
            
            graficoBarras.after(etiquetasContainer);
            
        }

        function crearMiniGraficoAuxiliares(tiposAuxiliares) {
            
            
            var graficoBarras = $('#graficoBarrasAuxiliares');
            if (graficoBarras.length === 0) {
                
                return;
            }
            
            // Limpiar contenido anterior
            graficoBarras.empty();
            
            // Verificar si hay datos válidos
            if (!tiposAuxiliares || tiposAuxiliares.length === 0 || !Array.isArray(tiposAuxiliares)) {
                
                graficoBarras.html('<div style="color: #999; font-size: 10px; text-align: center;">Sin datos</div>');
                return;
            }
            
            // Ajustar el justify-content dinámicamente
            var justificarContenido = tiposAuxiliares.length <= 3 ? 'center' : 'space-between';
            graficoBarras.css('justify-content', justificarContenido);
            
            // Verificar que los datos tengan la estructura correcta
            var datosValidos = tiposAuxiliares.filter(function(tipo) {
                return tipo && tipo.TipoAuxiliar && typeof tipo.Cantidad === 'number' && tipo.Cantidad >= 0;
            });
            
            if (datosValidos.length === 0) {
                
                graficoBarras.html('<div style="color: #999; font-size: 10px; text-align: center;">Sin datos</div>');
                return;
            }
            
            
            
            // Calcular el máximo para normalizar las barras
            var maxCantidad = Math.max(...datosValidos.map(t => t.Cantidad));
            
            
            // Colores para las barras (tonos púrpura)
            var colores = ['#6f42c1', '#8e44ad', '#9b59b6', '#a569bd', '#bb8fce', '#d2b4de'];
            
            datosValidos.forEach(function(tipo, index) {
                var altura = maxCantidad > 0 ? (tipo.Cantidad / maxCantidad) * 35 : 0;
                var color = colores[index % colores.length];
                
                
                
                var barra = $('<div>').css({
                    'width': datosValidos.length <= 3 ? '16px' : 'auto',
                    'flex': datosValidos.length > 3 ? '1' : 'none',
                    'max-width': '20px',
                    'height': altura + 'px',
                    'background': color,
                    'border-radius': '2px 2px 0 0',
                    'position': 'relative',
                    'transition': 'all 0.3s ease',
                    'min-height': '2px'
                }).attr('title', tipo.TipoAuxiliar + ': ' + tipo.Cantidad);
                
                // Agregar etiqueta con el número
                var etiqueta = $('<div>').css({
                    'position': 'absolute',
                    'top': '-15px',
                    'left': '50%',
                    'transform': 'translateX(-50%)',
                    'font-size': '8px',
                    'color': '#333',
                    'font-weight': 'bold',
                    'white-space': 'nowrap'
                }).text(tipo.Cantidad);
                
                barra.append(etiqueta);
                graficoBarras.append(barra);
            });
            
            // Limpiar etiquetas anteriores si existen
            graficoBarras.next('.etiquetas-tipos-auxiliares').remove();
            
            // Agregar etiquetas de tipos debajo del gráfico
            var etiquetasContainer = $('<div>').addClass('etiquetas-tipos-auxiliares').css({
                'display': 'flex',
                'justify-content': datosValidos.length <= 3 ? 'center' : 'space-between',
                'gap': '8px',
                'margin-top': '4px',
                'flex-wrap': 'wrap',
                'width': '100%'
            });
            
            datosValidos.forEach(function(tipo, index) {
                var color = colores[index % colores.length];
                var etiqueta = $('<div>').css({
                    'font-size': '8px',
                    'color': '#666',
                    'display': 'flex',
                    'align-items': 'center',
                    'gap': '2px'
                });
                
                var punto = $('<div>').css({
                    'width': '6px',
                    'height': '6px',
                    'background': color,
                    'border-radius': '50%'
                });
                
                etiqueta.append(punto).append(tipo.TipoAuxiliar);
                etiquetasContainer.append(etiqueta);
            });
            
            graficoBarras.after(etiquetasContainer);
            
        }

        function mostrarMovimientosPorDia(movimientosPorDia) {
            
            
            var graficoBarras = $('#graficoBarrasMovimientos');
            if (graficoBarras.length === 0) {
                
                return;
            }
            
            graficoBarras.empty();
            
            if (!movimientosPorDia || movimientosPorDia.length === 0) {
                
                graficoBarras.html('<div style="color: #999; font-size: 10px; text-align: center;">Sin datos</div>');
                return;
            }
            
            // Ajustar el justify-content dinámicamente
            var justificarContenido = movimientosPorDia.length <= 3 ? 'center' : 'space-between';
            graficoBarras.css('justify-content', justificarContenido);
            
            // Calcular el total de movimientos
            var totalMovimientos = movimientosPorDia.reduce(function(sum, dia) {
                return sum + (parseInt(dia.TotalMovimientos) || 0);
            }, 0);
            
            // Actualizar el contador total
            $('#totalMovimientosCount').text(totalMovimientos.toLocaleString());
            
            
            
            // Calcular el máximo para normalizar las barras
            var maxMovimientos = Math.max(...movimientosPorDia.map(d => parseInt(d.TotalMovimientos) || 0));
            
            
            // Colores para las barras (tonos azules)
            var colores = ['#007bff', '#0056b3', '#004085', '#003d82', '#003a7a', '#003771', '#003469'];
            
            movimientosPorDia.forEach(function(dia, index) {
                var cantidad = parseInt(dia.TotalMovimientos) || 0;
                var altura = maxMovimientos > 0 ? (cantidad / maxMovimientos) * 35 : 0;
                var color = colores[index % colores.length];
                
                
                
                var barra = $('<div>').css({
                    'width': movimientosPorDia.length <= 3 ? '16px' : 'auto',
                    'flex': movimientosPorDia.length > 3 ? '1' : 'none',
                    'max-width': '20px',
                    'height': altura + 'px',
                    'background': color,
                    'border-radius': '2px 2px 0 0',
                    'position': 'relative',
                    'transition': 'all 0.3s ease',
                    'min-height': '2px'
                }).attr('title', dia.DiaSemana + ': ' + cantidad + ' movimientos');
                
                // Agregar etiqueta con el número
                var etiqueta = $('<div>').css({
                    'position': 'absolute',
                    'top': '-15px',
                    'left': '50%',
                    'transform': 'translateX(-50%)',
                    'font-size': '8px',
                    'color': '#333',
                    'font-weight': 'bold',
                    'white-space': 'nowrap'
                }).text(cantidad);
                
                barra.append(etiqueta);
                graficoBarras.append(barra);
            });
            
            // Limpiar etiquetas anteriores si existen
            graficoBarras.next('.etiquetas-movimientos').remove();
            
            // Agregar etiquetas de días debajo del gráfico
            var etiquetasContainer = $('<div>').addClass('etiquetas-movimientos').css({
                'display': 'flex',
                'justify-content': movimientosPorDia.length <= 3 ? 'center' : 'space-between',
                'gap': '8px',
                'margin-top': '4px',
                'flex-wrap': 'wrap',
                'width': '100%'
            });
            
            movimientosPorDia.forEach(function(dia, index) {
                var color = colores[index % colores.length];
                var etiqueta = $('<div>').css({
                    'font-size': '8px',
                    'color': '#666',
                    'display': 'flex',
                    'align-items': 'center',
                    'gap': '2px'
                });
                
                var punto = $('<div>').css({
                    'width': '6px',
                    'height': '6px',
                    'background': color,
                    'border-radius': '50%'
                });
                
                etiqueta.append(punto).append(dia.DiaSemana);
                etiquetasContainer.append(etiqueta);
            });
            
            graficoBarras.after(etiquetasContainer);
            
        }

        // Acceder a logs (la visibilidad del mosaico se controla por permisos de menú)
        function accederLogs() {
            window.location.href = 'Forms/Logs/DetalleLogs.aspx';
        }

        function abrirModalCambioPass(e) {
            if (e) e.stopPropagation();
            $('#modalCambioPassOverlay').addClass('show');
            $('#modalCambioPassWindow').show();
            $('#modalNuevaClave, #modalRepetirClave').val('');
            $('#modalCambioPassMsg').removeClass('ok error').hide().text('');
        }
        function cerrarModalCambioPass() {
            $('#modalCambioPassOverlay').removeClass('show');
            $('#modalCambioPassWindow').hide();
        }
        $(document).ready(function() {
            $('#btnModalCambiarPass').on('click', function() {
                var nueva = ($('#modalNuevaClave').val() || '').trim();
                var repetir = ($('#modalRepetirClave').val() || '').trim();
                var $msg = $('#modalCambioPassMsg');
                $msg.removeClass('ok error').hide();
                if (!nueva) {
                    $msg.addClass('error').text('Ingrese la nueva contraseña.').show();
                    return;
                }
                if (nueva !== repetir) {
                    $msg.addClass('error').text('Las contraseñas no coinciden.').show();
                    return;
                }
                $(this).prop('disabled', true);
                $.ajax({
                    type: 'POST',
                    url: 'Dashboard.aspx/CambiarClave',
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    data: JSON.stringify({ nuevaClave: nueva }),
                    success: function(response) {
                        var d = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        $msg.removeClass('ok error').addClass(d.Success ? 'ok' : 'error').text(d.Message || (d.Success ? 'Contraseña actualizada correctamente.' : 'Error al cambiar la contraseña.')).show();
                        if (d.Success) {
                            $('#modalNuevaClave, #modalRepetirClave').val('');
                            setTimeout(cerrarModalCambioPass, 1500);
                        }
                    },
                    error: function(xhr, status, err) {
                        $msg.addClass('error').text('Error de conexión. Intente de nuevo.').show();
                    },
                    complete: function() {
                        $('#btnModalCambiarPass').prop('disabled', false);
                    }
                });
            });
        });

        // Funcionalidad del tooltip de ID de sesión
        $(document).ready(function() {
            // La visibilidad de Finanzas y Logs se controla solo por permisos de menú (script de permisos en DOMContentLoaded)
            
            const userName = $('#userName');
            const sessionTooltip = $('#sessionTooltip');
            const sessionIdInput = $('#sessionIdInput');
            
            // Obtener el ID de sesión del atributo data
            const sessionId = userName.data('session-id');
            sessionIdInput.val(sessionId);
            
            // Mostrar tooltip al hacer clic en el nombre del usuario
            userName.on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                sessionTooltip.addClass('show');
            });
            
            // Ocultar tooltip al hacer clic fuera de él
            $(document).on('click', function(e) {
                if (!userName.is(e.target) && !sessionTooltip.is(e.target) && sessionTooltip.has(e.target).length === 0) {
                    sessionTooltip.removeClass('show');
                }
            });
            
            // Mantener tooltip visible si está sobre él
            sessionTooltip.on('mouseenter', function() {
                sessionTooltip.addClass('show');
            });
            
            sessionTooltip.on('mouseleave', function() {
                sessionTooltip.removeClass('show');
            });
            
            // Seleccionar todo el texto al hacer clic en el input
            sessionIdInput.on('click', function() {
                this.select();
            });
        });
        
        // Función para copiar el ID de sesión
        function copySessionId() {
            const sessionIdInput = document.getElementById('sessionIdInput');
            const copyBtn = document.querySelector('.copy-btn');
            const copyIcon = copyBtn.querySelector('i');
            
            // Seleccionar y copiar el texto
            sessionIdInput.select();
            sessionIdInput.setSelectionRange(0, 99999); // Para dispositivos móviles
            
            try {
                document.execCommand('copy');
                
                // Cambiar el botón temporalmente
                copyBtn.classList.add('copied');
                copyIcon.className = 'fas fa-check';
                
                // Restaurar después de 2 segundos
                setTimeout(function() {
                    copyBtn.classList.remove('copied');
                    copyIcon.className = 'fas fa-copy';
                }, 2000);
                
                // Mostrar notificación
                showNotification('ID de sesión copiado al portapapeles', 'success');
                
            } catch (err) {
                // Fallback para navegadores modernos
                if (navigator.clipboard) {
                    navigator.clipboard.writeText(sessionIdInput.value).then(function() {
                        copyBtn.classList.add('copied');
                        copyIcon.className = 'fas fa-check';
                        
                        setTimeout(function() {
                            copyBtn.classList.remove('copied');
                            copyIcon.className = 'fas fa-copy';
                        }, 2000);
                        
                        showNotification('ID de sesión copiado al portapapeles', 'success');
                    });
                } else {
                    showNotification('No se pudo copiar el ID de sesión', 'error');
                }
            }
        }

        // Permisos de menú: filtrar mosaicos y mensaje de sin permiso
        (function() {
            var permisosMenuAdmin = <%= If(PermisosMenuAdmin, "true", "false") %>;
            var permisosMenuUrls = <%= ObtenerPermisosMenuUrlsJson() %>;
            var mensajePermiso = <%= Newtonsoft.Json.JsonConvert.SerializeObject(MensajePermiso) %>;
            document.addEventListener('DOMContentLoaded', function() {
                if (mensajePermiso && mensajePermiso.length > 0) {
                    showNotification(mensajePermiso, 'warning');
                }
                document.querySelectorAll('.card[data-url]').forEach(function(card) {
                    var url = card.getAttribute('data-url');
                    if (!url) return;
                    var permitido = permisosMenuAdmin || (permisosMenuUrls === true) || (Array.isArray(permisosMenuUrls) && permisosMenuUrls.indexOf(url) !== -1);
                    card.style.display = permitido ? '' : 'none';
                });
            });
        })();
        
        // Función para mostrar notificaciones
        function showNotification(message, type) {
            // Crear elemento de notificación
            const notification = $('<div>').addClass('notification').addClass(type).text(message);
            
            // Estilos para la notificación
            notification.css({
                'position': 'fixed',
                'top': '20px',
                'right': '20px',
                'background': type === 'success' ? '#28a745' : (type === 'warning' ? '#f0ad4e' : '#dc3545'),
                'color': 'white',
                'padding': '12px 20px',
                'border-radius': '8px',
                'box-shadow': '0 4px 12px rgba(0,0,0,0.15)',
                'z-index': '10000',
                'font-size': '14px',
                'font-weight': '500',
                'opacity': '0',
                'transform': 'translateX(100%)',
                'transition': 'all 0.3s ease'
            });
            
            $('body').append(notification);
            
            // Animar entrada
            setTimeout(function() {
                notification.css({
                    'opacity': '1',
                    'transform': 'translateX(0)'
                });
            }, 100);
            
            // Remover después de 3 segundos
            setTimeout(function() {
                notification.css({
                    'opacity': '0',
                    'transform': 'translateX(100%)'
                });
                setTimeout(function() {
                    notification.remove();
                }, 300);
            }, 3000);
        }
    </script>
</body>
</html>



