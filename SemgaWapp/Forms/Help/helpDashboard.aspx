<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="helpDashboard.aspx.vb" Inherits="SemgaWapp.helpDashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Centro de Ayuda</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
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
            color: #333;
            margin-bottom: 5px;
        }

        .page-title p {
            color: #666;
            font-size: 14px;
        }

        .tiles-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 280px));
            gap: 20px;
            margin-top: 20px;
            max-width: 1200px;
            justify-content: start;
            margin-left: auto;
            margin-right: auto;
        }

        .tile {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            cursor: pointer;
            border: 2px solid transparent;
            max-width: 280px;
            aspect-ratio: 1;
        }

        .tile:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
            border-color: #87CEEB;
        }

        .tile-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            color: white;
            margin-bottom: 15px;
        }

        .tile-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }

        .tile-description {
            font-size: 14px;
            color: #666;
            line-height: 1.6;
        }

        .documentacion-tile .tile-icon {
            background: linear-gradient(135deg, #17a2b8, #138496);
        }

        .procesos-tecnicos-tile .tile-icon {
            background: linear-gradient(135deg, #ff6b35, #e55a2b);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <div class="logo">
                <div class="logo-icon">
                    <i class="fas fa-question-circle"></i>
                </div>
                <div>
                    <div class="logo-text">Centro de Ayuda</div>
                    <div class="breadcrumb">Sistema de Gestión - Coopsemga</div>
                </div>
            </div>
            <a href="../../Dashboard.aspx" class="back-btn">
                <i class="fas fa-arrow-left"></i> Volver al Dashboard
            </a>
        </div>

        <div class="main-content">
            <div class="page-title">
                <h1><i class="fas fa-life-ring"></i> Centro de Ayuda</h1>
                <p>Accede a la documentación y recursos de ayuda del sistema</p>
            </div>

            <div class="tiles-container">
                <!-- Documentación de Aplicación -->
                <div class="tile documentacion-tile" data-url="forms/help/documentacion.aspx" onclick="window.location.href='Documentacion.aspx'">
                    <div class="tile-icon">
                        <i class="fas fa-book"></i>
                    </div>
                    <div class="tile-title">Documentación de Aplicación</div>
                    <div class="tile-description">
                        Consultar documentación de formularios, métodos y consultas SQL del sistema
                    </div>
                </div>

                <!-- Manual de Procesos Técnicos -->
                <div class="tile procesos-tecnicos-tile" data-url="forms/help/procesostecnicos.aspx" onclick="window.location.href='procesosTecnicos.aspx'">
                    <div class="tile-icon">
                        <i class="fas fa-cogs"></i>
                    </div>
                    <div class="tile-title">Manual de Procesos Técnicos</div>
                    <div class="tile-description">
                        Consultar manual de procesos técnicos y procedimientos del sistema
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
