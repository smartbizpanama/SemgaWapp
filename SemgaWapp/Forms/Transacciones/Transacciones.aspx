<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Transacciones.aspx.vb" Inherits="SemgaWapp.Transacciones" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Gestión de Transacciones</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet"/>
    <!-- Flatpickr CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css"/>
    <!-- Toasts: posición con clase global .toast-container + modificador --top-end o --center -->
    <link href="../../Scripts/toast-global.css" rel="stylesheet" />
    
    <style>
        /* Evita scrollbar con pantalla “vacía”: márgenes del .main-container sumaban altura al viewport */
        html {
            height: 100%;
        }
        body {
            background: #f8f9fa;
            min-height: 100%;
            margin: 0;
            padding: 15px;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .main-container {
            background: #ffffff;
            border-radius: 6px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin: 0;
            padding: 15px;
            border: 1px solid #e9ecef;
        }
        
        .header-section {
            background: #2c3e50;
            color: white;
            padding: 10px 15px;
            border-radius: 6px;
            margin-bottom: 15px;
        }
        
        .filters-section {
            background: #ffffff;
            padding: 10px 15px;
            border-radius: 6px;
            margin-bottom: 15px;
            border: 1px solid #e9ecef;
        }
        
        .table th {
            background-color: #2c3e50;
            color: white;
            border: none;
            font-weight: 500;
            font-size: 13px;
            padding: 12px 8px;
        }
        
        .table td {
            padding: 10px 8px;
            vertical-align: middle;
            border-top: 1px solid #dee2e6;
            font-size: 13px;
        }
        
        .table-hover tbody tr:hover {
            background-color: #f8f9fa;
        }
        
        .btn-sm {
            padding: 4px 8px;
            font-size: 11px;
        }
        
        .badge {
            font-size: 10px;
            padding: 4px 8px;
        }
        
        .form-control, .form-select {
            font-size: 13px;
            border-radius: 4px;
        }
        
        /* Campo monto: prefijo $ con fondo gris y separador (estilo tipo @ username) */
        .input-group-monto {
            border-radius: 4px;
        }
        .input-group-monto .input-group-text-monto {
            background-color: #e9ecef;
            color: #495057;
            border: 1px solid #ced4da;
            border-right: 1px solid #dee2e6;
            border-radius: 4px 0 0 4px;
            padding-left: 0.75rem;
            padding-right: 0.5rem;
        }
        .input-group-monto .form-control {
            border-radius: 0 4px 4px 0;
            border-left: none;
        }
        .input-group-monto .form-control:focus {
            outline: none;
            box-shadow: none;
        }
        .input-group-monto:focus-within .input-group-text-monto {
            border-color: #86b7fe;
            box-shadow: none;
        }
        .input-group-monto:focus-within .form-control {
            border-color: #86b7fe;
            box-shadow: none;
        }
        .input-group-monto:focus-within {
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }
        
        .form-label {
            font-size: 12px;
            font-weight: 500;
            margin-bottom: 4px;
        }
        
        /* Solo el contenedor de toasts informativos (top-end). No aplicar al de confirms (--center). */
        .toast-container.toast-container--top-end {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1055;
        }
        
        .toast {
            min-width: 300px;
            margin-bottom: 10px;
            border: none;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
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
            background: transparent;
            border-bottom: 1px solid rgba(0, 0, 0, 0.1);
            font-weight: 600;
        }
        
        .toast-body {
            padding: 12px 16px;
        }
        
        /* Estilos para asociado bloqueado */
        .asociado-bloqueado {
            background: linear-gradient(135deg, #e8f5e8, #d4edda) !important;
            border: 2px solid #28a745 !important;
            position: relative;
        }
        
        .asociado-bloqueado::before {
            content: "✓ TRANSACCIÓN GUARDADA - ID: " attr(data-transaction-id);
            position: absolute;
            top: -10px;
            right: 10px;
            background: #28a745;
            color: white;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: bold;
            z-index: 10;
            white-space: nowrap;
        }
        
        .asociado-bloqueado .fas.fa-user-check {
            color: #28a745 !important;
        }
        
        .asociado-bloqueado strong {
            color: #155724 !important;
        }
        
        .asociado-bloqueado small {
            color: #155724 !important;
        }
        
        /* Estilos para el div de mensajes (error/éxito) */
        #divErrorValidacion {
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
            animation: slideInError 0.3s ease-out;
        }
        
        #divErrorValidacion.alert-danger {
            border-left: 4px solid #dc3545;
            background: linear-gradient(135deg, #f8d7da, #f5c6cb);
            box-shadow: 0 2px 8px rgba(220, 53, 69, 0.15);
        }
        
        #divErrorValidacion.alert-success {
            border-left: 4px solid #28a745;
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            box-shadow: 0 2px 8px rgba(40, 167, 69, 0.15);
        }
        
        @keyframes slideInError {
            from {
                opacity: 0;
                transform: translateX(20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        #divErrorValidacion .btn-outline-danger {
            border-color: #dc3545;
            color: #dc3545;
        }
        
        #divErrorValidacion .btn-outline-danger:hover {
            background-color: #dc3545;
            color: white;
        }
        
        #divErrorValidacion.alert-success .btn-outline-danger {
            border-color: #28a745;
            color: #28a745;
        }
        
        #divErrorValidacion.alert-success .btn-outline-danger:hover {
            background-color: #28a745;
            color: white;
        }
        
        /* Asegurar que el botón de cerrar se muestre correctamente */
        #btnCerrarError {
            display: inline-block !important;
            visibility: visible !important;
            opacity: 1 !important;
        }
        
        /* Asegurar que el ícono de cerrar sea una X */
        #btnCerrarError span {
            font-size: 16px !important;
            font-weight: bold !important;
            color: inherit !important;
        }
        
        /* Ajustar altura de botones para que coincida con form-control */
        #btnCancelarTransaccion {
            height: 38px !important;
            padding: 8px 16px !important;
            font-size: 14px !important;
            line-height: 1.5 !important;
        }
        
        /* Asegurar que el botón Volver siempre esté a la derecha */
        .header-section .col-md-6.text-end {
            display: flex !important;
            justify-content: flex-end !important;
            align-items: center !important;
        }
        
        .header-section .col-md-6.text-end button {
            flex-shrink: 0 !important;
        }
        
        /* Asegurar que el header mantenga su layout */
        .header-section {
            position: relative !important;
            z-index: 1 !important;
        }
        
        .header-section .row {
            display: flex !important;
            align-items: center !important;
            justify-content: space-between !important;
        }
        
        /* Fila doble: dos columnas iguales (alineadas con formulario / lote) */
        .row-fila-doble {
            display: flex !important;
            flex-wrap: nowrap;
            justify-content: space-between;
            gap: 0 1%;
        }
        
        .row-fila-doble .columna-izq,
        .row-fila-doble .columna-der {
            flex: 0 0 49.5%;
            max-width: 50%;
            min-width: 0;
        }
        
        .row-fila-doble .columna-izq .card {
            width: 100%;
        }
        
        /* Dos columnas 50/50: alineadas con .row-fila-doble */
        #divFormularioTransaccion:not(.d-none) {
            display: flex !important;
            flex-wrap: nowrap;
            justify-content: space-between;
        }
        
        #divFormularioTransaccion.d-none {
            display: none !important;
        }
        
        #divFormularioTransaccion .card {
            min-width: 0;
        }
        #divFormularioTransaccion .card-lote-transacciones,
        #divFormularioTransaccion .card-form-transaccion {
            flex: 0 0 49.5% !important;
            max-width: 50% !important;
        }
        
        #tblTransaccionesLote td, #tblTransaccionesLote th {
            font-size: 12px;
            padding: 6px 8px;
        }
        
        /* Detalle simulación préstamo (rubro PR): tarjetas métricas */
        tr.lote-pr-sim-row td {
            border-top: none !important;
            padding-top: 0 !important;
            background: #f1f5f9;
        }
        tr.lote-pr-sim-row .lote-pr-sim-inner {
            border-left: 3px solid #2563eb;
            padding: 8px 10px 10px;
            border-radius: 0 10px 10px 0;
            margin: 0 0 6px 0;
            background: linear-gradient(145deg, #ffffff 0%, #f8fafc 55%, #f1f5f9 100%);
            box-shadow: 0 1px 3px rgba(15, 23, 42, 0.06);
        }
        tr.lote-pr-sim-row .lote-pr-sim-toolbar {
            min-width: 0;
            overflow-x: auto;
            overflow-y: hidden;
            -webkit-overflow-scrolling: touch;
            margin-top: 2px;
        }
        tr.lote-pr-sim-row .lote-pr-metrics {
            display: flex;
            flex-wrap: nowrap;
            gap: 6px;
            align-items: stretch;
            flex: 1 1 auto;
            min-width: 0;
        }
        tr.lote-pr-sim-row .lote-pr-metric {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            background: #fff;
            border-radius: 8px;
            padding: 6px 8px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 1px 6px rgba(15, 23, 42, 0.05), 0 1px 2px rgba(15, 23, 42, 0.04);
            border-top: 2px solid var(--lote-metric-accent, #64748b);
            transition: box-shadow 0.18s ease;
        }
        /* Métricas reparten todo el ancho; saldo con mayor peso que el resto */
        tr.lote-pr-sim-row .lote-pr-metric--saldo {
            flex: 1.5 1 0;
            min-width: 0;
            max-width: none;
        }
        tr.lote-pr-sim-row .lote-pr-metric--compact {
            flex: 1 1 0;
            min-width: 0;
            max-width: none;
            padding: 6px 8px;
        }
        tr.lote-pr-sim-row .lote-pr-metric--compact .lote-pr-metric-value {
            font-size: 12px;
        }
        tr.lote-pr-sim-row .lote-pr-metric--saldo .lote-pr-metric-value {
            font-size: 14px;
        }
        tr.lote-pr-sim-row .lote-pr-metric:hover {
            box-shadow: 0 3px 10px rgba(15, 23, 42, 0.08);
        }
        tr.lote-pr-sim-row .lote-pr-metric--saldo { --lote-metric-accent: #0284c7; }
        tr.lote-pr-sim-row .lote-pr-metric--tasa { --lote-metric-accent: #4f46e5; }
        tr.lote-pr-sim-row .lote-pr-metric--dias { --lote-metric-accent: #64748b; }
        tr.lote-pr-sim-row .lote-pr-metric--intgen { --lote-metric-accent: #0891b2; }
        tr.lote-pr-sim-row .lote-pr-metric--aplint { --lote-metric-accent: #2563eb; }
        tr.lote-pr-sim-row .lote-pr-metric--aplcap { --lote-metric-accent: #059669; }
        tr.lote-pr-sim-row .lote-pr-metric--rti-fecha { --lote-metric-accent: #7c3aed; }
        tr.lote-pr-sim-row .lote-pr-metric--rti-intcalc { --lote-metric-accent: #0e7490; }
        tr.lote-pr-sim-row .lote-pr-metric--rti-intpag { --lote-metric-accent: #b45309; }
        tr.lote-pr-sim-row .lote-pr-metric--rti-madev { --lote-metric-accent: #be185d; }
        tr.lote-pr-sim-row .lote-pr-metric--rti-nuevopag { --lote-metric-accent: #15803d; }
        tr.lote-pr-sim-row .lote-pr-metric--rtr-madev { --lote-metric-accent: #be185d; }
        tr.lote-pr-sim-row .lote-pr-metric--rtr-nuevo { --lote-metric-accent: #15803d; }
        tr.lote-pr-sim-row .lote-pr-metric-label {
            display: block;
            width: 100%;
            text-align: center;
            font-size: 9px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #64748b;
            margin-bottom: 3px;
            line-height: 1.15;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        tr.lote-pr-sim-row .lote-pr-metric-value {
            display: block;
            width: 100%;
            text-align: center;
            font-size: 13px;
            font-weight: 700;
            color: #0f172a;
            letter-spacing: -0.02em;
            line-height: 1.15;
            font-variant-numeric: tabular-nums;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        tr.lote-pr-sim-row .lote-pr-switch-wrap {
            flex-shrink: 0;
            align-self: stretch;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-width: 96px;
            max-width: 110px;
            padding: 6px 8px;
            background: #fff;
            border-radius: 8px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 1px 6px rgba(15, 23, 42, 0.05), 0 1px 2px rgba(15, 23, 42, 0.04);
            border-top: 2px solid #475569;
        }
        tr.lote-pr-sim-row .lote-pr-switch-entire {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            flex: 1 1 auto;
            min-height: 0;
            margin: 0;
            cursor: pointer;
            user-select: none;
        }
        tr.lote-pr-sim-row .lote-pr-switch-title {
            font-size: 9px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #64748b;
            line-height: 1.15;
            text-align: center;
            margin-bottom: 4px;
        }
        tr.lote-pr-sim-row .lote-pr-switch-center {
            position: relative;
            flex: 1 1 auto;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 1.25rem;
        }
        /* Input real oculto; la pista muestra NO / SI */
        tr.lote-pr-sim-row .lote-pr-solo-capital-switch.lote-pr-sr-input {
            position: absolute;
            width: 1px;
            height: 1px;
            padding: 0;
            margin: -1px;
            overflow: hidden;
            clip: rect(0, 0, 0, 0);
            white-space: nowrap;
            border: 0;
        }
        tr.lote-pr-sim-row .lote-pr-switch-ui-track {
            position: relative;
            width: 34px;
            height: 16px;
            border-radius: 8px;
            background: #94a3b8;
            box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.12);
            transition: background 0.2s ease;
        }
        tr.lote-pr-sim-row .lote-pr-solo-capital-switch:checked + .lote-pr-switch-ui-track {
            background: #0d6efd;
        }
        tr.lote-pr-sim-row .lote-pr-switch-ui-txt {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            font-size: 6px;
            font-weight: 800;
            line-height: 1;
            letter-spacing: 0.02em;
            z-index: 1;
            pointer-events: none;
        }
        /* NO a la derecha (visible con pulgar a la izquierda); SI a la izquierda (visible con pulgar a la derecha) */
        tr.lote-pr-sim-row .lote-pr-switch-ui-no {
            right: 4px;
            color: rgba(255, 255, 255, 0.95);
        }
        tr.lote-pr-sim-row .lote-pr-switch-ui-si {
            left: 4px;
            color: rgba(255, 255, 255, 0.88);
        }
        tr.lote-pr-sim-row .lote-pr-solo-capital-switch:checked + .lote-pr-switch-ui-track .lote-pr-switch-ui-no {
            color: rgba(255, 255, 255, 0.75);
        }
        tr.lote-pr-sim-row .lote-pr-solo-capital-switch:checked + .lote-pr-switch-ui-track .lote-pr-switch-ui-si {
            color: rgba(255, 255, 255, 1);
        }
        tr.lote-pr-sim-row .lote-pr-switch-ui-thumb {
            position: absolute;
            top: 2px;
            left: 2px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: #fff;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.25);
            z-index: 2;
            transition: left 0.2s ease;
        }
        tr.lote-pr-sim-row .lote-pr-solo-capital-switch:checked + .lote-pr-switch-ui-track .lote-pr-switch-ui-thumb {
            left: 20px;
        }
        tr.lote-pr-sim-row .lote-pr-switch-entire:focus-within .lote-pr-switch-ui-track {
            outline: 2px solid rgba(13, 110, 253, 0.45);
            outline-offset: 2px;
        }
        /* Botones Añadir y Cancelar del formulario: mismo tamaño y alto */
        #btnAnadirTransaccion, #btnCancelarTransaccion {
            height: 38px !important;
            min-height: 38px !important;
            width: 135px;
            min-width: 135px;
            max-width: 135px;
            padding: 0.375rem 12px !important;
            line-height: 1.5 !important;
            box-sizing: border-box;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        
        /* Ocultar barra global cuando no hay asociado */
        #divBotonesGlobales.d-none {
            display: none !important;
        }
        
        #divBotonesGlobales:not(.d-none) {
            display: block !important;
        }
        
        /* Barra de botones globales: mismo ancho que las columnas de arriba */
        .barra-botones-globales {
            background: rgba(13, 110, 253, 0.08);
            border-radius: 8px;
            padding: 14px 20px;
            margin: 0 0 15px 0;
            border: 1px solid rgba(13, 110, 253, 0.15);
        }

        .header-title-with-fechas {
            min-width: 0;
        }
        .header-fechas-ref .fecha-ref-pill {
            display: inline-flex;
            align-items: center;
            flex-wrap: wrap;
            padding: 5px 12px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 500;
            border: 1px solid transparent;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
        }
        /* Fecha real (internet / zona del equipo): verde azulado */
        .header-fechas-ref .fecha-ref-pill--real {
            background: linear-gradient(135deg, #0f766e 0%, #14b8a6 100%);
            color: #fff;
            border-color: rgba(255, 255, 255, 0.35);
        }
        /* Fecha sistema (SQL GETDATE): amarillo */
        .header-fechas-ref .fecha-ref-pill--sistema {
            background: linear-gradient(135deg, #ca8a04 0%, #eab308 100%);
            color: #422006;
            border-color: rgba(66, 32, 6, 0.25);
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.15);
        }
        .header-fechas-ref .fecha-ref-pill strong {
            font-weight: 600;
            margin-right: 4px;
        }

        /* Acciones del asociado (misma semántica que botones en GestionSocios) */
        .acciones-asociado-transacciones .btn {
            flex: 1 1 0;
            min-width: 0;
            font-size: 12px;
            font-weight: 500;
            white-space: normal;
            line-height: 1.2;
            padding: 0.5rem 0.35rem;
        }
        .global-panel-trans {
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 12px 30px rgba(15, 23, 42, 0.08);
            border: 1px solid rgba(148, 163, 184, 0.25);
            overflow: hidden;
        }
        .global-panel-header-trans {
            background: linear-gradient(135deg, #facc15, #fbbf24);
            color: #1f2937;
            border-bottom: 1px solid rgba(120, 53, 15, 0.2);
            align-items: center;
            padding: 14px 24px;
        }
        .global-panel-title-trans {
            font-weight: 600;
            font-size: 1rem;
            color: #1f2937;
            display: inline-flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }
        .global-panel-body-trans { padding: 22px; }
        .global-panel-footer-trans {
            background: #f8fafc;
            padding: 18px 22px;
            border-top: 1px solid rgba(148, 163, 184, 0.2);
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }
        .global-card-trans {
            background: #ffffff;
            border-radius: 10px;
            border: 1px solid rgba(148, 163, 184, 0.25);
            box-shadow: 0 6px 20px rgba(15, 23, 42, 0.06);
            padding: 16px;
        }
        .movimientos-modal-dialog-trans { max-width: 1200px; width: 95%; }
        #tablaMovimientosSocio td.observaciones-cell {
            min-width: 220px;
            text-align: left !important;
            white-space: normal;
        }
        #tablaMovimientosSocio thead th { text-align: center !important; }
    </style>
</head>
<body>
    <%-- ResolveUrl aquí (no en <head>): si hay <%= %> dentro de head runat="server", BasePage no puede añadir el favicon vía Header.Controls.Add. --%>
    <script type="text/javascript">
        window.SEMGA_TRANSACCIONES_PAGE_URL = '<%= ResolveUrl("~/Forms/Transacciones/Transacciones.aspx") %>';
        window.SEMGA_DASHBOARD_URL = '<%= ResolveUrl("~/Dashboard.aspx") %>';
    </script>
    <form id="form1" runat="server">
        <div class="main-container">
            <!-- Header Section -->
            <div class="header-section">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <div class="d-flex flex-wrap align-items-center gap-2 gap-md-3 header-title-with-fechas">
                            <h6 class="mb-0 flex-shrink-0 align-self-center" style="font-size: 16px;"><i class="fas fa-exchange-alt me-2"></i>Gestión de Transacciones</h6>
                            <div id="fechasReferenciaHeader" class="header-fechas-ref d-flex flex-wrap align-items-center gap-2 flex-grow-1 min-width-0" aria-live="polite"></div>
                        </div>
                    </div>
                    <div class="col-md-6 text-end">
                        <button type="button" class="btn btn-secondary" onclick="volverDashboard()">
                            <i class="fas fa-arrow-left me-1"></i>Volver
                        </button>
                    </div>
                </div>
            </div>

            <!-- Selección de Asociado: misma anchura que formulario (50%) -->
            <div id="rowAsociado" class="row-fila-doble mb-4">
                <div class="columna-izq">
                    <div class="card border-primary h-100">
                        <div class="card-header bg-light">
                            <h6 class="mb-0 text-primary">
                                <i class="fas fa-user me-2"></i>Asociado Seleccionado
                            </h6>
                        </div>
                        <div class="card-body py-3">
                            <div id="divSinAsociado" class="text-center py-2">
                                <div class="d-flex align-items-center justify-content-between">
                                    <div class="d-flex align-items-center">
                                        <i class="fas fa-user-plus fa-lg text-muted me-3"></i>
                                        <span class="text-muted">No hay asociado seleccionado</span>
                                    </div>
                                    <button type="button" id="btnBuscarAsociado" class="btn btn-outline-primary btn-sm">
                                        <i class="fas fa-search me-1"></i>Buscar
                                    </button>
                                </div>
                            </div>
                            
                            <div id="divAsociadoSeleccionado" class="alert alert-success d-none py-2 mb-0">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="d-flex align-items-center">
                                        <i class="fas fa-user-check fa-lg text-success me-3"></i>
                                        <div>
                                            <strong id="lblAsociadoInfo" class="d-block"></strong>
                                            <small id="lblAsociadoDetalle" class="text-muted"></small>
                                        </div>
                                    </div>
                                    <button type="button" id="btnEliminarAsociado" class="btn btn-outline-success btn-sm">
                                        <i class="fas fa-times"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Acciones del asociado + error de validación -->
                <div class="columna-der d-flex flex-column gap-3">
                    <div class="card border-secondary h-100">
                        <div class="card-header bg-light py-2">
                            <h6 class="mb-0 text-secondary">
                                <i class="fas fa-folder-open me-2"></i>Consultas del asociado
                            </h6>
                        </div>
                        <div class="card-body py-3">
                            <div class="d-flex flex-wrap gap-2 acciones-asociado-transacciones" role="group" aria-label="Consultas">
                                <button type="button" id="btnAccSocTransacciones" class="btn btn-outline-primary btn-sm" disabled title="Transacciones">
                                    <i class="fas fa-list-ul me-1"></i>Transacciones
                                </button>
                                <button type="button" id="btnAccSocMovimientos" class="btn btn-outline-info btn-sm" disabled title="Ver movimientos">
                                    <i class="fas fa-list-ul me-1"></i>Movimientos
                                </button>
                                <button type="button" id="btnAccSocEstadoCuenta" class="btn btn-outline-info btn-sm" disabled title="Generar Estado de Cuenta">
                                    <i class="fas fa-file-invoice me-1"></i>Estado de cuenta
                                </button>
                            </div>
                        </div>
                    </div>
                    <div id="divErrorValidacion" class="alert alert-danger d-none" style="margin-bottom: 0;">
                        <div class="d-flex justify-content-between align-items-start">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-exclamation-triangle fa-lg text-danger me-3"></i>
                                <div>
                                    <strong class="d-block">Error de Validación</strong>
                                    <span id="lblMensajeError" class="text-muted"></span>
                                </div>
                            </div>
                            <button type="button" id="btnCerrarError" class="btn btn-outline-danger btn-sm">
                                <span style="font-size: 16px; font-weight: bold;">×</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Dos columnas: solo visibles cuando hay asociado seleccionado -->
            <div id="divFormularioTransaccion" class="mb-3 d-none" style="gap: 0 1%;">
                <!-- Izquierda: formulario de datos de la transacción -->
                <div class="card border-success card-form-transaccion">
                    <div class="card-header bg-light">
                        <h6 class="mb-0 text-success">
                            <i class="fas fa-plus-circle me-2"></i>Datos de la transacción
                        </h6>
                    </div>
                    <div class="card-body">
                        <div id="panelCapturaTransaccion" class="panel-captura-transaccion" role="region" aria-label="Datos de la transacción">
                            <div class="row mb-2">
                                <div class="col-6">
                                    <label for="ddlRubro" class="form-label fw-bold">Rubro <span class="text-danger">*</span></label>
                                    <select id="ddlRubro" class="form-select form-select-sm">
                                        <option value="">Seleccionar rubro...</option>
                                    </select>
                                </div>
                                <div class="col-6">
                                    <label for="ddlAuxiliar" class="form-label fw-bold">Auxiliar <span class="text-danger">*</span></label>
                                    <select id="ddlAuxiliar" class="form-select form-select-sm">
                                        <option value="">Seleccionar auxiliar...</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-6">
                                    <label for="ddlCuenta" class="form-label fw-bold">Cuenta <span class="text-danger">*</span></label>
                                    <select id="ddlCuenta" class="form-select form-select-sm">
                                        <option value="">Seleccionar cuenta...</option>
                                    </select>
                                </div>
                                <div class="col-6">
                                    <label for="ddlCodigoTransaccion" class="form-label fw-bold">Transacción <span class="text-danger">*</span></label>
                                    <select id="ddlCodigoTransaccion" class="form-select form-select-sm">
                                        <option value="">Seleccionar código...</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-12">
                                    <label for="txtMonto" class="form-label fw-bold">Monto <span class="text-danger">*</span></label>
                                    <div class="input-group input-group-sm input-group-monto">
                                        <span class="input-group-text input-group-text-monto">$</span>
                                        <input type="text" id="txtMonto" class="form-control form-control-sm" inputmode="decimal" placeholder="0.00" autocomplete="off" maxlength="14">
                                    </div>
                                </div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-12">
                                    <label for="txtObservaciones" class="form-label fw-bold">Observaciones</label>
                                    <input type="text" id="txtObservaciones" class="form-control form-control-sm" placeholder="">
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col-12 d-flex gap-2 align-items-center">
                                    <button type="button" id="btnAnadirTransaccion" class="btn btn-primary">
                                        <i class="fas fa-plus me-1"></i>Añadir
                                    </button>
                                    <button type="button" id="btnCancelarTransaccion" class="btn btn-secondary">
                                        <i class="fas fa-times me-1"></i>Cancelar
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Derecha: lista de transacciones del lote -->
                <div class="card border-primary card-lote-transacciones">
                    <div class="card-header bg-light">
                        <h6 class="mb-0 text-primary" id="tituloTransaccionesLote">
                            <i class="fas fa-list me-2"></i>Transacciones del lote (máx. <%= CantTransLoteMax %>)
                        </h6>
                    </div>
                    <div class="card-body p-2">
                        <input type="hidden" id="cantTransLoteMax" value="<%= CantTransLoteMax %>" />
                        <input type="hidden" id="jsonTransaccionesLote" value="[]" />
                        <div class="table-responsive" style="max-height: 560px; overflow-y: auto;">
                            <table class="table table-sm table-hover mb-0" id="tblTransaccionesLote" style="display: none;">
                                <thead class="table-light sticky-top">
                                    <tr>
                                        <th style="width: 50px;">Línea</th>
                                        <th>Auxiliar</th>
                                        <th>Cuenta</th>
                                        <th>Transacción</th>
                                        <th class="text-end">Monto</th>
                                        <th>Mensaje</th>
                                        <th style="width: 70px;"></th>
                                    </tr>
                                </thead>
                                <tbody id="tbodyTransaccionesLote">
                                    <!-- Filas generadas por JS -->
                                </tbody>
                            </table>
                        </div>
                        <div id="divListaVacia" class="text-center text-muted py-3 small">No hay transacciones añadidas. Use "Añadir" para agregar.</div>
                    </div>
                </div>
            </div>

            <!-- Botones globales: solo visibles cuando hay asociado seleccionado -->
            <div id="divBotonesGlobales" class="d-none">
                <div class="barra-botones-globales">
                    <div class="d-flex justify-content-center gap-3 align-items-center">
                        <button type="button" id="btnGuardarLote" class="btn btn-success">
                            <i class="fas fa-save me-1"></i>Guardar
                        </button>
                        <button type="button" id="btnImprimirLote" class="btn btn-primary" style="display: none;">
                            <i class="fas fa-print me-1"></i>Imprimir
                        </button>
                        <button type="button" id="btnCancelarGlobal" class="btn btn-secondary">
                            <i class="fas fa-times me-1"></i>Cancelar
                        </button>
                    </div>
                </div>
            </div>

            <!-- Prueba comprobante lote: solo para probar formato sin hacer transacción (oculto) -->
            <div class="mt-3 p-2 border rounded bg-light d-none" id="divPruebaComprobanteLote" style="max-width: 320px;">
                <label class="form-label small text-muted mb-1">Prueba comprobante lote</label>
                <div class="d-flex gap-2 align-items-center">
                    <input type="number" id="txtPruebaIDTransaccion" class="form-control form-control-sm" placeholder="ID Transacción" min="1" style="width: 100px;" />
                    <button type="button" id="btnPruebaImprimirLote" class="btn btn-outline-secondary btn-sm">
                        <i class="fas fa-print me-1"></i>Imprimir
                    </button>
                </div>
            </div>

        </div>

        <!-- Toast: informativos (top-end) y confirms (centro) -->
        <div id="toastContainer" class="toast-container toast-container--top-end"></div>
        <div id="confirmToastContainer" class="toast-container toast-container--center" aria-hidden="true"></div>
        
        <!-- Global Modals Container -->
        <div id="globalModalsContainer"></div>

        <!-- Modales consulta asociado (GestionSocios.aspx) -->
        <div class="modal fade" id="modalMovimientosSocio" tabindex="-1" aria-labelledby="modalMovimientosSocioLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
            <div class="modal-dialog modal-xl modal-dialog-scrollable movimientos-modal-dialog-trans">
                <div class="modal-content global-panel-trans">
                    <div class="modal-header global-panel-header-trans">
                        <h5 class="modal-title global-panel-title-trans" id="modalMovimientosSocioLabel">
                            <i class="fas fa-receipt me-2"></i>Movimientos del socio
                            <span id="tituloMovimientosSocio" class="d-inline-flex align-items-center gap-2"></span>
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body global-panel-body-trans">
                        <div id="estadoMovimientosSocio" class="d-flex align-items-center justify-content-center flex-column py-4 d-none">
                            <i class="fas fa-folder-open fa-2x text-muted mb-2"></i>
                            <p class="text-muted mb-0">No se encontraron movimientos para este socio.</p>
                        </div>
                        <div id="spinnerMovimientosSocio" class="text-center my-4 d-none">
                            <div class="spinner-border" role="status"><span class="visually-hidden">Cargando...</span></div>
                            <p class="mt-3 mb-0">Cargando movimientos...</p>
                        </div>
                        <div class="global-card-trans" id="contenedorTablaMovimientosSocio" style="display: none;">
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
                            <button type="button" class="btn btn-outline-primary" id="btnVerMasMovimientos">Ver más movimientos</button>
                        </div>
                    </div>
                    <div class="modal-footer global-panel-footer-trans">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                    </div>
                </div>
            </div>
        </div>
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
    </form>

    <!-- Estilos impresión estado de cuenta (resumen; el HTML del servidor aporta clases .estado-cuenta, .tabla-datos, etc.) -->
    <textarea id="semgaEstadoCuentaPrintCss" class="d-none" aria-hidden="true">@page { size: 8.5in 11in; margin: 0.5in; }
body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 20px; font-size: 12px; line-height: 1.4; background: #fff; color: #333; }
.estado-cuenta { width: 100%; max-width: 8.5in; margin: 0 auto; background: #fff; }
.header { text-align: center; margin-bottom: 30px; padding-bottom: 20px; border-bottom: 2px solid #2c3e50; }
.cooperativa-nombre { font-size: 18px; font-weight: 700; color: #2c3e50; margin-bottom: 10px; text-transform: uppercase; }
.titulo-estado { font-size: 24px; font-weight: 700; color: #2c3e50; margin-top: 15px; text-transform: uppercase; }
.datos-asociado { background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); border: 1px solid #dee2e6; border-radius: 6px; padding: 15px; margin-bottom: 25px; }
.tabla-datos { width: 100%; border-collapse: collapse; margin-bottom: 30px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
.tabla-datos thead { background: #2c3e50; color: #fff; }
.tabla-datos th, .tabla-datos td { padding: 8px; border: 1px solid #dee2e6; }
.footer { margin-top: 40px; padding-top: 15px; border-top: 1px solid #dee2e6; text-align: center; font-size: 11px; color: #6c757d; }
.no-print, .btn-detalle-intereses { display: none !important; }
@media print { body { margin: 0; padding: 0; } .datos-asociado, .tabla-datos thead { -webkit-print-color-adjust: exact; print-color-adjust: exact; } }
    </textarea>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="../../Scripts/smart-chips.js"></script>
    <script src="../../Scripts/global-associate-search.js?v=1.4"></script>
    <script src="../../Scripts/inactivity-monitor-final.js?v=2.6"></script>
    <script src="../../Scripts/notifications.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="../../Scripts/transacciones-socios-acciones.js?v=1.1"></script>
    <!-- Flatpickr Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/es.js"></script>

    <script>
        /** URL para PageMethods de esta página (virtual directory-safe). */
        function semgaTransPageMethod(methodName) {
            var u = (typeof window.SEMGA_TRANSACCIONES_PAGE_URL === 'string' && window.SEMGA_TRANSACCIONES_PAGE_URL)
                ? window.SEMGA_TRANSACCIONES_PAGE_URL.replace(/\/+$/, '')
                : 'Transacciones.aspx';
            return u + '/' + methodName;
        }
        function semgaTransaccionesReload() {
            window.location.href = (typeof window.SEMGA_TRANSACCIONES_PAGE_URL === 'string' && window.SEMGA_TRANSACCIONES_PAGE_URL)
                ? window.SEMGA_TRANSACCIONES_PAGE_URL
                : 'Transacciones.aspx';
        }
        function semgaIrDashboard() {
            window.location.href = (typeof window.SEMGA_DASHBOARD_URL === 'string' && window.SEMGA_DASHBOARD_URL)
                ? window.SEMGA_DASHBOARD_URL
                : '../../Dashboard.aspx';
        }

        function semgaCargarFechasReferenciaTitulo(endpoint) {
            var tz = '';
            try {
                tz = Intl.DateTimeFormat().resolvedOptions().timeZone || '';
            } catch (e) { }
            $.ajax({
                type: 'POST',
                url: endpoint,
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify({ timeZoneCliente: tz }),
                dataType: 'json',
                success: function (response) {
                    var d = response.d;
                    if (!d || d.Resultado !== 'SUCCESS') return;
                    var $c = $('#fechasReferenciaHeader');
                    if (!$c.length) return;
                    var $p1 = $('<span class="fecha-ref-pill fecha-ref-pill--real"></span>')
                        .append($('<i class="fas fa-globe-americas me-1" aria-hidden="true"></i>'))
                        .append($('<strong></strong>').text('Fecha real: '))
                        .append($('<span></span>').text(d.FechaReal || ''));
                    var $p2 = $('<span class="fecha-ref-pill fecha-ref-pill--sistema"></span>')
                        .append($('<i class="fas fa-database me-1" aria-hidden="true"></i>'))
                        .append($('<strong></strong>').text('Fecha sistema: '))
                        .append($('<span></span>').text(d.FechaSistema || ''));
                    $c.empty().append($p1, $p2);
                }
            });
        }

        $(document).ready(function() {
            semgaCargarFechasReferenciaTitulo(semgaTransPageMethod('ObtenerFechasReferenciaTitulo'));
            if (typeof SemgaTransAcciones !== 'undefined') {
                SemgaTransAcciones.init();
            }

            // Ocultar sección de transacción y botones globales hasta que se elija un asociado
            $('#divFormularioTransaccion, #divBotonesGlobales').addClass('d-none');

            // Inicializar monitoreo de inactividad
            if (typeof initializeInactivityMonitoring === 'function') {
                initializeInactivityMonitoring();
            }

            // Inicializar componente global de búsqueda de asociados
            inicializarBusquedaAsociadosGlobal();

            // Escuchar mensajes de la ventana del comprobante
            window.addEventListener('message', function(event) {
                if (event.data && event.data.tipo === 'marcarImpreso') {
                    marcarComprobanteComoImpreso(
                        event.data.capitalMovimientoId || '',
                        event.data.interesesMovimientoId || ''
                    );
                }
            });

            // Eventos
            $('#btnBuscarAsociado').on('click', function() {
                abrirBusquedaAsociados(globalSearchConfig);
            });

            $('#btnEliminarAsociado').on('click', function() {
                if (listaTransaccionesPendientes.length > 0) {
                    mostrarErrorValidacion('Vacíe el lote de transacciones (elimine todas las filas) antes de cambiar de asociado.');
                    return;
                }
                if (tieneDatosCapturados()) {
                    mostrarConfirmEliminarAsociado();
                } else {
                    eliminarAsociadoSeleccionado();
                }
            });

            // Eventos del formulario de Transacción
            $('#ddlRubro').on('change', function() {
                const codigoRubro = $(this).val();
                if (codigoRubro) {
                    cargarAuxiliaresPorRubro(codigoRubro);
                    cargarTransaccionesPorRubro(codigoRubro);
                } else {
                    limpiarDropdowns(['#ddlAuxiliar', '#ddlCuenta', '#ddlCodigoTransaccion']);
                }
            });

            $('#ddlAuxiliar').on('change', function() {
                const auxiliarId = $(this).val();
                if (auxiliarId) {
                    cargarCuentasPorAuxiliar(auxiliarId);
                } else {
                    limpiarDropdowns(['#ddlCuenta']);
                }
            });

            $('#btnAnadirTransaccion').on('click', function() {
                añadirTransaccionALista();
            });

            $('#btnCancelarTransaccion').on('click', function() {
                limpiarFormularioTransaccion();
            });

            $('#btnGuardarLote').on('click', function() {
                guardarLote();
            });

            $('#btnCancelarGlobal').on('click', function() {
                cancelarGlobal();
            });

            $('#btnImprimirLote').on('click', function() {
                if (ultimoIDTransaccion == null || ultimoIDTransaccion === undefined) {
                    showToast('info', 'Imprimir', 'No hay comprobante de lote para imprimir.');
                    return;
                }
                imprimirComprobanteLotePorId(ultimoIDTransaccion);
            });

            $('#btnPruebaImprimirLote').on('click', function() {
                var idTrans = parseInt($('#txtPruebaIDTransaccion').val(), 10);
                if (isNaN(idTrans) || idTrans < 1) {
                    showToast('warning', 'Prueba', 'Ingrese un ID Transacción válido (número mayor a 0).');
                    return;
                }
                imprimirComprobanteLotePorId(idTrans);
            });

            // Evento para cerrar el div de error
            $('#btnCerrarError').on('click', function() {
                ocultarErrorValidacion();
            });
            
            // Campo monto: solo dos decimales y formato con $
            (function() {
                var $monto = $('#txtMonto');
                $monto.on('input', function() {
                    var v = $(this).val();
                    var dot = v.indexOf('.');
                    if (dot >= 0) {
                        var before = v.substring(0, dot).replace(/[^0-9]/g, '');
                        var after = v.substring(dot + 1).replace(/[^0-9]/g, '').substring(0, 2);
                        v = (before || '') + '.' + after;
                    } else {
                        v = v.replace(/[^0-9.]/g, '');
                        if (v.split('.').length > 2) v = v.replace(/\.+$/, '');
                    }
                    $(this).val(v);
                });
                $monto.on('blur', function() {
                    var v = $(this).val().replace(',', '.').trim();
                    if (v === '' || v === '.') {
                        $(this).val('');
                        return;
                    }
                    var n = parseFloat(v);
                    if (!isNaN(n) && n >= 0) {
                        $(this).val(n.toFixed(2));
                    }
                });
            })();
            
            // Evento para presionar Enter en el campo monto -> Añadir a la lista
            $('#txtMonto').on('keypress', function(e) {
                if (e.which === 13) {
                    e.preventDefault();
                    $(this).blur();
                    setTimeout(function() { añadirTransaccionALista(); }, 50);
                }
            });
            
            // Ocultar mensajes de error/éxito cuando el usuario interactúe con cualquier control
            $('input, select, button').on('focus click change input', function() {
                ocultarMensajes();
            });
        });

        // Variable global para almacenar datos
        var asociadoSeleccionado = null;
        var globalSearchConfig = null;
        var jsonAuxiliares = null; // Almacenar el JSON de auxiliares del asociado
        var listaTransaccionesPendientes = []; // Lote de transacciones (mismo asociado). Cada ítem: { CodigoRubro, AuxiliarKey, IDAuxiliar, CodigoTransaccion, Monto, Observaciones, textoAuxiliar, textoCuenta, textoTransaccion }

        // Función para inicializar el componente global de búsqueda
        function inicializarBusquedaAsociadosGlobal() {
            globalSearchConfig = crearBusquedaAsociados('globalModalsContainer', {
                modalId: 'modalBuscarAsociadoGlobal',
                searchInputId: 'txtBuscarAsociadoGlobal',
                resultsTableId: 'tbodyAsociadosGlobal',
                searchButtonId: 'btnBuscarAsociadoGlobal',
                clearButtonId: 'btnLimpiarBusquedaGlobal',
                modalTitle: 'Buscar Asociado',
                searchPlaceholder: 'Ingrese nombre, cédula o número de asociado...',
                validarAuxiliares: true, // Validar que el asociado tenga auxiliares
                onSelect: function(asociado) {
                    // Callback cuando se selecciona un asociado
                    seleccionarAsociado(asociado.numeroAsociado, asociado.nombre, asociado.numeroIdentificacion, asociado.codTipoDoc, asociado.cantAuxiliares, {
                        Rubros: asociado.Rubros,
                        AuxiliaresPorRubro: asociado.AuxiliaresPorRubro,
                        TransaccionesPorRubro: asociado.TransaccionesPorRubro
                    });
                },
                onCancel: function() {
                    // Callback cuando se cancela la búsqueda
                }
            });
        }


        function seleccionarAsociado(numeroAsociado, nombre, cedula, tipoDocumento, cantAuxiliares, datosAuxiliares) {
            // Almacenar los datos procesados del servidor
            if (datosAuxiliares && typeof datosAuxiliares === 'object') {
                jsonAuxiliares = datosAuxiliares;
            } else {
                jsonAuxiliares = null;
            }
            
            // Procesar selección del asociado
            procesarSeleccionAsociado(numeroAsociado, nombre, cedula, tipoDocumento);
        }

        function procesarSeleccionAsociado(numeroAsociado, nombre, cedula, tipoDocumento) {
            asociadoSeleccionado = {
                numeroAsociado: numeroAsociado,
                nombre: nombre,
                cedula: cedula,
                tipoDocumento: tipoDocumento
            };
            
            $('#lblAsociadoInfo').text(nombre);
            var identificacionHtml = crearChipIdentificacion(tipoDocumento, cedula);
            $('#lblAsociadoDetalle').html(identificacionHtml + ' | N° Asociado: ' + numeroAsociado);
            
            $('#divSinAsociado').addClass('d-none');
            $('#divAsociadoSeleccionado').removeClass('d-none');
            
            // Mostrar formulario y botones globales (solo cuando hay asociado); visibilidad solo con .d-none + CSS
            $('#divFormularioTransaccion').removeClass('d-none');
            $('#divBotonesGlobales').removeClass('d-none');
            
            // Reiniciar lote para el nuevo asociado
            listaTransaccionesPendientes = [];
            actualizarJsonYTablaLote();
            actualizarEstadoBotonAsociado();
            
            // Ocultar cualquier error de validación previo
            ocultarErrorValidacion();
            
            // Cargar datos para el formulario usando JsonAuxiliares
            cargarDatosFormulario();

            window.semgaNumeroAsociadoTransacciones = numeroAsociado;
            if (typeof SemgaTransAcciones !== 'undefined') {
                SemgaTransAcciones.syncSocio(asociadoSeleccionado);
                SemgaTransAcciones.setAccionesHabilitadas(true);
            }
        }


        function tieneDatosCapturados() {
            // Verificar si hay datos en los campos del formulario
            const rubro = $('#ddlRubro').val();
            const auxiliar = $('#ddlAuxiliar').val();
            const cuenta = $('#ddlCuenta').val();
            const transaccion = $('#ddlCodigoTransaccion').val();
            const monto = $('#txtMonto').val();
            const observaciones = $('#txtObservaciones').val();
            
            return rubro || auxiliar || cuenta || transaccion || monto || observaciones;
        }

        function mostrarConfirmEliminarAsociado() {
            // Usar el sistema global de notificaciones
            showConfirmToast(
                'warning',
                'Advertencia',
                'Eliminar al asociado borrará los datos de la transacción.<br><strong>¿Desea continuar?</strong>',
                function() {
                    // Función de confirmación - redirigir para reiniciar todo
                    semgaTransaccionesReload();
                },
                function() {
                    // Función de cancelación - no hacer nada
                    showToast('info', 'Operación cancelada', 'El asociado no fue eliminado.');
                }
            );
        }

        function eliminarAsociadoSeleccionado() {
            window.semgaNumeroAsociadoTransacciones = null;
            if (typeof SemgaTransAcciones !== 'undefined') {
                SemgaTransAcciones.setAccionesHabilitadas(false);
            }
            asociadoSeleccionado = null;
            jsonAuxiliares = null;
            listaTransaccionesPendientes = [];
            $('#lblAsociadoInfo').text('');
            $('#lblAsociadoDetalle').text('');
            
            $('#divAsociadoSeleccionado').addClass('d-none');
            $('#divSinAsociado').removeClass('d-none');
            
            $('#divFormularioTransaccion').addClass('d-none');
            $('#divBotonesGlobales').addClass('d-none');
            $('#jsonTransaccionesLote').val('[]');
        }

        // Funciones para el formulario de Transacción basadas en JsonAuxiliares
        function cargarDatosFormulario() {
            if (!jsonAuxiliares) {
                return;
            }
            
            // 1. Cargar rubros únicos
            cargarRubrosDesdeJson();
            
            // 2. Si solo hay un rubro, seleccionarlo automáticamente
            if (jsonAuxiliares && jsonAuxiliares.Rubros && jsonAuxiliares.Rubros.length === 1) {
                $('#ddlRubro').val(jsonAuxiliares.Rubros[0].CodigoRubro).trigger('change');
            }
        }

        function cargarRubrosDesdeJson() {
            if (!jsonAuxiliares || !jsonAuxiliares.Rubros) {
                return;
            }
            
            $('#ddlRubro').empty();
            
            // Si solo hay un rubro, no mostrar opción "Seleccionar..."
            if (jsonAuxiliares.Rubros.length === 1) {
                $('#ddlRubro').append(`<option value="${jsonAuxiliares.Rubros[0].CodigoRubro}">${jsonAuxiliares.Rubros[0].DescripcionRubro}</option>`);
            } else {
                $('#ddlRubro').append('<option value="">Seleccionar rubro...</option>');
                $.each(jsonAuxiliares.Rubros, function(index, rubro) {
                    $('#ddlRubro').append(`<option value="${rubro.CodigoRubro}">${rubro.DescripcionRubro}</option>`);
                });
            }
        }

        /** Obtiene el value para el option del auxiliar: "Cuenta-IdTipoAuxiliar". El servidor envía Cuentas[] y no Cuenta, por eso se usa la primera cuenta. */
        function auxiliarOptionValue(auxiliar) {
            var idTipo = auxiliar.IdTipoAuxiliar || '';
            if (auxiliar.Cuentas && auxiliar.Cuentas.length > 0) {
                var prim = auxiliar.Cuentas[0];
                var cuenta = (typeof prim === 'object' && prim.Cuenta != null) ? prim.Cuenta : String(prim);
                return cuenta + '-' + idTipo;
            }
            return idTipo;
        }

        function cargarAuxiliaresPorRubro(codigoRubro) {
            if (!jsonAuxiliares || !jsonAuxiliares.AuxiliaresPorRubro || !jsonAuxiliares.AuxiliaresPorRubro[codigoRubro]) {
                return;
            }
            
            const auxiliaresDelRubro = jsonAuxiliares.AuxiliaresPorRubro[codigoRubro];
            
            $('#ddlAuxiliar').empty();
            
            // Si solo hay un auxiliar, no mostrar opción "Seleccionar..."
            if (auxiliaresDelRubro.length === 1) {
                var val1 = auxiliarOptionValue(auxiliaresDelRubro[0]);
                $('#ddlAuxiliar').append(`<option value="${val1}">${auxiliaresDelRubro[0].DescripcionAuxiliar}</option>`);
                cargarCuentasPorAuxiliar(val1);
            } else {
                $('#ddlAuxiliar').append('<option value="">Seleccionar auxiliar...</option>');
                $.each(auxiliaresDelRubro, function(index, auxiliar) {
                    var val = auxiliarOptionValue(auxiliar);
                    $('#ddlAuxiliar').append(`<option value="${val}">${auxiliar.DescripcionAuxiliar}</option>`);
                });
            }
        }

		function cargarCuentasPorAuxiliar(auxiliarId) {
			const [cuenta, idTipoAuxiliar] = auxiliarId.split('-');

			$('#ddlCuenta').empty();

			// Buscar el auxiliar en los datos para obtener todas sus cuentas
			if (jsonAuxiliares && jsonAuxiliares.AuxiliaresPorRubro) {
				let todasLasCuentas = [];

				// Buscar en todos los rubros
				Object.keys(jsonAuxiliares.AuxiliaresPorRubro).forEach(codigoRubro => {
					const auxiliares = jsonAuxiliares.AuxiliaresPorRubro[codigoRubro];
					auxiliares.forEach(auxiliar => {
						if (auxiliar.IdTipoAuxiliar === idTipoAuxiliar) {
							// Si tiene lista de cuentas, usar todas
							if (auxiliar.Cuentas && Array.isArray(auxiliar.Cuentas)) {
								auxiliar.Cuentas.forEach(cuentaItem => {
									if (typeof cuentaItem === 'object' && cuentaItem.IdAuxiliar && cuentaItem.Cuenta) {
										// Ya es un objeto con IdAuxiliar y Cuenta
										todasLasCuentas.push(cuentaItem);
									} else if (typeof cuentaItem === 'string') {
										// Es un string, crear objeto
										const cuentaObj = {
											IdAuxiliar: auxiliar.IdAuxiliar,
											Cuenta: cuentaItem
										};
										todasLasCuentas.push(cuentaObj);
									}
								});
							} else if (auxiliar.Cuenta) {
								// Si tiene una sola cuenta, agregarla con IdAuxiliar
								const cuentaObj = {
									IdAuxiliar: auxiliar.IdAuxiliar,
									Cuenta: auxiliar.Cuenta
								};
								todasLasCuentas.push(cuentaObj);
							}
						}
					});
				});
				
				// Eliminar duplicados por IdAuxiliar
				const cuentasUnicas = [];
				const idsVistos = new Set();
				todasLasCuentas.forEach(cuentaItem => {
					if (typeof cuentaItem === 'object' && cuentaItem.IdAuxiliar && !idsVistos.has(cuentaItem.IdAuxiliar)) {
						cuentasUnicas.push(cuentaItem);
						idsVistos.add(cuentaItem.IdAuxiliar);
					} else if (typeof cuentaItem === 'string' && !idsVistos.has(cuentaItem)) {
						cuentasUnicas.push({ IdAuxiliar: null, Cuenta: cuentaItem });
						idsVistos.add(cuentaItem);
					}
				});

				if (cuentasUnicas.length === 1) {
					// Si solo hay una cuenta, seleccionarla automáticamente
					const cuentaItem = cuentasUnicas[0];
					$('#ddlCuenta').append(`<option value="${cuentaItem.IdAuxiliar}">${cuentaItem.Cuenta}</option>`);
					$('#ddlCuenta').val(cuentaItem.IdAuxiliar);
				} else {
					// Si hay múltiples cuentas, mostrar opción de seleccionar
					$('#ddlCuenta').append('<option value="">Seleccionar cuenta...</option>');
					cuentasUnicas.forEach(cuentaItem => {
						$('#ddlCuenta').append(`<option value="${cuentaItem.IdAuxiliar}">${cuentaItem.Cuenta}</option>`);
					});
					// Seleccionar automáticamente la opción "Seleccionar cuenta..."
					$('#ddlCuenta').val('');
				}
			} else {
				// Fallback: usar la cuenta original
				$('#ddlCuenta').append(`<option value="${cuenta}">${cuenta}</option>`);
				$('#ddlCuenta').val(cuenta);
			}
		}

        function cargarTransaccionesPorRubro(codigoRubro) {
            if (!jsonAuxiliares || !jsonAuxiliares.TransaccionesPorRubro || !jsonAuxiliares.TransaccionesPorRubro[codigoRubro]) {
                return;
            }
            
            const transacciones = jsonAuxiliares.TransaccionesPorRubro[codigoRubro];
            $('#ddlCodigoTransaccion').empty();
            
            // Si solo hay una Transacción, no mostrar opción "Seleccionar..."
            if (transacciones.length === 1) {
                $('#ddlCodigoTransaccion').append(`<option value="${transacciones[0].CodigoTransaccion}">${transacciones[0].DescripcionTransaccion}</option>`);
            } else {
                $('#ddlCodigoTransaccion').append('<option value="">Seleccionar código...</option>');
                $.each(transacciones, function(index, transaccion) {
                    $('#ddlCodigoTransaccion').append(`<option value="${transaccion.CodigoTransaccion}">${transaccion.DescripcionTransaccion}</option>`);
                });
            }
        }

        function limpiarDropdowns(selectores) {
            $.each(selectores, function(index, selector) {
                $(selector).empty().append('<option value="">Seleccionar...</option>');
            });
        }

        function crearChipIdentificacion(codTipoDoc, numeroIdentificacion) {
            return crearChipTipoDocumento(codTipoDoc, numeroIdentificacion);
        }

        // --- Lote de transacciones (mismo asociado) ---
        function actualizarEstadoBotonAsociado() {
            var hayItems = listaTransaccionesPendientes.length > 0;
            $('#btnEliminarAsociado').prop('disabled', hayItems);
            $('#btnBuscarAsociado').prop('disabled', hayItems);
            if (hayItems) {
                $('#btnEliminarAsociado').attr('title', 'Vacíe el lote de transacciones antes de cambiar de asociado');
            } else {
                $('#btnEliminarAsociado').removeAttr('title');
            }
        }

        /** Devuelve el índice (0-based) de la primera transacción duplicada, o -1 si no hay duplicado. No se considera el monto (rubro+auxiliar+cuenta+transacción). */
        function indiceDuplicadoEnLote(codigoRubro, auxiliarKey, idAuxiliar, codigoTransaccion) {
            for (var i = 0; i < listaTransaccionesPendientes.length; i++) {
                var it = listaTransaccionesPendientes[i];
                if (it.CodigoRubro === codigoRubro &&
                    it.AuxiliarKey === auxiliarKey &&
                    String(it.IDAuxiliar) === String(idAuxiliar) &&
                    it.CodigoTransaccion === codigoTransaccion) {
                    return i;
                }
            }
            return -1;
        }

        function completarPushItemAlLote(item, onDone) {
            listaTransaccionesPendientes.push(item);
            actualizarJsonYTablaLote();
            actualizarEstadoBotonAsociado();
            limpiarFormularioTransaccion();
            ocultarErrorValidacion();
            if (typeof onDone === 'function') onDone(true);
        }

        /** PR: simula con el SP; si Resultado es error no llama onOk. */
        function ejecutarSiSimulacionPrestamoOk(item, onOk, onFail) {
            if (!esRubroPrestamo(item.CodigoRubro)) {
                onOk();
                return;
            }
            if (!asociadoSeleccionado || !asociadoSeleccionado.numeroAsociado) {
                showToast('error', 'Simulación', 'No hay asociado seleccionado.');
                if (onFail) onFail();
                return;
            }
            var fail = onFail || function () { };
            $.ajax({
                type: 'POST',
                url: semgaTransPageMethod('SimularMovimiento'),
                data: JSON.stringify({
                    numeroAsociado: parseInt(asociadoSeleccionado.numeroAsociado, 10),
                    codigoRubro: item.CodigoRubro,
                    idAuxiliar: parseInt(item.IDAuxiliar, 10),
                    codigoTransaccion: item.CodigoTransaccion,
                    monto: item.Monto,
                    snSoloCapital: item.SnSoloCapital ? 1 : 0
                }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (response) {
                    var d = response.d;
                    if (!simExito(d)) {
                        showToast('error', 'Simulación', (d && d.Mensaje) ? d.Mensaje : 'No se pudo simular el movimiento.');
                        fail();
                        return;
                    }
                    onOk();
                },
                error: function (xhr, status, err) {
                    showToast('error', 'Simulación', err || xhr.statusText || '');
                    fail();
                }
            });
        }

        /** onDone(true) si se añadió; onDone(false) si validación, simulación o usuario canceló. */
        function añadirTransaccionALista(onDone) {
            if (!validarFormularioTransaccion()) {
                if (typeof onDone === 'function') onDone(false);
                return;
            }
            if (!asociadoSeleccionado || !asociadoSeleccionado.numeroAsociado) {
                mostrarErrorValidacion('No hay un asociado seleccionado');
                if (typeof onDone === 'function') onDone(false);
                return;
            }
            var cantMax = parseInt($('#cantTransLoteMax').val(), 10) || 10;
            if (listaTransaccionesPendientes.length >= cantMax) {
                showToast('warning', 'Lote lleno', 'El lote admite como máximo ' + cantMax + ' transacciones. Debe guardar o eliminar líneas para añadir más.');
                if (typeof onDone === 'function') onDone(false);
                return;
            }
            var codigoRubro = $('#ddlRubro').val();
            var auxiliarKey = $('#ddlAuxiliar').val();
            var idAuxiliar = $('#ddlCuenta').val();
            var codigoTransaccion = $('#ddlCodigoTransaccion').val();
            var montoInput = $('#txtMonto').val().replace(',', '.');
            var monto = parseFloat(montoInput);
            if (!isNaN(monto)) monto = Math.round(monto * 100) / 100;
            var item = {
                CodigoRubro: codigoRubro,
                AuxiliarKey: auxiliarKey,
                IDAuxiliar: idAuxiliar,
                CodigoTransaccion: codigoTransaccion,
                Monto: monto,
                Observaciones: $('#txtObservaciones').val() || '',
                textoAuxiliar: $('#ddlAuxiliar option:selected').text(),
                textoCuenta: $('#ddlCuenta option:selected').text(),
                textoTransaccion: $('#ddlCodigoTransaccion option:selected').text()
            };
            asegurarCamposRubroPrestamo(item);
            var idxDup = indiceDuplicadoEnLote(codigoRubro, auxiliarKey, idAuxiliar, codigoTransaccion);
            var cantMaxDup = parseInt($('#cantTransLoteMax').val(), 10) || 10;
            var notificarFallo = function () {
                if (typeof onDone === 'function') onDone(false);
            };
            if (idxDup >= 0) {
                var numLinea = idxDup + 1;
                if (listaTransaccionesPendientes.length >= cantMaxDup) {
                    showToast('warning', 'Lote lleno', 'El lote admite como máximo ' + cantMaxDup + ' transacciones.');
                    notificarFallo();
                    return;
                }
                showConfirmToast(
                    'warning',
                    'Posible duplicado',
                    'Ya hay en la lista una transacción idéntica en la línea ' + numLinea + '.<br><strong>¿Seguro desea duplicarla?</strong>',
                    function () {
                        if (listaTransaccionesPendientes.length >= cantMaxDup) {
                            showToast('warning', 'Lote lleno', 'No se puede añadir: el lote ya tiene el máximo de ' + cantMaxDup + ' transacciones.');
                            notificarFallo();
                            return;
                        }
                        ejecutarSiSimulacionPrestamoOk(item, function () {
                            completarPushItemAlLote(item, onDone);
                        }, notificarFallo);
                    },
                    function () {
                        showToast('info', 'Operación cancelada', 'No se añadió la transacción.');
                        notificarFallo();
                    }
                );
                return;
            }
            ejecutarSiSimulacionPrestamoOk(item, function () {
                completarPushItemAlLote(item, onDone);
            }, notificarFallo);
        }

        function esRubroPrestamo(codigoRubro) {
            return (codigoRubro || '').toString().trim().toUpperCase() === 'PR';
        }

        /** Variante de simulación según código de transacción (PR). */
        function codigoTransPrSimTipo(ct) {
            ct = (ct || '').toString().trim().toUpperCase();
            if (ct === 'PRRTI') return 'PRRTI';
            if (ct === 'PRRTR') return 'PRRTR';
            return 'PAGO';
        }

        function simExito(d) {
            return d && (d.Resultado === 'SUCCESS' || d.Resultado === 'OK');
        }

        function fmtFechaSimPr(s) {
            if (s == null || s === '') return '—';
            var t = String(s).trim();
            if (/^\d{4}-\d{2}-\d{2}/.test(t)) {
                var p = t.substring(0, 10).split('-');
                return parseInt(p[2], 10) + '/' + parseInt(p[1], 10) + '/' + p[0];
            }
            return t;
        }

        function htmlToolbarSimPr(ct, swId, soloCap, idx) {
            var tipo = codigoTransPrSimTipo(ct);
            var metrics;
            if (tipo === 'PRRTI') {
                metrics = '<div class="lote-pr-metrics sim-badges flex-grow-1">' +
                    '<div class="lote-pr-metric lote-pr-metric--saldo" title="SaldoAuxiliar"><span class="lote-pr-metric-label">Saldo del auxiliar</span><span class="lote-pr-metric-value js-sim-rti-saldo">—</span></div>' +
                    '<div class="lote-pr-metric lote-pr-metric--compact lote-pr-metric--rti-fecha" title="FechaUltCalculoIntereses"><span class="lote-pr-metric-label">ULT. FEC. CÁLCULO</span><span class="lote-pr-metric-value js-sim-rti-fecha">—</span></div>' +
                    '<div class="lote-pr-metric lote-pr-metric--compact lote-pr-metric--rti-intcalc" title="InteresesCalculados"><span class="lote-pr-metric-label">INT. CALCULADOS</span><span class="lote-pr-metric-value js-sim-rti-intcalc">—</span></div>' +
                    '<div class="lote-pr-metric lote-pr-metric--compact lote-pr-metric--rti-intpag" title="InteresesPagados"><span class="lote-pr-metric-label">INT. PAGADOS</span><span class="lote-pr-metric-value js-sim-rti-intpag">—</span></div>' +
                    '<div class="lote-pr-metric lote-pr-metric--compact lote-pr-metric--rti-madev" title="MontoADevolver"><span class="lote-pr-metric-label">Monto a devolver</span><span class="lote-pr-metric-value js-sim-rti-madev">—</span></div>' +
                    '<div class="lote-pr-metric lote-pr-metric--compact lote-pr-metric--rti-nuevopag" title="NuevoInteresPagado"><span class="lote-pr-metric-label">NUEVO INT. PAGADOS</span><span class="lote-pr-metric-value js-sim-rti-nuevopag">—</span></div>' +
                    '</div>';
            } else if (tipo === 'PRRTR') {
                metrics = '<div class="lote-pr-metrics sim-badges flex-grow-1">' +
                    '<div class="lote-pr-metric lote-pr-metric--saldo" title="SaldoAuxiliar"><span class="lote-pr-metric-label">Saldo auxiliar</span><span class="lote-pr-metric-value js-sim-rtr-saldo">—</span></div>' +
                    '<div class="lote-pr-metric lote-pr-metric--compact lote-pr-metric--rtr-madev" title="MontoADevolver"><span class="lote-pr-metric-label">Monto a devolver</span><span class="lote-pr-metric-value js-sim-rtr-madev">—</span></div>' +
                    '<div class="lote-pr-metric lote-pr-metric--compact lote-pr-metric--rtr-nuevo" title="NuevoSaldo"><span class="lote-pr-metric-label">Nuevo saldo</span><span class="lote-pr-metric-value js-sim-rtr-nuevo">—</span></div>' +
                    '</div>';
            } else {
                metrics = '<div class="lote-pr-metrics sim-badges flex-grow-1">' +
                    '<div class="lote-pr-metric lote-pr-metric--saldo" title="SaldoAuxiliar"><span class="lote-pr-metric-label">Saldo del auxiliar</span><span class="lote-pr-metric-value js-sim-saldo">—</span></div>' +
                    '<div class="lote-pr-metric lote-pr-metric--compact lote-pr-metric--tasa" title="TasaInteresPorcentaje"><span class="lote-pr-metric-label">Tasa</span><span class="lote-pr-metric-value js-sim-tasa">—</span></div>' +
                    '<div class="lote-pr-metric lote-pr-metric--compact lote-pr-metric--dias" title="DiasInteresesAGenerar"><span class="lote-pr-metric-label">Días interés</span><span class="lote-pr-metric-value js-sim-dias">—</span></div>' +
                    '<div class="lote-pr-metric lote-pr-metric--compact lote-pr-metric--intgen" title="MontoInteresesAGenerar"><span class="lote-pr-metric-label">Int. a generar</span><span class="lote-pr-metric-value js-sim-montointgen">—</span></div>' +
                    '<div class="lote-pr-metric lote-pr-metric--compact lote-pr-metric--aplint" title="MontoAAplicarIntereses"><span class="lote-pr-metric-label">Aplic. intereses</span><span class="lote-pr-metric-value js-sim-aplint">—</span></div>' +
                    '<div class="lote-pr-metric lote-pr-metric--compact lote-pr-metric--aplcap" title="MontoAAplicarCapital"><span class="lote-pr-metric-label">Aplic. capital</span><span class="lote-pr-metric-value js-sim-aplcap">—</span></div>' +
                    '</div>';
            }
            if (tipo !== 'PAGO') return metrics;
            return metrics +
                '<div class="lote-pr-switch-wrap">' +
                '<label class="lote-pr-switch-entire" for="' + swId + '">' +
                '<span class="lote-pr-switch-title">Solo capital</span>' +
                '<div class="lote-pr-switch-center">' +
                '<input class="lote-pr-solo-capital-switch lote-pr-sr-input" type="checkbox" role="switch" id="' + swId + '" data-lote-idx="' + idx + '"' + (soloCap ? ' checked' : '') + '>' +
                '<span class="lote-pr-switch-ui-track" aria-hidden="true">' +
                '<span class="lote-pr-switch-ui-txt lote-pr-switch-ui-no">NO</span>' +
                '<span class="lote-pr-switch-ui-txt lote-pr-switch-ui-si">SI</span>' +
                '<span class="lote-pr-switch-ui-thumb"></span>' +
                '</span></div></label></div>';
        }

        function aplicarResultadoSimulacionPr($detail, it, d) {
            if (!simExito(d)) return;
            it.Simulacion = d;
            var tipo = codigoTransPrSimTipo(it.CodigoTransaccion);
            if (tipo === 'PRRTI') {
                $detail.find('.js-sim-rti-saldo').text(fmtSaldoAuxiliar(d.SaldoAuxiliar));
                $detail.find('.js-sim-rti-fecha').text(fmtFechaSimPr(d.FechaUltCalculoIntereses));
                $detail.find('.js-sim-rti-intcalc').text(fmtSaldoAuxiliar(d.InteresesCalculados));
                $detail.find('.js-sim-rti-intpag').text(fmtSaldoAuxiliar(d.InteresesPagados));
                $detail.find('.js-sim-rti-madev').text(fmtSaldoAuxiliar(d.MontoADevolver));
                $detail.find('.js-sim-rti-nuevopag').text(fmtSaldoAuxiliar(d.NuevoInteresPagado));
            } else if (tipo === 'PRRTR') {
                $detail.find('.js-sim-rtr-saldo').text(fmtSaldoAuxiliar(d.SaldoAuxiliar));
                $detail.find('.js-sim-rtr-madev').text(fmtSaldoAuxiliar(d.MontoADevolver));
                $detail.find('.js-sim-rtr-nuevo').text(fmtSaldoAuxiliar(d.NuevoSaldo));
            } else {
                $detail.find('.js-sim-saldo').text(fmtSaldoAuxiliar(d.SaldoAuxiliar));
                $detail.find('.js-sim-tasa').text(fmtTasaInteresPorcentaje(d.TasaInteresPorcentaje));
                $detail.find('.js-sim-dias').text(d.DiasInteresesAGenerar != null ? d.DiasInteresesAGenerar : '—');
                $detail.find('.js-sim-montointgen').text(fmtSaldoAuxiliar(d.MontoInteresesAGenerar));
                $detail.find('.js-sim-aplint').text(fmtSaldoAuxiliar(d.MontoAAplicarIntereses));
                $detail.find('.js-sim-aplcap').text(fmtSaldoAuxiliar(d.MontoAAplicarCapital));
            }
        }

        function asegurarCamposRubroPrestamo(item) {
            if (!item || !esRubroPrestamo(item.CodigoRubro)) return;
            if (typeof item.SnSoloCapital !== 'boolean') item.SnSoloCapital = false;
        }

        /** JSON del hidden #jsonTransaccionesLote: misma forma que consume OPENJSON (snSoloCapital 0/1 en PR). */
        function serializarLineaLoteParaHidden(it, index) {
            var idAux = it.IDAuxiliar;
            if (typeof idAux !== 'number') idAux = parseInt(idAux, 10);
            if (isNaN(idAux)) idAux = null;
            var o = {
                NumeroLinea: index + 1,
                CodigoRubro: it.CodigoRubro,
                IDAuxiliar: idAux,
                CodigoTransaccion: it.CodigoTransaccion,
                Monto: it.Monto,
                Observaciones: it.Observaciones || ''
            };
            if (esRubroPrestamo(it.CodigoRubro)) {
                o.snSoloCapital = it.SnSoloCapital ? 1 : 0;
            }
            return o;
        }

        function serializarListaLoteParaInputHidden(arr) {
            if (!arr || !arr.length) return [];
            var out = [];
            for (var i = 0; i < arr.length; i++) {
                out.push(serializarLineaLoteParaHidden(arr[i], i));
            }
            return out;
        }

        function actualizarHiddenJsonLote() {
            $('#jsonTransaccionesLote').val(JSON.stringify(serializarListaLoteParaInputHidden(listaTransaccionesPendientes)));
        }

        function fmtMontoSimPr(n) {
            if (n == null || n === '' || (typeof n === 'number' && isNaN(n))) return '—';
            return Number(n).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        }

        function fmtSaldoAuxiliar(n) {
            if (n == null || n === '' || (typeof n === 'number' && isNaN(n))) return '—';
            return '$' + Number(n).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        }

        /** Tasa desde BD: si viene como decimal 0–1 se muestra como %; si ya es >1 se asume valor en % */
        function fmtTasaInteresPorcentaje(n) {
            if (n == null || n === '' || (typeof n === 'number' && isNaN(n))) return '—';
            var x = Number(n);
            if (x > 0 && x <= 1) x = x * 100;
            return x.toLocaleString('es-PA', { minimumFractionDigits: 2, maximumFractionDigits: 6 }) + '%';
        }

        function crearFilaDetallePrSim(idx, it) {
            var tr = $('<tr class="lote-pr-sim-row"></tr>').attr('data-lote-idx', idx);
            var soloCap = !!it.SnSoloCapital;
            var swId = 'swPrLote' + idx;
            var html = '<td colspan="7">' +
                '<div class="lote-pr-sim-inner">' +
                '<div class="lote-pr-sim-toolbar d-flex flex-nowrap align-items-stretch justify-content-between gap-2">' +
                htmlToolbarSimPr(it.CodigoTransaccion, swId, soloCap, idx) +
                '</div>' +
                '<div class="sim-loading small text-muted mt-2 d-none"><i class="fas fa-spinner fa-spin me-1"></i>Calculando simulación…</div>' +
                '<div class="sim-error small text-danger mt-2 d-none"></div>' +
                '</div></td>';
            tr.html(html);
            tr.find('.lote-pr-solo-capital-switch').on('change', function () {
                var i = parseInt($(this).attr('data-lote-idx'), 10);
                if (isNaN(i) || !listaTransaccionesPendientes[i]) return;
                listaTransaccionesPendientes[i].SnSoloCapital = $(this).is(':checked');
                actualizarHiddenJsonLote();
                simularMovimientoLinea(i);
            });
            return tr;
        }

        function simularMovimientoLinea(idx) {
            var it = listaTransaccionesPendientes[idx];
            if (!it || !esRubroPrestamo(it.CodigoRubro) || !asociadoSeleccionado) return;
            var $detail = $('tr.lote-pr-sim-row[data-lote-idx="' + idx + '"]');
            if (!$detail.length) return;
            $detail.find('.sim-loading').removeClass('d-none');
            $detail.find('.sim-error').addClass('d-none').text('');
            $detail.find('.sim-badges').addClass('opacity-50');
            $.ajax({
                type: 'POST',
                url: semgaTransPageMethod('SimularMovimiento'),
                data: JSON.stringify({
                    numeroAsociado: parseInt(asociadoSeleccionado.numeroAsociado, 10),
                    codigoRubro: it.CodigoRubro,
                    idAuxiliar: parseInt(it.IDAuxiliar, 10),
                    codigoTransaccion: it.CodigoTransaccion,
                    monto: it.Monto,
                    snSoloCapital: it.SnSoloCapital ? 1 : 0
                }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (response) {
                    $detail.find('.sim-loading').addClass('d-none');
                    $detail.find('.sim-badges').removeClass('opacity-50');
                    var d = response.d;
                    if (!d || !simExito(d)) {
                        $detail.find('.sim-error').removeClass('d-none').text((d && d.Mensaje) ? d.Mensaje : 'No se pudo simular.');
                        return;
                    }
                    aplicarResultadoSimulacionPr($detail, it, d);
                },
                error: function (xhr, status, err) {
                    $detail.find('.sim-loading').addClass('d-none');
                    $detail.find('.sim-badges').removeClass('opacity-50');
                    $detail.find('.sim-error').removeClass('d-none').text('Error: ' + (err || xhr.statusText || ''));
                }
            });
        }

        function actualizarJsonYTablaLote() {
            actualizarHiddenJsonLote();
            var tbody = $('#tbodyTransaccionesLote');
            tbody.empty();
            if (listaTransaccionesPendientes.length === 0) {
                $('#divListaVacia').show();
                $('#tblTransaccionesLote').hide();
            } else {
                $('#divListaVacia').hide();
                $('#tblTransaccionesLote').show();
                $.each(listaTransaccionesPendientes, function(i, it) {
                    asegurarCamposRubroPrestamo(it);
                    var montoFmt = it.Monto.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
                    var tr = $('<tr class="lote-linea-main"></tr>').attr('data-numero-linea', i + 1).attr('data-lote-idx', i);
                    tr.append($('<td class="text-center"></td>').text(i + 1));
                    tr.append($('<td></td>').text(it.textoAuxiliar || ''));
                    tr.append($('<td></td>').text(it.textoCuenta || ''));
                    tr.append($('<td></td>').text(it.textoTransaccion || ''));
                    tr.append($('<td class="text-end"></td>').text(montoFmt));
                    tr.append($('<td class="td-mensaje-lote small"></td>').text(it.Mensaje || ''));
                    var acc = $('<td class="text-nowrap"></td>');
                    acc.append($('<button type="button" class="btn btn-outline-primary btn-sm py-0 px-1" title="Editar"><i class="fas fa-edit"></i></button>').on('click', function() { editarEnLista(i); }));
                    acc.append(' ');
                    acc.append($('<button type="button" class="btn btn-outline-danger btn-sm py-0 px-1" title="Eliminar"><i class="fas fa-trash-alt"></i></button>').on('click', function() {
                        var idx = i;
                        showConfirmToast('warning', 'Eliminar línea', '¿Eliminar esta transacción del lote?', function() {
                            eliminarDeLista(idx);
                            showToast('success', 'Línea eliminada', 'Se quitó la transacción del lote.');
                        }, function() {
                            showToast('info', 'Operación cancelada', 'No se eliminó la línea.');
                        });
                    }));
                    tr.append(acc);
                    tbody.append(tr);
                    if (esRubroPrestamo(it.CodigoRubro)) {
                        tbody.append(crearFilaDetallePrSim(i, it));
                    }
                });
                for (var j = 0; j < listaTransaccionesPendientes.length; j++) {
                    if (esRubroPrestamo(listaTransaccionesPendientes[j].CodigoRubro)) {
                        simularMovimientoLinea(j);
                    }
                }
            }
        }

        function eliminarDeLista(index) {
            listaTransaccionesPendientes.splice(index, 1);
            actualizarJsonYTablaLote();
            actualizarEstadoBotonAsociado();
        }

        function editarEnLista(index) {
            if (tieneDatosCapturados()) {
                showConfirmToast(
                    'warning',
                    'Advertencia',
                    'Hay datos capturados en el formulario de la transacción. Al editar esta fila se perderán.<br><strong>¿Desea continuar?</strong>',
                    function() {
                        procederConEditarEnLista(index);
                    },
                    function() {
                        showToast('info', 'Operación cancelada', 'No se cargaron los datos de la fila.');
                    }
                );
                return;
            }
            procederConEditarEnLista(index);
        }

        function procederConEditarEnLista(index) {
            var it = listaTransaccionesPendientes[index];
            $('#ddlRubro').val(it.CodigoRubro).trigger('change');
            setTimeout(function() {
                $('#ddlAuxiliar').val(it.AuxiliarKey || '').trigger('change');
                setTimeout(function() {
                    $('#ddlCuenta').val(it.IDAuxiliar);
                    $('#ddlCodigoTransaccion').val(it.CodigoTransaccion);
                    $('#txtMonto').val(typeof it.Monto === 'number' && !isNaN(it.Monto) ? it.Monto.toFixed(2) : it.Monto);
                    $('#txtObservaciones').val(it.Observaciones || '');
                    eliminarDeLista(index);
                }, 150);
            }, 150);
        }

        function cancelarGlobal() {
            showConfirmToast('warning', 'Cancelar todo', 'Se borrará el asociado y todas las transacciones del lote.<br><strong>¿Continuar?</strong>',
                function() {
                    eliminarAsociadoSeleccionado();
                    semgaTransaccionesReload();
                },
                function() { showToast('info', 'Operación cancelada', ''); }
            );
        }

        /** Construye un ítem de transacción desde el formulario actual (misma estructura que el lote). */
        function construirItemDesdeFormulario() {
            var codigoRubro = $('#ddlRubro').val();
            var auxiliarKey = $('#ddlAuxiliar').val();
            var idAuxiliar = $('#ddlCuenta').val();
            var codigoTransaccion = $('#ddlCodigoTransaccion').val();
            var montoInput = $('#txtMonto').val().replace(',', '.');
            var monto = parseFloat(montoInput);
            if (!isNaN(monto)) monto = Math.round(monto * 100) / 100;
            var o = {
                CodigoRubro: codigoRubro,
                AuxiliarKey: auxiliarKey,
                IDAuxiliar: idAuxiliar,
                CodigoTransaccion: codigoTransaccion,
                Monto: monto,
                Observaciones: $('#txtObservaciones').val() || '',
                textoAuxiliar: $('#ddlAuxiliar option:selected').text(),
                textoCuenta: $('#ddlCuenta option:selected').text(),
                textoTransaccion: $('#ddlCodigoTransaccion option:selected').text()
            };
            asegurarCamposRubroPrestamo(o);
            return o;
        }

        /** Arma el arreglo de transacciones a guardar: lista del lote o, si está vacía, una transacción desde el formulario si está completo. */
        function obtenerTransaccionesParaGuardar() {
            if (listaTransaccionesPendientes.length > 0) {
                return listaTransaccionesPendientes.slice();
            }
            if (validarFormularioTransaccion() && asociadoSeleccionado && asociadoSeleccionado.numeroAsociado) {
                return [construirItemDesdeFormulario()];
            }
            return null;
        }

        /** Convierte un ítem interno a payload para el SP (OPENJSON): NumeroLinea, NumeroAsociado, …; rubro PR incluye snSoloCapital 0/1. */
        function itemAPayload(it, index) {
            var idAux = it.IDAuxiliar;
            if (typeof idAux !== 'number') idAux = parseInt(idAux, 10);
            if (isNaN(idAux)) idAux = null;
            var p = {
                NumeroLinea: (index != null ? index + 1 : 1),
                NumeroAsociado: asociadoSeleccionado ? asociadoSeleccionado.numeroAsociado : null,
                CodigoRubro: it.CodigoRubro,
                IDAuxiliar: idAux,
                CodigoTransaccion: it.CodigoTransaccion,
                Monto: it.Monto,
                Observaciones: it.Observaciones || ''
            };
            if (esRubroPrestamo(it.CodigoRubro)) {
                p.snSoloCapital = it.SnSoloCapital ? 1 : 0;
            }
            return p;
        }

        var loteGuardadoExito = false;
        var ultimoLoteDetalles = [];
        var ultimoIDTransaccion = null;

        function guardarLote() {
            if (loteGuardadoExito) return;
            function continuarConfirmacionGuardado() {
                var transacciones = obtenerTransaccionesParaGuardar();
                if (!transacciones || transacciones.length === 0) {
                    mostrarErrorValidacion('Añada al menos una transacción al lote o complete el formulario de datos de la transacción antes de guardar.');
                    return;
                }
                var numeroAsociado = asociadoSeleccionado ? parseInt(asociadoSeleccionado.numeroAsociado, 10) : 0;
                if (!numeroAsociado) {
                    mostrarErrorValidacion('No hay asociado seleccionado.');
                    return;
                }
                var n = transacciones.length;
                var textoCantidad = n === 1 ? '1 transacción' : n + ' transacciones';
                showConfirmToast('warning', 'Confirmar guardado', '¿Seguro desea guardar estas ' + textoCantidad + '?', function() {
                    enviarLoteAlServidor(transacciones, numeroAsociado);
                }, function() {
                    showToast('info', 'Operación cancelada', 'No se guardó el lote.');
                });
            }
            if (listaTransaccionesPendientes.length === 0 && validarFormularioTransaccion() && asociadoSeleccionado && asociadoSeleccionado.numeroAsociado) {
                añadirTransaccionALista(function (ok) {
                    if (ok) continuarConfirmacionGuardado();
                });
                return;
            }
            continuarConfirmacionGuardado();
        }

        function enviarLoteAlServidor(transacciones, numeroAsociado) {
            var payload = transacciones.map(function(it, i) { return itemAPayload(it, i); });
            var jsonLote = JSON.stringify(payload);
            $('#btnGuardarLote').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-1"></i>Guardando...');
            $.ajax({
                type: 'POST',
                url: semgaTransPageMethod('GuardarLote'),
                data: JSON.stringify({ numeroAsociado: numeroAsociado, jsonLote: jsonLote }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function(response) {
                    var d = response.d;
                    if (!d) {
                        showToast('error', 'Error', 'No se recibió respuesta del servidor.');
                        $('#btnGuardarLote').prop('disabled', false).html('<i class="fas fa-save me-1"></i>Guardar');
                        return;
                    }
                    var detalles = d.Detalles || [];
                    ultimoLoteDetalles = detalles;
                    if (d.IDTransaccion != null && d.IDTransaccion !== undefined) ultimoIDTransaccion = d.IDTransaccion;
                    actualizarMensajesEnTablaLote(detalles);
                    if (d.Resultado === 'SUCCESS') {
                        showToast('success', 'Guardado', d.Mensaje || 'Lote procesado correctamente.');
                        congelarLoteExitoso();
                        loteGuardadoExito = true;
                    } else {
                        showToast('error', 'Error', d.Mensaje || 'Hubo errores en el lote.');
                    }
                    $('#btnGuardarLote').prop('disabled', false).html('<i class="fas fa-save me-1"></i>Guardar');
                },
                error: function(xhr, status, err) {
                    showToast('error', 'Error', 'Error al guardar el lote: ' + (err || xhr.statusText));
                    $('#btnGuardarLote').prop('disabled', false).html('<i class="fas fa-save me-1"></i>Guardar');
                }
            });
        }

        /** Rellena la columna Mensaje de la tabla del lote con los Detalles devueltos por el SP (por NumeroLinea). */
        function actualizarMensajesEnTablaLote(detalles) {
            if (!detalles || !detalles.length) return;
            var map = {};
            for (var i = 0; i < detalles.length; i++) {
                var num = detalles[i].NumeroLinea;
                if (num != null) map[num] = detalles[i];
            }
            $('#tbodyTransaccionesLote tr.lote-linea-main').each(function() {
                var num = parseInt($(this).attr('data-numero-linea'), 10);
                var det = map[num];
                var $td = $(this).find('.td-mensaje-lote');
                if ($td.length && det) {
                    $td.text(det.Mensaje || '').removeClass('text-success text-danger');
                    if ((det.Mensaje || '').toUpperCase() === 'OK') $td.addClass('text-success');
                    else if (det.Mensaje) $td.addClass('text-danger');
                }
            });
        }

        /** Deshabilita formulario y tabla de lote, oculta Guardar y muestra Imprimir. */
        function congelarLoteExitoso() {
            $('#divFormularioTransaccion input, #divFormularioTransaccion select').prop('disabled', true);
            $('#btnAnadirTransaccion, #btnCancelarTransaccion').prop('disabled', true);
            $('#tbodyTransaccionesLote .btn').prop('disabled', true).addClass('disabled');
            $('#tbodyTransaccionesLote .lote-pr-solo-capital-switch').prop('disabled', true);
            $('#btnGuardarLote').hide();
            $('#btnImprimirLote').show();
        }

        function escapeHtml(text) {
            var div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        function validarFormularioTransaccion() {
            // Validar que haya un asociado seleccionado
            if (!asociadoSeleccionado || !asociadoSeleccionado.numeroAsociado) {
                mostrarErrorValidacion('Por favor seleccione un asociado');
                return false;
            }
            
            const camposRequeridos = ['#ddlRubro', '#ddlAuxiliar', '#ddlCuenta', '#ddlCodigoTransaccion', '#txtMonto'];
            let valido = true;

            camposRequeridos.forEach(function(campo) {
                const valor = $(campo).val();
                if (!valor) {
                    $(campo).addClass('is-invalid');
                    valido = false;
                } else {
                    $(campo).removeClass('is-invalid');
                }
            });

            if (!valido) {
                mostrarErrorValidacion('Por favor complete todos los campos requeridos');
            }

            return valido;
        }

        function limpiarFormularioTransaccion() {
            // Solo limpia los campos del formulario de datos (no toca asociado ni lista del lote)
            $('#txtMonto').val('');
            $('#txtObservaciones').val('');
            $('.form-control, .form-select').removeClass('is-invalid');
            if (jsonAuxiliares && jsonAuxiliares.Rubros) {
                $('#ddlRubro').empty();
                if (jsonAuxiliares.Rubros.length === 1) {
                    $('#ddlRubro').append('<option value="' + jsonAuxiliares.Rubros[0].CodigoRubro + '">' + jsonAuxiliares.Rubros[0].DescripcionRubro + '</option>');
                } else {
                    $('#ddlRubro').append('<option value="">Seleccionar rubro...</option>');
                    $.each(jsonAuxiliares.Rubros, function(i, r) {
                        $('#ddlRubro').append('<option value="' + r.CodigoRubro + '">' + r.DescripcionRubro + '</option>');
                    });
                }
                $('#ddlAuxiliar').empty().append('<option value="">Seleccionar auxiliar...</option>');
                $('#ddlCuenta').empty().append('<option value="">Seleccionar cuenta...</option>');
                $('#ddlCodigoTransaccion').empty().append('<option value="">Seleccionar código...</option>');
            }
            ocultarErrorValidacion();
        }

        function mostrarModalComprobante(htmlContent, capitalMovimientoId, interesesMovimientoId) {
            // Crear el modal del comprobante
            const modalHtml = `
                <div id="modalComprobante" class="comprobante-modal-overlay">
                    <div class="comprobante-modal">
                        <div class="comprobante-modal-header">
                            <h5><i class="fas fa-receipt text-primary"></i> Comprobante de Transacción</h5>
                            <button type="button" class="btn-close-custom" onclick="cerrarModalComprobante()">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                        <div class="comprobante-modal-body">
                            <div class="comprobante-container">
                                ${htmlContent}
                            </div>
                        </div>
                        <div class="comprobante-modal-footer">
                            <button type="button" class="btn btn-secondary" onclick="cerrarModalComprobante()">
                                <i class="fas fa-times"></i> Cerrar
                            </button>
                            <button type="button" class="btn btn-primary" onclick="imprimirDesdeModal('${capitalMovimientoId || ''}', '${interesesMovimientoId || ''}')">
                                <i class="fas fa-print"></i> Imprimir
                            </button>
                        </div>
                    </div>
                </div>
            `;

            // Agregar el modal al body
            $('body').append(modalHtml);
            
            // Agregar estilos si no existen
            if (!$('#comprobanteModalStyles').length) {
                $('head').append(`
                    <style id="comprobanteModalStyles">
                        .comprobante-modal-overlay {
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
                        
                        .comprobante-modal {
                            background: white;
                            border-radius: 12px;
                            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.4);
                            width: 95%;
                            max-width: 900px;
                            max-height: 95vh;
                            overflow: hidden;
                            animation: modalSlideIn 0.3s ease-out;
                            display: flex;
                            flex-direction: column;
                        }
                        
                        .comprobante-modal-header {
                            background: linear-gradient(135deg, #2c3e50, #34495e);
                            color: white;
                            padding: 15px 20px;
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            flex-shrink: 0;
                        }
                        
                        .comprobante-modal-header h5 {
                            margin: 0;
                            font-size: 18px;
                            font-weight: 600;
                        }
                        
                        .comprobante-modal-body {
                            flex: 1;
                            overflow: auto;
                            padding: 20px;
                            background: #f8f9fa;
                        }
                        
                        .comprobante-container {
                            background: white;
                            border-radius: 8px;
                            padding: 20px;
                            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                            /* Removido max-height y overflow-y para evitar doble scroll */
                        }
                        
                        .comprobante-modal-footer {
                            padding: 15px 20px;
                            background: #f8f9fa;
                            border-top: 1px solid #dee2e6;
                            display: flex;
                            justify-content: flex-end;
                            gap: 10px;
                            flex-shrink: 0;
                        }
                        
                        /* Ocultar botones del comprobante en el modal */
                        .comprobante-container .no-print {
                            display: none !important;
                        }
                        
                        /* Ajustar el tamaño del comprobante en el modal */
                        .comprobante-container .comprobante {
                            height: auto !important;
                            margin-bottom: 10px;
                        }
                        
                        /* Botones del modal */
                        .comprobante-modal-footer .btn {
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
                        
                        .comprobante-modal-footer .btn-secondary {
                            background: #6c757d;
                            color: white;
                        }
                        
                        .comprobante-modal-footer .btn-secondary:hover {
                            background: #5a6268;
                        }
                        
                        .comprobante-modal-footer .btn-primary {
                            background: #007bff;
                            color: white;
                        }
                        
                        .comprobante-modal-footer .btn-primary:hover {
                            background: #0056b3;
                        }
                    </style>
                `);
            }
        }

        function imprimirComprobanteLotePorId(idTrans) {
            $.ajax({
                type: 'POST',
                url: semgaTransPageMethod('GenerarComprobanteLote'),
                data: JSON.stringify({ idTrans: idTrans }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        mostrarModalComprobante(response.d.Html, '', '');
                    } else {
                        if (typeof showToast === 'function') {
                            showToast('error', 'Error', (response.d && response.d.Mensaje) || 'Error al generar comprobante.');
                        } else {
                            alert((response.d && response.d.Mensaje) || 'Error al generar comprobante.');
                        }
                    }
                },
                error: function(xhr, status, err) {
                    var msg = 'Error al generar comprobante: ' + (err || xhr.statusText);
                    if (typeof showToast === 'function') {
                        showToast('error', 'Error', msg);
                    } else {
                        alert(msg);
                    }
                }
            });
        }

        function cerrarModalComprobante() {
            $('#modalComprobante').remove();
        }

        function imprimirDesdeModal(capitalMovimientoId, interesesMovimientoId) {
            // Crear una ventana temporal para imprimir
            const ventanaImpresion = window.open('', '_blank', 'width=800,height=600');
            
            // Obtener el contenido del comprobante del modal
            const contenidoComprobante = $('#modalComprobante .comprobante-container').html();
            
            // Escribir el contenido en la ventana de impresión
            ventanaImpresion.document.write(`
                <!DOCTYPE html>
                <html>
                <head>
                    <title>Comprobante de Transacción</title>
                    <style>
                        body { margin: 0; padding: 20px; font-family: Arial, sans-serif; }
                        .comprobante { height: auto !important; }
                        .no-print { display: none !important; }
                    </style>
                </head>
                <body>
                    ${contenidoComprobante}
                </body>
                </html>
            `);
            
            ventanaImpresion.document.close();
            
            // Imprimir cuando la ventana esté lista
            ventanaImpresion.onload = function() {
                setTimeout(() => {
                    ventanaImpresion.print();
                    ventanaImpresion.close();
                }, 500);
            };
            
            // Cerrar el modal
            cerrarModalComprobante();
        }

        function volverDashboard() {
            semgaIrDashboard();
        }
        
        // Funciones para manejar el div de mensajes (error/éxito)
        function mostrarErrorValidacion(mensaje) {
            $('#lblMensajeError').html(mensaje); // Usar html() en lugar de text() para interpretar HTML
            $('#divErrorValidacion').removeClass('d-none alert-success').addClass('alert-danger');
            $('#divErrorValidacion i').removeClass('fa-check-circle fa-lg text-success').addClass('fa-exclamation-triangle fa-lg text-danger');
            $('#divErrorValidacion strong').text('Error de Validación');
        }
        
        function mostrarExitoValidacion(mensaje) {
            $('#lblMensajeError').html(mensaje); // Usar html() en lugar de text() para interpretar HTML
            $('#divErrorValidacion').removeClass('d-none alert-danger').addClass('alert-success');
            $('#divErrorValidacion i').removeClass('fa-exclamation-triangle fa-lg text-danger').addClass('fa-check-circle fa-lg text-success');
            $('#divErrorValidacion strong').text('Éxito');
        }
        
        function ocultarMensajes() {
            $('#divErrorValidacion').addClass('d-none');
        }
        
        function ocultarErrorValidacion() {
            ocultarMensajes();
        }

        // Funciones de Toast Notifications
        function showToast(type, title, message, duration = 4000) {
            const toastId = 'toast-' + Date.now();
            const iconClass = getToastIcon(type);
            const toastClass = 'toast-' + type;
            
            const toastHtml = `
                <div class="toast ${toastClass}" id="${toastId}" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="toast-header">
                        <i class="${iconClass} me-2"></i>
                        <strong class="me-auto">${title}</strong>
                        <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                    </div>
                    <div class="toast-body">
                        ${message}
                    </div>
                </div>
            `;
            
            $('#toastContainer').append(toastHtml);
            
            const toastElement = new bootstrap.Toast(document.getElementById(toastId), {
                delay: duration
            });
            
            toastElement.show();
        }

        function getToastIcon(type) {
            switch(type) {
                case 'success': return 'fas fa-check-circle text-success';
                case 'error': return 'fas fa-exclamation-circle text-danger';
                case 'warning': return 'fas fa-exclamation-triangle text-warning';
                case 'info': return 'fas fa-info-circle text-info';
                default: return 'fas fa-info-circle text-info';
            }
        }

        /** Confirm centrado en pantalla (overlay propio, no depende de notifications.js ni caché). */
        function showConfirmToast(type, title, message, onConfirm, onCancel) {
            var overlay = document.createElement('div');
            overlay.setAttribute('role', 'dialog');
            overlay.setAttribute('aria-modal', 'true');
            overlay.style.cssText = 'position:fixed;inset:0;width:100%;height:100%;display:flex;justify-content:center;align-items:center;z-index:99999;background:rgba(0,0,0,0.3);padding:1rem;box-sizing:border-box;';
            var iconClass = getToastIcon(type);
            var toastClass = 'toast-' + type;
            var boxId = 'confirmBox-' + Date.now();
            var boxHtml = '<div id="' + boxId + '" class="toast show ' + toastClass + ' shadow" style="min-width:320px;max-width:90vw;opacity:1;">' +
                '<div class="toast-header"><i class="' + iconClass + ' me-2"></i><strong class="me-auto">' + (title || '') + '</strong></div>' +
                '<div class="toast-body">' +
                '<div class="mb-3">' + (message || '') + '</div>' +
                '<div class="d-flex gap-2 justify-content-end">' +
                '<button type="button" class="btn btn-sm btn-outline-secondary btn-cancel-confirm"><i class="fas fa-times me-1"></i>Cancelar</button>' +
                '<button type="button" class="btn btn-sm btn-primary btn-ok-confirm"><i class="fas fa-check me-1"></i>Confirmar</button>' +
                '</div></div></div>';
            overlay.innerHTML = boxHtml;
            document.body.appendChild(overlay);
            var box = document.getElementById(boxId);
            function closeConfirm() {
                if (overlay.parentNode) overlay.parentNode.removeChild(overlay);
            }
            overlay.querySelector('.btn-ok-confirm').addEventListener('click', function() {
                if (typeof onConfirm === 'function') onConfirm();
                closeConfirm();
            });
            overlay.querySelector('.btn-cancel-confirm').addEventListener('click', function() {
                if (typeof onCancel === 'function') onCancel();
                closeConfirm();
            });
            overlay.addEventListener('click', function(e) {
                if (e.target === overlay) {
                    if (typeof onCancel === 'function') onCancel();
                    closeConfirm();
                }
            });
        }

        // Función para marcar el comprobante como impreso
        function marcarComprobanteComoImpreso(capitalMovimientoId, interesesMovimientoId) {
            $.ajax({
                type: 'POST',
                url: semgaTransPageMethod('MarcarComprobanteImpreso'),
                data: JSON.stringify({ 
                    capitalMovimientoId: capitalMovimientoId || '',
                    interesesMovimientoId: interesesMovimientoId || ''
                }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function(response) {
                    if (response.d.Resultado === 'SUCCESS') {
                        showToast('success', 'Éxito', 'Comprobante marcado como impreso');
                    } else {
                        showToast('error', 'Error', 'Error al marcar comprobante como impreso: ' + response.d.Mensaje);
                    }
                },
                error: function(xhr, status, error) {
                    showToast('error', 'Error', 'Error al marcar comprobante como impreso: ' + error);
                }
            });
        }

        window.imprimirComprobanteLotePorId = imprimirComprobanteLotePorId;
        window.mostrarModalComprobante = mostrarModalComprobante;
    </script>
</body>
</html>

















