<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="dashboardReportes.aspx.vb" Inherits="SemgaWapp.dashboardReportes" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Reportes y Estadísticas</title>
    
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
        .reports-tile .tile-icon {
            background: linear-gradient(135deg, #28a745, #20c997);
        }

        .historial-tile .tile-icon {
            background: linear-gradient(135deg, #17a2b8, #138496);
        }

        .movimientos-tile .tile-icon {
            background: linear-gradient(135deg, #ffc107, #ff9800);
        }

        .asientos-tile .tile-icon {
            background: linear-gradient(135deg, #6f42c1, #e83e8c);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }

            .tiles-grid {
                grid-template-columns: 1fr;
                gap: 12px;
                margin-top: 12px;
            }

            .tile {
                padding: 15px;
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
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .tile {
            animation: fadeIn 0.4s ease-out forwards;
            opacity: 0;
        }

        .tile:nth-child(1) { animation-delay: 0.05s; }
        .tile:nth-child(2) { animation-delay: 0.1s; }
        .tile:nth-child(3) { animation-delay: 0.15s; }
        .tile:nth-child(4) { animation-delay: 0.2s; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Header -->
        <div class="header">
            <div class="logo">
                <div class="logo-icon">
                    <i class="fas fa-chart-bar"></i>
                </div>
                <div>
                    <div class="logo-text">Reportes y Estadísticas</div>
                    <div class="breadcrumb">Dashboard de Reportes</div>
                </div>
            </div>
            <a href="../../Dashboard.aspx" class="back-btn">
                <i class="fas fa-arrow-left"></i>
                Volver al Menú
            </a>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Page Title -->
            <div class="page-title">
                <h1>Reportes y Estadísticas</h1>
            </div>

            <!-- Tiles Grid (visibilidad según permisos de menú por URL) -->
            <div class="tiles-grid">
                <!-- Reportes del Sistema -->
                <div class="tile reports-tile" data-url="forms/reportes/reportes.aspx" onclick="window.location.href='Reportes.aspx'">
                    <div class="tile-icon">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <div class="tile-title">Reportes del Sistema</div>
                    <div class="tile-description">
                        Acceder a todos los reportes y consultas disponibles del sistema
                    </div>
                </div>

                <!-- Tablas Históricas -->
                <div class="tile historial-tile" data-url="forms/logs/historialtablas.aspx" onclick="window.location.href='../Logs/historialTablas.aspx?origen=reportes'">
                    <div class="tile-icon">
                        <i class="fas fa-database"></i>
                    </div>
                    <div class="tile-title">Tablas Históricas</div>
                    <div class="tile-description">
                        Consultar y gestionar las versiones históricas de las tablas del sistema
                    </div>
                </div>

                <!-- Movimientos -->
                <div class="tile movimientos-tile" data-url="forms/reportes/movimientos.aspx" onclick="window.location.href='Movimientos.aspx'">
                    <div class="tile-icon">
                        <i class="fas fa-exchange-alt"></i>
                    </div>
                    <div class="tile-title">Movimientos</div>
                    <div class="tile-description">
                        Consultar y reportar los movimientos y transacciones del sistema
                    </div>
                </div>

                <!-- Asientos -->
                <div class="tile asientos-tile" data-url="forms/reportes/asientos.aspx" onclick="window.location.href='Asientos.aspx'">
                    <div class="tile-icon">
                        <i class="fas fa-book"></i>
                    </div>
                    <div class="tile-title">Asientos</div>
                    <div class="tile-description">
                        Consultar asientos contables por rango de fechas
                    </div>
                </div>
            </div>
        </div>
    </form>
    <script type="text/javascript">
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
    </script>
</body>
</html>
