<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="GestionSocios.aspx.vb" Inherits="SemgaWapp.GestionSocios" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Gestión de Socios - Cooperativa Coopsemga</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet"/>
    <!-- Flatpickr CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css"/>
    <!-- Select2 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" rel="stylesheet"/>
    
    <style>
        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
            overflow: hidden;
        }
        
        body {
            background: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .main-container {
            background: #ffffff;
            border-radius: 6px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin: 15px;
            padding: 15px;
            border: 1px solid #e9ecef;
            height: calc(100vh - 30px);
            max-height: calc(100vh - 30px);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            box-sizing: border-box;
        }
        
        /* Barra superior: título | filtros | botones en una fila */
        .top-bar-section {
            display: flex;
            align-items: stretch;
            gap: 6px;
            margin-bottom: 12px;
            flex-shrink: 0;
        }
        .top-bar-titulo {
            background: #2c3e50;
            color: white;
            padding: 10px 16px;
            display: flex;
            align-items: center;
            flex-shrink: 0;
            border-radius: 6px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
        }
        .top-bar-titulo h6 {
            font-size: 15px;
            margin: 0;
            white-space: nowrap;
        }
        .top-bar-filtros {
            flex: 1;
            display: flex;
            align-items: flex-end;
            gap: 12px;
            padding: 8px 12px;
            background: #ffffff;
            min-width: 0;
            border-radius: 6px;
            border: 1px solid #e9ecef;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
        }
        .top-bar-filtro-item {
            flex: 1;
            min-width: 0;
        }
        .top-bar-filtro-item .form-label {
            font-size: 11px;
            margin-bottom: 2px;
        }
        .top-bar-filtro-buscar {
            flex-shrink: 0;
            align-self: flex-end;
        }
        .top-bar-filtro-buscar .btn {
            min-width: 38px;
        }
        .top-bar-botones {
            background: #2c3e50;
            color: white;
            padding: 8px 12px;
            display: flex;
            align-items: center;
            gap: 8px;
            flex-shrink: 0;
            border-radius: 6px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
        }
        .top-bar-botones .btn-light {
            background: rgba(255,255,255,0.2);
            border-color: rgba(255,255,255,0.3);
            color: white;
        }
        .top-bar-botones .btn-light:hover {
            background: rgba(255,255,255,0.3);
            border-color: rgba(255,255,255,0.5);
            color: white;
        }

        #modalTransaccionesSocio .modal-header-transacciones {
            padding: 6px 12px;
            min-height: auto;
        }
        #modalTransaccionesSocio .modal-header-transacciones .modal-title {
            font-size: 0.9rem;
        }
        
        .btn-primary {
            background: #2c3e50;
            border: 1px solid #2c3e50;
            border-radius: 4px;
            padding: 6px 12px;
            font-weight: 500;
            color: white;
            font-size: 12px;
        }
        
        .btn-primary:hover {
            background: #34495e;
            border-color: #34495e;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(44, 62, 80, 0.2);
        }
        
        .table {
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            border: 1px solid #e9ecef;
            border-collapse: separate;
            border-spacing: 0;
        }
        
        .table thead th {
            background: #34495e;
            color: white;
            border: none;
            border-right: 1px solid #5a6c7d;
            font-weight: 600;
            font-size: 12px;
            padding: 8px 6px;
            text-align: center !important;
            vertical-align: middle;
        }
        
        .table thead th:last-child {
            border-right: none;
        }
        
        .table tbody td {
            padding: 6px;
            border-bottom: 1px solid #f1f3f4;
            border-right: 1px solid #dee2e6;
            vertical-align: middle;
            font-size: 12px;
            text-align: center;
        }
        
        .table tbody td:last-child {
            border-right: none;
        }
        
        .table tbody tr:hover {
            background-color: #A2F4FD !important;
            cursor: pointer;
        }
        
        #tablaSocios tbody tr:hover,
        #tablaSocios tbody tr:hover td {
            background-color: #A2F4FD !important;
        }
        
        .table-hover tbody tr:hover,
        .table-hover tbody tr:hover td {
            background-color: #A2F4FD !important;
        }
        
        /* Estilos específicos para DataTables */
        #tablaSocios_wrapper .dataTables_scrollBody tbody tr:hover,
        #tablaSocios_wrapper .dataTables_scrollBody tbody tr:hover td {
            background-color: #A2F4FD !important;
        }
        
        /* Forzar centrado en títulos y celdas de DataTables */
        #tablaSocios thead th {
            text-align: center !important;
        }
        
        #tablaSocios tbody td {
            text-align: center !important;
        }

        #tablaSocios.tabla-socios-deshabilitada {
            opacity: 0;
            pointer-events: none;
        }
        
        .badge {
            font-size: 0.75em;
            padding: 4px 8px;
            border-radius: 4px;
            font-weight: 500;
        }
        
        .badge-success {
            background: #28a745;
            color: white;
        }
        
        .badge-warning {
            background: #ffc107;
            color: #212529;
        }
        
        .badge-danger {
            background: #dc3545;
            color: white;
        }
        
        .badge-secondary {
            background: #6c757d;
            color: white;
        }
        
        .badge-info {
            background: #17a2b8;
            color: white;
        }
        
        .badge-light-blue {
            background: #17a2b8;
            color: white;
            font-weight: bold;
        }
        
        /* Colores más oscuros para el porcentaje restante */
        #porcentajeRestante.text-warning {
            color: #e67e22 !important; /* Naranja oscuro en lugar de amarillo */
            font-weight: bold;
        }
        
        #porcentajeRestante.text-success {
            color: #27ae60 !important; /* Verde más oscuro */
            font-weight: bold;
        }
        
        #porcentajeRestante.text-danger {
            color: #e74c3c !important; /* Rojo más oscuro */
            font-weight: bold;
        }
        
        .modal-content {
            border-radius: 8px;
            border: none;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }
        
        /* Reducir espacio superior del modal */
        #modalSocio .modal-body {
            padding-top: 10px !important;
            padding-bottom: 20px !important;
        }
        
        /* Reducir espacio entre header y tabs */
        #modalSocio .nav-tabs {
            margin-top: 0 !important;
            border-top: 1px solid #dee2e6;
        }
        
        /* Reducir padding del contenido de las pestañas */
        #modalSocio .tab-content {
            padding-top: 15px !important;
        }
        
        #modalSocio .tab-pane {
            padding: 0 !important;
        }
        
        .modal-header {
            background: #2c3e50;
            color: white;
            border-radius: 8px 8px 0 0;
            border: none;
            padding: 20px;
        }
        
        .nav-tabs {
            border-bottom: 1px solid #e9ecef;
            margin-bottom: 20px;
        }
        
        .nav-tabs .nav-link {
            border: none;
            color: #6c757d;
            font-weight: 500;
            padding: 12px 20px;
            border-radius: 0;
        }
        
        .nav-tabs .nav-link.active {
            background: #5a9fd4;
            color: white;
            border-radius: 0;
        }
        
        .nav-tabs .nav-link:hover {
            color: #5a9fd4;
            background: #f8f9fa;
        }
        
        .form-control, .form-select {
            border-radius: 4px;
            border: 1px solid #ced4da;
            padding: 6px 8px;
            font-size: 12px;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #2c3e50;
            box-shadow: 0 0 0 0.2rem rgba(44, 62, 80, 0.15);
        }
        
        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 4px;
            font-size: 12px;
        }
        
        .loading {
            display: none;
            text-align: center;
            padding: 20px;
        }
        
        .spinner-border {
            color: #2c3e50;
        }
        
        .toast-container {
            position: fixed;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 1055;
        }
        
        .toast {
            min-width: 300px;
            max-width: 500px;
        }
        
        /* Toast Confirm Personalizado */
        .toast-confirm {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            z-index: 1060;
            min-width: 400px;
            max-width: 500px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            border: none;
            overflow: hidden;
        }
        
        .toast-confirm-header {
            padding: 15px 20px;
            border-bottom: 1px solid #e9ecef;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .toast-confirm-body {
            padding: 20px;
        }
        
        .toast-confirm-footer {
            padding: 15px 20px;
            border-top: 1px solid #e9ecef;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
        
        .toast-confirm-icon {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 14px;
        }
        
        .toast-confirm-icon.success {
            background-color: #28a745;
        }
        
        .toast-confirm-icon.warning {
            background-color: #ffc107;
        }
        
        .toast-confirm-icon.danger {
            background-color: #dc3545;
        }
        
        .toast-confirm-icon.info {
            background-color: #17a2b8;
        }
        
        .toast-confirm-title {
            font-weight: 600;
            margin: 0;
            color: #333;
        }
        
        .toast-confirm-message {
            margin: 0;
            color: #666;
            line-height: 1.4;
        }
        
        .toast-confirm-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .toast-confirm-btn-primary {
            background-color: #007bff;
            color: white;
        }
        
        .toast-confirm-btn-primary:hover {
            background-color: #0056b3;
        }
        
        .toast-confirm-btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .toast-confirm-btn-secondary:hover {
            background-color: #545b62;
        }
        
        .toast-confirm-btn-danger {
            background-color: #dc3545;
            color: white;
        }
        
        .toast-confirm-btn-danger:hover {
            background-color: #c82333;
        }
        
        .toast-confirm-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            z-index: 1059;
        }
        
        /* Estilo para botón deshabilitado */
        .btn.disabled, .btn:disabled {
            background-color: #6c757d !important;
            border-color: #6c757d !important;
            color: #fff !important;
            opacity: 0.65;
            cursor: not-allowed;
        }
        
        .btn-sm {
            padding: 4px 8px;
            font-size: 11px;
            border-radius: 3px;
        }
        
        .btn-outline-primary {
            color: #2c3e50;
            border-color: #2c3e50;
        }
        
        .btn-outline-primary:hover {
            background: #2c3e50;
            border-color: #2c3e50;
            color: white;
        }
        
        .action-buttons {
            white-space: nowrap;
        }
        
        .btn-light {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            color: #495057;
        }
        
        .btn-light:hover {
            background: #e9ecef;
            border-color: #adb5bd;
            color: #495057;
        }
        
        .btn-secondary {
            background: #6c757d;
            border-color: #6c757d;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
            border-color: #545b62;
        }
        
        /* Estilos para divs elegantes del tab Sistemas */
        .info-card {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }
        
        .info-card:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            transform: translateY(-1px);
        }
        
        .info-label {
            font-size: 11px;
            font-weight: 600;
            color: #6c757d;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 5px;
        }
        
        .info-value {
            font-size: 14px;
            font-weight: 500;
            color: #2c3e50;
            margin: 0;
        }
        
        .info-icon {
            color: #2c3e50;
            margin-right: 8px;
            font-size: 16px;
        }
        
        /* Forzar alineación a la izquierda para la columna de identificación */
        #tablaSocios td:nth-child(7) {
            text-align: left !important;
        }
        
        #tablaSocios td:nth-child(7) * {
            text-align: left !important;
        }
        
        /* Estilos para tabla con scroll interno */
        .dataTables_wrapper {
            position: relative;
        }
        
        /* Forzar scroll interno en la tabla - min-height para ocupar espacio disponible */
        #tablaSocios_wrapper .dataTables_scrollBody {
            min-height: 300px !important;
            overflow-y: auto !important;
        }
        
        .dataTables_scrollBody {
            border: 1px solid #dee2e6;
            border-top: none;
        }
        
        .dataTables_scrollHead {
            border: 1px solid #dee2e6;
            border-bottom: none;
        }
        
        /* Asegurar que los controles de paginación estén visibles y alineados */
        .dataTables_info,
        .dataTables_paginate {
            margin-top: 10px;
            margin-bottom: 10px;
            background: white;
            padding: 10px;
            display: flex;
            align-items: center;
        }
        
        /* Alinear información y paginación al mismo nivel */
        .dataTables_wrapper .dataTables_info {
            float: left;
            margin-top: 0;
            margin-bottom: 0;
            padding: 10px 0;
        }
        
        .dataTables_wrapper .dataTables_paginate {
            float: right;
            margin-top: 0;
            margin-bottom: 0;
            padding: 10px 0;
        }
        
        /* Limpiar floats */
        .dataTables_wrapper::after {
            content: "";
            display: table;
            clear: both;
        }
        
        /* Estilo para el contenedor de la tabla */
        .table-responsive {
            flex: 1 1 auto;
            min-height: 0;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            position: relative;
            height: 100%;
        }
        
        form {
            overflow: hidden;
            height: 100%;
        }
        
        /* Contenedor de la tabla con altura controlada */
        .dataTables_wrapper {
            display: flex;
            flex-direction: column;
            width: 100%;
            min-height: 0;
            flex: 1 1 auto;
            height: 100%;
            overflow: visible; /* Permitir que el footer sea visible */
            max-height: 100%;
        }
        
        /* Área de scroll de DataTables - ocupa todo el espacio disponible */
        .dataTables_scroll {
            flex: 1 1 auto;
            min-height: 200px;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .dataTables_scrollHead {
            flex-shrink: 0;
        }

        .dataTables_scrollBody {
            flex: 1 1 auto;
            min-height: 200px;
            overflow-y: auto !important;
            overflow-x: auto !important;
        }
        
        /* Asegurar que la fila con info y paginación sea visible y esté FUERA del scroll */
        .dataTables_wrapper .row.mt-3 {
            display: flex !important;
            visibility: visible !important;
            opacity: 1 !important;
            margin-top: 15px !important;
            padding: 10px 15px !important;
            border-top: 1px solid #dee2e6 !important;
            background-color: #f8f9fa !important;
            border-radius: 4px !important;
            align-items: center !important;
            justify-content: space-between !important;
            clear: both !important;
            min-height: 50px !important;
            height: auto !important;
            overflow: visible !important;
            flex-shrink: 0 !important; /* NO se reduce, siempre visible */
            flex-grow: 0 !important; /* NO crece más allá de su contenido */
            flex-basis: auto !important;
        }
        
        .dataTables_info {
            display: inline-block !important;
            visibility: visible !important;
            opacity: 1 !important;
        }
        
        .dataTables_length {
            text-align: center !important;
            padding: 12px 15px;
            margin-top: 15px;
            flex-shrink: 0;
        }

        /* Evitar que la flecha del dropdown cubra el número en "Mostrar X registros" */
        #tablaSocios_wrapper .dataTables_length select {
            padding-right: 2rem !important;
            min-width: 70px;
            padding-left: 0.5rem;
        }
        
        .dataTables_paginate {
            display: block !important;
            visibility: visible !important;
            opacity: 1 !important;
        }
        
        .dataTables_paginate .paginate_button {
            display: inline-block !important;
            visibility: visible !important;
            opacity: 1 !important;
            text-decoration: none !important;
        }
        
        .dataTables_wrapper .dataTables_paginate .paginate_button:hover:not(.disabled) {
            background-color: #f8f9fa !important;
            border-color: #2c3e50 !important;
            color: #2c3e50 !important;
        }
        
        /* Select2 Custom Styles - Matching form controls */
        .select2-container {
            width: 100% !important;
        }
        
        .select2-container--bootstrap-5 .select2-selection {
            border: 1px solid #ced4da;
            border-radius: 0.375rem;
            min-height: 38px;
            font-size: 0.875rem;
            font-family: inherit;
        }
        
        .select2-container--bootstrap-5 .select2-selection--single {
            height: 38px;
            line-height: 36px;
        }
        
        .select2-container--bootstrap-5 .select2-selection--single .select2-selection__rendered {
            padding-left: 12px;
            padding-right: 20px;
            font-size: 0.875rem;
            font-family: inherit;
            color: #212529;
        }
        
        .select2-container--bootstrap-5 .select2-selection--single .select2-selection__arrow {
            height: 36px;
            right: 8px;
        }
        
        .select2-container--bootstrap-5 .select2-selection--single .select2-selection__arrow b {
            border-color: #6c757d transparent transparent transparent;
            border-style: solid;
            border-width: 5px 4px 0 4px;
            height: 0;
            left: 50%;
            margin-left: -4px;
            margin-top: -2px;
            position: absolute;
            top: 50%;
            width: 0;
        }
        
        .select2-dropdown {
            border: 1px solid #ced4da;
            border-radius: 0.375rem;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            font-size: 0.875rem;
            font-family: inherit;
        }
        
        .select2-search--dropdown .select2-search__field {
            border: 1px solid #ced4da;
            border-radius: 0.25rem;
            padding: 0.375rem 0.75rem;
            font-size: 0.875rem;
            font-family: inherit;
        }
        
        .select2-results__option {
            padding: 0.5rem 0.75rem;
            font-size: 0.875rem;
            font-family: inherit;
        }
        
        .select2-results__option--highlighted {
            background-color: #0d6efd;
            color: white;
        }
        
        /* Asegurar que Select2 tenga el mismo estilo que los form-control */
        .select2-container--bootstrap-5 .select2-selection:focus {
            border-color: #86b7fe;
            outline: 0;
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }
        
        /* Eliminar doble flecha y asegurar que solo aparezca la de Select2 */
        .select2-container--bootstrap-5 .select2-selection--single .select2-selection__arrow {
            position: absolute;
            right: 8px;
            top: 50%;
            transform: translateY(-50%);
        }
        
        .select2-container--bootstrap-5 .select2-selection--single .select2-selection__arrow b {
            display: none !important;
        }
        
        /* Asegurar que el dropdown tenga búsqueda */
        .select2-search--dropdown {
            display: block !important;
        }
        
        .select2-search--dropdown .select2-search__field {
            width: 100% !important;
            padding: 8px 12px !important;
            border: 1px solid #ced4da !important;
            border-radius: 4px !important;
        }
        
        /* Ocultar flecha nativa del select */
        select.form-select {
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
        }
        
        /* Forzar que Select2 funcione correctamente */
        .select2-container {
            z-index: 9999 !important;
        }
        
        .select2-dropdown {
            z-index: 9999 !important;
        }
        
        /* Asegurar que el campo de búsqueda sea visible y funcional */
        .select2-search--dropdown {
            padding: 4px !important;
            display: block !important;
            position: relative !important;
        }
        
        .select2-search--dropdown .select2-search__field {
            width: 100% !important;
            height: 32px !important;
            padding: 6px 8px !important;
            border: 1px solid #ced4da !important;
            border-radius: 4px !important;
            font-size: 0.875rem !important;
            background: white !important;
            color: #212529 !important;
            outline: none !important;
        }
        
        .select2-search--dropdown .select2-search__field:focus {
            border-color: #86b7fe !important;
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25) !important;
        }
        
        /* Asegurar que el campo de búsqueda sea clickeable */
        .select2-search--dropdown {
            pointer-events: auto !important;
        }
        
        .select2-search--dropdown .select2-search__field {
            pointer-events: auto !important;
            cursor: text !important;
        }
        
        /* Asegurar que los resultados sean visibles y eliminar doble scrollbar */
        .select2-results {
            max-height: 200px !important;
            overflow-y: auto !important;
        }
        
        /* Eliminar doble scrollbar */
        .select2-results__options {
            overflow: hidden !important;
        }
        
        .select2-results__options::-webkit-scrollbar {
            width: 8px !important;
        }
        
        .select2-results__options::-webkit-scrollbar-track {
            background: #f1f1f1 !important;
        }
        
        .select2-results__options::-webkit-scrollbar-thumb {
            background: #c1c1c1 !important;
            border-radius: 4px !important;
        }
        
        .select2-results__options::-webkit-scrollbar-thumb:hover {
            background: #a8a8a8 !important;
        }
        
        /* Forzar un solo scrollbar */
        .select2-dropdown {
            overflow: hidden !important;
        }
        
        .select2-dropdown .select2-results {
            overflow-y: auto !important;
            overflow-x: hidden !important;
        }
        
        /* Forzar que Select2 reemplace completamente el select */
        .select2-hidden-accessible {
            position: absolute !important;
            left: -9999px !important;
        }
        
        /* Forzar tamaño de letra consistente en todos los elementos Select2 */
        .select2-container * {
            font-size: 0.875rem !important;
        }
        
        .select2-selection__rendered {
            font-size: 0.875rem !important;
        }
        
        .select2-selection__placeholder {
            font-size: 0.875rem !important;
        }
        
        .select2-selection__choice {
            font-size: 0.875rem !important;
        }
        
        .select2-search__field {
            font-size: 0.875rem !important;
        }
        
        .select2-results__option {
            font-size: 0.875rem !important;
        }
        
        .select2-results__group {
            font-size: 0.875rem !important;
        }
        
        /* Asegurar que el texto seleccionado tenga el mismo tamaño */
        .select2-container--bootstrap-5 .select2-selection--single .select2-selection__rendered {
            font-size: 0.875rem !important;
            line-height: 1.5 !important;
        }
        
        /* Mejorar la visualización del dropdown de Select2 */
        .select2-dropdown {
            max-height: none !important;
            overflow: visible !important;
            z-index: 9999 !important;
        }
        
        .select2-results {
            max-height: 300px !important;
            overflow-y: auto !important;
        }
        
        .select2-results__options {
            max-height: none !important;
            overflow: visible !important;
            padding-bottom: 8px !important;
        }
        
        .select2-results__option {
            padding: 8px 12px !important;
            font-size: 14px !important;
            line-height: 1.4 !important;
        }
        
        .select2-results__option--highlighted {
            background-color: #0d6efd !important;
            color: white !important;
        }
        
        /* Asegurar que el dropdown sea visible */
        .select2-dropdown--below {
            border-top: 1px solid #ced4da !important;
        }
        
        .select2-dropdown--above {
            border-bottom: 1px solid #ced4da !important;
        }
        
        /* Configuración simplificada de scroll */
        .select2-dropdown .select2-results {
            overflow-y: auto !important;
            overflow-x: hidden !important;
        }
        
        .select2-dropdown .select2-results__options {
            overflow: visible !important;
        }

        .global-panel {
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 12px 30px rgba(15, 23, 42, 0.08);
            border: 1px solid rgba(148, 163, 184, 0.25);
            overflow: hidden;
        }

        .global-panel-header {
            background: linear-gradient(135deg, #facc15, #fbbf24);
            color: #1f2937;
            border-bottom: 1px solid rgba(120, 53, 15, 0.2);
            align-items: center;
            padding: 14px 24px;
        }

        .global-panel-title {
            font-weight: 600;
            font-size: 1rem;
            color: #1f2937;
            display: inline-flex;
            align-items: center;
            gap: 12px;
        }

        .global-panel-title .badge {
            font-size: 0.85rem;
            font-weight: 600;
            background: rgba(17, 24, 39, 0.8);
            color: #ffffff;
        }

        .global-panel-body {
            padding: 22px;
        }

        .global-panel-footer {
            background: #f8fafc;
            padding: 18px 22px;
            border-top: 1px solid rgba(148, 163, 184, 0.2);
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }

        .global-card {
            background: #ffffff;
            border-radius: 10px;
            border: 1px solid rgba(148, 163, 184, 0.25);
            box-shadow: 0 6px 20px rgba(15, 23, 42, 0.06);
            padding: 16px;
        }

        .movimientos-modal-dialog {
            max-width: 1200px;
            width: 95%;
        }

        #modalMovimientosSocio .modal-body {
            overflow-x: hidden;
        }

        .chip-documento-modal .badge,
        .chip-documento-modal .text-muted {
            color: #ffffff !important;
        }

        .movimientos-socio-container {
            width: 100%;
            overflow-x: hidden;
            padding-bottom: 6px;
        }

        #tablaMovimientosSocio {
            width: 100%;
        }

        #tablaMovimientosSocio thead th {
            text-align: center !important;
        }

        #tablaMovimientosSocio td:nth-child(1),
        #tablaMovimientosSocio th:nth-child(1) {
            text-align: center !important;
        }

        #tablaMovimientosSocio td:nth-child(2),
        #tablaMovimientosSocio th:nth-child(2) {
            text-align: center !important;
        }

        #tablaMovimientosSocio td.observaciones-cell {
            min-width: 320px;
            text-align: left !important;
            white-space: normal;
        }

        #tablaSocios thead th:nth-child(6),
        #tablaSocios tbody td:nth-child(6) {
            text-align: center !important;
        }

        #tablaSocios thead th:nth-child(7),
        #tablaSocios tbody td:nth-child(7) {
            text-align: left !important;
        }

        #verMasMovimientosContainer {
            margin-top: 12px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="main-container">
            <!-- Barra superior: título + filtros + botones en una sola fila -->
            <div class="top-bar-section">
                <div class="top-bar-titulo">
                    <h6 class="mb-0"><i class="fas fa-users me-2"></i>Gestión de Socios</h6>
                </div>
                <div class="top-bar-filtros">
                    <div class="top-bar-filtro-item">
                        <label class="form-label fw-bold">Nombre o N°</label>
                        <input type="text" id="filtroNombre" class="form-control form-control-sm" placeholder="Buscar..."/>
                    </div>
                    <div class="top-bar-filtro-item">
                        <label class="form-label fw-bold">Tipo</label>
                        <select id="filtroTipo" class="form-select form-select-sm">
                            <option value="">Todos</option>
                        </select>
                    </div>
                    <div class="top-bar-filtro-item">
                        <label class="form-label fw-bold">Estatus</label>
                        <select id="filtroEstatus" class="form-select form-select-sm">
                            <option value="">Todos</option>
                            <option value="A">Activo</option>
                            <option value="I">Inactivo</option>
                            <option value="S">Suspendido</option>
                        </select>
                    </div>
                    <div class="top-bar-filtro-item">
                        <label class="form-label fw-bold">Tipo Doc</label>
                        <select id="filtroTipoDocumento" class="form-select form-select-sm">
                            <option value="">Todos</option>
                        </select>
                    </div>
                    <div class="top-bar-filtro-item">
                        <label class="form-label fw-bold">Identificación</label>
                        <input type="text" id="filtroIdentificacion" class="form-control form-control-sm" placeholder="número...">
                    </div>
                    <div class="top-bar-filtro-buscar">
                        <button type="button" class="btn btn-light w-100" onclick="aplicarFiltros()" title="Buscar">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </div>
                <div class="top-bar-botones">
                    <button type="button" class="btn btn-light btn-sm me-2" onclick="abrirModalNuevoSocio()">
                        <i class="fas fa-plus me-1"></i>Nuevo
                    </button>
                    <button type="button" class="btn btn-light btn-sm" onclick="volverDashboard()">
                        <i class="fas fa-arrow-left me-1"></i>Volver
                    </button>
                </div>
            </div>

            <!-- Loading -->
            <div class="loading" id="loadingSocios">
                <div class="spinner-border" role="status">
                    <span class="visually-hidden">Cargando...</span>
                </div>
                <p class="mt-2">Cargando socios...</p>
            </div>

            <!-- Table Section -->
            <div class="table-responsive">
                <table id="tablaSocios" class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th class="text-center">Trans.</th>
                            <th class="text-center">Movs.</th>
                            <th>Num.</th>
                            <th>Tipo Asociado</th>
                            <th>Nombre Completo</th>
                            <th>Estatus</th>
                            <th>identificación</th>
                            <th>Fecha Creación</th>
                            <th>Usuario Creó</th>
                            <th>Fecha Modificación</th>
                            <th>Usuario Modificó</th>
                            <th>Estado de Cuenta</th>
                            <th>Editar</th>
                            <th>Eliminar</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Los datos se cargarán diN°micamente -->
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Modal Movimientos del Socio -->
        <div class="modal fade" id="modalMovimientosSocio" tabindex="-1" aria-labelledby="modalMovimientosSocioLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
            <div class="modal-dialog modal-xl modal-dialog-scrollable movimientos-modal-dialog">
                <div class="modal-content global-panel">
                    <div class="modal-header global-panel-header">
                        <h5 class="modal-title global-panel-title" id="modalMovimientosSocioLabel">
                            <i class="fas fa-receipt me-2"></i>Movimientos del socio
                            <span id="tituloMovimientosSocio" class="d-inline-flex align-items-center gap-2"></span>
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body global-panel-body">
                        <div id="estadoMovimientosSocio" class="d-flex align-items-center justify-content-center flex-column py-4 d-none">
                            <i class="fas fa-folder-open fa-2x text-muted mb-2"></i>
                            <p class="text-muted mb-0">No se encontraron movimientos para este socio.</p>
                        </div>
                        <div id="spinnerMovimientosSocio" class="text-center my-4 d-none">
                            <div class="spinner-border" role="status">
                                <span class="visually-hidden">Cargando...</span>
                            </div>
                            <p class="mt-3 mb-0">Cargando movimientos...</p>
                        </div>
                        <div class="movimientos-socio-container global-card" id="contenedorTablaMovimientosSocio" style="display: none;">
                            <table class="table table-hover align-middle" id="tablaMovimientosSocio">
                                <thead>
                                    <tr>
                                        <th>Transacción</th>
                                        <th>Fecha</th>
                                        <th>Rubro</th>
                                        <th>Detalle</th>
                                        <th>Monto</th>
                                        <th>Observaciones</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody id="tbodyMovimientosSocio"></tbody>
                            </table>
                        </div>
                        <div class="d-flex justify-content-center" id="verMasMovimientosContainer" style="display: none;">
                            <button type="button" class="btn btn-outline-primary" id="btnVerMasMovimientos">
                                Ver más movimientos
                            </button>
                        </div>
                    </div>
                    <div class="modal-footer global-panel-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Transacciones del Socio -->
        <div class="modal fade" id="modalTransaccionesSocio" tabindex="-1" aria-labelledby="modalTransaccionesSocioLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
            <div class="modal-dialog modal-lg modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header modal-header-transacciones" style="background: #2c3e50; color: white;">
                        <h6 class="modal-title mb-0" id="modalTransaccionesSocioLabel">
                            <i class="fas fa-list-ul me-2"></i>Transacciones del socio
                            <span id="tituloTransaccionesSocio" class="ms-2"></span>
                        </h6>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div id="estadoTransaccionesSocio" class="text-center py-4 d-none">
                            <i class="fas fa-folder-open fa-2x text-muted mb-2"></i>
                            <p class="text-muted mb-0">No se encontraron transacciones.</p>
                        </div>
                        <div id="spinnerTransaccionesSocio" class="text-center my-4 d-none">
                            <div class="spinner-border" role="status"></div>
                            <p class="mt-2 mb-0">Cargando transacciones...</p>
                        </div>
                        <div id="contenedorTablaTransaccionesSocio" style="display: none;">
                            <table class="table table-hover table-sm">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Fecha/Hora</th>
                                        <th>Cajero</th>
                                        <th>Movimientos</th>
                                        <th>Imprimir</th>
                                    </tr>
                                </thead>
                                <tbody id="tbodyTransaccionesSocio"></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal para Ficha de Socio -->
        <div class="modal fade" id="modalSocio" tabindex="-1" aria-labelledby="modalSocioLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
            <div class="modal-dialog modal-xl" style="min-height: 600px; max-width: 1000px;">
                <div class="modal-content" style="min-height: 600px;">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalSocioLabel">
                            <i class="fas fa-user me-2"></i>Ficha de Socio
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <!-- Tabs Navigation -->
                        <ul class="nav nav-tabs" id="socioTabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" id="generales-tab" data-bs-toggle="tab" data-bs-target="#generales" type="button" role="tab">
                                    <i class="fas fa-user me-2"></i>Generales
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="trabajo-tab" data-bs-toggle="tab" data-bs-target="#trabajo" type="button" role="tab">
                                    <i class="fas fa-briefcase me-2"></i>Trabajo
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="residencia-tab" data-bs-toggle="tab" data-bs-target="#residencia" type="button" role="tab">
                                    <i class="fas fa-home me-2"></i>Residencia
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="beneficiario-tab" data-bs-toggle="tab" data-bs-target="#beneficiario" type="button" role="tab">
                                    <i class="fa-solid fa-people-arrows me-2"></i>Beneficiarios
                                </button>
                            </li>
                            <li class="nav-item" role="presentation" id="sistemas-tab-item">
                                <button class="nav-link" id="sistemas-tab" data-bs-toggle="tab" data-bs-target="#sistemas" type="button" role="tab">
                                    <i class="fas fa-cog me-2"></i>Sistemas
                                </button>
                            </li>
                        </ul>

                        <!-- Tab Content -->
                        <div class="tab-content mt-4" id="socioTabContent">
                            <!-- Tab Generales -->
                            <div class="tab-pane fade show active" id="generales" role="tabpanel">
                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">número de Asociado</label>
                                        <div id="numeroAsociado" class="numero-asociado-display" style="
                                            background: #f8f9fa;
                                            color: #495057;
                                            padding: 8px 12px;
                                            border-radius: 4px;
                                            font-size: 14px;
                                            font-weight: 600;
                                            text-align: center;
                                            border-left: 2px solid #17a2b8;
                                            min-height: 38px;
                                            display: flex;
                                            align-items: center;
                                            justify-content: center;
                                            letter-spacing: 0.5px;
                                        ">
                                            <span id="numeroAsociadoText" style="color: #495057;">Generado automáticamente</span>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Tipo de Asociado *</label>
                                        <select id="tipoAsociado" name="tipoAsociado" class="form-select">
                                            <option value="">Seleccionar tipo</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Estatus</label>
                                        <select id="estatus" class="form-select">
                                            <option value="A" selected="selected">Activo</option>
                                            <option value="I">Inactivo</option>
                                            <option value="S">Suspendido</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Sexo</label>
                                        <select id="sexo" class="form-select">
                                            <option value="">Seleccionar</option>
                                            <option value="M">Masculino</option>
                                            <option value="F">Femenino</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row mt-3">
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Primer Nombre *</label>
                                        <input type="text" id="nombre" name="nombre" class="form-control"/>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Segundo Nombre</label>
                                        <input type="text" id="segundoNombre" class="form-control"/>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Primer Apellido *</label>
                                        <input type="text" id="apellido" name="apellido" class="form-control"/>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Segundo Apellido</label>
                                        <input type="text" id="segundoApellido" class="form-control"/>
                                    </div>
                                </div>
                                <div class="row mt-3">
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Tipo de identificación *</label>
                                        <select id="tipoIdentificacion" name="tipoIdentificacion" class="form-select">
                                            <option value="">Seleccionar</option>
                                            <option value="CEDULA">cédula</option>
                                            <option value="PASAPORTE">Pasaporte</option>
                                            <option value="RUC">RUC</option>
                                            <option value="OTRO">Otro</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">número de identificación *</label>
                                        <input type="text" id="numeroIdentificacion" name="numeroIdentificacion" class="form-control"/>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Fecha de Nacimiento</label>
                                        <input type="text" id="fechaNacimiento" class="form-control flatpickr-date" placeholder="dd/mm/yyyy"/>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Correo Electrónico</label>
                                        <input type="email" id="correoElectronico" class="form-control"/>
                                    </div>
                                </div>
                                <div class="row mt-3">
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Teléfono Residencia</label>
                                        <input type="text" id="telefonoResidencia" class="form-control"/>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Teléfono Celular</label>
                                        <input type="text" id="telefonoCelular" class="form-control"/>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Teléfono de un Familiar</label>
                                        <input type="text" id="telefonoFamiliar" class="form-control"/>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Nivel de Estudio</label>
                                        <select id="nivelEstudio" class="form-select">
                                            <option value="">Seleccionar nivel...</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <!-- Tab Trabajo -->
                            <div class="tab-pane fade" id="trabajo" role="tabpanel">
                                <div class="row g-3">
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Profesión</label>
                                        <select id="profesion" class="form-select">
                                            <option value="">Seleccionar profesión...</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Ocupación</label>
                                        <select id="ocupacion" class="form-select" style="display: block !important;">
                                            <option value="">Seleccionar ocupación...</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Lugar de Trabajo</label>
                                        <select id="lugarTrabajo" class="form-select">
                                            <option value="">Seleccionar empresa...</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Teléfono de Trabajo</label>
                                        <input type="text" id="telefonoTrabajo" class="form-control">
                                    </div>
                                </div>
                                
                                <!-- Sección Dirección de Trabajo -->
                                <div class="mt-4">
                                    <h6 class="fw-bold text-primary mb-3">
                                        <i class="fas fa-map-marker-alt me-2"></i>Dirección de Trabajo
                                    </h6>
                                    <div class="row g-3">
                                        <div class="col-md-3">
                                            <label class="form-label fw-bold">País</label>
                                            <select id="paisTrabajo" class="form-select">
                                                <option value="">Seleccionar país...</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label fw-bold">Provincia</label>
                                            <select id="provinciaTrabajo" class="form-select">
                                                <option value="">Seleccionar provincia...</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label fw-bold">Distrito</label>
                                            <select id="distritoTrabajo" class="form-select">
                                                <option value="">Seleccionar distrito...</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label fw-bold">Corregimiento</label>
                                            <select id="corregimientoTrabajo" class="form-select">
                                                <option value="">Seleccionar corregimiento...</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="row g-3 mt-2">
                                        <div class="col-md-12">
                                            <label class="form-label fw-bold">Dirección de Trabajo</label>
                                            <textarea id="direccionTrabajo" class="form-control" rows="3"></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Tab Residencia -->
                            <div class="tab-pane fade" id="residencia" role="tabpanel">
                                <!-- Sección Dirección Residencial -->
                                <div class="mt-4">
                                    <h6 class="fw-bold text-primary mb-3">
                                        <i class="fas fa-home me-2"></i>Dirección Residencial
                                    </h6>
                                    <div class="row g-3">
                                        <div class="col-md-3">
                                            <label class="form-label fw-bold">País</label>
                                            <select id="paisResidencia" class="form-select">
                                                <option value="">Seleccionar país...</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label fw-bold">Provincia</label>
                                            <select id="provinciaResidencia" class="form-select">
                                                <option value="">Seleccionar provincia...</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label fw-bold">Distrito</label>
                                            <select id="distritoResidencia" class="form-select">
                                                <option value="">Seleccionar distrito...</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label fw-bold">Corregimiento</label>
                                            <select id="corregimientoResidencia" class="form-select">
                                                <option value="">Seleccionar corregimiento...</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="row g-3 mt-2">
                                        <div class="col-md-12">
                                            <label class="form-label fw-bold">Dirección de Residencia</label>
                                            <textarea id="direccionResidencia" class="form-control" rows="3"></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Tab Beneficiarios -->
                            <div class="tab-pane fade" id="beneficiario" role="tabpanel">


                                <!-- Tabla de beneficiarios -->
                                <div class="row">
                                    <div class="col-12">
                                        <div class="card">
                                            <div class="card-header bg-light">
                                                <div class="d-flex align-items-center justify-content-between">
                                                    <div class="d-flex align-items-center">
                                                        <h6 class="mb-0 me-3"><i class="fas fa-users me-2"></i>Beneficiarios Asignados</h6>
                                                        <button type="button" class="btn btn-primary btn-sm" onclick="abrirModalAgregarBeneficiario()" title="Agregar Beneficiario">
                                                            <i class="fas fa-plus me-1"></i>Agregar
                                                        </button>
                                                    </div>
                                                    <div class="d-flex align-items-center">
                                                        <i class="fas fa-percentage me-2"></i>
                                                        <span class="fw-bold">Restante: </span>
                                                        <span id="porcentajeRestante" class="fw-bold fs-6 ms-1">100.00%</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="alert alert-info alert-sm py-2 mb-0 text-center" style="border-radius: 0; border-left: none; border-right: none; background-color: #e3f2fd;">
                                                <i class="fas fa-info-circle me-2" style="color: #1976d2;"></i>
                                                <small style="color: #1565c0;"><strong>Nota:</strong> Los beneficiarios se guardan automáticamente sin necesidad de guardar los datos del asociado.</small>
                                            </div>
                                            <div class="card-body p-0">
                                                <div class="table-responsive">
                                                    <table id="tablaBeneficiarios" class="table table-hover mb-0">
                                                        <thead class="table-dark">
                                                            <tr>
                                                                <th>Nombre Completo</th>
                                                                <th>identificación</th>
                                                                <th>Parentesco</th>
                                                                <th>Porcentaje</th>
                                                                <th>Acciones</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <!-- Los datos se cargarán diN°micamente -->
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Tab Sistemas -->
                            <div class="tab-pane fade" id="sistemas" role="tabpanel">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <div class="info-card">
                                            <div class="info-label">
                                                <i class="fas fa-calendar-plus info-icon"></i>Fecha de Creación
                                            </div>
                                            <p class="info-value" id="fechaCreacionDisplay">-</p>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="info-card">
                                            <div class="info-label">
                                                <i class="fas fa-user-plus info-icon"></i>Usuario que Creó
                                    </div>
                                            <p class="info-value" id="usuarioCreaDisplay">-</p>
                                </div>
                                    </div>
                                </div>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <div class="info-card">
                                            <div class="info-label">
                                                <i class="fas fa-calendar-edit info-icon"></i>Fecha de Modificación
                                            </div>
                                            <p class="info-value" id="fechaModificacionDisplay">-</p>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="info-card">
                                            <div class="info-label">
                                                <i class="fas fa-user-edit info-icon"></i>Usuario que Modificó
                                            </div>
                                            <p class="info-value" id="usuarioModificaDisplay">-</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-2"></i>Cancelar
                        </button>
                        <button type="button" class="btn btn-primary" onclick="guardarSocio()">
                            <i class="fas fa-save me-2"></i>Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Toast Container -->
        <div class="toast-container">
            <div id="toast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="toast-header">
                    <i class="fas fa-info-circle text-primary me-2"></i>
                    <strong class="me-auto">Notificación</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
                <div class="toast-body" id="toastMessage">
                    <!-- Mensaje diN°mico -->
                </div>
            </div>
        </div>
    </form>

    <!-- Modal para Agregar Beneficiario -->
    <div class="modal fade" id="modalAgregarBeneficiario" tabindex="-1" aria-labelledby="modalAgregarBeneficiarioLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog modal-dialog-centered" style="margin-top: 100px;">
            <div class="modal-content">
                <div class="modal-header" style="background-color: #28a745; color: white;">
                    <h5 class="modal-title" id="modalAgregarBeneficiarioLabel">
                        <i class="fas fa-user-plus me-2"></i>Agregar Beneficiario
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="formAgregarBeneficiario">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Nombre *</label>
                                <input type="text" id="beneficiarioNombre" class="form-control" placeholder="Nombre del beneficiario"/>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Apellido *</label>
                                <input type="text" id="beneficiarioApellido" class="form-control" placeholder="Apellido del beneficiario"/>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Tipo ID *</label>
                                <select id="beneficiarioTipoIdentificacion" class="form-select">
                                    <option value="">Seleccionar...</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">número ID *</label>
                                <input type="text" id="beneficiarioNumeroIdentificacion" class="form-control" placeholder="número de identificación"/>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Parentesco *</label>
                                <select id="beneficiarioParentesco" class="form-select">
                                    <option value="">Seleccionar parentesco...</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Porcentaje *</label>
                                <div class="input-group">
                                    <input type="number" id="beneficiarioPorcentaje" class="form-control" placeholder="0.00" min="0" max="100" step="0.01" oninput="validarPorcentaje(this)"/>
                                    <span class="input-group-text">%</span>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-1"></i>Cancelar
                    </button>
                    <button type="button" class="btn btn-primary" onclick="agregarBeneficiario()">
                        <i class="fas fa-plus me-1"></i>Agregar
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal para Editar Beneficiario -->
    <div class="modal fade" id="modalEditarBeneficiario" tabindex="-1" aria-labelledby="modalEditarBeneficiarioLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog modal-dialog-centered" style="margin-top: 100px;">
            <div class="modal-content">
                <div class="modal-header" style="background-color: #007bff; color: white;">
                    <h5 class="modal-title" id="modalEditarBeneficiarioLabel">
                        <i class="fas fa-user-edit me-2"></i>Editar Beneficiario
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="formEditarBeneficiario">
                        <input type="hidden" id="editarBeneficiarioId" value=""/>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Nombre *</label>
                                <input type="text" id="editarBeneficiarioNombre" class="form-control" placeholder="Nombre del beneficiario"/>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Apellido *</label>
                                <input type="text" id="editarBeneficiarioApellido" class="form-control" placeholder="Apellido del beneficiario"/>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Tipo ID *</label>
                                <select id="editarBeneficiarioTipoIdentificacion" class="form-select">
                                    <option value="">Seleccionar...</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">número ID *</label>
                                <input type="text" id="editarBeneficiarioNumeroIdentificacion" class="form-control" placeholder="número de identificación">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Parentesco *</label>
                                <select id="editarBeneficiarioParentesco" class="form-select">
                                    <option value="">Seleccionar parentesco...</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Porcentaje *</label>
                                <div class="input-group">
                                    <input type="number" id="editarBeneficiarioPorcentaje" class="form-control" placeholder="0.00" min="0" max="100" step="0.01" oninput="validarPorcentajeEditar(this)">
                                    <span class="input-group-text">%</span>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-1"></i>Cancelar
                    </button>
                    <button type="button" class="btn btn-primary" onclick="guardarEdicionBeneficiario()">
                        <i class="fas fa-save me-1"></i>Guardar Cambios
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <!-- Flatpickr Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/es.js"></script>
    
    <script>
        let tablaSocios;
        let tablaSociosInicializada = false;
        let tablaMovimientosSocio;
        let socioMovimientosEnConsulta = null;
        let esModoEdicion = false;
        let numeroAsociadoActual = null;
        const formateadorMonedaSocios = new Intl.NumberFormat('es-US', { style: 'currency', currency: 'USD' });
        window.__sociosCache = window.__sociosCache || [];
        const configuracionesChipRubros = {
            'AH': { color: 'bg-success', icono: 'fas fa-piggy-bank', nombre: 'Ahorro' },
            'AP': { color: 'bg-info', icono: 'fas fa-coins', nombre: 'Aporte' },
            'PR': { color: 'bg-warning', icono: 'fas fa-hand-holding-usd', nombre: 'Préstamo' },
            'CR': { color: 'bg-danger', icono: 'fas fa-credit-card', nombre: 'Crédito' },
            'IN': { color: 'bg-primary', icono: 'fas fa-chart-line', nombre: 'Inversión' }
        };
        const movimientosSocioEstado = {
            start: 0,
            length: 20,
            total: 0,
            orderColumn: 'Fecha',
            orderDir: 'DESC',
            cargando: false,
            silenciarOrden: false
        };
        window.__movimientosSocioEstado = movimientosSocioEstado;
        
        // Variables globales para dropdowns relacionados
        var paisesData = [];
        var provinciasData = [];
        var distritosData = [];
        var corregimientosData = [];
        
        // Variables globales para dropdowns de residencia
        var paisesResidenciaData = [];
        var provinciasResidenciaData = [];
        var distritosResidenciaData = [];
        var corregimientosResidenciaData = [];
        
        // Variables para controlar el estado de carga de datos
        var datosCompletamenteCargados = false;
        var datosCargando = {
            tiposAsociado: false,
            statusAsociado: false,
            tiposDocumento: false,
            nivelesEstudio: false,
            profesiones: false,
            parentezcos: false,
            empresas: false,
            ocupaciones: false,
            paises: false,
            provincias: false,
            distritos: false,
            corregimientos: false,
            paisesResidencia: false,
            provinciasResidencia: false,
            distritosResidencia: false,
            corregimientosResidencia: false
        };
        
        function verificarDatosCargados() {
            datosCompletamenteCargados = Object.values(datosCargando).every(function(cargado) {
                return cargado === true;
            });
            return datosCompletamenteCargados;
        }
        
        function mostrarLoadingModal() {
            const loadingHtml = `
                <div id="loadingOverlay" style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 9999; display: flex; align-items: center; justify-content: center;">
                    <div style="background: white; padding: 30px; border-radius: 10px; text-align: center;">
                        <div class="spinner-border text-primary" role="status" style="width: 3rem; height: 3rem;">
                            <span class="visually-hidden">Cargando...</span>
                        </div>
                        <p class="mt-3 mb-0" style="font-size: 1.1rem; font-weight: 500;">Cargando datos...</p>
                        <p class="text-muted" style="font-size: 0.9rem;">Por favor espere</p>
                    </div>
                </div>
            `;
            $('body').append(loadingHtml);
        }
        
        function ocultarLoadingModal() {
            $('#loadingOverlay').remove();
        }
        
        function esperarDatosCargados(callback) {
            if (verificarDatosCargados()) {
                callback();
            } else {
                mostrarLoadingModal();
                const intervalo = setInterval(function() {
                    if (verificarDatosCargados()) {
                        clearInterval(intervalo);
                        ocultarLoadingModal();
                        callback();
                    }
                }, 100);
                
                // Timeout de 10 segundos
                setTimeout(function() {
                    clearInterval(intervalo);
                    ocultarLoadingModal();
                    mostrarToast('Tiempo de espera agotado. Por favor, recargue la página.', 'error');
                }, 10000);
            }
        }

        $(document).ready(function() {
            // Inicializar Flatpickr para fechas
            flatpickr(".flatpickr-date", {
                locale: "es",
                dateFormat: "d/m/Y",
                allowInput: true,
                clickOpens: true,
                placeholder: "dd/mm/yyyy"
            });
            inicializarTablaConDelay();
            inicializarTablaMovimientos();
            cargarTiposAsociado();
            cargarStatusAsociado();
            cargarTiposDocumento();
            cargarNivelesEstudio();
            cargarProfesiones();
            cargarParentezcos();
            cargarEmpresas();
            cargarOcupaciones();
            cargarPaises();
            cargarProvincias();
            cargarDistritos();
            cargarCorregimientos();
            cargarPaisesResidencia();
            cargarProvinciasResidencia();
            cargarDistritosResidencia();
            cargarCorregimientosResidencia();
            
            // Configurar Select2 después de cargar todos los datos
            setTimeout(function() {
                configurarSelect2();
            }, 1000);
            
            // Marcar todos los datos como cargados después de 2 segundos
            setTimeout(function() {
                Object.keys(datosCargando).forEach(function(key) {
                    datosCargando[key] = true;
                });
                verificarDatosCargados();
            }, 2000);
            
            // Agregar evento para reinicializar Select2 cuando se abra el modal
            $('#modalSocio').on('shown.bs.modal', function() {
                setTimeout(function() {
                    forzarSelect2();
                    configurarEventosSelect2();
                    asegurarCampoBusqueda();
                }, 200);
            });
            
            $('#btnVerMasMovimientos').on('click', function() {
                if (!socioMovimientosEnConsulta || movimientosSocioEstado.cargando) {
                    return;
                }
                cargarMovimientosSocio(socioMovimientosEnConsulta, false);
            });
            
            verificarEnvironment();
            
            // Configurar event listeners para dropdowns relacionados
            configurarDropdownsRelacionados();
            configurarDropdownsResidencia();
            
            // Verificar el campo ocupación después de cargar
            setTimeout(function() {
                const ocupacionField = $('#ocupacion');
            }, 2000);
            
            // Verificar mayúsculas automáticas y aplicar si está habilitado
            verificarMayusculasAutomaticas();
        });

        function inicializarTablaConDelay() {
            $('#tablaSocios').addClass('tabla-socios-deshabilitada');
            $('#loadingSocios').show();

            setTimeout(function() {
                inicializarDataTable();
                tablaSociosInicializada = true;
                $('#tablaSocios').removeClass('tabla-socios-deshabilitada');
                // Con serverSide, la tabla carga automáticamente en el primer draw
            }, 1500);
        }

        function volverDashboard() {
            window.location.href = '/Dashboard.aspx';
        }

        // Función para ajustar la altura del grid basándose en 10 filas fijas
        function ajustarAlturaGrid() {
            if (!tablaSocios) return;
            
            // Calcular altura máxima disponible restando todos los elementos fijos
            var viewportHeight = $(window).height();
            var mainContainer = $('.main-container');
            var mainContainerOffset = mainContainer.offset();
            var mainContainerTop = mainContainerOffset ? mainContainerOffset.top : 0;
            var mainContainerPadding = parseFloat(mainContainer.css('padding-top')) + parseFloat(mainContainer.css('padding-bottom')) || 0;
            var topBarHeight = $('.top-bar-section').outerHeight(true) || 0;
            
            // Obtener altura del footer ANTES de calcular, para asegurar que esté visible
            var footerRow = $('.dataTables_wrapper .row.mt-3');
            var footerHeight = footerRow.outerHeight(true) || 60;
            
            // Calcular altura disponible para el wrapper de DataTables
            // Restar espacio adicional para márgenes y padding
            var espacioAdicional = 30;
            var alturaDisponible = viewportHeight - mainContainerTop - mainContainerPadding - topBarHeight - espacioAdicional;
            
            // Asegurar altura mínima
            if (alturaDisponible < 300) {
                alturaDisponible = 300;
            }
            
            // Asegurar que el wrapper de DataTables ocupe todo el espacio disponible
            var dataTablesWrapper = $('#tablaSocios_wrapper');
            if (dataTablesWrapper.length) {
                // Calcular altura para el área de scroll (sin el footer)
                // El footer debe estar siempre visible, así que restamos su altura
                var alturaScroll = alturaDisponible - footerHeight;
                
                // Asegurar altura mínima para el scroll
                if (alturaScroll < 200) {
                    alturaScroll = 200;
                }
                
                // Aplicar altura al wrapper completo
                dataTablesWrapper.css({
                    'height': alturaDisponible + 'px',
                    'max-height': alturaDisponible + 'px',
                    'min-height': alturaDisponible + 'px'
                });
                
                // Aplicar altura al contenedor de scroll - ocupar todo el espacio disponible
                var scrollDiv = dataTablesWrapper.find('.dataTables_scroll');
                var scrollBody = dataTablesWrapper.find('.dataTables_scrollBody');
                if (scrollDiv.length) {
                    scrollDiv.css({ 'min-height': alturaScroll + 'px', 'flex': '1 1 auto' });
                }
                if (scrollBody.length) {
                    scrollBody.css({
                        'min-height': alturaScroll + 'px',
                        'max-height': alturaScroll + 'px',
                        'height': alturaScroll + 'px',
                        'overflow-y': 'auto !important',
                        'overflow-x': 'auto !important'
                    });
                }
                
                // Actualizar el scrollY de DataTables dinámicamente
                if (tablaSocios && tablaSocios.settings()[0].oScroll) {
                    var settings = tablaSocios.settings()[0];
                    if (settings.oScroll && settings.oScroll.sY) {
                        // Actualizar la altura del scroll en la configuración
                        settings.oScroll.sY = alturaScroll + 'px';
                        // Forzar recálculo
                        tablaSocios.columns.adjust();
                    }
                }
                
                // Asegurar que el footer esté siempre visible
                footerRow.css({
                    'display': 'flex !important',
                    'visibility': 'visible !important',
                    'opacity': '1 !important',
                    'flex-shrink': '0 !important',
                    'flex-grow': '0 !important'
                });
            }
            
            // Asegurar que los contenedores padre ocupen el espacio disponible
            var tableResponsive = $('.table-responsive');
            
            if (tableResponsive.length) {
                tableResponsive.css({
                    'flex': '1 1 auto',
                    'min-height': '0',
                    'overflow': 'hidden',
                    'height': '100%'
                });
            }
        }
        
        function inicializarDataTable() {
            tablaSocios = $('#tablaSocios').DataTable({
                serverSide: true,
                processing: true,
                language: {
                    url: 'https://cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json',
                    emptyTable: "Ningún asociado en la lista",
                    zeroRecords: "Ningún asociado en la lista",
                    processing: "Cargando socios..."
                },
                responsive: false,
                pageLength: 25,
                lengthMenu: [[10, 25, 50, 100], [10, 25, 50, 100]],
                order: [[2, 'desc']], // N° Asociado
                scrollY: '400px', // Altura inicial, se ajustará dinámicamente en ajustarAlturaGrid
                scrollCollapse: false,
                scroller: false,
                paging: true,
                autoWidth: false,
                columnDefs: [
                    { targets: [0, 1], width: '48px' }, // Trans. y Movs. mismo ancho
                    { targets: [2], width: '60px' }, // Num. columna reducida
                    { targets: [9, 10], visible: false }, // Ocultar Fecha Modificación y Usuario Modificó
                    { targets: [0, 1, 11, 12], orderable: false }, // Trans, Movs y columnas de acción no ordenables
                    { targets: [0, 1, 11, 12], className: 'text-center' }, // Centrar botones
                    { targets: [6], className: 'text-left', createdCell: function (td, cellData, rowData, row, col) {
                        $(td).css('text-align', 'left');
                    }} // Columna de identificación alineada a la izquierda
                ],
                dom: 'rt<"row mt-3"<"col-sm-12 col-md-4"i><"col-sm-12 col-md-4 text-center"l><"col-sm-12 col-md-4"p>>', // tabla arriba, info izquierda, length centro, paginación derecha abajo
                searching: false, // Desactivar búsqueda de DataTables ya que usamos filtros personalizados
                ajax: function(data, callback, settings) {
                    const order = data.order && data.order[0];
                    const sortColumn = (order && order.column >= 2 && order.column <= 8) ? order.column - 1 : 1;
                    const sortDirection = order ? order.dir : 'desc';
                    const filtros = {
                        FiltroNombre: $('#filtroNombre').val() || '',
                        FiltroTipo: $('#filtroTipo').val() || '',
                        FiltroEstatus: $('#filtroEstatus').val() || '',
                        FiltroTipoDocumento: $('#filtroTipoDocumento').val() || '',
                        FiltroIdentificacion: $('#filtroIdentificacion').val() || '',
                        PageSize: data.length,
                        PageIndex: Math.floor(data.start / data.length),
                        SortColumn: sortColumn,
                        SortDirection: sortDirection
                    };
                    $.ajax({
                        type: "POST",
                        url: "GestionSocios.aspx/ObtenerSocios",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify({ filtrosJson: JSON.stringify(filtros) }),
                        dataType: "json",
                        success: function(response) {
                            let payload = response.d;
                            if (typeof payload === 'string') {
                                try { payload = JSON.parse(payload); } catch (e) { payload = { Success: false }; }
                            }
                            if (!payload.Success) {
                                mostrarToast(payload.Message || 'No se pudieron cargar los socios.', 'error');
                                callback({ draw: data.draw, recordsTotal: 0, recordsFiltered: 0, data: [] });
                                return;
                            }
                            const socios = payload.Data || [];
                            const totalRegistros = payload.TotalRegistros || 0;
                            if (totalRegistros === 0 && socios.length === 0) {
                                mostrarToast('No se encontraron socios.', 'info');
                            }
                            const rows = socios.map(function(socio) {
                                const nombreCompleto = `${socio.Nombre || ''} ${socio.SegundoNombre || ''} ${socio.Apellido || ''} ${socio.SegundoApellido || ''}`.trim();
                                const identificacion = formatearIdentificacion(socio.TipoIdentificacion, socio.NumeroIdentificacion);
                                const estatusBadge = obtenerBadgeEstatus(socio.Estatus);
                                const fechaCreacion = formatearFechaHora(socio.FechaCreacion);
                                const fechaModificacion = formatearFecha(socio.FechaModificacion);
                                const botonTrans = `<button type="button" class="btn btn-sm btn-outline-primary" onclick="event.preventDefault(); event.stopPropagation(); verTransaccionesSocio(${socio.NumeroAsociado})" title="Transacciones"><i class="fas fa-list-ul"></i></button>`;
                                const botonMovimientos = `<button type="button" class="btn btn-sm btn-outline-info" onclick="event.preventDefault(); event.stopPropagation(); verMovimientosSocio(${socio.NumeroAsociado})" title="Ver movimientos"><i class="fas fa-list-ul"></i></button>`;
                                agregarSocioACache(socio);
                                return [
                                    botonTrans,
                                    botonMovimientos,
                                    socio.NumeroAsociado,
                                    socio.TipoAsociado || 'N/A',
                                    nombreCompleto || 'N/A',
                                    estatusBadge,
                                    identificacion || 'N/A',
                                    fechaCreacion,
                                    socio.UsuarioCrea || 'N/A',
                                    fechaModificacion,
                                    socio.UsuarioModifica || 'N/A',
                                    `<button type="button" class="btn btn-sm btn-outline-info" onclick="event.preventDefault(); event.stopPropagation(); generarEstadoCuenta(${socio.NumeroAsociado})" title="Generar Estado de Cuenta"><i class="fas fa-file-invoice"></i></button>`,
                                    `<button type="button" class="btn btn-sm btn-outline-primary" onclick="event.preventDefault(); event.stopPropagation(); verSocio(${socio.NumeroAsociado})" title="Editar socio"><i class="fas fa-edit"></i></button>`,
                                    `<button type="button" class="btn btn-sm btn-outline-danger" onclick="event.preventDefault(); event.stopPropagation(); eliminarSocio(${socio.NumeroAsociado}, '${(socio.Nombre || '')} ${(socio.Apellido || '')}')" title="Eliminar socio"><i class="fas fa-trash"></i></button>`
                                ];
                            });
                            $('#loadingSocios').hide();
                            callback({ draw: data.draw, recordsTotal: totalRegistros, recordsFiltered: totalRegistros, data: rows });
                        },
                        error: function() {
                            $('#loadingSocios').hide();
                            mostrarToast('Error al cargar socios', 'error');
                            callback({ draw: data.draw, recordsTotal: 0, recordsFiltered: 0, data: [] });
                        }
                    });
                },
                drawCallback: function(settings) {
                    // Ajustar altura del grid después de cada draw
                    setTimeout(function() {
                        ajustarAlturaGrid();
                    }, 50);
                },
                initComplete: function(settings, json) {
                    setTimeout(function() {
                        // Ajustar altura del grid
                        ajustarAlturaGrid();
                        
                        // Forzar visibilidad de controles de paginación
                        var paginate = $('.dataTables_paginate');
                        var info = $('.dataTables_info');
                        var row = $('.dataTables_wrapper .row.mt-3');
                        
                        if (paginate.length) {
                            paginate.each(function() {
                                this.style.setProperty('display', 'block', 'important');
                                this.style.setProperty('visibility', 'visible', 'important');
                                this.style.setProperty('opacity', '1', 'important');
                            });
                        }
                        
                        if (info.length) {
                            info.each(function() {
                                this.style.setProperty('display', 'inline-block', 'important');
                                this.style.setProperty('visibility', 'visible', 'important');
                                this.style.setProperty('opacity', '1', 'important');
                            });
                        }
                        
                        if (row.length) {
                            row.each(function() {
                                this.style.setProperty('display', 'flex', 'important');
                                this.style.setProperty('visibility', 'visible', 'important');
                                this.style.setProperty('opacity', '1', 'important');
                            });
                        }
                        
                    }, 200);
                }
            });

            // Agregar evento de doble clic en las filas
            $('#tablaSocios tbody').on('dblclick', 'tr', function(e) {
                e.preventDefault();
                e.stopPropagation();
                const data = tablaSocios.row(this).data();
                if (data && data[2]) { // Verificar que hay datos y que el número de asociado existe (col 2 = N° Asociado)
                    const numeroAsociado = parseInt(data[2]);
                    verSocio(numeroAsociado);
                }
            });
            
            // Aplicar estilos de hover personalizados (celeste claro) para la tabla de socios
            $('#tablaSocios tbody').on('mouseenter', 'tr', function() {
                $(this).css('background-color', '#A2F4FD');
                $(this).find('td').css('background-color', '#A2F4FD');
            });
            
            $('#tablaSocios tbody').on('mouseleave', 'tr', function() {
                // Restaurar el color original (blanco o gris alternado)
                const isEven = $(this).index() % 2 === 0;
                if (isEven) {
                    $(this).css('background-color', '#f8f9fa');
                    $(this).find('td').css('background-color', '#f8f9fa');
                } else {
                    $(this).css('background-color', '');
                    $(this).find('td').css('background-color', '');
                }
            });
            
            // Ajustar altura cuando se redimensiona la ventana
            $(window).on('resize', function() {
                setTimeout(function() {
                    if (tablaSocios) {
                        ajustarAlturaGrid();
                        tablaSocios.columns.adjust().draw();
                    }
                }, 100);
            });
            
            // Ajustar altura cuando cambie el número de filas por página
            $(document).on('change', '.dataTables_length select', function() {
                setTimeout(function() {
                    if (tablaSocios) {
                        ajustarAlturaGrid();
                    }
                }, 100);
            });
        }

        function inicializarTablaMovimientos() {
            tablaMovimientosSocio = $('#tablaMovimientosSocio').DataTable({
                language: {
                    url: 'https://cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json',
                    emptyTable: 'Sin movimientos registrados'
                },
                paging: false,
                searching: false,
                info: false,
                ordering: true,
                order: [[1, 'desc']],
                autoWidth: false,
                dom: 't',
                columns: [
                    { data: 'transaccion', className: 'align-middle' },
                    {
                        data: 'fechaOrden',
                        render: function(data, type, row) {
                            if (type === 'sort' || type === 'type') {
                                return data || 0;
                            }
                            return row.fechaTexto;
                        },
                        className: 'align-middle'
                    },
                    { data: 'rubro', className: 'text-center align-middle' },
                    { data: 'descripcion', className: 'align-middle' },
                    { data: 'monto', className: 'text-center align-middle' },
                    { data: 'observaciones', className: 'observaciones-cell' },
                    { data: 'acciones', className: 'text-center align-middle', orderable: false }
                ]
            });

            $('#tablaMovimientosSocio').on('order.dt', function() {
                if (!tablaMovimientosSocio) {
                    return;
                }
                if (movimientosSocioEstado.silenciarOrden) {
                    movimientosSocioEstado.silenciarOrden = false;
                    return;
                }
                if (movimientosSocioEstado.cargando) {
                    return;
                }

                const orden = tablaMovimientosSocio.order();
                if (!orden || !orden.length) {
                    return;
                }

                const mapColumnas = ['Transaccion', 'Fecha', 'Rubro', 'Detalle', 'Monto', 'Observaciones', 'Acciones'];
                const indice = orden[0][0];
                const nuevaColumna = mapColumnas[indice] || 'Fecha';
                const nuevaDireccion = (orden[0][1] || 'desc').toUpperCase();

                if (nuevaColumna === 'Acciones') {
                    movimientosSocioEstado.silenciarOrden = true;
                    tablaMovimientosSocio.order([obtenerIndiceColumnaMovimientos(movimientosSocioEstado.orderColumn), movimientosSocioEstado.orderDir.toLowerCase()]).draw(false);
                    return;
                }

                if (nuevaColumna !== movimientosSocioEstado.orderColumn || nuevaDireccion !== movimientosSocioEstado.orderDir) {
                    movimientosSocioEstado.orderColumn = nuevaColumna;
                    movimientosSocioEstado.orderDir = nuevaDireccion;
                    movimientosSocioEstado.start = 0;
                    movimientosSocioEstado.total = 0;
                    movimientosSocioEstado.cargando = false;
                    cargarMovimientosSocio(socioMovimientosEnConsulta, true);
                }
            });

            $('#btnVerMasMovimientos').off('click').on('click', function() {
                if (!socioMovimientosEnConsulta || movimientosSocioEstado.cargando) {
                    return;
                }
                cargarMovimientosSocio(socioMovimientosEnConsulta, false);
            });
        }

        function cargarTiposAsociado() {
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerTiposAsociado",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d.Success) {
                        const tipos = response.d.Data;
                        const selectFiltro = $('#filtroTipo');
                        const selectModal = $('#tipoAsociado');
                        
                        selectFiltro.empty().append('<option value="">Todos los tipos</option>');
                        selectModal.empty().append('<option value="">Seleccionar tipo</option>');
                        
                        tipos.forEach(function(tipo) {
                            selectFiltro.append(`<option value="${tipo.IdTipoAsociado}">${tipo.TipoAsociado}</option>`);
                            selectModal.append(`<option value="${tipo.IdTipoAsociado}">${tipo.TipoAsociado}</option>`);
                        });
                    } else {
                        mostrarToast(response.d.Message || 'Error al cargar tipos de asociado', 'error');
                    }
                    datosCargando.tiposAsociado = true;
                    verificarDatosCargados();
                },
                error: function() {
                    mostrarToast('Error al cargar tipos de asociado', 'error');
                    datosCargando.tiposAsociado = true;
                    verificarDatosCargados();
                }
            });
        }

        function cargarStatusAsociado() {
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerStatusAsociado",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d.Success) {
                        const status = response.d.Data;
                        const selectFiltro = $('#filtroEstatus');
                        const selectModal = $('#estatus');
                        
                        selectFiltro.empty().append('<option value="">Todos los estatus</option>');
                        selectModal.empty().append('<option value="">Seleccionar estatus</option>');
                        
                        status.forEach(function(stat) {
                            selectFiltro.append(`<option value="${stat.CodStatusAsociado}">${stat.StatusAsociado}</option>`);
                            selectModal.append(`<option value="${stat.CodStatusAsociado}">${stat.StatusAsociado}</option>`);
                        });
                    } else {
                        mostrarToast(response.d.Message || 'Error al cargar status de asociado', 'error');
                    }
                },
                error: function() {
                    mostrarToast('Error al cargar status de asociado', 'error');
                }
            });
        }

        function cargarTiposDocumento() {
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerTiposDocumento",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d.Success) {
                        const tiposDoc = response.d.Data;
                        const selectModal = $('#tipoIdentificacion');
                        const selectFiltro = $('#filtroTipoDocumento');
                        
                        // Llenar el select del modal
                        selectModal.empty().append('<option value="">Seleccionar tipo de documento</option>');
                        
                        // Llenar el select del filtro
                        selectFiltro.empty().append('<option value="">Todos los tipos</option>');
                        
                        tiposDoc.forEach(function(tipo) {
                            selectModal.append(`<option value="${tipo.CodTipoDoc}">${tipo.TipoDocumento}</option>`);
                            selectFiltro.append(`<option value="${tipo.CodTipoDoc}">${tipo.TipoDocumento}</option>`);
                            
                            // Llenar también los dropdowns de beneficiarios
                            $('#beneficiarioTipoIdentificacion').append(`<option value="${tipo.CodTipoDoc}">${tipo.TipoDocumento}</option>`);
                            $('#editarBeneficiarioTipoIdentificacion').append(`<option value="${tipo.CodTipoDoc}">${tipo.TipoDocumento}</option>`);
                        });
                    } else {
                        mostrarToast(response.d.Message || 'Error al cargar tipos de documento', 'error');
                    }
                },
                error: function() {
                    mostrarToast('Error al cargar tipos de documento', 'error');
                }
            });
        }

        function cargarSocios(resetPage) {
            if (!tablaSocios) {
                setTimeout(function() { cargarSocios(resetPage); }, 300);
                return;
            }
            tablaSocios.ajax.reload(null, !!resetPage); // resetPage=true → ir a página 1 (útil tras crear socio)
        }

        function aplicarFiltros() {
            cargarSocios();
        }

        function obtenerBadgeEstatus(estatus) {
            switch(estatus) {
                case 'A': return '<span class="badge badge-success">Activo</span>';
                case 'I': return '<span class="badge badge-warning">Inactivo</span>';
                case 'S': return '<span class="badge badge-danger">Suspendido</span>';
                default: return '<span class="badge badge-secondary">N/A</span>';
            }
        }

        // Función de compatibilidad - ahora usa la función global
        function formatearIdentificacion(tipoIdentificacion, numeroIdentificacion) {
            return crearChipTipoDocumento(tipoIdentificacion, numeroIdentificacion);
        }

        function formatearFecha(fecha) {
            if (!fecha) return 'N/A';
            
            let date;
            
            // Manejar formato de timestamp de JavaScript (/Date(1757620890457)/)
            if (typeof fecha === 'string' && fecha.includes('/Date(')) {
                const timestamp = parseInt(fecha.match(/\d+/)[0]);
                date = new Date(timestamp);
            } else {
                date = new Date(fecha);
            }
            
            // Verificar si la fecha es válida
            if (isNaN(date.getTime())) {
                return 'N/A';
            }
            
            return date.toLocaleDateString('es-ES', {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric'
            });
        }

        function formatearFechaHora(fecha) {
            if (!fecha) return 'N/A';
            
            let date;
            
            // Manejar formato de timestamp de JavaScript (/Date(1757620890457)/)
            if (typeof fecha === 'string' && fecha.includes('/Date(')) {
                const timestamp = parseInt(fecha.match(/\d+/)[0]);
                date = new Date(timestamp);
            } else {
                date = new Date(fecha);
            }
            
            // Verificar si la fecha es válida
            if (isNaN(date.getTime())) {
                return 'N/A';
            }
            
            return date.toLocaleString('es-ES', {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
                hour12: true
            });
        }

        function verSocio(numeroAsociado) {
            esperarDatosCargados(function() {
                $.ajax({
                    type: "POST",
                    url: "GestionSocios.aspx/ObtenerSocioPorNumero",
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify({ numeroAsociado: numeroAsociado }),
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }
                    if (response.d.Success) {
                        const socio = response.d.Data;
                        llenarFormulario(socio);
                        esModoEdicion = true;
                        numeroAsociadoActual = numeroAsociado;
                        
                        // Crear título con información del socio
                        const nombreCompleto = `${socio.Nombre} ${socio.Apellido}`.trim();
                        const chipDocumento = crearChipTipoDocumento(socio.TipoIdentificacion, '');
                        const numeroDoc = socio.NumeroIdentificacion || 'N/A';
                        const titulo = `
                            <i class="fas fa-user-edit me-2"></i>Editar Socio - ${nombreCompleto}
                            <span class="ms-2">${chipDocumento} <span class="text-white">${numeroDoc}</span></span>
                        `;
                        $('#modalSocioLabel').html(titulo);
                        
                        // Mostrar tab Sistemas para edición
                        $('#sistemas-tab-item').show();
                        
                        // Activar tab Generales
                        $('#generales-tab').tab('show');
                        
                        // Cargar beneficiarios del socio
                        cargarBeneficiarios(numeroAsociado);
                        
                        $('#modalSocio').modal('show');
                        
                        // Aplicar mayúsculas automáticas cuando se abra el modal
                        setTimeout(function() {
                            if (mayusculasAutomaticasHabilitadas === true) {
                                aplicarMayusculasAutomaticas();
                            }
                        }, 100);
                    } else {
                        mostrarToast(response.d.Message, 'error');
                    }
                },
                error: function() {
                    mostrarToast('Error al cargar datos del socio', 'error');
                }
            });
            });
        }

        function eliminarSocio(numeroAsociado, nombreCompleto) {
            // Mostrar div de confirmación personalizado
            mostrarConfirmEliminarSocio(numeroAsociado, nombreCompleto);
        }

        function mostrarConfirmEliminarSocio(numeroAsociado, nombreCompleto) {
            // Asegurar que los estilos de modales estén disponibles
            if (!$('#customModalStyles').length) {
                $('head').append(`
                    <style id="customModalStyles">
                        .custom-modal-overlay {
                            position: fixed;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 100%;
                            background: rgba(0, 0, 0, 0.5);
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            z-index: 9999;
                            backdrop-filter: blur(3px);
                        }
                        
                        .custom-modal {
                            background: white;
                            border-radius: 12px;
                            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.4);
                            width: 90%;
                            max-width: 450px;
                            max-height: 90vh;
                            overflow: hidden;
                            animation: modalSlideIn 0.3s ease-out;
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
                        
                        .custom-modal-header {
                            background: linear-gradient(135deg, #dc3545, #c82333);
                            color: white;
                            padding: 20px;
                            border-radius: 12px 12px 0 0;
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                        }
                        
                        .custom-modal-header h5 {
                            margin: 0;
                            font-weight: 600;
                            font-size: 18px;
                        }
                        
                        .btn-close-custom {
                            background: rgba(255, 255, 255, 0.2);
                            border: none;
                            color: white;
                            width: 30px;
                            height: 30px;
                            border-radius: 50%;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            cursor: pointer;
                            transition: background 0.3s;
                        }
                        
                        .btn-close-custom:hover {
                            background: rgba(255, 255, 255, 0.3);
                        }
                        
                        .custom-modal-body {
                            padding: 25px;
                        }
                        
                        .pregunta-confirm {
                            text-align: center;
                            font-size: 16px;
                            color: #495057;
                            margin-bottom: 15px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            gap: 10px;
                        }
                        
                        .pregunta-confirm i {
                            font-size: 24px;
                            color: #dc3545;
                        }
                        
                        .texto-adicional {
                            text-align: center;
                            font-size: 14px;
                            color: #6c757d;
                            font-weight: 500;
                        }
                        
                        .custom-modal-footer {
                            padding: 20px 25px;
                            background: #f8f9fa;
                            border-radius: 0 0 12px 12px;
                            display: flex;
                            gap: 10px;
                            justify-content: flex-end;
                        }
                        
                        .btn-cancel, .btn-confirm {
                            padding: 10px 20px;
                            border-radius: 6px;
                            border: none;
                            font-weight: 500;
                            cursor: pointer;
                            transition: all 0.3s;
                            display: flex;
                            align-items: center;
                            gap: 8px;
                        }
                        
                        .btn-cancel {
                            background: #6c757d;
                            color: white;
                        }
                        
                        .btn-cancel:hover {
                            background: #5a6268;
                        }
                        
                        .btn-confirm {
                            background: #dc3545;
                            color: white;
                        }
                        
                        .btn-confirm:hover {
                            background: #c82333;
                        }
                    </style>
                `);
            }

            const modalHtml = `
                <div id="modalConfirmEliminarSocio" class="custom-modal-overlay">
                    <div class="custom-modal">
                        <div class="custom-modal-header">
                            <h5>Confirmar Eliminación</h5>
                            <button type="button" class="btn-close-custom" onclick="cerrarConfirmEliminarSocio()">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                        <div class="custom-modal-body">
                            <div class="pregunta-confirm">
                                <i class="fas fa-exclamation-triangle"></i>
                                ¿Está seguro de eliminar el socio ${numeroAsociado} - ${nombreCompleto}?
                            </div>
                            <div class="texto-adicional">
                                Esta acción no se puede deshacer.
                            </div>
                        </div>
                        <div class="custom-modal-footer">
                            <button type="button" class="btn btn-cancel" onclick="cerrarConfirmEliminarSocio()">
                                <i class="fas fa-times"></i> Cancelar
                            </button>
                            <button type="button" class="btn btn-confirm" onclick="confirmarEliminarSocio(${numeroAsociado}, '${nombreCompleto}')">
                                <i class="fas fa-trash"></i> Eliminar
                            </button>
                        </div>
                    </div>
                </div>
            `;

            // Agregar el modal al body
            $('body').append(modalHtml);
        }

        function cerrarConfirmEliminarSocio() {
            $('#modalConfirmEliminarSocio').remove();
        }

        function confirmarEliminarSocio(numeroAsociado, nombreCompleto) {
            // Cerrar el modal
            cerrarConfirmEliminarSocio();
            
            // Proceder con la eliminación
            $('#loadingSocios').show();
            
            const requestData = {
                numeroAsociado: numeroAsociado
            };
            
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/EliminarAsociado",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify(requestData),
                dataType: "json",
                success: function(response) {
                    $('#loadingSocios').hide();
                    
                    // Verificar si la respuesta es válida
                    if (!response || !response.d) {
                        mostrarToast('Error: Respuesta inválida del servidor', 'error');
                        return;
                    }
                    
                    // Parsear response.d si es un string JSON
                    let serverResponse;
                    if (typeof response.d === 'string') {
                        try {
                            serverResponse = JSON.parse(response.d);
                        } catch (e) {
                            mostrarToast('Error: Formato de respuesta inválido', 'error');
                            return;
                        }
                    } else {
                        serverResponse = response.d;
                    }
                    
                    if (serverResponse.Success === true) {
                        mostrarToast(`Socio ${numeroAsociado} - ${nombreCompleto} eliminado exitosamente`, 'success');
                        cargarSocios(); // Recargar la lista
                    } else {
                        const errorMsg = serverResponse.Message || 'Error desconocido';
                        mostrarToast(errorMsg, 'error');
                    }
                },
                error: function(xhr, status, error) {
                    $('#loadingSocios').hide();
                    
                    // Mostrar error más detallado
                    let errorMessage = 'Error al eliminar el socio: ' + error;
                    if (xhr.responseText) {
                        errorMessage += ' | Respuesta: ' + xhr.responseText.substring(0, 200);
                    }
                    mostrarToast(errorMessage, 'error');
                }
            });
        }

        function abrirModalNuevoSocio() {
            limpiarFormulario();
            esModoEdicion = false;
            numeroAsociadoActual = null;
            $('#modalSocioLabel').html('<i class="fas fa-user-plus me-2"></i>Nuevo Socio');
            
            // Ocultar tab Sistemas para nuevo socio
            $('#sistemas-tab-item').hide();
            
            // Limpiar beneficiarios para nuevo socio
            cargarBeneficiarios(null);
            
            // Activar tab Generales
            $('#generales-tab').tab('show');
            
            // Verificar si estamos en ambiente de desarrollo y llenar datos de prueba
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerParametroSistema",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ paramKey: 'Environment' }),
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }
                    if (response.d.Success && response.d.Data === 'dev') {
                        setTimeout(function() {
                            llenarDatosPrueba();
                        }, 500); // Pequeño delay para asegurar que el modal está completamente cargado
                    }
                },
                error: function() {
                    // Si no se puede verificar el environment, no llenar datos
                }
            });
            
            $('#modalSocio').modal('show');
            
            // Verificar el estado del campo ocupación
            setTimeout(function() {
                const ocupacionField = $('#ocupacion');
            }, 500);
            
            // Aplicar mayúsculas automáticas cuando se abra el modal
            setTimeout(function() {
                if (mayusculasAutomaticasHabilitadas === true) {
                    aplicarMayusculasAutomaticas();
                }
            }, 100);
            
            // Reinicializar Select2 después de abrir el modal
            setTimeout(function() {
                reinicializarSelect2();
            }, 500);
            
            // Forzar reinicialización adicional después de que el modal esté completamente visible
            setTimeout(function() {
                forzarSelect2();
            }, 1000);
        }

        function llenarFormulario(socio) {
            $('#numeroAsociadoText').text(socio.NumeroAsociado);
            $('#tipoAsociado').val(socio.IdTipoAsociado);
            $('#estatus').val(socio.Estatus);
            $('#sexo').val(socio.Sexo);
            $('#nombre').val(socio.Nombre);
            $('#segundoNombre').val(socio.SegundoNombre);
            $('#apellido').val(socio.Apellido);
            $('#segundoApellido').val(socio.SegundoApellido);
            $('#tipoIdentificacion').val(socio.TipoIdentificacion);
            $('#numeroIdentificacion').val(socio.NumeroIdentificacion);
            $('#fechaNacimiento').val(formatearFechaParaInput(socio.FechaNacimiento));
            $('#correoElectronico').val(socio.CorreoElectronico);
            $('#telefonoResidencia').val(socio.TelefonoResidencia);
            $('#telefonoCelular').val(socio.TelefonoCelular);
            $('#telefonoFamiliar').val(socio.TelefonoFamiliar);
            // Llenar ocupación después de asegurar que el dropdown esté cargado
            setTimeout(function() {
                $('#ocupacion').val(socio.Ocupacion);
            }, 100);
            $('#nivelEstudio').val(socio.NivelEstudio);
            $('#profesion').val(socio.Profesion);
            
            // Tab Trabajo
            $('#lugarTrabajo').val(socio.LugarTrabajo);
            $('#telefonoTrabajo').val(socio.TelefonoTrabajo || '');
            
            // Establecer valores de dirección de trabajo con delay para asegurar que los datos estén cargados
            setTimeout(function() {
                $('#paisTrabajo').val(socio.PaisTrabajo).trigger('change');
                setTimeout(function() {
                    $('#provinciaTrabajo').val(socio.ProvinciaTrabajo).trigger('change');
                    setTimeout(function() {
                        $('#distritoTrabajo').val(socio.DistritoTrabajo).trigger('change');
                        setTimeout(function() {
                            $('#corregimientoTrabajo').val(socio.CorregimientoTrabajo).trigger('change');
                        }, 200);
                    }, 200);
                }, 200);
            }, 300);
            
            $('#direccionTrabajo').val(socio.DireccionTrabajo);
            
            // Tab Residencia
            setTimeout(function() {
                $('#paisResidencia').val(socio.PaisResidencia).trigger('change');
                setTimeout(function() {
                    $('#provinciaResidencia').val(socio.ProvinciaResidencia).trigger('change');
                    setTimeout(function() {
                        $('#distritoResidencia').val(socio.DistritoResidencia).trigger('change');
                        setTimeout(function() {
                            $('#corregimientoResidencia').val(socio.CorregimientoResidencia).trigger('change');
                        }, 200);
                    }, 200);
                }, 200);
            }, 300);
            
            $('#direccionResidencia').val(socio.DireccionResidencia);
            
            // Tab Sistemas - Llenar divs elegantes
            $('#fechaCreacionDisplay').text(formatearFechaHora(socio.FechaCreacion) || 'N/A');
            $('#usuarioCreaDisplay').text(socio.UsuarioCrea || 'N/A');
            $('#fechaModificacionDisplay').text(formatearFechaHora(socio.FechaModificacion) || 'N/A');
            $('#usuarioModificaDisplay').text(socio.UsuarioModifica || 'N/A');
        }

        function limpiarFormulario() {
            // Limpiar todos los campos del modal
            $('#numeroAsociadoText').text('Generado automáticamente');
            $('#tipoAsociado').val('');
            $('#estatus').val('A');
            $('#sexo').val('');
            $('#nombre').val('');
            $('#segundoNombre').val('');
            $('#apellido').val('');
            $('#segundoApellido').val('');
            $('#tipoIdentificacion').val('');
            $('#numeroIdentificacion').val('');
            $('#fechaNacimiento').val('');
            $('#correoElectronico').val('');
            $('#telefonoResidencia').val('');
            $('#telefonoCelular').val('');
            $('#telefonoFamiliar').val('');
            $('#ocupacion').val('');
            $('#nivelEstudio').val('');
            $('#profesion').val('');
            
            // Tab Trabajo
            $('#lugarTrabajo').val('');
            $('#telefonoTrabajo').val('');
            $('#paisTrabajo').val('PA'); // Solo Panamá seleccionado
            $('#provinciaTrabajo').val(''); // Sin selección
            $('#distritoTrabajo').val(''); // Sin selección
            $('#corregimientoTrabajo').val(''); // Sin selección
            $('#direccionTrabajo').val('');
            
            // Tab Residencia
            $('#paisResidencia').val('PA'); // Solo Panamá seleccionado
            $('#provinciaResidencia').val(''); // Sin selección
            $('#distritoResidencia').val(''); // Sin selección
            $('#corregimientoResidencia').val(''); // Sin selección
            $('#direccionResidencia').val('');
            
            // Tab Sistemas - Limpiar divs elegantes
            $('#fechaCreacionDisplay').text('-');
            $('#usuarioCreaDisplay').text('-');
            $('#fechaModificacionDisplay').text('-');
            $('#usuarioModificaDisplay').text('-');
        }

        function formatearFechaParaInput(fecha) {
            if (!fecha) return '';
            
            let date;
            
            // Manejar formato de timestamp de JavaScript (/Date(1757620890457)/)
            if (typeof fecha === 'string' && fecha.includes('/Date(')) {
                const timestamp = parseInt(fecha.match(/\d+/)[0]);
                date = new Date(timestamp);
            } else {
                date = new Date(fecha);
            }
            
            // Verificar si la fecha es válida
            if (isNaN(date.getTime())) {
                return '';
            }
            
            // Formatear como dd/mm/yyyy para input type="text"
            const day = String(date.getDate()).padStart(2, '0');
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const year = date.getFullYear();
            return `${day}/${month}/${year}`;
        }

        function guardarSocio() {
            if (!validarFormulario()) {
                return;
            }

            const socioData = {
                NumeroAsociado: numeroAsociadoActual,
                IdTipoAsociado: $('#tipoAsociado').val(),
                Estatus: $('#estatus').val(),
                Sexo: $('#sexo').val(),
                Nombre: $('#nombre').val(),
                SegundoNombre: $('#segundoNombre').val(),
                Apellido: $('#apellido').val(),
                SegundoApellido: $('#segundoApellido').val(),
                TipoIdentificacion: $('#tipoIdentificacion').val(),
                NumeroIdentificacion: $('#numeroIdentificacion').val(),
                FechaNacimiento: convertirFechaParaBD($('#fechaNacimiento').val()),
                CorreoElectronico: $('#correoElectronico').val(),
                TelefonoResidencia: $('#telefonoResidencia').val(),
                TelefonoCelular: $('#telefonoCelular').val(),
                TelefonoFamiliar: $('#telefonoFamiliar').val(),
                Ocupacion: $('#ocupacion').val(),
                NivelEstudio: $('#nivelEstudio').val(),
                Profesion: $('#profesion').val(),
                LugarTrabajo: $('#lugarTrabajo').val(),
                TelefonoTrabajo: $('#telefonoTrabajo').val(),
                PaisTrabajo: $('#paisTrabajo').val(),
                ProvinciaTrabajo: $('#provinciaTrabajo').val(),
                DistritoTrabajo: $('#distritoTrabajo').val(),
                CorregimientoTrabajo: $('#corregimientoTrabajo').val(),
                PaisResidencia: $('#paisResidencia').val(),
                ProvinciaResidencia: $('#provinciaResidencia').val(),
                DistritoResidencia: $('#distritoResidencia').val(),
                CorregimientoResidencia: $('#corregimientoResidencia').val(),
                DireccionTrabajo: $('#direccionTrabajo').val(),
                DireccionResidencia: $('#direccionResidencia').val()
            };

            const url = esModoEdicion ? "GestionSocios.aspx/ActualizarSocio" : "GestionSocios.aspx/CrearSocio";
            const mensajeExito = esModoEdicion ? "Socio actualizado correctamente" : "Socio creado correctamente";

            $.ajax({
                type: "POST",
                url: url,
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ socioDataJson: JSON.stringify(socioData) }),
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }
                    if (response.d.Success) {
                        mostrarToast(mensajeExito, 'success');
                        
                        if (!esModoEdicion && response.d.Data && response.d.Data.NumeroAsociado) {
                            // Actualizar el número de asociado en el div
                            $('#numeroAsociadoText').text(response.d.Data.NumeroAsociado);
                            numeroAsociadoActual = response.d.Data.NumeroAsociado;
                            esModoEdicion = true;
                            
                            // Crear título con información del socio recién creado
                            const socioData = response.d.Data;
                            const nombreCompleto = `${socioData.Nombre} ${socioData.Apellido}`.trim();
                            const chipDocumento = crearChipTipoDocumento(socioData.TipoIdentificacion, '');
                            const numeroDoc = socioData.NumeroIdentificacion || 'N/A';
                            const titulo = `
                                <i class="fas fa-user-edit me-2"></i>Editar Socio - ${nombreCompleto}
                                <span class="ms-2">${chipDocumento} <span class="text-white">${numeroDoc}</span></span>
                            `;
                            $('#modalSocioLabel').html(titulo);
                            
                            // Mostrar tab Sistemas para edición
                            $('#sistemas-tab-item').show();
                            
                            // Cerrar modal y actualizar lista después de crear socio
                            $('#modalSocio').modal('hide');
                            cargarSocios(true); // Ir a página 1 para ver el socio recién creado
                        } else {
                            // Cerrar modal si es edición
                            $('#modalSocio').modal('hide');
                            cargarSocios();
                        }
                    } else {
                        mostrarToast(response.d.Message, 'error');
                    }
                },
                error: function() {
                    mostrarToast('Error al guardar socio', 'error');
                }
            });
        }

        function validarFormulario() {
            const camposObligatorios = [
                { id: 'nombre', nombre: 'Primer Nombre' },
                { id: 'apellido', nombre: 'Primer Apellido' },
                { id: 'tipoAsociado', nombre: 'Tipo de Asociado' },
                { id: 'tipoIdentificacion', nombre: 'Tipo de identificación' },
                { id: 'numeroIdentificacion', nombre: 'número de identificación' }
            ];

            for (let campo of camposObligatorios) {
                if (!$('#' + campo.id).val()) {
                    mostrarToast(`El campo ${campo.nombre} es obligatorio`, 'error');
                    $('#' + campo.id).focus();
                    return false;
                }
            }

            // Validar email si se proporciona
            const email = $('#correoElectronico').val();
            if (email && !validarEmail(email)) {
                mostrarToast('El formato del correo electrúnico no es válido', 'error');
                $('#correoElectronico').focus();
                return false;
            }

            return true;
        }

        function validarEmail(email) {
            const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return regex.test(email);
        }

        // Función para mostrar confirm personalizado
        function mostrarConfirm(opciones) {
            return new Promise((resolve) => {
                // Crear overlay
                const overlay = document.createElement('div');
                overlay.className = 'toast-confirm-overlay';
                
                // Crear modal
                const modal = document.createElement('div');
                modal.className = 'toast-confirm';
                
                // Determinar icono y color
                let iconClass = 'fas fa-question';
                let iconBgClass = 'info';
                
                switch(opciones.tipo) {
                    case 'success':
                        iconClass = 'fas fa-check';
                        iconBgClass = 'success';
                        break;
                    case 'warning':
                        iconClass = 'fas fa-exclamation-triangle';
                        iconBgClass = 'warning';
                        break;
                    case 'danger':
                        iconClass = 'fas fa-times';
                        iconBgClass = 'danger';
                        break;
                    case 'info':
                    default:
                        iconClass = 'fas fa-info';
                        iconBgClass = 'info';
                        break;
                }
                
                // Crear HTML del modal
                modal.innerHTML = `
                    <div class="toast-confirm-header">
                        <div class="toast-confirm-icon ${iconBgClass}">
                            <i class="${iconClass}"></i>
                        </div>
                        <h6 class="toast-confirm-title">${opciones.titulo || 'Confirmar'}</h6>
                    </div>
                    <div class="toast-confirm-body">
                        <p class="toast-confirm-message">${opciones.mensaje}</p>
                    </div>
                    <div class="toast-confirm-footer">
                        <button type="button" class="toast-confirm-btn toast-confirm-btn-secondary" onclick="cerrarConfirm(false)">
                            ${opciones.textoCancelar || 'Cancelar'}
                        </button>
                        <button type="button" class="toast-confirm-btn ${opciones.tipoBoton === 'danger' ? 'toast-confirm-btn-danger' : 'toast-confirm-btn-primary'}" onclick="cerrarConfirm(true)">
                            ${opciones.textoConfirmar || 'Confirmar'}
                        </button>
                    </div>
                `;
                
                // Agregar al DOM
                document.body.appendChild(overlay);
                document.body.appendChild(modal);
                
                // Función para cerrar
                window.cerrarConfirm = function(resultado) {
                    document.body.removeChild(overlay);
                    document.body.removeChild(modal);
                    delete window.cerrarConfirm;
                    resolve(resultado);
                };
                
                // Cerrar con ESC
                const handleEsc = (e) => {
                    if (e.key === 'Escape') {
                        document.removeEventListener('keydown', handleEsc);
                        window.cerrarConfirm(false);
                    }
                };
                document.addEventListener('keydown', handleEsc);
                
                // Cerrar clickeando overlay
                overlay.addEventListener('click', () => {
                    window.cerrarConfirm(false);
                });
            });
        }

        function mostrarToast(mensaje, tipo) {
            const toast = $('#toast');
            const toastMessage = $('#toastMessage');
            const toastHeader = toast.find('.toast-header i');
            
            toastMessage.text(mensaje);
            
            // Cambiar icono según el tipo
            toastHeader.removeClass().addClass('fas me-2');
            if (tipo === 'success') {
                toastHeader.addClass('fa-check-circle text-success');
            } else if (tipo === 'error') {
                toastHeader.addClass('fa-exclamation-circle text-danger');
            } else {
                toastHeader.addClass('fa-info-circle text-primary');
            }
            
            // Configurar opciones según el tipo
            const options = {
                autohide: true, // Todos los toasts se ocultan automáticamente
                delay: tipo === 'error' ? 6000 : (tipo === 'success' ? 4000 : 3000) // Errores 6s, Éxito 4s, info 3s
            };
            
            const bsToast = new bootstrap.Toast(toast[0], options);
            bsToast.show();
            
            // Pausar el toast cuando el mouse está encima
            toast.on('mouseenter', function() {
                bsToast._config.autohide = false;
            });
            
            // Reanudar el toast cuando el mouse salga
            toast.on('mouseleave', function() {
                bsToast._config.autohide = true;
                // Reiniciar el timer
                clearTimeout(bsToast._timeout);
                bsToast._timeout = setTimeout(() => {
                    bsToast.hide();
                }, options.delay);
            });
        }

        // Event listeners para filtros
        $('#filtroNombre, #filtroIdentificacion').on('keypress', function(e) {
            if (e.which === 13) { // Enter
                aplicarFiltros();
            }
        });

        // Variable global para almacenar si las mayúsculas automáticas están habilitadas
        let mayusculasAutomaticasHabilitadas = null;

        // Función para verificar si las mayúsculas automáticas están habilitadas
        function verificarMayusculasAutomaticas() {
            if (mayusculasAutomaticasHabilitadas !== null) {
                return; // Ya se verificó
            }
            
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerParametroSistema",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ paramKey: "MAYUS_AUTOM_CREACION_SOCIOS" }),
                dataType: "json",
                success: function(response) {
                    
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }
                    
                    
                    mayusculasAutomaticasHabilitadas = (response.d.Success && response.d.Data === "1");
                    
                    
                    // Aplicar mayúsculas automáticas si está habilitado
                    if (mayusculasAutomaticasHabilitadas) {
                        aplicarMayusculasAutomaticas();
                    }
                },
                error: function(xhr, status, error) {
                    
                    mayusculasAutomaticasHabilitadas = false;
                }
            });
        }

        // Función para aplicar mayúsculas automáticas en tiempo real
        function aplicarMayusculasAutomaticas() {
            
            
            if (!mayusculasAutomaticasHabilitadas) {
                
                return;
            }
            
            
            
            // Aplicar mayúsculas automáticas a los campos de texto
            const camposTexto = [
                '#nombre', '#segundoNombre', '#apellido', '#segundoApellido',
                '#provinciaTrabajo', '#distritoTrabajo',
                '#corregimientoTrabajo', '#direccionTrabajo', '#provinciaResidencia',
                '#distritoResidencia', '#corregimientoResidencia', '#direccionResidencia',
                '#nivelEstudio', '#profesion',
                // Campos de beneficiarios
                '#beneficiarioNombre', '#beneficiarioApellido',
                '#editarBeneficiarioNombre', '#editarBeneficiarioApellido'
            ];
            
            camposTexto.forEach(function(selector) {
                // Remover eventos anteriores para evitar duplicados
                $(selector).off('input.mayusculas');
                
                // Agregar el nuevo evento
                $(selector).on('input.mayusculas', function() {
                    
                    const cursorPos = this.selectionStart;
                    const originalValue = $(this).val();
                    const upperValue = originalValue.toUpperCase();
                    
                    if (originalValue !== upperValue) {
                        
                        $(this).val(upperValue);
                        // Mantener la posición del cursor
                        this.setSelectionRange(cursorPos, cursorPos);
                    }
                });
            });
        }

        // Flatpickr maneja automáticamente el formateo y Validación de fechas

        function validarFormatoFecha(fecha) {
            const regex = /^(\d{2})\/(\d{2})\/(\d{4})$/;
            if (!regex.test(fecha)) return false;
            
            const [, day, month, year] = fecha.match(regex);
            const date = new Date(year, month - 1, day);
            
            return date.getDate() == day && 
                   date.getMonth() == month - 1 && 
                   date.getFullYear() == year;
        }

        function convertirFechaParaBD(fecha) {
            if (!fecha) return '';
            const regex = /^(\d{2})\/(\d{2})\/(\d{4})$/;
            if (!regex.test(fecha)) return '';
            
            const [, day, month, year] = fecha.match(regex);
            return `${year}-${month}-${day}`;
        }

        function verificarEnvironment() {
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerParametroSistema",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ paramKey: 'Environment' }),
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }
                    if (response.d.Success && response.d.Data === 'dev') {
                        
                    }
                },
                error: function() {
                    
                }
            });
        }

        function llenarDatosPrueba() {
            // Verificar que estamos en environment dev antes de proceder
            $.ajax({
                url: 'GestionSocios.aspx/ObtenerParametroSistema',
                type: 'POST',
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify({ paramKey: 'Environment' }),
                dataType: 'json',
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }
                    
                    if (response.d && response.d.Success && response.d.Data === 'dev') {
                        // Solo proceder si estamos en environment dev
                        
                        cargarDatosAleatorios();
                    } else {
                        
                    }
                },
                error: function() {
                    
                }
            });
        }

        function cargarDatosAleatorios() {
            // Cargar datos aleatorios desde el WebMethod
            
            $.ajax({
                url: 'GestionSocios.aspx/ObtenerDatosPrueba',
                type: 'POST',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }
                    
                    if (response.d && response.d.Success) {
                        
                        const data = JSON.parse(response.d.Data);
                        
                        
                        if (data && data.asociados && data.asociados.length > 0) {
                            
                        // Obtener registros ya usados del localStorage
                        const registrosUsados = JSON.parse(localStorage.getItem('asociadosUsados') || '[]');
                        
                        // Filtrar solo los registros no usados
                        const registrosDisponibles = data.asociados.filter((asociado, index) => 
                            !registrosUsados.includes(index)
                        );
                        
                        if (registrosDisponibles.length === 0) {
                            mostrarToast('Todos los datos de prueba han sido utilizados. Reiniciando...', 'warning');
                            localStorage.removeItem('asociadosUsados');
                            // Recargar la función para empezar de nuevo
                            setTimeout(() => cargarDatosAleatorios(), 1000);
                            return;
                        }
                        
                        // Seleccionar un asociado aleatorio de los disponibles
                        const indiceAleatorio = Math.floor(Math.random() * registrosDisponibles.length);
                        const datosPrueba = registrosDisponibles[indiceAleatorio];
                        
                        // Encontrar el índice original en el array completo
                        const indiceOriginal = data.asociados.findIndex(asociado => 
                            asociado.numeroIdentificacion === datosPrueba.numeroIdentificacion
                        );
                        
                        // Marcar como usado en localStorage
                        registrosUsados.push(indiceOriginal);
                        localStorage.setItem('asociadosUsados', JSON.stringify(registrosUsados));
                        
                        // Llenar campos del formulario con datos aleatorios
                        $('#tipoAsociado').val(datosPrueba.tipoAsociado);
                        $('#nombre').val(datosPrueba.nombre);
                        $('#segundoNombre').val(datosPrueba.segundoNombre || '');
                        $('#apellido').val(datosPrueba.apellido);
                        $('#segundoApellido').val(datosPrueba.segundoApellido || '');
                        $('#tipoIdentificacion').val(datosPrueba.tipoIdentificacion);
                        $('#numeroIdentificacion').val(datosPrueba.numeroIdentificacion);
                        $('#fechaNacimiento').val(datosPrueba.fechaNacimiento);
                        $('#correoElectronico').val(datosPrueba.correoElectronico);
                        $('#telefonoResidencia').val(datosPrueba.telefonoResidencia);
                        $('#telefonoCelular').val(datosPrueba.telefonoCelular);
                        $('#telefonoFamiliar').val(datosPrueba.telefonoFamiliar || '');
                        // Convertir ocupación a Code si es necesario
                        let codigoOcupacion = 1; // Por defecto Ingeniero de Sistemas (Code: 1)
                        if (typeof datosPrueba.ocupacion === 'string') {
                            // Mapear nombres de ocupaciones a Codes
                            const ocupacionMapping = {
                                'Ingeniero de Sistemas': 1,
                                'Contador Público': 2,
                                'Médico General': 3,
                                'Abogado': 4,
                                'Profesor': 5
                            };
                            codigoOcupacion = ocupacionMapping[datosPrueba.ocupacion] || 1;
                        } else {
                            codigoOcupacion = datosPrueba.ocupacion || 1;
                        }
                        $('#ocupacion').val(codigoOcupacion);
                        $('#nivelEstudio').val(datosPrueba.nivelEstudio);
                        $('#profesion').val(datosPrueba.profesion);
                        // Convertir nombre de empresa a código si es necesario
                        let codigoEmpresa = 1; // Por defecto Cooperativa Coopsemga
                        if (typeof datosPrueba.lugarTrabajo === 'string') {
                            // Mapear nombres de empresas a códigos
                            const empresaMapping = {
                                'Innovación Tecnológica S.A.': 2,
                                'Consultores Asociados': 3,
                                'Corporación XYZ': 4,
                                'Empresa ABC S.A.': 5,
                                'Cooperativa Coopsemga': 1,
                                'Banco Nacional de Panamá': 2,
                                'Caja de Ahorros': 3,
                                'Banco General': 4,
                                'Banistmo': 5
                            };
                            codigoEmpresa = empresaMapping[datosPrueba.lugarTrabajo] || 1;
                        } else {
                            codigoEmpresa = datosPrueba.lugarTrabajo || 1;
                        }
                        $('#lugarTrabajo').val(codigoEmpresa);
                        $('#telefonoTrabajo').val(datosPrueba.telefonoTrabajo || '');
                        $('#paisTrabajo').val('PA'); // Panamá por defecto
                        $('#provinciaTrabajo').val('8'); // Panamá por defecto
                        $('#distritoTrabajo').val('47'); // Panamá por defecto
                        $('#corregimientoTrabajo').val('0'); // Temporal por defecto
                        $('#direccionTrabajo').val(datosPrueba.direccionTrabajo);
                        $('#paisResidencia').val('PA'); // Panamá por defecto
                        $('#provinciaResidencia').val('8'); // Panamá por defecto
                        $('#distritoResidencia').val('47'); // Panamá por defecto
                        $('#corregimientoResidencia').val('0'); // Temporal por defecto
                        $('#direccionResidencia').val(datosPrueba.direccionResidencia);
                        
                        mostrarToast(`Datos de prueba cargados: ${datosPrueba.nombre} ${datosPrueba.apellido} (${registrosDisponibles.length - 1} restantes)`, 'success');
                        
                            
                        } else {
                            mostrarToast('Error: No se encontraron asociados en los datos de prueba', 'error');
                        }
                    } else {
                        mostrarToast('Error: ' + (response.d ? response.d.Message : 'No se pudieron cargar los datos de prueba'), 'error');
                    }
                },
                error: function(xhr, status, error) {
                    
                    mostrarToast('Error al cargar los datos de prueba: ' + error, 'error');
                }
            });
        }

        function cargarNivelesEstudio() {
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerNivelesEstudio",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d.Success) {
                        const niveles = response.d.Data;
                        const selectNivel = $('#nivelEstudio');
                        
                        selectNivel.empty().append('<option value="">Seleccionar nivel...</option>');
                        
                        niveles.forEach(function(nivel) {
                            selectNivel.append(`<option value="${nivel.Code}">${nivel.Descripcion}</option>`);
                        });
                    } else {
                        mostrarToast(response.d.Message || 'Error al cargar niveles de estudio', 'error');
                    }
                },
                error: function() {
                    mostrarToast('Error al cargar niveles de estudio', 'error');
                }
            });
        }

        function cargarProfesiones() {
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerProfesiones",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d.Success) {
                        const profesiones = response.d.Data;
                        const selectProfesion = $('#profesion');
                        
                        selectProfesion.empty().append('<option value="">Seleccionar profesión...</option>');
                        
                        profesiones.forEach(function(profesion) {
                            selectProfesion.append(`<option value="${profesion.Code}">${profesion.Descripcion}</option>`);
                        });
                    } else {
                        mostrarToast(response.d.Message || 'Error al cargar profesiones', 'error');
                    }
                },
                error: function() {
                    mostrarToast('Error al cargar profesiones', 'error');
                }
            });
        }

        function cargarEmpresas() {
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerEmpresas",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d.Success) {
                        const empresas = response.d.Data;
                        const selectEmpresa = $('#lugarTrabajo');
                        
                        selectEmpresa.empty().append('<option value="">Seleccionar empresa...</option>');
                        
                        empresas.forEach(function(empresa) {
                            selectEmpresa.append(`<option value="${empresa.Code}">${empresa.Descripcion}</option>`);
                        });
                    } else {
                        mostrarToast(response.d.Message || 'Error al cargar empresas', 'error');
                    }
                },
                error: function() {
                    mostrarToast('Error al cargar empresas', 'error');
                }
            });
        }

        function cargarOcupaciones() {
            // Verificar que el elemento existe y es un select
            const selectElement = $('#ocupacion');
            
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerOcupaciones",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d.Success) {
                        const ocupaciones = response.d.Data;
                        const selectOcupacion = $('#ocupacion');
                        
                        selectOcupacion.empty().append('<option value="">Seleccionar ocupación...</option>');
                        
                        ocupaciones.forEach(function(ocupacion) {
                            selectOcupacion.append(`<option value="${ocupacion.Code}">${ocupacion.Descripcion}</option>`);
                        });
                    } else {
                        mostrarToast(response.d.Message || 'Error al cargar ocupaciones', 'error');
                    }
                },
                error: function() {
                    mostrarToast('Error al cargar ocupaciones', 'error');
                }
            });
        }

        function cargarPaises() {
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerPaises",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d.Success) {
                        paisesData = response.d.Data;
                        
                        const selectPais = $('#paisTrabajo');
                        
                        selectPais.empty().append('<option value="">Seleccionar país...</option>');
                        
                        paisesData.forEach(function(pais) {
                            const selected = pais.Code === 'PA' ? ' selected' : '';
                            selectPais.append(`<option value="${pais.Code}"${selected}>${pais.Descripcion}</option>`);
                        });
                        
                        // Actualizar Select2 después de cargar datos
                        selectPais.trigger('change');
                        
                        cargarProvinciasPorPais('PA');
                    } else {
                        mostrarToast(response.d.Message || 'Error al cargar países', 'error');
                    }
                },
                error: function(xhr, status, error) {
                    mostrarToast('Error al cargar países', 'error');
                }
            });
        }

        function cargarProvincias() {
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerProvincias",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d.Success) {
                        provinciasData = response.d.Data;
                        
                        cargarProvinciasPorPais('PA');
                    } else {
                        mostrarToast(response.d.Message || 'Error al cargar provincias', 'error');
                    }
                },
                error: function(xhr, status, error) {
                    mostrarToast('Error al cargar provincias', 'error');
                }
            });
        }

        function cargarProvinciasPorPais(codigoPais) {
            // Limpiar inmediatamente los dropdowns dependientes
            $('#distritoTrabajo').empty().append('<option value="">Seleccionar distrito...</option>');
            $('#corregimientoTrabajo').empty().append('<option value="">Seleccionar corregimiento...</option>');
            
            if (!provinciasData || provinciasData.length === 0) {
                return;
            }
            
            const provinciasFiltradas = provinciasData.filter(function(provincia) {
                return provincia.CodePais === codigoPais;
            });
            
            const selectProvincia = $('#provinciaTrabajo');
            
            selectProvincia.empty().append('<option value="">Seleccionar provincia...</option>');
            
            provinciasFiltradas.forEach(function(provincia) {
                const selected = (codigoPais === 'PA' && provincia.Code === 8) ? ' selected' : '';
                selectProvincia.append(`<option value="${provincia.Code}"${selected}>${provincia.Descripcion}</option>`);
            });
            
            // Actualizar Select2 después de cargar datos
            selectProvincia.trigger('change');
            
            // Si es Panamá, cargar distritos de la provincia por defecto
            if (codigoPais === 'PA') {
                cargarDistritosPorProvincia(8);
            }
        }

        function cargarDistritos() {
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerDistritos",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d.Success) {
                        distritosData = response.d.Data;
                        
                        cargarDistritosPorProvincia(8);
                    } else {
                        mostrarToast(response.d.Message || 'Error al cargar distritos', 'error');
                    }
                },
                error: function(xhr, status, error) {
                    mostrarToast('Error al cargar distritos', 'error');
                }
            });
        }

        function cargarDistritosPorProvincia(codigoProvincia) {
            // Limpiar inmediatamente el dropdown dependiente
            $('#corregimientoTrabajo').empty().append('<option value="">Seleccionar corregimiento...</option>');
            
            if (!distritosData || distritosData.length === 0) {
                return;
            }
            
            const distritosFiltrados = distritosData.filter(function(distrito) {
                return distrito.CodeProvincia === codigoProvincia;
            });
            
            const selectDistrito = $('#distritoTrabajo');
            
            selectDistrito.empty().append('<option value="">Seleccionar distrito...</option>');
            
            distritosFiltrados.forEach(function(distrito) {
                const selected = (codigoProvincia === 8 && distrito.Code === 47) ? ' selected' : '';
                selectDistrito.append(`<option value="${distrito.Code}"${selected}>${distrito.Descripcion}</option>`);
            });
            
            // Actualizar Select2 después de cargar datos
            selectDistrito.trigger('change');
            
            // Si es Panamá (8), cargar corregimientos del distrito por defecto
            if (codigoProvincia === 8) {
                cargarCorregimientosPorDistrito(47);
            }
        }

        function cargarCorregimientos() {
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerCorregimientos",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d.Success) {
                        corregimientosData = response.d.Data;
                        
                        cargarCorregimientosPorDistrito(47);
                    } else {
                        mostrarToast(response.d.Message || 'Error al cargar corregimientos', 'error');
                    }
                },
                error: function(xhr, status, error) {
                    mostrarToast('Error al cargar corregimientos', 'error');
                }
            });
        }

        function cargarCorregimientosPorDistrito(codigoDistrito) {
            if (!corregimientosData || corregimientosData.length === 0) {
                return;
            }
            
            const corregimientosFiltrados = corregimientosData.filter(function(corregimiento) {
                return corregimiento.CodeDistrito === codigoDistrito;
            });
            
            const selectCorregimiento = $('#corregimientoTrabajo');
            
            selectCorregimiento.empty().append('<option value="">Seleccionar corregimiento...</option>');
            
            corregimientosFiltrados.forEach(function(corregimiento) {
                const selected = (codigoDistrito === 47 && corregimiento.Code === 0) ? ' selected' : '';
                selectCorregimiento.append(`<option value="${corregimiento.Code}"${selected}>${corregimiento.Descripcion}</option>`);
            });
            
            // Actualizar Select2 después de cargar datos
            selectCorregimiento.trigger('change');
        }

        function configurarDropdownsRelacionados() {
            // Event listener para cambio de país
            $('#paisTrabajo').on('change', function() {
                const codigoPais = $(this).val();
                
                // Limpiar inmediatamente todos los dropdowns dependientes
                $('#provinciaTrabajo').empty().append('<option value="">Seleccionar provincia...</option>');
                $('#distritoTrabajo').empty().append('<option value="">Seleccionar distrito...</option>');
                $('#corregimientoTrabajo').empty().append('<option value="">Seleccionar corregimiento...</option>');
                
                if (codigoPais) {
                    cargarProvinciasPorPais(codigoPais);
                }
            });
            
            // Event listener para cambio de provincia
            $('#provinciaTrabajo').on('change', function() {
                const codigoProvincia = parseInt($(this).val());
                
                // Limpiar inmediatamente los dropdowns dependientes
                $('#distritoTrabajo').empty().append('<option value="">Seleccionar distrito...</option>');
                $('#corregimientoTrabajo').empty().append('<option value="">Seleccionar corregimiento...</option>');
                
                if (codigoProvincia) {
                    cargarDistritosPorProvincia(codigoProvincia);
                }
            });
            
            // Event listener para cambio de distrito
            $('#distritoTrabajo').on('change', function() {
                const codigoDistrito = parseInt($(this).val());
                
                // Limpiar inmediatamente el dropdown dependiente
                $('#corregimientoTrabajo').empty().append('<option value="">Seleccionar corregimiento...</option>');
                
                if (codigoDistrito) {
                    cargarCorregimientosPorDistrito(codigoDistrito);
                }
            });
        }

        function configurarDropdownsResidencia() {
            // Event listener para cambio de país de residencia
            $('#paisResidencia').on('change', function() {
                const codigoPais = $(this).val();
                
                // Limpiar inmediatamente todos los dropdowns dependientes
                $('#provinciaResidencia').empty().append('<option value="">Seleccionar provincia...</option>');
                $('#distritoResidencia').empty().append('<option value="">Seleccionar distrito...</option>');
                $('#corregimientoResidencia').empty().append('<option value="">Seleccionar corregimiento...</option>');
                
                if (codigoPais) {
                    cargarProvinciasResidenciaPorPais(codigoPais);
                }
            });
            
            // Event listener para cambio de provincia de residencia
            $('#provinciaResidencia').on('change', function() {
                const codigoProvincia = parseInt($(this).val());
                
                // Limpiar inmediatamente los dropdowns dependientes
                $('#distritoResidencia').empty().append('<option value="">Seleccionar distrito...</option>');
                $('#corregimientoResidencia').empty().append('<option value="">Seleccionar corregimiento...</option>');
                
                if (codigoProvincia) {
                    cargarDistritosResidenciaPorProvincia(codigoProvincia);
                }
            });
            
            // Event listener para cambio de distrito de residencia
            $('#distritoResidencia').on('change', function() {
                const codigoDistrito = parseInt($(this).val());
                
                // Limpiar inmediatamente el dropdown dependiente
                $('#corregimientoResidencia').empty().append('<option value="">Seleccionar corregimiento...</option>');
                
                if (codigoDistrito) {
                    cargarCorregimientosResidenciaPorDistrito(codigoDistrito);
                }
            });
        }

        // ===== CONFIGURACIÓN DE SELECT2 PARA COMBOBOXES =====

        // Función auxiliar para destruir Select2 de manera segura
        function destruirSelect2Seguro(selector) {
            try {
                const elemento = $(selector);
                if (elemento.length > 0) {
                    // Verificar si Select2 está inicializado
                    if (elemento.hasClass('select2-hidden-accessible') && typeof elemento.select2 === 'function') {
                        elemento.select2('destroy');
                    }
                }
            } catch (e) {
                // Error silencioso
            }
        }

        function configurarSelect2() {
            // Verificar que jQuery y Select2 estén disponibles
            if (typeof $ === 'undefined' || typeof $.fn.select2 === 'undefined') {
                return;
            }
            
            // Destruir Select2 existente de manera segura
            const elementos = ['#paisTrabajo', '#provinciaTrabajo', '#distritoTrabajo', '#corregimientoTrabajo', '#profesion', '#ocupacion', '#lugarTrabajo', '#paisResidencia', '#provinciaResidencia', '#distritoResidencia', '#corregimientoResidencia'];
            
            elementos.forEach(destruirSelect2Seguro);
            
            // Configurar Select2 para comboboxes de trabajo
            const elementosTrabajo = $('#paisTrabajo, #provinciaTrabajo, #distritoTrabajo, #corregimientoTrabajo, #profesion, #ocupacion, #lugarTrabajo');
            if (elementosTrabajo.length > 0) {
                elementosTrabajo.select2({
                theme: 'bootstrap-5',
                placeholder: 'Seleccionar...',
                allowClear: true,
                width: '100%',
                dropdownAutoWidth: true,
                dropdownParent: $('body'),
                scrollAfterSelect: true,
                language: {
                    noResults: function() {
                        return "No se encontraron resultados";
                    },
                    searching: function() {
                        return "Buscando...";
                    }
                }
            });
            }
            
            // Configurar Select2 para comboboxes de residencia
            const elementosResidencia = $('#paisResidencia, #provinciaResidencia, #distritoResidencia, #corregimientoResidencia');
            if (elementosResidencia.length > 0) {
                elementosResidencia.select2({
                theme: 'bootstrap-5',
                placeholder: 'Seleccionar...',
                allowClear: true,
                width: '100%',
                dropdownAutoWidth: true,
                dropdownParent: $('body'),
                scrollAfterSelect: true,
                language: {
                    noResults: function() {
                        return "No se encontraron resultados";
                    },
                    searching: function() {
                        return "Buscando...";
                    }
                }
            });
            }
        }

        function reinicializarSelect2() {
            // Verificar que jQuery y Select2 estén disponibles
            if (typeof $ === 'undefined' || typeof $.fn.select2 === 'undefined') {
                return;
            }
            
            // Verificar que los elementos existan antes de configurar
            const elementosTrabajo = ['#paisTrabajo', '#provinciaTrabajo', '#distritoTrabajo', '#corregimientoTrabajo', '#profesion', '#ocupacion', '#lugarTrabajo'];
            const elementosResidencia = ['#paisResidencia', '#provinciaResidencia', '#distritoResidencia', '#corregimientoResidencia'];
            
            // Destruir Select2 existente de manera segura
            elementosTrabajo.forEach(destruirSelect2Seguro);
            elementosResidencia.forEach(destruirSelect2Seguro);
            
            // Configurar Select2 para comboboxes de trabajo
            elementosTrabajo.forEach(function(selector) {
                if ($(selector).length > 0) {
                    try {
                        $(selector).select2({
                            theme: 'bootstrap-5',
                            placeholder: 'Seleccionar...',
                            allowClear: true,
                            width: '100%',
                            minimumResultsForSearch: 0,
                            dropdownParent: $('#modalSocio'),
                            language: {
                                noResults: function() {
                                    return "No se encontraron resultados";
                                },
                                searching: function() {
                                    return "Buscando...";
                                }
                            }
                        });
                    } catch (e) {
                        // Error silencioso
                    }
                }
            });
            
            // Configurar Select2 para comboboxes de residencia
            elementosResidencia.forEach(function(selector) {
                if ($(selector).length > 0) {
                    try {
                        $(selector).select2({
                            theme: 'bootstrap-5',
                            placeholder: 'Seleccionar...',
                            allowClear: true,
                            width: '100%',
                            minimumResultsForSearch: 0,
                            dropdownParent: $('#modalSocio'),
                            language: {
                                noResults: function() {
                                    return "No se encontraron resultados";
                                },
                                searching: function() {
                                    return "Buscando...";
                                }
                            }
                        });
                    } catch (e) {
                        // Error silencioso
                    }
                }
            });
        }

        function forzarSelect2() {
            // Verificar que jQuery y Select2 estén disponibles
            if (typeof $ === 'undefined' || typeof $.fn.select2 === 'undefined') {
                return;
            }
            
            const elementos = [
                '#paisTrabajo', '#provinciaTrabajo', '#distritoTrabajo', '#corregimientoTrabajo', '#profesion', '#ocupacion', '#lugarTrabajo',
                '#paisResidencia', '#provinciaResidencia', '#distritoResidencia', '#corregimientoResidencia'
            ];
            
            // Destruir Select2 existente de manera segura
            elementos.forEach(destruirSelect2Seguro);
            
            elementos.forEach(function(selector) {
                const elemento = $(selector);
                if (elemento.length > 0) {
                    // Limpiar cualquier residuo de Select2
                    elemento.removeClass('select2-hidden-accessible');
                    elemento.next('.select2-container').remove();
                    
                    // Forzar inicialización
                    try {
                        elemento.select2({
                            theme: 'bootstrap-5',
                            placeholder: 'Seleccionar...',
                            allowClear: true,
                            width: '100%',
                            minimumResultsForSearch: 0,
                            dropdownParent: $('#modalSocio'),
                            language: {
                                noResults: function() {
                                    return "No se encontraron resultados";
                                },
                                searching: function() {
                                    return "Buscando...";
                                }
                            }
                        });
                    } catch (e) {
                        // Error silencioso
                    }
                }
            });
        }

        function configurarEventosSelect2() {
            const elementos = [
                '#paisTrabajo', '#provinciaTrabajo', '#distritoTrabajo', '#corregimientoTrabajo', '#profesion', '#ocupacion', '#lugarTrabajo',
                '#paisResidencia', '#provinciaResidencia', '#distritoResidencia', '#corregimientoResidencia'
            ];
            
            elementos.forEach(function(selector) {
                const elemento = $(selector);
                if (elemento.length > 0) {
                    // Evento cuando se abre el dropdown
                    elemento.on('select2:open', function() {
                        setTimeout(function() {
                            // Forzar foco en el campo de búsqueda
                            $('.select2-search__field').focus();
                        }, 100);
                    });
                }
            });
        }

        function asegurarCampoBusqueda() {
            // Verificar que el campo de búsqueda esté presente y funcional
            setTimeout(function() {
                const campoBusqueda = $('.select2-search__field');
                if (campoBusqueda.length > 0) {
                    // Asegurar que el campo sea clickeable y funcional
                    campoBusqueda.prop('readonly', false);
                    campoBusqueda.prop('disabled', false);
                    campoBusqueda.css({
                        'pointer-events': 'auto',
                        'cursor': 'text',
                        'background': 'white',
                        'color': '#212529'
                    });
                }
            }, 500);
        }

        // ===== FUNCIONES PARA DROPDOWNS DE RESIDENCIA =====

        function cargarPaisesResidencia() {
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerPaises",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d.Success) {
                        paisesResidenciaData = response.d.Data;
                        
                        const selectPais = $('#paisResidencia');
                        
                        selectPais.empty().append('<option value="">Seleccionar país...</option>');
                        
                        paisesResidenciaData.forEach(function(pais) {
                            const selected = pais.Code === 'PA' ? ' selected' : '';
                            selectPais.append(`<option value="${pais.Code}"${selected}>${pais.Descripcion}</option>`);
                        });
                        
                        // Actualizar Select2 después de cargar datos
                        selectPais.trigger('change');
                        
                        cargarProvinciasResidenciaPorPais('PA');
                    } else {
                        mostrarToast(response.d.Message || 'Error al cargar países de residencia', 'error');
                    }
                },
                error: function(xhr, status, error) {
                    mostrarToast('Error al cargar países de residencia', 'error');
                }
            });
        }

        function cargarProvinciasResidencia() {
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerProvincias",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d.Success) {
                        provinciasResidenciaData = response.d.Data;
                        
                        cargarProvinciasResidenciaPorPais('PA');
                    } else {
                        mostrarToast(response.d.Message || 'Error al cargar provincias de residencia', 'error');
                    }
                },
                error: function(xhr, status, error) {
                    mostrarToast('Error al cargar provincias de residencia', 'error');
                }
            });
        }

        function cargarProvinciasResidenciaPorPais(codigoPais) {
            // Limpiar inmediatamente los dropdowns dependientes
            $('#distritoResidencia').empty().append('<option value="">Seleccionar distrito...</option>');
            $('#corregimientoResidencia').empty().append('<option value="">Seleccionar corregimiento...</option>');
            
            if (!provinciasResidenciaData || provinciasResidenciaData.length === 0) {
                return;
            }
            
            const provinciasFiltradas = provinciasResidenciaData.filter(function(provincia) {
                return provincia.CodePais === codigoPais;
            });
            
            const selectProvincia = $('#provinciaResidencia');
            
            selectProvincia.empty().append('<option value="">Seleccionar provincia...</option>');
            
            provinciasFiltradas.forEach(function(provincia) {
                const selected = (codigoPais === 'PA' && provincia.Code === 8) ? ' selected' : '';
                selectProvincia.append(`<option value="${provincia.Code}"${selected}>${provincia.Descripcion}</option>`);
            });
            
            // Actualizar Select2 después de cargar datos
            selectProvincia.trigger('change');
            
            // Si es Panamá, cargar distritos de la provincia por defecto
            if (codigoPais === 'PA') {
                cargarDistritosResidenciaPorProvincia(8);
            }
        }

        function cargarDistritosResidencia() {
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerDistritos",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d.Success) {
                        distritosResidenciaData = response.d.Data;
                        
                        cargarDistritosResidenciaPorProvincia(8);
                    } else {
                        mostrarToast(response.d.Message || 'Error al cargar distritos de residencia', 'error');
                    }
                },
                error: function(xhr, status, error) {
                    mostrarToast('Error al cargar distritos de residencia', 'error');
                }
            });
        }

        function cargarDistritosResidenciaPorProvincia(codigoProvincia) {
            // Limpiar inmediatamente el dropdown dependiente
            $('#corregimientoResidencia').empty().append('<option value="">Seleccionar corregimiento...</option>');
            
            if (!distritosResidenciaData || distritosResidenciaData.length === 0) {
                return;
            }
            
            const distritosFiltrados = distritosResidenciaData.filter(function(distrito) {
                return distrito.CodeProvincia === codigoProvincia;
            });
            
            const selectDistrito = $('#distritoResidencia');
            
            selectDistrito.empty().append('<option value="">Seleccionar distrito...</option>');
            
            distritosFiltrados.forEach(function(distrito) {
                const selected = (codigoProvincia === 8 && distrito.Code === 47) ? ' selected' : '';
                selectDistrito.append(`<option value="${distrito.Code}"${selected}>${distrito.Descripcion}</option>`);
            });
            
            // Actualizar Select2 después de cargar datos
            selectDistrito.trigger('change');
            
            // Si es Panamá (8), cargar corregimientos del distrito por defecto
            if (codigoProvincia === 8) {
                cargarCorregimientosResidenciaPorDistrito(47);
            }
        }

        function cargarCorregimientosResidencia() {
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerCorregimientos",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d.Success) {
                        corregimientosResidenciaData = response.d.Data;
                        
                        cargarCorregimientosResidenciaPorDistrito(47);
                    } else {
                        mostrarToast(response.d.Message || 'Error al cargar corregimientos de residencia', 'error');
                    }
                },
                error: function(xhr, status, error) {
                    mostrarToast('Error al cargar corregimientos de residencia', 'error');
                }
            });
        }

        function cargarCorregimientosResidenciaPorDistrito(codigoDistrito) {
            if (!corregimientosResidenciaData || corregimientosResidenciaData.length === 0) {
                return;
            }
            
            const corregimientosFiltrados = corregimientosResidenciaData.filter(function(corregimiento) {
                return corregimiento.CodeDistrito === codigoDistrito;
            });
            
            const selectCorregimiento = $('#corregimientoResidencia');
            
            selectCorregimiento.empty().append('<option value="">Seleccionar corregimiento...</option>');
            
            corregimientosFiltrados.forEach(function(corregimiento) {
                const selected = (codigoDistrito === 47 && corregimiento.Code === 0) ? ' selected' : '';
                selectCorregimiento.append(`<option value="${corregimiento.Code}"${selected}>${corregimiento.Descripcion}</option>`);
            });
            
            // Actualizar Select2 después de cargar datos
            selectCorregimiento.trigger('change');
        }

        // ===== FUNCIONES PARA BENEFICIARIOS =====

        function cargarParentezcos() {
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerParentezcos",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d.Success) {
                        const parentezcos = response.d.Data;
                        const select = $('#beneficiarioParentesco');
                        
                        select.empty().append('<option value="">Seleccionar parentesco</option>');
                        
                        parentezcos.forEach(function(parentezco) {
                            select.append(`<option value="${parentezco.IDParentezco}">${parentezco.Parentezco}</option>`);
                        });
                    } else {
                        mostrarToast(response.d.Message || 'Error al cargar parentezcos', 'error');
                    }
                },
                error: function() {
                    mostrarToast('Error al cargar parentezcos', 'error');
                }
            });
        }

        function cargarBeneficiarios(numeroAsociado) {
            if (!numeroAsociado) {
                $('#tablaBeneficiarios tbody').empty();
                actualizarPorcentajeRestante(0);
                return;
            }

            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerBeneficiarios",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ numeroAsociado: numeroAsociado }),
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d.Success) {
                        const beneficiarios = response.d.Data;
                        const tbody = $('#tablaBeneficiarios tbody');
                        tbody.empty();

                        let porcentajeTotal = 0;

                        if (beneficiarios && beneficiarios.length > 0) {
                            beneficiarios.forEach(function(beneficiario) {
                                const nombreCompleto = `${beneficiario.Nombre || ''} ${beneficiario.Apellido || ''}`.trim();
                                const identificacion = formatearIdentificacion(beneficiario.TipoIdentificacion, beneficiario.NumeroIdentificacion);
                                const porcentaje = parseFloat(beneficiario.Porcentaje || 0);
                                porcentajeTotal += porcentaje;

                                tbody.append(`
                                    <tr ondblclick="editarBeneficiario(${beneficiario.IDBeneficiario})" style="cursor: pointer;">
                                        <td>${nombreCompleto || 'N/A'}</td>
                                        <td>${identificacion}</td>
                                        <td>${beneficiario.Parentezco || 'N/A'}</td>
                                        <td><span class="badge" style="background-color: #1976d2; color: white;">${porcentaje.toFixed(2)}%</span></td>
                                        <td>
                                            <button type="button" class="btn btn-sm btn-outline-primary me-1" 
                                                    onclick="editarBeneficiario(${beneficiario.IDBeneficiario})" 
                                                    title="Editar beneficiario"
                                                    data-beneficiario='${JSON.stringify(beneficiario)}'>
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarBeneficiario(${beneficiario.IDBeneficiario})" title="Eliminar beneficiario">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                `);
                            });
                        } else {
                            tbody.append(`
                                <tr>
                                    <td colspan="5" class="text-center text-muted py-3">
                                        <i class="fas fa-users fa-2x mb-2"></i><br>
                                        No hay beneficiarios asignados
                                    </td>
                                </tr>
                            `);
                        }

                        actualizarPorcentajeRestante(porcentajeTotal);
                    } else {
                        mostrarToast(response.d.Message, 'error');
                    }
                },
                error: function() {
                    mostrarToast('Error al cargar beneficiarios', 'error');
                }
            });
        }

        function actualizarPorcentajeRestante(porcentajeAsignado) {
            const porcentajeRestante = 100 - porcentajeAsignado;
            const elemento = $('#porcentajeRestante');
            const botonAgregar = $('button[onclick="abrirModalAgregarBeneficiario()"]');
            
            elemento.text(porcentajeRestante.toFixed(2) + '%');
            
            // Cambiar color según el porcentaje con colores más oscuros
            elemento.removeClass('text-success text-warning text-danger text-info');
            if (porcentajeRestante > 50) {
                elemento.addClass('text-success'); // Verde oscuro
            } else if (porcentajeRestante > 0) {
                elemento.addClass('text-warning'); // Naranja/amarillo oscuro
            } else {
                elemento.addClass('text-danger'); // Rojo oscuro
            }
            
            // Habilitar/deshabilitar botón agregar según porcentaje restante
            if (porcentajeRestante <= 0) {
                botonAgregar.prop('disabled', true).addClass('disabled');
                botonAgregar.attr('title', 'No se puede agregar más beneficiarios - Porcentaje completo');
            } else {
                botonAgregar.prop('disabled', false).removeClass('disabled');
                botonAgregar.attr('title', 'Agregar Beneficiario');
            }
        }

        function agregarBeneficiario() {
            // Validar campos obligatorios
            const camposObligatorios = [
                { id: 'beneficiarioNombre', nombre: 'Nombre' },
                { id: 'beneficiarioApellido', nombre: 'Apellido' },
                { id: 'beneficiarioTipoIdentificacion', nombre: 'Tipo de identificación' },
                { id: 'beneficiarioNumeroIdentificacion', nombre: 'número de identificación' },
                { id: 'beneficiarioParentesco', nombre: 'Parentesco' },
                { id: 'beneficiarioPorcentaje', nombre: 'Porcentaje' }
            ];

            for (let campo of camposObligatorios) {
                if (!$('#' + campo.id).val()) {
                    mostrarToast(`El campo ${campo.nombre} es obligatorio`, 'error');
                    $('#' + campo.id).focus();
                    return;
                }
            }

            // Validar porcentaje
            const porcentaje = parseFloat($('#beneficiarioPorcentaje').val());
            if (porcentaje <= 0 || porcentaje > 100) {
                mostrarToast('El porcentaje debe estar entre 0.01 y 100', 'error');
                $('#beneficiarioPorcentaje').focus();
                return;
            }

            // Verificar que no exceda el 100% total
            const porcentajeActual = parseFloat($('#porcentajeRestante').text().replace('%', ''));
            if (porcentaje > porcentajeActual) {
                mostrarToast(`El porcentaje no puede exceder el ${porcentajeActual.toFixed(2)}% disponible`, 'error');
                $('#beneficiarioPorcentaje').focus();
                return;
            }

            if (!numeroAsociadoActual) {
                mostrarToast('Debe guardar el socio primero antes de agregar beneficiarios', 'error');
                return;
            }

            // Confirmar antes de agregar
            const nombre = $('#beneficiarioNombre').val().trim();
            const apellido = $('#beneficiarioApellido').val().trim();
            const parentesco = $('#beneficiarioParentesco option:selected').text();
            
            mostrarConfirm({
                tipo: 'success',
                titulo: 'Agregar Beneficiario',
                mensaje: `¿Está seguro de agregar a ${nombre} ${apellido} como beneficiario?\n\nParentesco: ${parentesco}\nPorcentaje: ${porcentaje}%`,
                textoConfirmar: 'Sí, Agregar',
                textoCancelar: 'Cancelar'
            }).then((confirmado) => {
                if (confirmado) {
                    // Continuar con el proceso de agregar beneficiario
                    procesarAgregarBeneficiario();
                }
            });
            
            return; // Salir de la función aquí, el resto se ejecutará en el callback
        }

        function procesarAgregarBeneficiario() {
            const porcentaje = parseFloat($('#beneficiarioPorcentaje').val());
            
            const beneficiarioData = {
                NumeroAsociado: numeroAsociadoActual,
                Nombre: $('#beneficiarioNombre').val(),
                Apellido: $('#beneficiarioApellido').val(),
                TipoIdentificacion: $('#beneficiarioTipoIdentificacion').val(),
                NumeroIdentificacion: $('#beneficiarioNumeroIdentificacion').val(),
                IDParentezco: parseInt($('#beneficiarioParentesco').val()),
                Porcentaje: porcentaje
            };

            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/CrearBeneficiario",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ beneficiarioDataJson: JSON.stringify(beneficiarioData) }),
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }
                    if (response.d.Success) {
                        mostrarToast('Beneficiario agregado correctamente', 'success');
                        limpiarFormularioBeneficiario();
                        cargarBeneficiarios(numeroAsociadoActual);
                        // Cerrar la modal
                        const modal = bootstrap.Modal.getInstance(document.getElementById('modalAgregarBeneficiario'));
                        if (modal) {
                            modal.hide();
                        }
                    } else {
                        mostrarToast(response.d.Message, 'error');
                    }
                },
                error: function() {
                    mostrarToast('Error al agregar beneficiario', 'error');
                }
            });
        }

        function eliminarBeneficiario(idBeneficiario) {
            mostrarConfirm({
                tipo: 'danger',
                titulo: 'Eliminar Beneficiario',
                mensaje: '¿Está seguro de que desea eliminar este beneficiario? Esta acción no se puede deshacer.',
                textoConfirmar: 'Sí, Eliminar',
                textoCancelar: 'Cancelar',
                tipoBoton: 'danger'
            }).then((confirmado) => {
                if (confirmado) {
                    $.ajax({
                        type: "POST",
                        url: "GestionSocios.aspx/EliminarBeneficiario",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify({ idBeneficiario: idBeneficiario }),
                        dataType: "json",
                        success: function(response) {
                            if (typeof response.d === 'string') {
                                response.d = JSON.parse(response.d);
                            }
                            if (response.d.Success) {
                                mostrarToast('Beneficiario eliminado correctamente', 'success');
                                cargarBeneficiarios(numeroAsociadoActual);
                            } else {
                                mostrarToast(response.d.Message, 'error');
                            }
                        },
                        error: function() {
                            mostrarToast('Error al eliminar beneficiario', 'error');
                        }
                    });
                }
            });
        }

        function limpiarFormularioBeneficiario() {
            $('#beneficiarioNombre').val('');
            $('#beneficiarioApellido').val('');
            $('#beneficiarioTipoIdentificacion').val('');
            $('#beneficiarioNumeroIdentificacion').val('');
            $('#beneficiarioParentesco').val('');
            $('#beneficiarioPorcentaje').val('');
        }

        function abrirModalAgregarBeneficiario() {
            if (!numeroAsociadoActual) {
                mostrarToast('Debe guardar el socio primero antes de agregar beneficiarios', 'error');
                return;
            }
            
            limpiarFormularioBeneficiario();
            const modal = new bootstrap.Modal(document.getElementById('modalAgregarBeneficiario'));
            modal.show();
        }

        function validarPorcentaje(input) {
            let valor = parseFloat(input.value);
            
            // Si el valor es mayor a 100, lo limita a 100
            if (valor > 100) {
                input.value = 100;
                mostrarToast('El porcentaje no puede ser mayor a 100%', 'warning');
            }
            
            // Si el valor es menor a 0, lo limita a 0
            if (valor < 0) {
                input.value = 0;
                mostrarToast('El porcentaje no puede ser menor a 0%', 'warning');
            }
            
            // Si el valor no es un número válido, lo limpia
            if (isNaN(valor) && input.value !== '') {
                input.value = '';
                mostrarToast('Por favor ingrese un valor numérico válido', 'warning');
            }
        }

        function validarPorcentajeEditar(input) {
            let valor = parseFloat(input.value);
            
            // Si el valor es mayor a 100, lo limita a 100
            if (valor > 100) {
                input.value = 100;
                mostrarToast('El porcentaje no puede ser mayor a 100%', 'warning');
            }
            
            // Si el valor es menor a 0, lo limita a 0
            if (valor < 0) {
                input.value = 0;
                mostrarToast('El porcentaje no puede ser menor a 0%', 'warning');
            }
            
            // Si el valor no es un número válido, lo limpia
            if (isNaN(valor) && input.value !== '') {
                input.value = '';
                mostrarToast('Por favor ingrese un valor numérico válido', 'warning');
            }
        }

        function editarBeneficiario(idBeneficiario) {
            // Buscar el beneficiario en la tabla actual usando el atributo data
            let beneficiario = null;
            $('#tablaBeneficiarios tbody tr').each(function() {
                const row = $(this);
                const editButton = row.find('button[onclick*="editarBeneficiario"]');
                if (editButton.length > 0) {
                    const onclickAttr = editButton.attr('onclick');
                    const match = onclickAttr.match(/editarBeneficiario\((\d+)\)/);
                    if (match && match[1] == idBeneficiario) {
                        // Obtener los datos del atributo data-beneficiario
                        const dataBeneficiario = editButton.attr('data-beneficiario');
                        if (dataBeneficiario) {
                            try {
                                beneficiario = JSON.parse(dataBeneficiario);
                            } catch (e) {
                                // Error silencioso
                            }
                        }
                        return false; // Salir del each
                    }
                }
            });
            
            if (beneficiario) {
                
                // Llenar el formulario de edición
                
                
                $('#editarBeneficiarioId').val(beneficiario.IDBeneficiario);
                $('#editarBeneficiarioNombre').val(beneficiario.Nombre);
                $('#editarBeneficiarioApellido').val(beneficiario.Apellido);
                $('#editarBeneficiarioTipoIdentificacion').val(beneficiario.TipoIdentificacion);
                $('#editarBeneficiarioNumeroIdentificacion').val(beneficiario.NumeroIdentificacion);
                $('#editarBeneficiarioPorcentaje').val(beneficiario.Porcentaje);
                
                // Cargar parentezcos y seleccionar el correcto
                cargarParentezcosEditar(beneficiario.IDParentezco || beneficiario.Parentezco);
                
                // Abrir la modal
                const modal = new bootstrap.Modal(document.getElementById('modalEditarBeneficiario'));
                modal.show();
            } else {
                mostrarToast('No se pudo encontrar la información del beneficiario', 'error');
            }
        }

        function cargarParentezcosEditar(parentescoSeleccionado) {
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerParentezcos",
                contentType: "application/json; charset=utf-8",
                data: "{}",
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d.Success) {
                        const parentezcos = response.d.Data;
                        const select = $('#editarBeneficiarioParentesco');
                        
                        select.empty().append('<option value="">Seleccionar parentesco</option>');
                        
                        parentezcos.forEach(function(parentezco) {
                            const option = $('<option></option>')
                                .attr('value', parentezco.IDParentezco)
                                .text(parentezco.Parentezco);
                            
                            // Seleccionar el parentesco actual
                            if (parentezco.IDParentezco === parentescoSeleccionado || parentezco.Parentezco === parentescoSeleccionado) {
                                option.attr('selected', true);
                            }
                            
                            select.append(option);
                        });
                    } else {
                        mostrarToast('Error al cargar parentezcos', 'error');
                    }
                },
                error: function() {
                    mostrarToast('Error al cargar parentezcos', 'error');
                }
            });
        }

        function guardarEdicionBeneficiario() {
            // Validar campos obligatorios
            const camposObligatorios = [
                { id: 'editarBeneficiarioNombre', nombre: 'Nombre' },
                { id: 'editarBeneficiarioApellido', nombre: 'Apellido' },
                { id: 'editarBeneficiarioTipoIdentificacion', nombre: 'Tipo de identificación' },
                { id: 'editarBeneficiarioNumeroIdentificacion', nombre: 'número de identificación' },
                { id: 'editarBeneficiarioParentesco', nombre: 'Parentesco' },
                { id: 'editarBeneficiarioPorcentaje', nombre: 'Porcentaje' }
            ];

            for (let campo of camposObligatorios) {
                if (!$('#' + campo.id).val()) {
                    mostrarToast(`El campo ${campo.nombre} es obligatorio`, 'error');
                    $('#' + campo.id).focus();
                    return;
                }
            }

            // Validar porcentaje
            const porcentaje = parseFloat($('#editarBeneficiarioPorcentaje').val());
            if (porcentaje <= 0 || porcentaje > 100) {
                mostrarToast('El porcentaje debe estar entre 0.01 y 100', 'error');
                $('#editarBeneficiarioPorcentaje').focus();
                return;
            }

            // Confirmar antes de actualizar
            const nombre = $('#editarBeneficiarioNombre').val().trim();
            const apellido = $('#editarBeneficiarioApellido').val().trim();
            const parentesco = $('#editarBeneficiarioParentesco option:selected').text();
            
            mostrarConfirm({
                tipo: 'info',
                titulo: 'Confirmar Cambios',
                mensaje: `¿Está seguro de actualizar a ${nombre} ${apellido}?\n\nParentesco: ${parentesco}\nPorcentaje: ${porcentaje}%`,
                textoConfirmar: 'Sí, Guardar',
                textoCancelar: 'Cancelar'
            }).then((confirmado) => {
                if (confirmado) {
                    procesarActualizarBeneficiario();
                }
            });
        }

        function procesarActualizarBeneficiario() {
            const beneficiarioData = {
                IDBeneficiario: parseInt($('#editarBeneficiarioId').val()),
                Nombre: $('#editarBeneficiarioNombre').val(),
                Apellido: $('#editarBeneficiarioApellido').val(),
                TipoIdentificacion: $('#editarBeneficiarioTipoIdentificacion').val(),
                NumeroIdentificacion: $('#editarBeneficiarioNumeroIdentificacion').val(),
                IDParentezco: parseInt($('#editarBeneficiarioParentesco').val()),
                Porcentaje: parseFloat($('#editarBeneficiarioPorcentaje').val())
            };

            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ActualizarBeneficiario",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ beneficiarioDataJson: JSON.stringify(beneficiarioData) }),
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }
                    if (response.d.Success) {
                        mostrarToast('Beneficiario actualizado correctamente', 'success');
                        cargarBeneficiarios(numeroAsociadoActual);
                        // Cerrar la modal
                        const modal = bootstrap.Modal.getInstance(document.getElementById('modalEditarBeneficiario'));
                        if (modal) {
                            modal.hide();
                        }
                    } else {
                        mostrarToast(response.d.Message, 'error');
                    }
                },
                error: function() {
                    mostrarToast('Error al actualizar beneficiario', 'error');
                }
            });
        }

        function verTransaccionesSocio(numeroAsociado) {
            const socio = obtenerSocioDeCache(numeroAsociado);
            const titulo = socio ? `${socio.Nombre || ''} ${socio.Apellido || ''}`.trim() : '';
            $('#tituloTransaccionesSocio').html(titulo ? `<span class="badge bg-secondary">#${numeroAsociado}</span> ${titulo}` : `<span class="badge bg-secondary">#${numeroAsociado}</span>`);
            $('#estadoTransaccionesSocio').addClass('d-none');
            $('#contenedorTablaTransaccionesSocio').hide();
            $('#spinnerTransaccionesSocio').removeClass('d-none');

            const modal = new bootstrap.Modal(document.getElementById('modalTransaccionesSocio'));
            modal.show();

            $.ajax({
                type: 'POST',
                url: 'GestionSocios.aspx/ObtenerTransaccionesSocio',
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify({ numeroAsociado: numeroAsociado }),
                dataType: 'json',
                success: function(response) {
                    $('#spinnerTransaccionesSocio').addClass('d-none');
                    let data = response.d;
                    if (typeof data === 'string') data = JSON.parse(data);
                    if (!data.Success) {
                        mostrarToast(data.Message || 'Error al cargar transacciones', 'error');
                        $('#estadoTransaccionesSocio').removeClass('d-none').find('p').text(data.Message || 'Error al cargar.');
                        return;
                    }
                    const lista = data.Data || [];
                    const tbody = $('#tbodyTransaccionesSocio');
                    tbody.empty();
                    if (lista.length === 0) {
                        $('#estadoTransaccionesSocio').removeClass('d-none');
                    } else {
                        $('#contenedorTablaTransaccionesSocio').show();
                        lista.forEach(function(t) {
                            const fechaHora = t.FechaHora ? (typeof t.FechaHora === 'string' && t.FechaHora.indexOf('/Date(') >= 0
                                ? new Date(parseInt(t.FechaHora.match(/\d+/)[0])).toLocaleString('es-PA')
                                : t.FechaHora) : 'N/A';
                            const btnImprimir = `<button type="button" class="btn btn-sm btn-outline-primary" onclick="imprimirComprobanteLotePorId(${t.IDTransaccion})" title="Imprimir comprobante"><i class="fas fa-print"></i></button>`;
                            tbody.append(`<tr><td>${t.IDTransaccion || ''}</td><td>${fechaHora}</td><td>${t.Cajero || 'N/A'}</td><td>${t.CantTran || 0}</td><td>${btnImprimir}</td></tr>`);
                        });
                    }
                },
                error: function() {
                    $('#spinnerTransaccionesSocio').addClass('d-none');
                    $('#estadoTransaccionesSocio').removeClass('d-none').find('p').text('Error al cargar transacciones.');
                    mostrarToast('Error al cargar transacciones', 'error');
                }
            });
        }

        function imprimirComprobanteLotePorId(idTrans) {
            $.ajax({
                type: 'POST',
                url: '../Transacciones/Transacciones.aspx/GenerarComprobanteLote',
                data: JSON.stringify({ idTrans: idTrans }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        mostrarModalComprobante(response.d.Html, '', '');
                    } else {
                        mostrarToast((response.d && response.d.Mensaje) || 'Error al generar comprobante', 'error');
                    }
                },
                error: function(xhr, status, err) {
                    mostrarToast('Error al generar comprobante: ' + (err || xhr.statusText), 'error');
                }
            });
        }

        function mostrarModalComprobante(htmlContent, capitalMovimientoId, interesesMovimientoId) {
            const modalHtml = `
                <div id="modalComprobante" class="comprobante-modal-overlay">
                    <div class="comprobante-modal">
                        <div class="comprobante-modal-header">
                            <h5><i class="fas fa-receipt text-primary"></i> Comprobante de Transacción</h5>
                            <button type="button" class="btn-close-custom" onclick="cerrarModalComprobante()"><i class="fas fa-times"></i></button>
                        </div>
                        <div class="comprobante-modal-body">
                            <div class="comprobante-container">${htmlContent}</div>
                        </div>
                        <div class="comprobante-modal-footer">
                            <button type="button" class="btn btn-secondary" onclick="cerrarModalComprobante()"><i class="fas fa-times"></i> Cerrar</button>
                            <button type="button" class="btn btn-primary" onclick="imprimirDesdeModal('${capitalMovimientoId || ''}', '${interesesMovimientoId || ''}')"><i class="fas fa-print"></i> Imprimir</button>
                        </div>
                    </div>
                </div>`;
            $('body').append(modalHtml);
            if (!$('#comprobanteModalStylesSocios').length) {
                $('head').append(`
                    <style id="comprobanteModalStylesSocios">
                        .comprobante-modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.7); display: flex; justify-content: center; align-items: center; z-index: 10000; }
                        .comprobante-modal { background: white; border-radius: 12px; box-shadow: 0 15px 35px rgba(0,0,0,0.4); width: 95%; max-width: 900px; max-height: 95vh; overflow: hidden; display: flex; flex-direction: column; }
                        .comprobante-modal-header { background: linear-gradient(135deg, #2c3e50, #34495e); color: white; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; }
                        .comprobante-modal-body { flex: 1; overflow: auto; padding: 20px; background: #f8f9fa; }
                        .comprobante-container { background: white; border-radius: 8px; padding: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
                        .comprobante-modal-footer { padding: 15px 20px; border-top: 1px solid #dee2e6; display: flex; justify-content: flex-end; gap: 10px; }
                        .btn-close-custom { background: none; border: none; color: white; font-size: 1.2rem; cursor: pointer; padding: 0 5px; }
                    </style>`);
            }
        }

        function cerrarModalComprobante() {
            $('#modalComprobante').remove();
        }

        function imprimirDesdeModal(capitalMovimientoId, interesesMovimientoId) {
            const ventanaImpresion = window.open('', '_blank', 'width=800,height=600');
            const contenidoComprobante = $('#modalComprobante .comprobante-container').html();
            ventanaImpresion.document.write(`
                <!DOCTYPE html><html><head><title>Comprobante de Transacción</title>
                <style>body { margin: 0; padding: 20px; font-family: Arial, sans-serif; }
                .comprobante { height: auto !important; } .no-print { display: none !important; }</style></head>
                <body>${contenidoComprobante}</body></html>`);
            ventanaImpresion.document.close();
            ventanaImpresion.onload = function() {
                setTimeout(function() { ventanaImpresion.print(); ventanaImpresion.close(); }, 500);
            };
            cerrarModalComprobante();
        }

        function verMovimientosSocio(numeroAsociado) {
            socioMovimientosEnConsulta = numeroAsociado;
            movimientosSocioEstado.start = 0;
            movimientosSocioEstado.total = 0;
            movimientosSocioEstado.cargando = false;
            movimientosSocioEstado.orderColumn = 'Fecha';
            movimientosSocioEstado.orderDir = 'DESC';

            actualizarTituloMovimientos(numeroAsociado);

            if (tablaMovimientosSocio) {
                tablaMovimientosSocio.clear().draw();
                movimientosSocioEstado.silenciarOrden = true;
                tablaMovimientosSocio.order([1, 'desc']).draw(false);
                setTimeout(function() {
                    movimientosSocioEstado.silenciarOrden = false;
                }, 0);
            }

            $('#estadoMovimientosSocio').addClass('d-none');
            $('#contenedorTablaMovimientosSocio').hide();
            $('#spinnerMovimientosSocio').removeClass('d-none');
            $('#verMasMovimientosContainer').hide();
            $('#btnVerMasMovimientos').prop('disabled', false).text('Ver más movimientos');

            const modal = new bootstrap.Modal(document.getElementById('modalMovimientosSocio'));
            modal.show();

            cargarMovimientosSocio(numeroAsociado, true);
        }

        function actualizarTituloMovimientos(numeroAsociado) {
            const socio = obtenerSocioDeCache(numeroAsociado);
            if (socio) {
                $('#tituloMovimientosSocio').html(crearTituloMovimientosDesdeSocio(socio));
            } else {
                $('#tituloMovimientosSocio').html(`<span class="badge bg-secondary">#${numeroAsociado}</span>`);
                cargarSocioParaTitulo(numeroAsociado);
            }
        }

        function cargarSocioParaTitulo(numeroAsociado) {
            $.ajax({
                type: 'POST',
                url: 'GestionSocios.aspx/ObtenerSocioPorNumero',
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify({ numeroAsociado: numeroAsociado }),
                dataType: 'json',
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }
                    if (response.d && response.d.Success && response.d.Data) {
                        const socio = response.d.Data;
                        agregarSocioACache(socio);
                        if (numeroAsociado === socioMovimientosEnConsulta) {
                            $('#tituloMovimientosSocio').html(crearTituloMovimientosDesdeSocio(socio));
                        }
                    }
                }
            });
        }

        function cargarMovimientosSocio(numeroAsociado, esReinicio) {
            esReinicio = esReinicio === true;
            if (!numeroAsociado) {
                return;
            }

            if (movimientosSocioEstado.cargando) {
                return;
            }

            const esPrimerBloque = esReinicio || movimientosSocioEstado.start === 0;

            if (esReinicio) {
                movimientosSocioEstado.start = 0;
                movimientosSocioEstado.total = 0;
                if (tablaMovimientosSocio) {
                    tablaMovimientosSocio.clear().draw();
                }
            }

            movimientosSocioEstado.cargando = true;

            if (esPrimerBloque) {
                $('#estadoMovimientosSocio').addClass('d-none');
                $('#contenedorTablaMovimientosSocio').hide();
                $('#spinnerMovimientosSocio').removeClass('d-none');
            } else {
                $('#btnVerMasMovimientos').prop('disabled', true).text('Cargando...');
            }

            $.ajax({
                type: 'POST',
                url: 'GestionSocios.aspx/ObtenerMovimientosSocio',
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify({
                    numeroAsociado: numeroAsociado,
                    start: movimientosSocioEstado.start,
                    length: movimientosSocioEstado.length,
                    orderColumn: movimientosSocioEstado.orderColumn,
                    orderDir: movimientosSocioEstado.orderDir
                }),
                dataType: 'text',
                success: function(rawResponse) {
                    let payload = rawResponse;
                    if (typeof rawResponse === 'string') {
                        const limpio = rawResponse.trim();
                        if (limpio.startsWith('<') || limpio.startsWith('if')) {
                            movimientosSocioEstado.cargando = false;
                            if (esPrimerBloque) {
                                $('#spinnerMovimientosSocio').addClass('d-none');
                                $('#contenedorTablaMovimientosSocio').hide();
                                $('#estadoMovimientosSocio').removeClass('d-none');
                                $('#estadoMovimientosSocio').find('p').text('Se recibió contenido inesperado del servidor.');
                            } else {
                                $('#btnVerMasMovimientos').prop('disabled', false).text('Ver más movimientos');
                            }
                            mostrarToast('Respuesta inesperada al solicitar movimientos.', 'error');
                            return;
                        }
                        try {
                            payload = JSON.parse(limpio);
                        } catch (parseEnvelopeError) {
                            movimientosSocioEstado.cargando = false;
                            if (esPrimerBloque) {
                                $('#spinnerMovimientosSocio').addClass('d-none');
                                $('#contenedorTablaMovimientosSocio').hide();
                                $('#estadoMovimientosSocio').removeClass('d-none');
                                $('#estadoMovimientosSocio').find('p').text('No se pudo interpretar la respuesta del servidor.');
                            } else {
                                $('#btnVerMasMovimientos').prop('disabled', false).text('Ver más movimientos');
                            }
                            mostrarToast('No se pudo interpretar la respuesta del servidor.', 'error');
                            return;
                        }
                    }

                    let datos = payload;
                    if (payload && payload.d !== undefined) {
                        datos = payload.d;
                    }

                    if (typeof datos === 'string') {
                        try {
                            datos = JSON.parse(datos);
                        } catch (parseDataError) {
                            movimientosSocioEstado.cargando = false;
                            if (esPrimerBloque) {
                                $('#spinnerMovimientosSocio').addClass('d-none');
                                $('#contenedorTablaMovimientosSocio').hide();
                                $('#estadoMovimientosSocio').removeClass('d-none');
                                $('#estadoMovimientosSocio').find('p').text('No se pudo interpretar los datos de movimientos.');
                            } else {
                                $('#btnVerMasMovimientos').prop('disabled', false).text('Ver más movimientos');
                            }
                            mostrarToast('No se pudo interpretar los datos de movimientos.', 'error');
                            return;
                        }
                    }

                    procesarResultadoMovimientos(datos, esPrimerBloque);
                },
                error: function(xhr, status, error) {
                    movimientosSocioEstado.cargando = false;
 
                    if (esPrimerBloque) {
                        $('#spinnerMovimientosSocio').addClass('d-none');
                        $('#contenedorTablaMovimientosSocio').hide();
                        $('#estadoMovimientosSocio').removeClass('d-none');
                        $('#estadoMovimientosSocio').find('p').text('Ocurrió un error al obtener los movimientos.');
                    } else {
                        $('#btnVerMasMovimientos').prop('disabled', false).text('Ver más movimientos');
                    }

                    mostrarToast('Error al cargar movimientos: ' + error, 'error');
                }
            });
        }

        function procesarResultadoMovimientos(resultado, esPrimerBloque) {
            const contenedorTabla = $('#contenedorTablaMovimientosSocio');
            const estado = $('#estadoMovimientosSocio');
            const spinner = $('#spinnerMovimientosSocio');

            if (esPrimerBloque) {
                spinner.addClass('d-none');
            }

            if (!resultado || resultado.Success === false) {
                estado.removeClass('d-none');
                estado.find('p').text(resultado && resultado.Message ? resultado.Message : 'No se pudieron obtener los movimientos.');
                contenedorTabla.hide();
                $('#verMasMovimientosContainer').hide();
                movimientosSocioEstado.cargando = false;
                $('#btnVerMasMovimientos').prop('disabled', false).text('Ver más movimientos');
                return;
            }

            const movimientos = Array.isArray(resultado.Data) ? resultado.Data : [];

            if (!tablaMovimientosSocio) {
                inicializarTablaMovimientos();
            }

            if (esPrimerBloque && tablaMovimientosSocio) {
                tablaMovimientosSocio.clear();
            }

            if (movimientos.length === 0) {
                if (movimientosSocioEstado.start === 0) {
                    estado.removeClass('d-none');
                    estado.find('p').text('No se encontraron movimientos para este socio.');
                    contenedorTabla.hide();
                }
                $('#verMasMovimientosContainer').hide();
                movimientosSocioEstado.cargando = false;
                $('#btnVerMasMovimientos').prop('disabled', false).text('Ver más movimientos');
                return;
            }

            estado.addClass('d-none');

            movimientos.forEach(function(movimiento) {
                tablaMovimientosSocio.row.add(crearFilaMovimientoSocio(movimiento));
            });

            const totalRegistros = Number(resultado.TotalRegistros || movimientosSocioEstado.total || movimientosSocioEstado.start + movimientos.length);
            movimientosSocioEstado.total = totalRegistros;
            movimientosSocioEstado.start += movimientos.length;

            movimientosSocioEstado.silenciarOrden = true;
            tablaMovimientosSocio.order([
                obtenerIndiceColumnaMovimientos(movimientosSocioEstado.orderColumn),
                movimientosSocioEstado.orderDir.toLowerCase()
            ]).draw(false);
            setTimeout(function() {
                movimientosSocioEstado.silenciarOrden = false;
            }, 0);

            tablaMovimientosSocio.columns.adjust();
            contenedorTabla.show();

            const hayMas = movimientosSocioEstado.start < movimientosSocioEstado.total;
            if (hayMas) {
                $('#verMasMovimientosContainer').show();
                $('#btnVerMasMovimientos').prop('disabled', false).text('Ver más movimientos');
            } else {
                $('#verMasMovimientosContainer').hide();
            }

            movimientosSocioEstado.cargando = false;
            if (!esPrimerBloque) {
                $('#btnVerMasMovimientos').prop('disabled', false).text('Ver más movimientos');
            }
        }

        function crearFilaMovimientoSocio(movimiento) {
            const movimientoId = obtenerMovimientoId(movimiento);
            const fechaOriginal = movimiento?.FechaMovimiento || movimiento?.Fecha || movimiento?.FechaRegistro || movimiento?.FechaCreacion;
            const fecha = formatearFechaHora(fechaOriginal);
            const descripcion = escaparHtmlSocios(obtenerDescripcionMovimiento(movimiento));
            const rubroChip = crearChipRubroMovimiento(movimiento);
            const observaciones = escaparHtmlSocios(movimiento?.Observaciones || '');
            const monto = formatearMontoMovimiento(movimiento?.Monto);
            const botonReimpresion = movimientoId
                ? `<button type="button" class="btn btn-sm btn-outline-primary" onclick="event.preventDefault(); event.stopPropagation(); reimprimirComprobanteMovimiento(${movimientoId})" title="Reimprimir comprobante"><i class="fas fa-print"></i></button>`
                : '<span class="text-muted">N/D</span>';
            const numeroTransaccion = movimiento?.Transaccion || movimientoId || '';

            return {
                transaccion: escaparHtmlSocios(numeroTransaccion || 'N/D'),
                fechaOrden: obtenerValorOrdenFecha(fechaOriginal),
                fechaTexto: fecha,
                rubro: rubroChip,
                descripcion: descripcion,
                monto: monto,
                observaciones: observaciones || '<span class="text-muted">Sin observaciones</span>',
                acciones: botonReimpresion
            };
        }

        function obtenerValorOrdenFecha(fecha) {
            if (!fecha) {
                return 0;
            }

            if (typeof fecha === 'string' && fecha.includes('/Date(')) {
                const timestamp = parseInt(fecha.match(/\d+/)[0]);
                return Number.isNaN(timestamp) ? 0 : timestamp;
            }

            const parsed = new Date(fecha);
            return Number.isNaN(parsed.getTime()) ? 0 : parsed.getTime();
        }

        function obtenerMovimientoId(movimiento) {
            if (!movimiento) {
                return null;
            }
            return movimiento.IDMovimiento || movimiento.MovimientoID || movimiento.IdMovimiento || movimiento.MovimientoId || null;
        }

        function obtenerDescripcionMovimiento(movimiento) {
            if (!movimiento) {
                return 'N/A';
            }
            const partes = [];
            if (movimiento.CodigoTransaccion) partes.push(movimiento.CodigoTransaccion);
            if (movimiento.DescripcionTransaccion) partes.push(movimiento.DescripcionTransaccion);
            if (partes.length === 0 && movimiento.Descripcion) partes.push(movimiento.Descripcion);
            return partes.length > 0 ? partes.join(' - ') : 'N/A';
        }

        function crearChipRubroMovimiento(movimiento) {
            if (!movimiento) {
                return '<span class="badge bg-secondary"><i class="fas fa-tag me-1"></i>N/D</span>';
            }

            const codigoOriginal = (movimiento.CodigoRubro || movimiento.Rubro || '').toString().trim().toUpperCase();
            const clave = codigoOriginal.length > 2 ? codigoOriginal.substring(0, 2) : codigoOriginal;
            const config = configuracionesChipRubros[codigoOriginal] || configuracionesChipRubros[clave] || { color: 'bg-secondary', icono: 'fas fa-tag', nombre: 'N/D' };
            const descripcion = movimiento.DescripcionRubro || movimiento.RubroDescripcion || config.nombre || 'N/D';
            const codigoMostrar = clave || codigoOriginal || 'ND';
            const textoCompleto = `${codigoMostrar}-${descripcion}`;

            return `<span class="badge ${config.color}"><i class="${config.icono} me-1"></i>${escaparHtmlSocios(textoCompleto)}</span>`;
        }

        function formatearMontoMovimiento(valor) {
            if (valor === null || valor === undefined || valor === '') {
                return formateadorMonedaSocios.format(0);
            }
            let numero = valor;
            if (typeof numero === 'string') {
                numero = numero.replace(/\s/g, '').replace(',', '.');
            }
            const monto = Number(numero);
            if (Number.isNaN(monto)) {
                return escaparHtmlSocios(valor);
            }
            return formateadorMonedaSocios.format(monto);
        }

        function escaparHtmlSocios(texto) {
            return $('<div>').text(texto ?? '').html();
        }

        function generarEstadoCuenta(numeroAsociado) {
            if (!numeroAsociado) {
                mostrarToast('No se pudo determinar el asociado.', 'warning');
                return;
            }

            $.ajax({
                type: 'POST',
                url: 'GestionSocios.aspx/GenerarEstadoCuenta',
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify({ numeroAsociado: numeroAsociado.toString() }),
                dataType: 'json',
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        mostrarModalEstadoCuenta(response.d.Html);
                    } else {
                        const mensaje = response.d && response.d.Mensaje ? response.d.Mensaje : 'No fue posible generar el estado de cuenta.';
                        mostrarToast(mensaje, 'error');
                    }
                },
                error: function(xhr, status, error) {
                    mostrarToast('Error al generar el estado de cuenta: ' + error, 'error');
                }
            });
        }

        function mostrarModalEstadoCuenta(htmlContent) {
            // Crear el modal del estado de cuenta
            const modalHtml = `
                <div id="modalEstadoCuenta" class="estado-cuenta-modal-overlay">
                    <div class="estado-cuenta-modal">
                        <div class="estado-cuenta-modal-header">
                            <h5><i class="fas fa-file-invoice text-primary"></i> Estado de Cuenta</h5>
                            <button type="button" class="btn-close-custom" onclick="cerrarModalEstadoCuenta()">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                        <div class="estado-cuenta-modal-body">
                            <div class="estado-cuenta-container">
                                ${htmlContent}
                            </div>
                        </div>
                        <div class="estado-cuenta-modal-footer">
                            <button type="button" class="btn btn-secondary" onclick="cerrarModalEstadoCuenta()">
                                <i class="fas fa-times"></i> Cerrar
                            </button>
                            <button type="button" class="btn btn-primary" onclick="imprimirEstadoCuentaDesdeModal()">
                                <i class="fas fa-print"></i> Imprimir
                            </button>
                        </div>
                    </div>
                </div>
            `;

            // Agregar el modal al body
            $('body').append(modalHtml);
            
            // Agregar estilos si no existen
            if (!$('#estadoCuentaModalStyles').length) {
                $('head').append(`
                    <style id="estadoCuentaModalStyles">
                        .estado-cuenta-modal-overlay {
                            position: fixed;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 100%;
                            background: rgba(0, 0, 0, 0.7);
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            z-index: 10000;
                            backdrop-filter: blur(3px);
                        }
                        
                        .estado-cuenta-modal {
                            background: white;
                            border-radius: 12px;
                            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.4);
                            width: 95%;
                            max-width: 1000px;
                            max-height: 95vh;
                            overflow: hidden;
                            animation: modalSlideIn 0.3s ease-out;
                            display: flex;
                            flex-direction: column;
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
                        
                        .estado-cuenta-modal-header {
                            background: linear-gradient(135deg, #2c3e50, #34495e);
                            color: white;
                            padding: 15px 20px;
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            flex-shrink: 0;
                        }
                        
                        .estado-cuenta-modal-header h5 {
                            margin: 0;
                            font-size: 18px;
                            font-weight: 600;
                        }
                        
                        .btn-close-custom {
                            background: rgba(255, 255, 255, 0.2);
                            border: none;
                            color: white;
                            width: 30px;
                            height: 30px;
                            border-radius: 50%;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            cursor: pointer;
                            transition: background 0.3s;
                        }
                        
                        .btn-close-custom:hover {
                            background: rgba(255, 255, 255, 0.3);
                        }
                        
                        .estado-cuenta-modal-body {
                            flex: 1;
                            overflow: auto;
                            padding: 20px;
                            background: #f8f9fa;
                        }
                        
                        .estado-cuenta-container {
                            background: white;
                            border-radius: 8px;
                            padding: 20px;
                            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        }
                        
                        .estado-cuenta-modal-footer {
                            padding: 15px 20px;
                            background: #f8f9fa;
                            border-top: 1px solid #dee2e6;
                            display: flex;
                            justify-content: flex-end;
                            gap: 10px;
                            flex-shrink: 0;
                        }
                        
                        /* Ocultar botones del estado de cuenta en el modal */
                        .estado-cuenta-container .no-print {
                            display: none !important;
                        }
                        
                        /* Botones del modal */
                        .estado-cuenta-modal-footer .btn {
                            padding: 10px 20px;
                            border: none;
                            border-radius: 6px;
                            font-weight: 500;
                            cursor: pointer;
                            transition: all 0.2s;
                            display: flex;
                            align-items: center;
                            gap: 8px;
                        }
                        
                        .estado-cuenta-modal-footer .btn-secondary {
                            background: #6c757d;
                            color: white;
                        }
                        
                        .estado-cuenta-modal-footer .btn-secondary:hover {
                            background: #5a6268;
                        }
                        
                        .estado-cuenta-modal-footer .btn-primary {
                            background: #007bff;
                            color: white;
                        }
                        
                        .estado-cuenta-modal-footer .btn-primary:hover {
                            background: #0056b3;
                        }
                        
                        /* Estilos para el modal de detalle de intereses */
                        .detalle-intereses-modal-overlay {
                            position: fixed;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 100%;
                            background: rgba(0, 0, 0, 0.7);
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            z-index: 10001;
                            backdrop-filter: blur(3px);
                        }
                        
                        .detalle-intereses-modal {
                            background: white;
                            border-radius: 12px;
                            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.4);
                            width: 95%;
                            max-width: 1200px;
                            max-height: 90vh;
                            overflow: hidden;
                            animation: modalSlideIn 0.3s ease-out;
                            display: flex;
                            flex-direction: column;
                        }
                        
                        .detalle-intereses-modal-header {
                            background: linear-gradient(135deg, #17a2b8, #138496);
                            color: white;
                            padding: 15px 20px;
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            flex-shrink: 0;
                        }
                        
                        .detalle-intereses-modal-header h5 {
                            margin: 0;
                            font-size: 18px;
                            font-weight: 600;
                        }
                        
                        .detalle-intereses-modal-body {
                            flex: 1;
                            overflow: auto;
                            padding: 20px;
                            background: #f8f9fa;
                        }
                        
                        .detalle-intereses-content {
                            background: white;
                            border-radius: 8px;
                            padding: 20px;
                            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        }
                        
                        .detalle-intereses-content table {
                            font-size: 12px;
                        }
                        
                        .detalle-intereses-content table thead {
                            background: #17a2b8;
                            color: white;
                        }
                        
                        .detalle-intereses-content table thead th {
                            padding: 10px 8px;
                            text-align: center;
                            font-weight: 600;
                            font-size: 11px;
                            text-transform: uppercase;
                        }
                        
                        .detalle-intereses-content table tbody td {
                            padding: 8px;
                            text-align: center;
                            vertical-align: middle;
                        }
                    </style>
                `);
            }
        }

        function cerrarModalEstadoCuenta() {
            $('#modalEstadoCuenta').remove();
        }

        function mostrarDetalleIntereses(idAuxiliar) {
            if (!idAuxiliar) {
                mostrarToast('No se pudo determinar el auxiliar.', 'warning');
                return;
            }

            // Mostrar loading
            const loadingHtml = `
                <div id="modalDetalleIntereses" class="detalle-intereses-modal-overlay">
                    <div class="detalle-intereses-modal">
                        <div class="detalle-intereses-modal-header">
                            <h5><i class="fas fa-info-circle text-info"></i> Detalle de Intereses</h5>
                            <button type="button" class="btn-close-custom" onclick="cerrarModalDetalleIntereses()">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                        <div class="detalle-intereses-modal-body">
                            <div class="text-center p-4">
                                <div class="spinner-border text-primary" role="status">
                                    <span class="visually-hidden">Cargando...</span>
                                </div>
                                <p class="mt-2">Cargando historial de intereses...</p>
                            </div>
                        </div>
                    </div>
                </div>
            `;
            $('body').append(loadingHtml);

            $.ajax({
                type: 'POST',
                url: 'GestionSocios.aspx/ObtenerHistorialIntereses',
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify({ idAuxiliar: idAuxiliar.toString() }),
                dataType: 'json',
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        mostrarDetalleInteresesContenido(response.d.Datos);
                    } else {
                        const mensaje = response.d && response.d.Mensaje ? response.d.Mensaje : 'No fue posible obtener el historial de intereses.';
                        mostrarToast(mensaje, 'error');
                        cerrarModalDetalleIntereses();
                    }
                },
                error: function(xhr, status, error) {
                    mostrarToast('Error al obtener el historial de intereses: ' + error, 'error');
                    cerrarModalDetalleIntereses();
                }
            });
        }

        function mostrarDetalleInteresesContenido(datos) {
            let tablaHtml = '';
            
            // Determinar el rubro del auxiliar (todos los registros tienen el mismo rubro)
            const codigoRubro = (datos && datos.length > 0) ? (datos[0].CodigoRubro || '') : '';
            const esPrestamo = codigoRubro.toUpperCase() === 'PR';
            
            if (datos && datos.length > 0) {
                
                // Definir las columnas según el tipo de cuenta
                let columnaInteresPagado = '';
                let columnaSaldoGenerado = '';
                
                if (esPrestamo) {
                    // Para préstamos: mostrar "Interés Pagado a Fecha"
                    columnaInteresPagado = '<th>Interés Pagado a Fecha</th>';
                } else {
                    // Para otros rubros: mostrar "Nuevo Saldo" después de "Interés Calculado"
                    columnaSaldoGenerado = '<th>Nuevo Saldo</th>';
                }
                
                tablaHtml = `
                    <table class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th>Fecha Cálculo</th>
                                <th>Hora</th>
                                <th>Fecha Últ. Cálculo</th>
                                <th>Saldo a Fecha</th>
                                <th>Interés Calc. a Fecha</th>
                                ${columnaInteresPagado}
                                <th>Días Intereses</th>
                                <th>Tasa</th>
                                <th>Interés Calculado</th>
                                ${columnaSaldoGenerado}
                                <th>Usuario</th>
                            </tr>
                        </thead>
                        <tbody>
                `;
                
                // Función auxiliar para formatear montos
                function formatearMontoHistorial(valor) {
                    if (!valor || valor === 'N/A' || valor === '') return formateadorMonedaSocios.format(0);
                    // Si ya es un string con formato, convertir a número
                    const valorStr = valor.toString().trim();
                    // Remover comas y convertir a número
                    const numero = parseFloat(valorStr.replace(/,/g, '')) || 0;
                    return formateadorMonedaSocios.format(numero);
                }
                
                datos.forEach(function(item) {
                    // Construir las celdas según el tipo de cuenta
                    let celdaInteresPagado = '';
                    let celdaSaldoGenerado = '';
                    
                    if (esPrestamo) {
                        celdaInteresPagado = `<td>${formatearMontoHistorial(item.InteresPagadoAFecha)}</td>`;
                    } else {
                        celdaSaldoGenerado = `<td><strong>${formatearMontoHistorial(item.SaldoGenerado)}</strong></td>`;
                    }
                    
                    tablaHtml += `
                        <tr>
                            <td>${item.FechaCalculo || 'N/A'}</td>
                            <td>${item.HoraCalculo || 'N/A'}</td>
                            <td>${item.FechaUltCalculo || 'N/A'}</td>
                            <td>${formatearMontoHistorial(item.SaldoAFecha)}</td>
                            <td>${formatearMontoHistorial(item.InteresCalculadoAFecha)}</td>
                            ${celdaInteresPagado}
                            <td>${item.DiasIntereses || '0'}</td>
                            <td>${item.Tasa || '0.00'}%</td>
                            <td><strong>${formatearMontoHistorial(item.InteresCalculado)}</strong></td>
                            ${celdaSaldoGenerado}
                            <td>${item.NombreUsuario || 'N/A'}</td>
                        </tr>
                    `;
                });
                
                tablaHtml += `
                        </tbody>
                    </table>
                `;
            } else {
                tablaHtml = '<div class="alert alert-info text-center">No se encontraron registros de intereses para este auxiliar.</div>';
            }

            // Guardar los datos globalmente para exportar
            window.historialInteresesActual = datos;
            window.codigoRubroActual = codigoRubro;
            
            const contenidoHtml = `
                <div class="detalle-intereses-content">
                    <div class="mb-3 text-end">
                        <button type="button" id="btnExportarExcelHistorial" class="btn btn-success btn-sm" onclick="exportarHistorialInteresesAExcel()" title="Exportar a Excel">
                            <i class="fas fa-file-excel me-1"></i>Exportar a Excel
                        </button>
                    </div>
                    ${tablaHtml}
                </div>
            `;

            $('#modalDetalleIntereses .detalle-intereses-modal-body').html(contenidoHtml);
        }
        
        function exportarHistorialInteresesAExcel() {
            if (!window.historialInteresesActual || window.historialInteresesActual.length === 0) {
                mostrarToast('No hay datos para exportar', 'warning');
                return;
            }
            
            // Obtener referencia al botón
            const btnExportar = $('#btnExportarExcelHistorial');
            if (btnExportar.length === 0) {
                return;
            }
            
            // Deshabilitar botón y mostrar indicador de carga
            btnExportar.prop('disabled', true);
            const textoOriginal = btnExportar.html();
            btnExportar.html('<span class="spinner-border spinner-border-sm me-1" role="status" aria-hidden="true"></span>Generando...');
            
            // Mostrar loading
            mostrarToast('Generando archivo Excel...', 'info');
            
            // Función para restaurar el botón
            const restaurarBoton = function() {
                btnExportar.prop('disabled', false);
                btnExportar.html(textoOriginal);
            };
            
            // Convertir los datos a un formato que el servidor pueda procesar
            const datosParaEnviar = window.historialInteresesActual.map(function(item) {
                const itemDict = {};
                for (const key in item) {
                    if (item.hasOwnProperty(key)) {
                        itemDict[key] = item[key];
                    }
                }
                return itemDict;
            });
            
            const datosEnviar = {
                datos: datosParaEnviar,
                codigoRubro: window.codigoRubroActual || ''
            };
            
            $.ajax({
                type: 'POST',
                url: 'GestionSocios.aspx/ExportarHistorialInteresesAExcel',
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify(datosEnviar),
                dataType: 'json',
                success: function(response) {
                    try {
                        if (typeof response.d === 'string') {
                            try {
                                response.d = JSON.parse(response.d);
                            } catch (e) {
                                mostrarToast('Error al procesar la respuesta del servidor', 'error');
                                restaurarBoton();
                                return;
                            }
                        }
                        
                        if (response.d && response.d.Resultado === 'SUCCESS') {
                            // Descargar el archivo usando el método del servidor
                            const nombreArchivo = response.d.NombreArchivo;
                            const urlDescarga = 'GestionSocios.aspx?action=download&file=' + encodeURIComponent(nombreArchivo);
                            
                            // Crear un enlace temporal para descargar
                            const link = document.createElement('a');
                            link.href = urlDescarga;
                            link.download = nombreArchivo;
                            link.target = '_blank';
                            document.body.appendChild(link);
                            link.click();
                            
                            // Esperar un momento antes de remover el enlace
                            setTimeout(function() {
                                document.body.removeChild(link);
                            }, 100);
                            
                            mostrarToast('Archivo Excel generado exitosamente', 'success');
                        } else {
                            const mensaje = response.d && response.d.Mensaje ? response.d.Mensaje : 'Error al generar el archivo Excel.';
                            mostrarToast(mensaje, 'error');
                        }
                    } finally {
                        // Restaurar botón siempre, incluso si hay error
                        restaurarBoton();
                    }
                },
                error: function(xhr, status, error) {
                    mostrarToast('Error al exportar historial de intereses: ' + error, 'error');
                    // Restaurar botón en caso de error
                    restaurarBoton();
                }
            });
        }

        function cerrarModalDetalleIntereses() {
            $('#modalDetalleIntereses').remove();
        }

        function imprimirEstadoCuentaDesdeModal() {
            // Crear una ventana temporal para imprimir (mismo proceso que comprobantes)
            const ventanaImpresion = window.open('', '_blank', 'width=800,height=600');
            
            // Obtener el contenido del estado de cuenta del modal
            const contenidoEstadoCuenta = $('#modalEstadoCuenta .estado-cuenta-container').html();
            
            // Leer los estilos completos del template HTML
            const estilosCompletos = `
                @page {
                    size: 8.5in 11in;
                    margin: 0.5in;
                }
                
                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    margin: 0;
                    padding: 20px;
                    font-size: 12px;
                    line-height: 1.4;
                    background-color: white;
                    color: #333;
                }
                
                .estado-cuenta {
                    width: 100%;
                    max-width: 8.5in;
                    margin: 0 auto;
                    background-color: white;
                }
                
                .header {
                    text-align: center;
                    margin-bottom: 30px;
                    padding-bottom: 20px;
                    border-bottom: 2px solid #2c3e50;
                }
                
                .logo {
                    margin-bottom: 15px;
                }
                
                .logo img {
                    max-width: 200px;
                    height: auto;
                }
                
                .cooperativa-nombre {
                    font-size: 18px;
                    font-weight: 700;
                    color: #2c3e50;
                    margin-bottom: 10px;
                    text-transform: uppercase;
                    letter-spacing: 1px;
                }
                
                .titulo-estado {
                    font-size: 24px;
                    font-weight: 700;
                    color: #2c3e50;
                    margin-top: 15px;
                    text-transform: uppercase;
                    letter-spacing: 2px;
                }
                
                .datos-asociado {
                    background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                    border: 1px solid #dee2e6;
                    border-radius: 6px;
                    padding: 15px;
                    margin-bottom: 25px;
                }
                
                .datos-asociado h3 {
                    font-size: 14px;
                    font-weight: 600;
                    color: #2c3e50;
                    margin-bottom: 10px;
                    text-transform: uppercase;
                    border-bottom: 1px solid #ced4da;
                    padding-bottom: 8px;
                }
                
                .datos-asociado .campo {
                    display: flex;
                    margin-bottom: 8px;
                }
                
                .datos-asociado .campo-label {
                    font-weight: 600;
                    color: #495057;
                    min-width: 150px;
                }
                
                .datos-asociado .campo-label::after {
                    content: ":";
                    margin-right: 10px;
                }
                
                .datos-asociado .campo-valor {
                    color: #212529;
                }
                
                .tabla-datos {
                    width: 100%;
                    border-collapse: collapse;
                    margin-bottom: 30px;
                    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                }
                
                .tabla-datos thead {
                    background: #2c3e50;
                    color: white;
                }
                
                .tabla-datos thead th {
                    padding: 12px 8px;
                    text-align: center;
                    font-weight: 600;
                    font-size: 11px;
                    text-transform: uppercase;
                    border: 1px solid #1a252f;
                }
                
                .tabla-datos thead th:nth-child(7) {
                    min-width: 120px;
                    width: 120px;
                }
                
                .tabla-datos tbody td {
                    padding: 10px 8px;
                    text-align: center;
                    border: 1px solid #dee2e6;
                    font-size: 11px;
                }
                
                .tabla-datos tbody tr:nth-child(even) {
                    background-color: #f8f9fa;
                }
                
                .tabla-datos tbody tr:hover {
                    background-color: #e9ecef;
                }
                
                .celda-intereses {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    gap: 8px;
                    text-align: center;
                }
                
                .btn-detalle-intereses {
                    background: #ffc107;
                    color: #333;
                    border: none;
                    border-radius: 4px;
                    padding: 4px 8px;
                    font-size: 10px;
                    cursor: pointer;
                    transition: all 0.2s;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    min-width: 24px;
                    height: 20px;
                }
                
                .btn-detalle-intereses i {
                    color: #333;
                    font-size: 10px;
                }
                
                .btn-detalle-intereses:hover {
                    background: #ffb300;
                    transform: scale(1.05);
                }
                
                .monto-intereses {
                    font-weight: 500;
                }
                
                .footer {
                    margin-top: 40px;
                    padding-top: 20px;
                    border-top: 2px solid #2c3e50;
                    text-align: center;
                    font-size: 10px;
                    color: #6c757d;
                }
                
                .fecha-impresion {
                    font-weight: 600;
                    color: #495057;
                }
                
                @media print {
                    body {
                        margin: 0;
                        padding: 0;
                    }
                    
                    .no-print {
                        display: none;
                    }
                    
                    .btn-detalle-intereses {
                        display: none !important;
                    }
                    
                    .celda-intereses {
                        justify-content: center;
                    }
                    
                    /* Forzar colores de fondo en impresión */
                    .datos-asociado {
                        background: #f8f9fa !important;
                        -webkit-print-color-adjust: exact;
                        print-color-adjust: exact;
                        color-adjust: exact;
                    }
                    
                    .tabla-datos thead {
                        background: #2c3e50 !important;
                        -webkit-print-color-adjust: exact;
                        print-color-adjust: exact;
                        color-adjust: exact;
                    }
                    
                    .tabla-datos thead th {
                        background: #2c3e50 !important;
                        color: white !important;
                        -webkit-print-color-adjust: exact;
                        print-color-adjust: exact;
                        color-adjust: exact;
                    }
                    
                    .tabla-datos tbody tr:nth-child(even) {
                        background-color: #f8f9fa !important;
                        -webkit-print-color-adjust: exact;
                        print-color-adjust: exact;
                        color-adjust: exact;
                    }
                }
                
                /* Forzar colores fuera de media print también */
                .datos-asociado {
                    -webkit-print-color-adjust: exact;
                    print-color-adjust: exact;
                    color-adjust: exact;
                }
                
                .tabla-datos thead {
                    -webkit-print-color-adjust: exact;
                    print-color-adjust: exact;
                    color-adjust: exact;
                }
                
                .tabla-datos thead th {
                    -webkit-print-color-adjust: exact;
                    print-color-adjust: exact;
                    color-adjust: exact;
                }
            `;
            
            // Escribir el contenido en la ventana de impresión con todos los estilos
            ventanaImpresion.document.write(`
                <!DOCTYPE html>
                <html>
                <head>
                    <title>Estado de Cuenta</title>
                    <style>
                        ${estilosCompletos}
                    </style>
                </head>
                <body>
                    ${contenidoEstadoCuenta}
                </body>
                </html>
            `);
            
            ventanaImpresion.document.close();
            
            // Esperar a que se cargue el contenido y luego imprimir
            setTimeout(function() {
                ventanaImpresion.print();
            }, 250);
        }

        function reimprimirComprobanteMovimiento(movimientoId) {
            if (!movimientoId) {
                mostrarToast('No se pudo determinar el movimiento a imprimir.', 'warning');
                return;
            }

            $.ajax({
                type: 'POST',
                url: 'GestionSocios.aspx/GenerarComprobanteMovimiento',
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify({ movimientoId: movimientoId.toString() }),
                dataType: 'json',
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        imprimirComprobanteMovimiento(response.d.Html, movimientoId);
                    } else {
                        const mensaje = response.d && response.d.Mensaje ? response.d.Mensaje : 'No fue posible generar el comprobante.';
                        mostrarToast(mensaje, 'error');
                    }
                },
                error: function(xhr, status, error) {
                    mostrarToast('Error al generar el comprobante: ' + error, 'error');
                }
            });
        }

        function imprimirComprobanteMovimiento(htmlContent, movimientoId) {
            marcarMovimientoImpreso(movimientoId);

            const ventanaImpresion = window.open('', '_blank', 'width=800,height=600');
            ventanaImpresion.document.write(`
                <!DOCTYPE html>
                <html>
                <head>
                    <title>Comprobante de Transacción</title>
                    <style>
                        body { margin: 0; padding: 20px; font-family: Arial, sans-serif; }
                        .comprobante { height: auto !important; }
                        .separator { display: block !important; }
                        .no-print { display: none !important; }
                    </style>
                </head>
                <body>
                    ${htmlContent}
                </body>
                </html>
            `);

            ventanaImpresion.document.close();
            ventanaImpresion.onload = function () {
                setTimeout(() => {
                    ventanaImpresion.print();
                    ventanaImpresion.close();
                }, 200);
            };
        }

        function marcarMovimientoImpreso(movimientoId) {
            if (!movimientoId) {
                return;
            }

            $.ajax({
                type: 'POST',
                url: 'GestionSocios.aspx/MarcarComprobanteImpreso',
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify({ movimientoId: movimientoId.toString() }),
                dataType: 'json'
            });
        }

        function crearTituloMovimientosDesdeSocio(socio) {
            const numero = socio.NumeroAsociado || socio.Numero || '';
            const chipDocumento = crearChipTipoDocumento(socio.TipoIdentificacion, socio.NumeroIdentificacion);
            const nombreCompleto = escaparHtmlSocios(`${socio.Nombre || ''} ${socio.SegundoNombre || ''} ${socio.Apellido || ''} ${socio.SegundoApellido || ''}`.trim() || 'Sin nombre');

            return `
                <span class="badge bg-secondary">#${numero}</span>
                <span class="fw-semibold">${nombreCompleto}</span>
                <span class="d-inline-flex align-items-center chip-documento-modal">${chipDocumento}</span>
            `;
        }

        function agregarSocioACache(socio) {
            if (!socio) {
                return;
            }
            const numero = Number(socio.NumeroAsociado);
            const indice = window.__sociosCache.findIndex(s => Number(s.NumeroAsociado) === numero);
            if (indice >= 0) {
                window.__sociosCache[indice] = socio;
            } else {
                window.__sociosCache.push(socio);
            }
        }

        function obtenerSocioDeCache(numeroAsociado) {
            if (!window.__sociosCache || !Array.isArray(window.__sociosCache)) {
                return null;
            }
            return window.__sociosCache.find(s => Number(s.NumeroAsociado) === Number(numeroAsociado)) || null;
        }

        function obtenerIndiceColumnaMovimientos(columna) {
            switch ((columna || '').toUpperCase()) {
                case 'TRANSACCION':
                case 'NUMERO':
                    return 0;
                case 'FECHA':
                    return 1;
                case 'RUBRO':
                    return 2;
                case 'DETALLE':
                case 'DESCRIPCION':
                    return 3;
                case 'MONTO':
                    return 4;
                case 'OBSERVACIONES':
                    return 5;
                default:
                    return 1;
            }
        }
    </script>
    
    <!-- Script de monitoreo de inactividad -->
    <script src="../../Scripts/smart-chips.js?v=1.3"></script>
    <script src="../../Scripts/inactivity-monitor-final.js?v=2.6"></script>
</body>
</html>



