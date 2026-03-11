<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="cambioPass.aspx.vb" Inherits="SemgaWapp.cambioPass" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Cambio de contraseña</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <script src="../../Scripts/inactivity-monitor-final.js?v=2.6"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #87CEEB 0%, #B0E0E6 100%);
            min-height: 100vh;
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
            max-width: 480px;
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
        .card-header-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .card-icon {
            width: 38px;
            height: 38px;
            background: linear-gradient(135deg, #6c757d, #495057);
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
            color: white;
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
        .btn-primary {
            background: linear-gradient(135deg, #87CEEB, #5F9EA0);
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(135, 206, 235, 0.4);
        }
        .mensaje { margin-top: 16px; padding: 12px 16px; border-radius: 8px; }
        .mensaje.ok { background: linear-gradient(135deg, #d4edda, #c3e6cb); color: #155724; border-left: 4px solid #28a745; }
        .mensaje.error { background: linear-gradient(135deg, #f8d7da, #f5c6cb); color: #721c24; border-left: 4px solid #dc3545; }
        @media (max-width: 768px) {
            .card-header { flex-direction: column; text-align: center; }
            .card-header-left { justify-content: center; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="main-content">
            <div class="card">
                <div class="card-header">
                    <div class="card-header-left">
                        <div class="card-icon">
                            <i class="fas fa-key"></i>
                        </div>
                        <div class="card-title">Cambio de contraseña</div>
                    </div>
                    <a href="../../Dashboard.aspx" class="back-btn">
                        <i class="fas fa-arrow-left"></i>
                        Volver
                    </a>
                </div>
                <div class="form-group">
                    <asp:Label ID="lblNueva" runat="server" CssClass="form-label" AssociatedControlID="txtNuevaClave" Text="Nueva contraseña" />
                    <asp:TextBox ID="txtNuevaClave" runat="server" TextMode="Password" CssClass="form-control" placeholder="Nueva contraseña" />
                </div>
                <div class="form-group">
                    <asp:Label ID="lblRepetir" runat="server" CssClass="form-label" AssociatedControlID="txtRepetirClave" Text="Repetir contraseña" />
                    <asp:TextBox ID="txtRepetirClave" runat="server" TextMode="Password" CssClass="form-control" placeholder="Repetir contraseña" />
                </div>
                <asp:Button ID="btnCambiar" runat="server" Text="Cambiar contraseña" CssClass="btn-primary" OnClick="btnCambiar_Click" />
                <asp:Panel ID="pnlMensaje" runat="server" CssClass="mensaje" Visible="false">
                    <asp:Literal ID="litMensaje" runat="server" />
                </asp:Panel>
            </div>
        </div>
    </form>
</body>
</html>
