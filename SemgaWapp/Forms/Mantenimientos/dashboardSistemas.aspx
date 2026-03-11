<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="dashboardSistemas.aspx.vb" Inherits="SemgaWapp.dashboardSistemas" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Configuraciones del Sistema</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
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
            padding: 15px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .page-title {
            text-align: center;
            margin-bottom: 20px;
        }

        .page-title h1 {
            font-size: 28px;
            font-weight: 700;
            color: #333;
            margin-bottom: 0;
        }

        .page-title p {
            display: none;
        }

        .tiles-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 280px));
            gap: 15px;
            margin-top: 15px;
            justify-content: start;
        }

        .tile {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            cursor: pointer;
            text-align: center;
            position: relative;
            overflow: hidden;
            aspect-ratio: 1;
            max-width: 280px;
        }

        .tile::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #87CEEB, #B0E0E6);
        }

        .tile:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }

        .tile-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
            margin: 0 auto 15px;
            transition: all 0.3s ease;
        }

        .tile:hover .tile-icon {
            transform: scale(1.1);
        }

        .tile-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }

        .tile-description {
            color: #666;
            line-height: 1.4;
            font-size: 13px;
        }

        /* Colores específicos para cada tile */
        .users-tile .tile-icon {
            background: linear-gradient(135deg, #007bff, #0056b3);
        }

        .params-tile .tile-icon {
            background: linear-gradient(135deg, #28a745, #20c997);
        }

        .tables-tile .tile-icon {
            background: linear-gradient(135deg, #ffc107, #e0a800);
        }

        .backup-tile .tile-icon {
            background: linear-gradient(135deg, #dc3545, #c82333);
        }

        .historial-tile .tile-icon {
            background: linear-gradient(135deg, #17a2b8, #138496);
        }

        /* Modal */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: none;
            z-index: 1000;
            backdrop-filter: blur(5px);
        }

        .modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: white;
            z-index: 1001;
            display: none;
            overflow: hidden;
            border-radius: 0;
            margin: 0;
            padding: 0;
        }

        .modal-header {
            background: linear-gradient(135deg, #87CEEB, #B0E0E6);
            padding: 8px 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: white;
        }

        .modal-title {
            font-size: 16px;
            font-weight: 600;
        }

        .modal-close {
            background: none;
            border: none;
            color: white;
            font-size: 24px;
            cursor: pointer;
            padding: 5px;
            border-radius: 5px;
            transition: all 0.3s ease;
        }

        .modal-close:hover {
            background: rgba(255, 255, 255, 0.2);
        }

        .modal-body {
            padding: 0;
            height: calc(100vh - 40px);
            overflow: hidden;
        }

        .modal-content {
            height: 100%;
            width: 100%;
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
                padding: 10px;
            }

            .page-title {
                margin-bottom: 15px;
            }

            .page-title h1 {
                font-size: 22px;
            }

            .tiles-grid {
                grid-template-columns: repeat(auto-fit, minmax(250px, 280px));
                justify-content: start;
                gap: 12px;
                margin-top: 12px;
            }

            .tile {
                padding: 15px;
                max-width: 280px;
                aspect-ratio: 1;
            }

            .tile-icon {
                width: 50px;
                height: 50px;
                font-size: 20px;
                margin-bottom: 12px;
            }

            .tile-title {
                font-size: 16px;
                margin-bottom: 6px;
            }

            .tile-description {
                font-size: 12px;
            }

            .modal {
                width: 95%;
                max-height: 90vh;
            }

            .modal-body {
                padding: 15px;
                max-height: calc(90vh - 60px);
            }
        }

        /* Toast Styles */
        .toast {
            position: fixed;
            top: 20px;
            right: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            padding: 16px 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            z-index: 9999;
            min-width: 300px;
            max-width: 400px;
            transform: translateX(100%);
            transition: transform 0.3s ease;
        }

        .toast.show {
            transform: translateX(0);
        }

        .toast-icon {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 12px;
        }

        .toast-content {
            flex: 1;
        }

        .toast-title {
            font-weight: 600;
            color: #333;
            margin-bottom: 4px;
        }

        .toast-message {
            color: #666;
            font-size: 14px;
            line-height: 1.4;
        }

        .toast-close {
            background: none;
            border: none;
            color: #999;
            cursor: pointer;
            font-size: 18px;
            padding: 0;
            margin-left: 8px;
        }

        .toast-close:hover {
            color: #666;
        }

        /* Toast Types */
        .toast.info .toast-icon {
            background: #17a2b8;
        }

        .toast.success .toast-icon {
            background: #28a745;
        }

        .toast.warning .toast-icon {
            background: #ffc107;
        }

        .toast.error .toast-icon {
            background: #dc3545;
        }

        /* Animaciones optimizadas para evitar parpadeo */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .tile {
            animation: fadeIn 0.4s ease-out forwards;
            opacity: 0;
        }

        .tile:nth-child(1) { animation-delay: 0.05s; }
        .tile:nth-child(2) { animation-delay: 0.1s; }
        .tile:nth-child(3) { animation-delay: 0.15s; }
        .tile:nth-child(4) { animation-delay: 0.2s; }
        .tile:nth-child(5) { animation-delay: 0.25s; }
        .tile:nth-child(6) { animation-delay: 0.3s; }
    </style>
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
            
            <div class="breadcrumb">
                Panel de Control > Configuraciones del Sistema
            </div>
            
            <a href="../../Dashboard.aspx" class="back-btn">
                <i class="fas fa-arrow-left"></i>
                Volver al Men&#250;
            </a>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="page-title">
                <h1>Configuraciones del Sistema</h1>
            </div>

            <!-- Tiles Grid (visibilidad según permisos de menú por URL) -->
            <div class="tiles-grid">
                <!-- Gestión de Usuarios -->
                <div class="tile users-tile" data-url="forms/mantenimientos/gestionusuarios.aspx" onclick="window.location.href='GestionUsuarios.aspx'">
                    <div class="tile-icon">
                        <i class="fas fa-user-cog"></i>
                    </div>
                    <div class="tile-title">Gesti&#243;n de Usuarios</div>
                    <div class="tile-description">
                        Administrar usuarios del sistema, roles, permisos y accesos
                    </div>
                </div>

                <!-- Tablas de Tipo -->
                <div class="tile tables-tile" data-url="forms/mantenimientos/mantenimientos.aspx" onclick="window.location.href='Mantenimientos.aspx'">
                    <div class="tile-icon">
                        <i class="fas fa-table"></i>
                    </div>
                    <div class="tile-title">Tablas de Tipo</div>
                    <div class="tile-description">
                        Mantenimientos de tablas de tipo del sistema
                    </div>
                </div>

                <!-- Parámetros del Sistema -->
                <div class="tile params-tile" data-url="forms/mantenimientos/appparams.aspx" onclick="window.location.href='appParams.aspx'">
                    <div class="tile-icon">
                        <i class="fas fa-cogs"></i>
                    </div>
                    <div class="tile-title">Par&#225;metros del Sistema</div>
                    <div class="tile-description">
                        Configurar par&#225;metros generales y comportamiento del sistema
                    </div>
                </div>

                <!-- Respaldo de Datos -->
                <div class="tile backup-tile" data-url="forms/sistemas/respaldos.aspx" onclick="window.location.href='../Sistemas/Respaldos.aspx'">
                    <div class="tile-icon">
                        <i class="fas fa-database"></i>
                    </div>
                    <div class="tile-title">Respaldo de Datos</div>
                    <div class="tile-description">
                        Crear y gestionar respaldos de la base de datos
                    </div>
                </div>

                <!-- Tablas Históricas -->
                <div class="tile historial-tile" data-url="forms/logs/historialtablas.aspx" onclick="window.location.href='../Logs/historialTablas.aspx?origen=sistemas'">
                    <div class="tile-icon">
                        <i class="fas fa-history"></i>
                    </div>
                    <div class="tile-title">Tablas Hist&#243;ricas</div>
                    <div class="tile-description">
                        Consultar y gestionar las versiones hist&#243;ricas de las tablas del sistema
                    </div>
                </div>

            </div>
        </div>

        <!-- Modal Overlay -->
        <div id="modalOverlay" class="modal-overlay" onclick="closeModal(); return false;"></div>

        <!-- Modal -->
        <div id="modal" class="modal">
            <div class="modal-header">
                <div class="modal-title" id="modalTitle">Gesti&#243;n de Usuarios</div>
                <button type="button" class="modal-close" onclick="closeModal(); return false;" onserverclick="">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <div class="modal-content" id="modalContent">
                    <!-- El contenido se cargará dinámicamente -->
                </div>
            </div>
        </div>
    </form>

    <script type="text/javascript">
        // Permisos de menú: mostrar solo mosaicos cuya URL esté permitida
        (function() {
            var permisosMenuAdmin = <%= If(PermisosMenuAdminValue, "true", "false") %>;
            var permisosMenuUrls = <%= PermisosMenuUrlsJsonValue %>;
            document.addEventListener('DOMContentLoaded', function() {
                document.querySelectorAll('.tile[data-url]').forEach(function(tile) {
                    var url = tile.getAttribute('data-url');
                    if (!url) return;
                    var permitido = permisosMenuAdmin || (permisosMenuUrls === true) || (Array.isArray(permisosMenuUrls) && permisosMenuUrls.indexOf(url) !== -1);
                    tile.style.display = permitido ? '' : 'none';
                });
            });
        })();

        // Inicializar monitoreo de inactividad cuando el DOM esté listo
        document.addEventListener('DOMContentLoaded', function() {
            if (typeof initializeInactivityMonitoring === 'function') {
                initializeInactivityMonitoring();
            }
        });

        function openModal(type) {
            const modal = document.getElementById('modal');
            const modalOverlay = document.getElementById('modalOverlay');
            const modalTitle = document.getElementById('modalTitle');
            const modalContent = document.getElementById('modalContent');

            // Configurar según el tipo
            switch(type) {
                case 'backup':
                    // Mostrar toast en lugar de modal
                    showToast('Funcionalidad en desarrollo', 'info');
                    return;
            }

            // Mostrar modal
            modal.style.display = 'block';
            modalOverlay.style.display = 'block';
            modal.style.opacity = '1';
        }

        function closeModal() {
            const modal = document.getElementById('modal');
            const modalOverlay = document.getElementById('modalOverlay');
            
            // Prevenir postback
            event.preventDefault();
            event.stopPropagation();
            
            modal.style.display = 'none';
            modalOverlay.style.display = 'none';
            
            return false;
        }


        // Cerrar modal con ESC
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                e.preventDefault();
                e.stopPropagation();
                closeModal();
                return false;
            }
        });

        // Prevenir que el clic en el modal cierre el modal
        document.getElementById('modal').addEventListener('click', function(e) {
            e.stopPropagation();
        });

        // Función para mostrar toast
        function showToast(message, type = 'info', title = 'Información') {
            // Crear elemento toast
            const toast = document.createElement('div');
            toast.className = `toast ${type}`;
            
            // Iconos según el tipo
            const icons = {
                'info': 'fas fa-info-circle',
                'success': 'fas fa-check-circle',
                'warning': 'fas fa-exclamation-triangle',
                'error': 'fas fa-times-circle'
            };
            
            toast.innerHTML = `
                <div class="toast-icon">
                    <i class="${icons[type] || icons.info}"></i>
                </div>
                <div class="toast-content">
                    <div class="toast-title">${title}</div>
                    <div class="toast-message">${message}</div>
                </div>
                <button class="toast-close" onclick="closeToast(this)">
                    <i class="fas fa-times"></i>
                </button>
            `;
            
            // Agregar al body
            document.body.appendChild(toast);
            
            // Mostrar con animación
            setTimeout(() => {
                toast.classList.add('show');
            }, 100);
            
            // Auto-ocultar después de 4 segundos
            setTimeout(() => {
                closeToast(toast.querySelector('.toast-close'));
            }, 4000);
        }
        
        // Función para cerrar toast
        function closeToast(button) {
            const toast = button.closest('.toast');
            if (toast) {
                toast.classList.remove('show');
                setTimeout(() => {
                    if (toast.parentNode) {
                        toast.parentNode.removeChild(toast);
                    }
                }, 300);
            }
        }
    </script>
</body>
</html>



