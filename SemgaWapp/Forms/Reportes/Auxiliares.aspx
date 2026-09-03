<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Auxiliares.aspx.vb" Inherits="SemgaWapp.Auxiliares" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Reporte de Auxiliares</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css"/>
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" rel="stylesheet"/>
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet"/>
    <link href="../../Scripts/toast-global.css" rel="stylesheet"/>
    
    <style>
        body {
            background: #f8f9fa;
            height: 100vh;
            overflow: hidden;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
        }

        * { box-sizing: border-box; }

        html, body { overflow-x: hidden; }
        
        .main-container {
            background: #ffffff;
            border-radius: 6px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin: 15px;
            padding: 15px;
            border: 1px solid #e9ecef;
            overflow: hidden;
            height: calc(100vh - 30px);
            width: calc(100vw - 30px);
            display: flex;
            flex-direction: column;
            min-height: 0;
        }

        .barra-reporte-auxiliares {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
            flex-shrink: 0;
        }

        .barra-reporte-auxiliares .titulo-reporte {
            font-size: 18px;
            font-weight: 700;
            color: #2c3e50;
            line-height: 1.15;
            text-align: center;
            white-space: nowrap;
        }

        .barra-reporte-auxiliares .filters-section {
            flex: 1;
            margin-bottom: 0;
            padding: 8px 12px;
        }

        .barra-reporte-auxiliares .back-btn {
            flex-shrink: 0;
            padding: 6px 14px;
            font-size: 13px;
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
            text-decoration: none;
        }
        
        .filters-section {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            padding: 15px;
            flex-shrink: 0;
        }
        
        .filter-label {
            font-weight: 500;
            color: #495057;
            font-size: 13px;
            white-space: nowrap;
            margin: 0;
            display: block;
        }

        .filters-toolbar {
            display: flex;
            flex-wrap: nowrap;
            align-items: flex-end;
            gap: 10px;
            width: 100%;
        }

        .filters-toolbar .filter-field {
            display: flex;
            flex-direction: column;
            gap: 4px;
            flex: 1 1 0;
            min-width: 0;
        }

        .filters-toolbar .filter-field--asociado {
            flex: 1.5 1 160px;
        }

        .filters-toolbar .filter-field--rubro,
        .filters-toolbar .filter-field--tipo {
            flex: 1.2 1 140px;
        }

        .filters-toolbar .filter-field--periodo {
            flex: 0.85 1 120px;
            min-width: 100px;
        }

        .filters-toolbar .filter-field--actions {
            flex: 0 0 auto;
        }

        .periodo-historial-picker {
            min-height: 38px;
            padding: 6px 10px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            background: #fff;
            color: #6c757d;
            font-size: 13px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            width: 100%;
            min-width: 0;
            box-sizing: border-box;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .periodo-historial-picker:hover:not(.periodo-historial-picker--seleccionado) {
            border-color: #87CEEB;
        }

        .periodo-historial-picker--seleccionado {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            color: #1a3a5c;
            border-color: #90caf9;
            font-size: 12px;
            font-weight: 600;
            justify-content: space-between;
        }

        .periodo-historial-picker--seleccionado:hover {
            border-color: #64b5f6;
        }

        .periodo-historial-picker__texto {
            flex: 1;
            min-width: 0;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .periodo-historial-picker .btn-quitar-periodo {
            border: none;
            background: rgba(26, 58, 92, 0.12);
            color: #1a3a5c;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            padding: 0;
            line-height: 1;
            cursor: pointer;
            flex-shrink: 0;
        }

        .periodo-historial-picker .btn-quitar-periodo:hover {
            background: rgba(26, 58, 92, 0.22);
        }

        .filter-asociado-row {
            display: flex;
            align-items: stretch;
            min-width: 0;
        }

        .filter-asociado-wrap {
            position: relative;
            flex: 1;
            min-width: 0;
        }

        .filter-asociado-wrap .filter-input-asociado {
            width: 100%;
            min-height: 38px;
            padding: 6px 32px 6px 10px;
            display: flex;
            align-items: center;
            cursor: pointer;
            background-color: #f8f9fa;
        }

        .filter-asociado-btn-clear {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            border: none;
            background: transparent;
            padding: 4px 8px;
            line-height: 1;
            cursor: pointer;
            color: #0d6efd;
            z-index: 2;
        }

        .filter-asociado-btn-clear {
            right: 4px;
            color: #6c757d;
            font-size: 13px;
        }

        .filter-asociado-btn-clear:hover {
            color: #495057;
        }

        .filter-input {
            padding: 6px 10px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            background: white;
            color: #495057;
            font-size: 13px;
            width: 100%;
            min-width: 0;
        }

        .filter-input:focus {
            outline: none;
            border-color: #87CEEB;
            box-shadow: 0 0 0 2px rgba(135, 206, 235, 0.25);
        }

        .filter-actions-inner {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            align-items: center;
            justify-content: flex-end;
            min-height: 38px;
        }

        .filter-actions-inner .btn-buscar,
        .filter-actions-inner .btn-limpiar,
        .filter-actions-inner .btn-exportar-excel-icon {
            box-sizing: border-box;
            height: 34px;
            min-height: 34px;
            max-height: 34px;
            margin: 0;
            padding: 0 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
            line-height: 1;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            flex-shrink: 0;
            vertical-align: middle;
        }

        .filter-actions-inner .btn-buscar i,
        .filter-actions-inner .btn-limpiar i,
        .filter-actions-inner .btn-exportar-excel-icon i {
            font-size: 13px;
            line-height: 1;
            display: block;
        }

        .filter-actions-inner .btn-exportar-excel-icon {
            width: 34px;
            padding: 0;
        }

        .btn-buscar {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
        }

        .btn-buscar:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.4);
        }

        .btn-limpiar {
            background: #6c757d;
            color: white;
        }

        .btn-limpiar:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        .btn-exportar-excel-icon {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
        }

        .btn-exportar-excel-icon:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.4);
        }

        .btn-exportar-excel-icon:disabled {
            background: #6c757d;
            cursor: not-allowed;
            transform: none;
            opacity: 0.65;
        }

        /* Multiselect compacto (Select2) */
        .filter-field--rubro .select2-container,
        .filter-field--tipo .select2-container {
            width: 100% !important;
        }

        .filter-field--rubro .select2-container--bootstrap-5 .select2-selection--multiple,
        .filter-field--tipo .select2-container--bootstrap-5 .select2-selection--multiple {
            min-height: 36px !important;
            max-height: 40px !important;
            overflow-y: auto !important;
            overflow-x: hidden;
            padding: 5px 22px 4px 6px !important;
            border-radius: 4px;
            align-content: flex-start;
        }

        .filter-field--rubro .select2-selection--multiple .select2-selection__rendered,
        .filter-field--tipo .select2-selection--multiple .select2-selection__rendered {
            display: flex !important;
            flex-wrap: wrap !important;
            align-items: center;
            gap: 3px 4px !important;
            padding: 1px 2px !important;
            margin: 0 !important;
            width: 100%;
        }

        .filter-field--rubro .select2-selection--multiple .select2-selection__choice,
        .filter-field--tipo .select2-selection--multiple .select2-selection__choice {
            display: inline-flex !important;
            align-items: center;
            font-size: 10.5px !important;
            font-weight: 600;
            line-height: 1.15 !important;
            padding: 2px 6px 2px 4px !important;
            margin: 0 !important;
            border-radius: 3px !important;
            max-width: 118px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            float: none !important;
        }

        .filter-field--tipo .select2-selection--multiple .select2-selection__choice {
            max-width: 150px;
        }

        .filter-field--rubro .select2-selection--multiple .select2-selection__choice {
            background: linear-gradient(135deg, #e0f7fa, #b2ebf2) !important;
            border: 1px solid #4dd0e1 !important;
            color: #00695c !important;
        }

        .filter-field--rubro .select2-selection--multiple .select2-selection__choice__remove {
            color: #00897b !important;
            margin-right: 2px !important;
            padding: 0 1px !important;
            font-size: 9px !important;
            font-weight: 700;
            line-height: 1 !important;
            border: none !important;
            opacity: 0.75;
        }

        .filter-field--rubro .select2-selection--multiple .select2-selection__choice__remove:hover {
            color: #004d40 !important;
            opacity: 1;
            background: transparent !important;
        }

        .filter-field--tipo .select2-selection--multiple .select2-selection__choice {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9) !important;
            border: 1px solid #81c784 !important;
            color: #1b5e20 !important;
        }

        .filter-field--tipo .select2-selection--multiple .select2-selection__choice__remove {
            color: #388e3c !important;
            margin-right: 2px !important;
            padding: 0 1px !important;
            font-size: 9px !important;
            font-weight: 700;
            line-height: 1 !important;
            border: none !important;
            opacity: 0.75;
        }

        .filter-field--tipo .select2-selection--multiple .select2-selection__choice__remove:hover {
            color: #1b5e20 !important;
            opacity: 1;
            background: transparent !important;
        }

        .filter-field--rubro .select2-search--inline .select2-search__field,
        .filter-field--tipo .select2-search--inline .select2-search__field {
            height: 20px !important;
            min-height: 20px !important;
            margin: 0 !important;
            padding: 0 2px !important;
            font-size: 11px !important;
            line-height: 20px !important;
        }

        .filter-field--rubro .select2-selection--multiple .select2-selection__clear,
        .filter-field--tipo .select2-selection--multiple .select2-selection__clear {
            font-size: 14px;
            margin-top: 2px;
            right: 4px;
        }

        .filter-field--rubro .select2-container--bootstrap-5 .select2-selection--multiple::-webkit-scrollbar,
        .filter-field--tipo .select2-container--bootstrap-5 .select2-selection--multiple::-webkit-scrollbar {
            width: 5px;
            height: 5px;
        }

        .filter-field--rubro .select2-container--bootstrap-5 .select2-selection--multiple::-webkit-scrollbar-thumb,
        .filter-field--tipo .select2-container--bootstrap-5 .select2-selection--multiple::-webkit-scrollbar-thumb {
            background: #ced4da;
            border-radius: 3px;
        }

        .table-container {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            min-height: 0;
        }

        .table-container .dataTables_info,
        .table-container .dataTables_paginate {
            padding: 10px 0;
        }

        .table-container .dataTables_wrapper .row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin: 0;
            position: relative;
        }

        .table-container .dataTables_info {
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
            white-space: nowrap;
        }

        .table-container .dataTables_paginate {
            margin-left: auto;
        }

        .placeholder-mensaje {
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
            height: 100%;
            min-height: 200px;
        }

        .placeholder-mensaje .texto { text-align: center; }

        .placeholder-mensaje i {
            font-size: 48px;
            margin-bottom: 15px;
            opacity: 0.3;
        }

        .contenedor-tabs-auxiliares {
            flex: 1;
            min-height: 0;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .auxiliares-tabs-header {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: 12px;
            flex-shrink: 0;
            border-bottom: 1px solid #e9ecef;
        }

        .auxiliares-tabs-header .nav-tabs {
            flex: 1;
            margin-bottom: 0;
            border-bottom: none;
        }

        #contenedorTabsAuxiliares .nav-tabs {
            flex-shrink: 0;
            margin-bottom: 0;
        }

        .btn-exportar-excel {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s ease;
            flex-shrink: 0;
            margin-bottom: 4px;
        }

        .btn-exportar-excel:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.4);
        }

        .btn-exportar-excel:disabled {
            background: #6c757d;
            cursor: not-allowed;
            transform: none;
            opacity: 0.65;
        }

        .loading-auxiliares-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(0, 0, 0, 0.6);
            z-index: 10001;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: white;
        }

        .loading-auxiliares-overlay .spinner-auxiliares {
            width: 60px;
            height: 60px;
            border: 4px solid rgba(255, 255, 255, 0.3);
            border-top-color: #87CEEB;
            border-radius: 50%;
            animation: spin-auxiliares 0.8s linear infinite;
        }

        .loading-auxiliares-overlay .texto-carga {
            margin-top: 20px;
            font-size: 18px;
            font-weight: 500;
        }

        @keyframes spin-auxiliares {
            to { transform: rotate(360deg); }
        }

        #contenedorTabsAuxiliares .nav-tabs .nav-link {
            border: none;
            color: #6c757d;
            font-weight: 500;
            padding: 12px 20px;
            border-radius: 0;
        }

        #contenedorTabsAuxiliares .nav-tabs .nav-link.active {
            background: #5a9fd4;
            color: white;
        }

        #contenedorTabsAuxiliares .nav-tabs .nav-link:hover:not(.active) {
            color: #5a9fd4;
            background: #f8f9fa;
        }

        .tab-content-auxiliares {
            flex: 1;
            min-height: 0;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            padding-top: 15px;
            border-top: 1px solid #dee2e6;
            position: relative;
        }

        /* Paneles apilados (sin display:none) para que DataTables no se destruya al cambiar de pestaña */
        .tab-content-auxiliares .tab-pane {
            position: absolute;
            top: 15px;
            left: 0;
            right: 0;
            bottom: 0;
            display: flex;
            flex-direction: column;
            min-height: 0;
            overflow: hidden;
            visibility: hidden;
            pointer-events: none;
            z-index: 0;
        }

        .tab-content-auxiliares .tab-pane.active {
            visibility: visible;
            pointer-events: auto;
            z-index: 1;
        }

        .contenedor-grid-auxiliares {
            flex: 1;
            min-height: 0;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        /* Grid detallado: mismo patrón de paginación que Movimientos.aspx */
        .auxiliares-grid-wrapper {
            flex: 1;
            min-height: 0;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .auxiliares-grid-wrapper .dataTables_wrapper {
            flex: 1;
            display: grid;
            grid-template-rows: 1fr auto;
            grid-template-columns: 1fr auto 1fr;
            min-height: 0;
            overflow: hidden;
        }

        .auxiliares-grid-wrapper .dataTables_scroll {
            grid-row: 1;
            grid-column: 1 / -1;
            min-height: 0;
            height: 100%;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            border-bottom: 1px solid #dee2e6;
        }

        .auxiliares-grid-wrapper .dataTables_scrollHead {
            flex-shrink: 0;
        }

        .auxiliares-grid-wrapper .dataTables_scrollBody {
            flex: 1;
            min-height: 0;
            overflow-y: auto !important;
            overflow-x: auto !important;
            height: 100% !important;
        }

        .auxiliares-grid-wrapper .dataTables_scrollBody::-webkit-scrollbar {
            height: 8px;
            width: 8px;
        }

        .auxiliares-grid-wrapper .dataTables_scrollBody::-webkit-scrollbar-track {
            background: #f8f9fa;
            border-radius: 4px;
        }

        .auxiliares-grid-wrapper .dataTables_scrollBody::-webkit-scrollbar-thumb {
            background: #6c757d;
            border-radius: 4px;
        }

        .auxiliares-grid-wrapper .dataTables_length {
            grid-row: 2;
            grid-column: 2;
            align-self: center;
            justify-self: center;
            padding: 10px 0;
            position: static !important;
            left: auto !important;
            transform: none !important;
        }

        .auxiliares-grid-wrapper .dataTables_info {
            grid-row: 2;
            grid-column: 1;
            align-self: center;
            justify-self: start;
            padding: 10px 0;
            position: static !important;
            left: auto !important;
            transform: none !important;
            white-space: nowrap;
        }

        .auxiliares-grid-wrapper .dataTables_paginate {
            grid-row: 2;
            grid-column: 3;
            align-self: center;
            justify-self: end;
            padding: 10px 0;
            margin-left: 0 !important;
        }

        .auxiliares-grid-wrapper .dataTables_wrapper > .row,
        .auxiliares-grid-wrapper .dataTables_wrapper .row [class*="col-"] {
            display: contents;
        }

        .auxiliares-grid-wrapper .table {
            background: white;
            border-radius: 8px;
            overflow: visible;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            min-width: 100%;
            table-layout: auto;
        }

        .auxiliares-grid-wrapper .table th {
            background: #2c3e50;
            color: white;
            padding: 8px 6px;
            font-weight: 600;
            text-align: center;
            border: none;
            font-size: 11px;
            white-space: nowrap;
            min-width: 70px;
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .auxiliares-grid-wrapper .table th:hover {
            background: #34495e;
        }

        .auxiliares-grid-wrapper .table td {
            padding: 6px 4px;
            text-align: center;
            border-bottom: 1px solid #dee2e6;
            vertical-align: middle;
            font-size: 11px;
            white-space: nowrap;
            min-width: 70px;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .auxiliares-grid-wrapper .table tbody tr:hover {
            background-color: #f8f9fa;
        }

        .auxiliares-grid-wrapper .table tbody tr:nth-child(even) {
            background-color: #f8f9fa;
        }

        #tablaAuxiliaresResumen,
        #tablaAuxiliaresDetalle {
            width: 100% !important;
            table-layout: auto;
            min-width: max-content;
        }

        .auxiliares-totales-bar {
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            flex-wrap: wrap;
            gap: 12px 28px;
            width: 100%;
            padding: 10px 14px;
            margin-top: 4px;
            background: linear-gradient(135deg, #f8f9fa, #eef2f5);
            border: 1px solid #dee2e6;
            border-radius: 6px;
            font-size: 13px;
            color: #2c3e50;
        }

        .auxiliares-totales-bar .totales-titulo {
            font-weight: 700;
            margin-right: 8px;
        }

        .auxiliares-totales-bar .totales-montos {
            display: flex;
            flex-wrap: wrap;
            gap: 16px 28px;
            align-items: center;
            justify-content: flex-end;
            text-align: right;
        }

        .auxiliares-totales-bar .totales-montos span {
            white-space: nowrap;
        }

        .auxiliares-totales-bar .totales-montos b {
            color: #1a5276;
            font-weight: 700;
        }

        .auxiliares-totales-bar.auxiliares-totales-global {
            flex-shrink: 0;
            margin-top: 8px;
        }

        .auxiliares-totales-bar b.monto-negativo {
            color: #c0392b !important;
        }

        .auxiliares-grid-wrapper td.monto-negativo {
            color: #c0392b !important;
            font-weight: 600;
        }

        /* Tabla pivot: rubro (padre) + tipo auxiliar (hijo indentado), expandir/contraer */
        .aux-resumen-pivot-scroll {
            flex: 1;
            min-height: 0;
            overflow: auto;
            padding: 4px 4px 8px;
            background: #fff;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
        }

        .aux-pivot-contenedor {
            width: 100%;
            max-width: 760px;
        }

        .aux-pivot-toolbar {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 8px 12px;
            padding: 8px 10px 6px;
            border-bottom: 1px solid #e9ecef;
            background: #fafbfc;
            width: 100%;
            box-sizing: border-box;
        }

        .aux-pivot-dimensiones {
            display: flex;
            align-items: center;
            gap: 8px;
            flex: 1;
            min-width: 0;
        }

        .aux-pivot-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 5px 12px;
            font-size: 12px;
            font-weight: 600;
            color: #334155;
            background: #fff;
            border: 1px solid #cbd5e1;
            border-radius: 20px;
            box-shadow: 0 1px 2px rgba(0,0,0,0.04);
        }

        .aux-pivot-pill i {
            font-size: 10px;
            color: #64748b;
        }

        .aux-pivot-acciones {
            display: flex;
            gap: 6px;
        }

        .aux-pivot-btn {
            padding: 5px 10px;
            font-size: 11px;
            font-weight: 600;
            color: #475569;
            background: #fff;
            border: 1px solid #cbd5e1;
            border-radius: 4px;
            cursor: pointer;
        }

        .aux-pivot-btn:hover {
            background: #f1f5f9;
            border-color: #94a3b8;
        }

        .aux-pivot-tabla {
            width: 100%;
            max-width: 760px;
            table-layout: fixed;
            border-collapse: collapse;
            font-size: 12px;
            background: #fff;
        }

        .aux-pivot-tabla thead th {
            background: #f8f9fa;
            color: #495057;
            font-weight: 600;
            font-size: 11px;
            text-align: center !important;
            padding: 8px 10px;
            border-bottom: 2px solid #dee2e6;
            border-right: 1px solid #e9ecef;
            white-space: nowrap;
        }

        .aux-pivot-tabla thead th.col-etiqueta {
            text-align: center !important;
            width: auto;
        }

        .aux-pivot-tabla thead th.col-cantidad,
        .aux-pivot-tabla thead th.col-asociados {
            width: 88px;
        }

        .aux-pivot-tabla thead th.col-saldo {
            width: 112px;
        }

        .aux-pivot-tabla thead th:last-child {
            border-right: none;
        }

        .aux-pivot-tabla tbody td {
            padding: 7px 10px;
            border-bottom: 1px solid #e9ecef;
            border-right: 1px solid #e9ecef;
            vertical-align: middle;
        }

        .aux-pivot-tabla tbody td:last-child {
            border-right: none;
        }

        .aux-pivot-tabla tbody tr:last-child td {
            border-bottom: none;
        }

        .aux-pivot-cell-label {
            text-align: left !important;
            color: #212529;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .aux-pivot-row-rubro .aux-pivot-cell-label span {
            overflow: hidden;
            text-overflow: ellipsis;
            min-width: 0;
        }

        .aux-pivot-cantidad {
            text-align: right !important;
            font-variant-numeric: tabular-nums;
            white-space: nowrap;
            padding-right: 10px !important;
        }

        .aux-pivot-monto {
            text-align: right !important;
            font-variant-numeric: tabular-nums;
            white-space: nowrap;
            padding-right: 10px !important;
        }

        .aux-pivot-monto.monto-negativo {
            color: #c0392b !important;
            font-weight: 600;
        }

        .table-container .aux-pivot-tabla thead th {
            text-align: center !important;
        }

        .table-container .aux-pivot-tabla tbody td.aux-pivot-cell-label {
            text-align: left !important;
        }

        .table-container .aux-pivot-tabla tbody td.aux-pivot-cantidad,
        .table-container .aux-pivot-tabla tbody td.aux-pivot-monto {
            text-align: right !important;
        }

        .aux-pivot-row-rubro {
            cursor: pointer;
            user-select: none;
        }

        .aux-pivot-row-rubro td {
            font-weight: 700;
            color: #1a3a5c;
            background-color: #e3f2fd !important;
        }

        .aux-pivot-row-rubro:hover td {
            background-color: #d4e9f7 !important;
        }

        .aux-pivot-row-rubro .aux-pivot-cell-label {
            display: flex;
            align-items: center;
            gap: 8px;
            justify-content: flex-start;
        }

        .aux-pivot-chevron {
            flex-shrink: 0;
            width: 12px;
            font-size: 10px;
            color: #6c757d;
            transition: transform 0.15s ease;
        }

        .aux-pivot-row-rubro.is-expanded .aux-pivot-chevron {
            transform: rotate(90deg);
        }

        .aux-pivot-row-tipo td {
            font-weight: 400;
            color: #495057;
            background: #fff;
        }

        .aux-pivot-row-tipo .aux-pivot-cell-label {
            padding-left: 28px;
        }

        .aux-pivot-row-tipo:hover td {
            background: #f8f9fa;
        }

        .aux-resumen-vacio {
            text-align: center;
            color: #6c757d;
            padding: 24px 12px;
            margin: 0;
        }

        @media (max-width: 1200px) {
            .filters-toolbar { flex-wrap: wrap; }
            .filters-toolbar .filter-field--actions { flex: 1 1 100%; }
            .filter-actions-inner { justify-content: flex-start; }
        }

        @media (max-width: 768px) {
            .barra-reporte-auxiliares { flex-wrap: wrap; }
            .barra-reporte-auxiliares .titulo-reporte { width: 100%; }
            .filters-toolbar .filter-field,
            .filters-toolbar .filter-field--asociado,
            .filters-toolbar .filter-field--rubro,
            .filters-toolbar .filter-field--tipo,
            .filters-toolbar .filter-field--periodo {
                flex: 1 1 100%;
            }

            .periodo-historial-picker {
                max-width: 100%;
            }

            .table-container .dataTables_wrapper .row {
                flex-direction: column;
                gap: 10px;
                align-items: center;
            }

            .table-container .dataTables_info {
                position: static;
                transform: none;
                text-align: center;
            }

            .table-container .dataTables_paginate {
                margin-left: 0;
                justify-content: center;
            }
        }

        @media (max-width: 576px) {
            .table-container .dataTables_info {
                font-size: 11px;
            }

            .table-container .dataTables_paginate .paginate_button {
                padding: 4px 6px;
                font-size: 11px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="main-container">
            <div class="barra-reporte-auxiliares">
                <div class="titulo-reporte">Reporte<br />Auxiliares</div>
                <div class="filters-section">
                    <div class="filters-toolbar">
                        <div class="filter-field filter-field--rubro">
                            <label class="filter-label" for="ddlRubro">Rubro</label>
                            <select id="ddlRubro" class="form-select" multiple="multiple"></select>
                        </div>
                        <div class="filter-field filter-field--tipo">
                            <label class="filter-label" for="ddlTipoAuxiliar">Tipo auxiliar</label>
                            <select id="ddlTipoAuxiliar" class="form-select" multiple="multiple"></select>
                        </div>
                        <div class="filter-field filter-field--asociado">
                            <label class="filter-label">Asociado</label>
                            <div class="filter-asociado-row">
                                <div class="filter-asociado-wrap">
                                    <div id="txtAsociadoSeleccionado" class="filter-input filter-input-asociado" style="color: #6c757d;" title="Buscar asociado" role="button" tabindex="0">
                                        <span id="txtAsociadoSeleccionadoTexto">Ningún asociado seleccionado</span>
                                    </div>
                                    <button type="button" id="btnLimpiarAsociado" class="filter-asociado-btn-clear" title="Quitar asociado" aria-label="Quitar asociado" style="display: none;">
                                        <i class="fas fa-times"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div class="filter-field filter-field--periodo">
                            <label class="filter-label">Período historial</label>
                            <div id="pickerPeriodoHistorial" class="periodo-historial-picker" role="button" tabindex="0" aria-label="Seleccionar período de historial">Sin período</div>
                        </div>
                        <div class="filter-field filter-field--actions">
                            <label class="filter-label" style="visibility: hidden;">Acciones</label>
                            <div class="filter-actions-inner">
                                <button type="button" id="btnBuscarAuxiliares" class="btn-buscar" onclick="buscarAuxiliares()">
                                    <i class="fas fa-search"></i> Buscar
                                </button>
                                <button type="button" class="btn-limpiar" onclick="limpiarFiltros()">
                                    <i class="fas fa-eraser"></i> Limpiar
                                </button>
                                <button type="button" id="btnExportarExcelAuxiliares" class="btn-exportar-excel-icon" disabled="disabled" title="Exportar a Excel" aria-label="Exportar a Excel" onclick="exportarAuxiliaresAExcel()">
                                    <i class="fas fa-file-excel"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <a href="dashboardReportes.aspx" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Volver
                </a>
            </div>

            <div class="table-container">
                <div id="placeholderAuxiliares" class="placeholder-mensaje">
                    <div class="texto">
                        <i class="fas fa-wallet"></i>
                        <p style="font-size: 16px;">Utiliza los filtros y haz clic en &quot;Buscar&quot; para ver los auxiliares</p>
                    </div>
                </div>
                <div id="contenedorTabsAuxiliares" class="contenedor-tabs-auxiliares" style="display: none;">
                    <div class="auxiliares-tabs-header">
                    <ul class="nav nav-tabs" id="auxiliaresTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="tabResumenAuxBtn" data-bs-toggle="tab" data-bs-target="#tabPaneResumenAux" type="button" role="tab"><i class="fas fa-chart-pie me-2"></i>Resumen</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="tabDetalladoAuxBtn" data-bs-toggle="tab" data-bs-target="#tabPaneDetalladoAux" type="button" role="tab"><i class="fas fa-list-ul me-2"></i>Detallado</button>
                        </li>
                    </ul>
                    </div>
                    <div class="tab-content tab-content-auxiliares" id="auxiliaresTabContent">
                        <div class="tab-pane fade show active" id="tabPaneResumenAux" role="tabpanel">
                            <div class="contenedor-grid-auxiliares">
                                <div id="contenedorResumenAuxPivot" class="aux-resumen-pivot-scroll"></div>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="tabPaneDetalladoAux" role="tabpanel">
                            <div class="contenedor-grid-auxiliares">
                                <div class="auxiliares-grid-wrapper">
                                    <table id="tablaAuxiliaresDetalle" class="table table-hover table-striped">
                                        <thead></thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="auxiliares-totales-bar auxiliares-totales-global" id="barTotalesAuxiliaresGlobal" style="display: none;">
                        <span class="totales-titulo">Totales</span>
                        <div class="totales-montos">
                            <span>Auxiliares: <b id="totalAuxiliaresGlobal">0</b></span>
                            <span>Asociados: <b id="totalAsociadosGlobal">0</b></span>
                            <span>Saldo: <b id="totalSaldoGlobal">$0.00</b></span>
                            <span>Registros (detalle): <b id="totalRegistrosDetalleGlobal">0</b></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="modalPeriodoHistorial" tabindex="-1" aria-labelledby="modalPeriodoHistorialLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-sm">
                <div class="modal-content">
                    <div class="modal-header py-2">
                        <h5 class="modal-title" id="modalPeriodoHistorialLabel"><i class="fas fa-history me-2"></i>Período de historial</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label" for="ddlAnioHistorial">Año</label>
                            <select id="ddlAnioHistorial" class="form-select form-select-sm"></select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="ddlMesHistorial">Mes</label>
                            <select id="ddlMesHistorial" class="form-select form-select-sm" disabled="disabled">
                                <option value="">Seleccione año</option>
                            </select>
                        </div>
                        <div class="mb-2">
                            <label class="form-label" for="ddlVersionHistorial">Versión</label>
                            <select id="ddlVersionHistorial" class="form-select form-select-sm" disabled="disabled">
                                <option value="">Seleccione mes</option>
                            </select>
                        </div>
                        <p id="msgSinPeriodosHistorial" class="text-muted small mb-0" style="display: none;">No hay cortes de historial registrados.</p>
                    </div>
                    <div class="modal-footer py-2">
                        <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancelar</button>
                        <button type="button" class="btn btn-primary btn-sm" id="btnAplicarPeriodoHistorial">Aplicar</button>
                    </div>
                </div>
            </div>
        </div>

        <div id="globalModalsContainer"></div>
    </form>

    <div id="loadingAuxiliaresOverlay" class="loading-auxiliares-overlay" style="display: none;">
        <div class="spinner-auxiliares"></div>
        <div class="texto-carga">Cargando, espere por favor...</div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <script src="../../Scripts/inactivity-monitor-final.js?v=2.6"></script>
    <script src="../../Scripts/notifications.js?v=2"></script>
    <script src="../../Scripts/smart-chips.js"></script>
    <script src="../../Scripts/global-associate-search.js?v=1.4"></script>

    <script type="text/javascript">
        var asociadoSeleccionado = null;
        var periodoHistorialSeleccionado = null;
        var modalPeriodoHistorialBs = null;
        var periodosHistorialCatalogo = [];

        var NOMBRES_MESES_HISTORIAL = [
            'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
            'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
        ];
        var globalSearchConfig = null;
        var dataTableAuxiliaresDetalle = null;
        var datosAuxiliaresResumenActual = [];
        var datosAuxiliaresDetalleActual = [];
        var totalRegistrosDetalleAux = 0;

        var COLUMNAS_DETALLE_AUX = [
            'ID Auxiliar', 'Número de Asociado', 'Código Rubro', 'Rubro', 'ID Tipo Auxiliar', 'Tipo Auxiliar',
            'Cuota', 'Saldo', 'Fecha de Creación', 'Hora de Creación', 'Fecha de Modificación', 'Hora de Modificación',
            'ID Usuario Crea', 'Usuario que Crea', 'ID Usuario Modifica', 'Usuario que Modifica',
            'Monto Original', 'Fecha de Otorgamiento', 'Hora de Otorgamiento', 'Tasa de Interés', 'Pago Mensual',
            'Interés Calculado', 'Interés Pagado', 'Fecha Último Pago', 'Hora Último Pago',
            'Fecha Último Retiro', 'Hora Último Retiro', '¿Activo?', '¿Eliminado?', 'Monto Pignorado',
            'ID Usuario Elimina', 'Usuario que Elimina', 'Fecha de Eliminación', 'Hora de Eliminación'
        ];
        var COLUMNAS_MONTO_AUX = ['Cuota', 'Saldo', 'Monto Original', 'Pago Mensual', 'Interés Calculado', 'Interés Pagado', 'Monto Pignorado'];
        var COLUMNAS_RESUMEN_EXCEL = ['Rubro / Tipo auxiliar', 'Auxiliares', 'Asociados', 'Saldo'];

        $(document).ready(function() {
            if (typeof initializeInactivityMonitoring === 'function') {
                initializeInactivityMonitoring();
            }

            inicializarSelect2Filtros();
            cargarRubros();
            cargarTiposAuxiliares();
            inicializarBusquedaAsociadosGlobal();

            $('#txtAsociadoSeleccionado').on('click', function() {
                abrirBusquedaAsociados(globalSearchConfig);
            });
            $('#txtAsociadoSeleccionado').on('keydown', function(e) {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    abrirBusquedaAsociados(globalSearchConfig);
                }
            });
            $('#btnLimpiarAsociado').on('click', function(e) {
                e.stopPropagation();
                limpiarAsociadoSeleccionado();
            });

            cargarPeriodosHistorialAuxiliares();
            $('#pickerPeriodoHistorial').on('click', function(e) {
                if ($(e.target).closest('.btn-quitar-periodo').length) return;
                abrirModalPeriodoHistorial();
            });
            $('#pickerPeriodoHistorial').on('keydown', function(e) {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    if ($(e.target).closest('.btn-quitar-periodo').length) return;
                    abrirModalPeriodoHistorial();
                }
            });
            $(document).on('click', '#pickerPeriodoHistorial .btn-quitar-periodo', limpiarPeriodoHistorial);
            $('#ddlAnioHistorial').on('change', onCambioAnioHistorial);
            $('#ddlMesHistorial').on('change', onCambioMesHistorial);
            $('#ddlVersionHistorial').on('change', actualizarEstadoBtnAplicarPeriodoHistorial);
            $('#btnAplicarPeriodoHistorial').on('click', aplicarPeriodoHistorialDesdeModal);

            $('#auxiliaresTabs button[data-bs-toggle="tab"]').on('shown.bs.tab', function() {
                setTimeout(ajustarAlturaScrollAuxiliares, 0);
                setTimeout(ajustarAlturaScrollAuxiliares, 80);
                setTimeout(ajustarAlturaScrollAuxiliares, 200);
            });
        });

        function truncarTextoSelect2(texto, maxLen) {
            if (!texto) return '';
            var s = String(texto);
            return s.length > maxLen ? s.substring(0, maxLen - 1) + '…' : s;
        }

        function inicializarSelect2Filtros() {
            var optsComun = {
                theme: 'bootstrap-5',
                width: '100%',
                allowClear: true,
                closeOnSelect: false
            };
            $('#ddlRubro').select2($.extend({}, optsComun, {
                placeholder: 'Todos los rubros',
                templateSelection: function(data) {
                    if (!data.id) return data.text;
                    return truncarTextoSelect2(data.text, 14);
                }
            }));
            $('#ddlTipoAuxiliar').select2($.extend({}, optsComun, {
                placeholder: 'Todos los tipos',
                templateResult: function(data) {
                    if (!data.id) return data.text;
                    if (data.element) {
                        var etiquetaLista = $(data.element).attr('data-list-label');
                        if (etiquetaLista) return etiquetaLista;
                    }
                    return data.text;
                },
                templateSelection: function(data) {
                    if (!data.id) return data.text;
                    return truncarTextoSelect2(data.text, 28);
                }
            }));
        }

        function inicializarBusquedaAsociadosGlobal() {
            globalSearchConfig = crearBusquedaAsociados('globalModalsContainer', {
                modalId: 'modalBuscarAsociadoAuxiliares',
                searchInputId: 'txtBuscarAsociadoAuxiliares',
                resultsTableId: 'tbodyAsociadosAuxiliares',
                searchButtonId: 'btnBuscarAsociadoModalAux',
                clearButtonId: 'btnLimpiarBusquedaAuxiliares',
                modalTitle: 'Buscar Asociado',
                searchPlaceholder: 'Ingrese nombre, cédula o número de asociado...',
                validarAuxiliares: false,
                onSelect: function(asociado) {
                    seleccionarAsociadoParaFiltro(asociado.numeroAsociado, asociado.nombre, asociado.numeroIdentificacion, asociado.codTipoDoc);
                }
            });
        }

        function seleccionarAsociadoParaFiltro(numeroAsociado, nombre, cedula, tipoDocumento) {
            asociadoSeleccionado = {
                numeroAsociado: numeroAsociado,
                nombre: nombre,
                cedula: cedula,
                tipoDocumento: tipoDocumento
            };
            var identificacionHtml = crearChipTipoDocumento
                ? crearChipTipoDocumento(tipoDocumento, cedula)
                : (tipoDocumento + ': ' + cedula);
            $('#txtAsociadoSeleccionadoTexto').html(nombre + ' (' + identificacionHtml + ') - N° ' + numeroAsociado);
            $('#txtAsociadoSeleccionado').css('color', '#495057');
            $('#btnLimpiarAsociado').show();
        }

        function limpiarAsociadoSeleccionado() {
            asociadoSeleccionado = null;
            $('#txtAsociadoSeleccionadoTexto').text('Ningún asociado seleccionado');
            $('#txtAsociadoSeleccionado').css('color', '#6c757d');
            $('#btnLimpiarAsociado').hide();
        }

        function cargarRubros() {
            $.ajax({
                type: 'POST',
                url: 'Auxiliares.aspx/ObtenerRubros',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                data: JSON.stringify({}),
                success: function(response) {
                    try {
                        var responseData = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        if (responseData && responseData.Success && responseData.Data) {
                            var rubros = typeof responseData.Data === 'string' ? JSON.parse(responseData.Data) : responseData.Data;
                            var ddl = $('#ddlRubro');
                            rubros.forEach(function(rubro) {
                                ddl.append($('<option>', {
                                    value: rubro.CodigoRubro,
                                    text: rubro.Descripcion
                                }));
                            });
                        }
                    } catch (e) { }
                }
            });
        }

        function cargarTiposAuxiliares() {
            $.ajax({
                type: 'POST',
                url: 'Auxiliares.aspx/ObtenerTiposAuxiliares',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                data: JSON.stringify({}),
                success: function(response) {
                    try {
                        var responseData = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        if (responseData && responseData.Success && responseData.Data) {
                            var tipos = typeof responseData.Data === 'string' ? JSON.parse(responseData.Data) : responseData.Data;
                            var ddl = $('#ddlTipoAuxiliar');
                            tipos.forEach(function(tipo) {
                                var desc = tipo.Descripcion || '';
                                var etiquetaLista = desc;
                                if (tipo.RubroDescripcion) {
                                    etiquetaLista = tipo.RubroDescripcion + ' — ' + desc;
                                } else if (tipo.CodigoRubro) {
                                    etiquetaLista = tipo.CodigoRubro + ' — ' + desc;
                                }
                                var opt = $('<option>', {
                                    value: tipo.TipoAuxiliar,
                                    text: desc
                                });
                                opt.attr('data-list-label', etiquetaLista);
                                ddl.append(opt);
                            });
                        }
                    } catch (e) { }
                }
            });
        }

        function jsonFiltroMultiselect(valores) {
            if (!valores || !valores.length) return null;
            return JSON.stringify(valores);
        }

        function normalizarPeriodoHistorialItem(item) {
            return {
                anio: parseInt(item.AnioHistorial != null ? item.AnioHistorial : item.anioHistorial, 10),
                mes: parseInt(item.MesHistorial != null ? item.MesHistorial : item.mesHistorial, 10),
                version: parseInt(item.VersionHistorial != null ? item.VersionHistorial : item.versionHistorial, 10)
            };
        }

        function cargarPeriodosHistorialAuxiliares() {
            $.ajax({
                type: 'POST',
                url: 'Auxiliares.aspx/ListarPeriodosHistorialAuxiliares',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                data: JSON.stringify({}),
                success: function(response) {
                    try {
                        var rd = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        if (rd && rd.Success && rd.Data) {
                            periodosHistorialCatalogo = (Array.isArray(rd.Data) ? rd.Data : []).map(normalizarPeriodoHistorialItem)
                                .filter(function(p) { return p.anio && p.mes >= 1 && p.mes <= 12 && !isNaN(p.version) && p.version >= 0; });
                        } else {
                            periodosHistorialCatalogo = [];
                        }
                    } catch (e) {
                        periodosHistorialCatalogo = [];
                    }
                    renderPeriodoHistorialPicker();
                },
                error: function() {
                    periodosHistorialCatalogo = [];
                    renderPeriodoHistorialPicker();
                }
            });
        }

        function obtenerAniosHistorialDisponibles() {
            var map = {};
            periodosHistorialCatalogo.forEach(function(p) { map[p.anio] = true; });
            return Object.keys(map).map(function(k) { return parseInt(k, 10); }).sort(function(a, b) { return b - a; });
        }

        function obtenerMesesHistorialPorAnio(anio) {
            var map = {};
            periodosHistorialCatalogo.filter(function(p) { return p.anio === anio; })
                .forEach(function(p) { map[p.mes] = true; });
            return Object.keys(map).map(function(k) { return parseInt(k, 10); }).sort(function(a, b) { return a - b; });
        }

        function obtenerVersionesHistorialPorAnioMes(anio, mes) {
            var map = {};
            periodosHistorialCatalogo.filter(function(p) { return p.anio === anio && p.mes === mes; })
                .forEach(function(p) { map[p.version] = true; });
            return Object.keys(map).map(function(k) { return parseInt(k, 10); }).sort(function(a, b) { return b - a; });
        }

        function deshabilitarSelectHistorial($sel, textoPlaceholder) {
            $sel.empty().append($('<option>', { value: '', text: textoPlaceholder }));
            $sel.prop('disabled', true).val('');
        }

        function llenarSelectPeriodoHistorial($sel, valores, textoFn, valorSeleccionado, opciones) {
            opciones = opciones || {};
            $sel.empty();
            if (!valores.length) {
                $sel.append($('<option>', { value: '', text: opciones.sinDatos || '(Sin datos)' }));
                $sel.prop('disabled', true);
                return;
            }
            $sel.prop('disabled', false);
            var unico = valores.length === 1;
            if (opciones.placeholder && !unico) {
                $sel.append($('<option>', { value: '', text: opciones.placeholder }));
            }
            valores.forEach(function(v) {
                $sel.append($('<option>', { value: v, text: textoFn(v) }));
            });
            if (valorSeleccionado != null && valores.indexOf(valorSeleccionado) >= 0) {
                $sel.val(valorSeleccionado);
            } else if (unico) {
                $sel.val(valores[0]);
            } else {
                $sel.val('');
            }
        }

        function periodoHistorialVersionSeleccionada() {
            var versionStr = $('#ddlVersionHistorial').val();
            if (versionStr === '' || versionStr == null) return false;
            var version = parseInt(versionStr, 10);
            return !isNaN(version) && version >= 0;
        }

        function actualizarEstadoBtnAplicarPeriodoHistorial() {
            var anio = parseInt($('#ddlAnioHistorial').val(), 10);
            var mes = parseInt($('#ddlMesHistorial').val(), 10);
            var completo = periodosHistorialCatalogo.length > 0 && anio && mes >= 1 && mes <= 12 && periodoHistorialVersionSeleccionada();
            $('#btnAplicarPeriodoHistorial').prop('disabled', !completo);
        }

        function onCambioAnioHistorial() {
            var anio = parseInt($('#ddlAnioHistorial').val(), 10);
            deshabilitarSelectHistorial($('#ddlVersionHistorial'), 'Seleccione mes');
            if (!anio) {
                deshabilitarSelectHistorial($('#ddlMesHistorial'), 'Seleccione año');
                actualizarEstadoBtnAplicarPeriodoHistorial();
                return;
            }
            var meses = obtenerMesesHistorialPorAnio(anio);
            llenarSelectPeriodoHistorial($('#ddlMesHistorial'), meses, function(m) {
                return NOMBRES_MESES_HISTORIAL[m - 1];
            }, null, { placeholder: 'Seleccione mes' });
            if (meses.length === 1) {
                onCambioMesHistorial();
                return;
            }
            actualizarEstadoBtnAplicarPeriodoHistorial();
        }

        function onCambioMesHistorial() {
            var anio = parseInt($('#ddlAnioHistorial').val(), 10);
            var mes = parseInt($('#ddlMesHistorial').val(), 10);
            if (!anio) {
                deshabilitarSelectHistorial($('#ddlVersionHistorial'), 'Seleccione mes');
                actualizarEstadoBtnAplicarPeriodoHistorial();
                return;
            }
            if (!mes) {
                deshabilitarSelectHistorial($('#ddlVersionHistorial'), 'Seleccione mes');
                actualizarEstadoBtnAplicarPeriodoHistorial();
                return;
            }
            var versiones = obtenerVersionesHistorialPorAnioMes(anio, mes);
            llenarSelectPeriodoHistorial($('#ddlVersionHistorial'), versiones, function(v) {
                return 'v' + v;
            }, null, { placeholder: 'Seleccione versión' });
            actualizarEstadoBtnAplicarPeriodoHistorial();
        }

        function inicializarModalPeriodoHistorialAlAbrir() {
            var tieneCatalogo = periodosHistorialCatalogo.length > 0;
            $('#msgSinPeriodosHistorial').toggle(!tieneCatalogo);
            actualizarEstadoBtnAplicarPeriodoHistorial();

            if (!tieneCatalogo) {
                deshabilitarSelectHistorial($('#ddlAnioHistorial'), '(Sin historial)');
                deshabilitarSelectHistorial($('#ddlMesHistorial'), 'Seleccione año');
                deshabilitarSelectHistorial($('#ddlVersionHistorial'), 'Seleccione mes');
                return;
            }

            var sel = periodoHistorialSeleccionado;
            var anios = obtenerAniosHistorialDisponibles();
            llenarSelectPeriodoHistorial($('#ddlAnioHistorial'), anios, function(v) { return String(v); },
                sel ? sel.anio : null, { placeholder: 'Seleccione año' });

            if (sel && sel.anio && anios.indexOf(sel.anio) >= 0) {
                var meses = obtenerMesesHistorialPorAnio(sel.anio);
                var mesRestaurar = sel.mes && meses.indexOf(sel.mes) >= 0 ? sel.mes : null;
                llenarSelectPeriodoHistorial($('#ddlMesHistorial'), meses, function(m) {
                    return NOMBRES_MESES_HISTORIAL[m - 1];
                }, mesRestaurar, { placeholder: 'Seleccione mes' });

                var mesActivo = parseInt($('#ddlMesHistorial').val(), 10);
                if (mesActivo) {
                    var versiones = obtenerVersionesHistorialPorAnioMes(sel.anio, mesActivo);
                    var verRestaurar = versiones.indexOf(sel.version) >= 0 ? sel.version : null;
                    llenarSelectPeriodoHistorial($('#ddlVersionHistorial'), versiones, function(v) {
                        return 'v' + v;
                    }, verRestaurar, { placeholder: 'Seleccione versión' });
                } else {
                    deshabilitarSelectHistorial($('#ddlVersionHistorial'), 'Seleccione mes');
                }
            } else {
                deshabilitarSelectHistorial($('#ddlMesHistorial'), 'Seleccione año');
                deshabilitarSelectHistorial($('#ddlVersionHistorial'), 'Seleccione mes');
                if (anios.length === 1) {
                    $('#ddlAnioHistorial').val(anios[0]);
                    onCambioAnioHistorial();
                }
            }

            actualizarEstadoBtnAplicarPeriodoHistorial();
        }

        function renderPeriodoHistorialPicker() {
            var $picker = $('#pickerPeriodoHistorial');
            if (!periodoHistorialSeleccionado) {
                $picker.removeClass('periodo-historial-picker--seleccionado')
                    .html(periodosHistorialCatalogo.length ? 'Sin período' : 'Sin historial');
                return;
            }
            var etiqueta = NOMBRES_MESES_HISTORIAL[periodoHistorialSeleccionado.mes - 1] + ' ' +
                periodoHistorialSeleccionado.anio + ' v' + periodoHistorialSeleccionado.version;
            $picker.addClass('periodo-historial-picker--seleccionado').html(
                '<span class="periodo-historial-picker__texto"><i class="fas fa-history me-1"></i>' + etiqueta + '</span>' +
                '<button type="button" class="btn-quitar-periodo" title="Quitar período" aria-label="Quitar período"><i class="fas fa-times"></i></button>'
            );
        }

        function abrirModalPeriodoHistorial() {
            if (!modalPeriodoHistorialBs) {
                modalPeriodoHistorialBs = new bootstrap.Modal(document.getElementById('modalPeriodoHistorial'));
            }
            inicializarModalPeriodoHistorialAlAbrir();
            modalPeriodoHistorialBs.show();
        }

        function aplicarPeriodoHistorialDesdeModal() {
            if (!periodosHistorialCatalogo.length) {
                if (typeof showToast === 'function') {
                    showToast('warning', 'Período', 'No hay periodos de historial disponibles');
                }
                return;
            }
            var anio = parseInt($('#ddlAnioHistorial').val(), 10);
            var mes = parseInt($('#ddlMesHistorial').val(), 10);
            if (!periodoHistorialVersionSeleccionada()) {
                if (typeof showToast === 'function') {
                    showToast('warning', 'Período', 'Seleccione un periodo de historial valido');
                }
                return;
            }
            var version = parseInt($('#ddlVersionHistorial').val(), 10);
            var existe = periodosHistorialCatalogo.some(function(p) {
                return p.anio === anio && p.mes === mes && p.version === version;
            });
            if (!existe) {
                if (typeof showToast === 'function') {
                    showToast('warning', 'Período', 'Seleccione un periodo de historial valido');
                }
                return;
            }
            periodoHistorialSeleccionado = { mes: mes, anio: anio, version: version };
            renderPeriodoHistorialPicker();
            if (modalPeriodoHistorialBs) modalPeriodoHistorialBs.hide();
        }

        function limpiarPeriodoHistorial(e) {
            if (e) {
                e.preventDefault();
                e.stopPropagation();
            }
            periodoHistorialSeleccionado = null;
            renderPeriodoHistorialPicker();
        }

        function textosMultiselect($sel) {
            var vals = $sel.val();
            if (!vals || !vals.length) return null;
            return $sel.find('option:selected').map(function() {
                return $(this).text().trim();
            }).get().filter(function(t) { return t.length > 0; });
        }

        function obtenerParametrosFiltros() {
            var codigosRubro = $('#ddlRubro').val();
            var tiposAuxiliar = $('#ddlTipoAuxiliar').val();
            return {
                codigosRubroJson: jsonFiltroMultiselect(codigosRubro),
                tiposAuxiliarJson: jsonFiltroMultiselect(tiposAuxiliar),
                numeroAsociado: asociadoSeleccionado ? asociadoSeleccionado.numeroAsociado : null,
                mesHistorial: periodoHistorialSeleccionado ? periodoHistorialSeleccionado.mes : null,
                anioHistorial: periodoHistorialSeleccionado ? periodoHistorialSeleccionado.anio : null,
                versionHistorial: periodoHistorialSeleccionado ? periodoHistorialSeleccionado.version : null
            };
        }

        function obtenerEtiquetasFiltrosAuxiliaresExcel() {
            var params = obtenerParametrosFiltros();
            var rubros = textosMultiselect($('#ddlRubro'));
            var tipos = textosMultiselect($('#ddlTipoAuxiliar'));
            var etiquetaAsociado = null;
            if (asociadoSeleccionado && asociadoSeleccionado.numeroAsociado) {
                etiquetaAsociado = (asociadoSeleccionado.nombre || '').trim();
                if (etiquetaAsociado) {
                    etiquetaAsociado += ' (N° ' + asociadoSeleccionado.numeroAsociado + ')';
                } else {
                    etiquetaAsociado = 'N° ' + asociadoSeleccionado.numeroAsociado;
                }
            }
            return {
                codigosRubroJson: params.codigosRubroJson,
                tiposAuxiliarJson: params.tiposAuxiliarJson,
                numeroAsociado: params.numeroAsociado,
                mesHistorial: params.mesHistorial,
                anioHistorial: params.anioHistorial,
                versionHistorial: params.versionHistorial,
                rubrosTexto: rubros,
                tiposAuxiliarTexto: tipos,
                etiquetaAsociado: etiquetaAsociado
            };
        }

        function cargarTodosAuxiliaresDetalle(payloadFiltros, onComplete, onError) {
            var todos = [];
            var pageSize = 500;
            var sortColumn = 1;
            var sortDirection = 'DESC';

            function fetchPage(pageIndex) {
                $.ajax({
                    type: 'POST',
                    url: 'Auxiliares.aspx/ListarAuxiliaresReporte',
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    data: JSON.stringify($.extend({}, payloadFiltros, {
                        pageSize: pageSize,
                        pageIndex: pageIndex,
                        sortColumn: sortColumn,
                        sortDirection: sortDirection
                    })),
                    success: function(r) {
                        try {
                            var batch = parseListarResponse(r);
                            var total = 0;
                            if (batch.length > 0 && batch[0].TotalRegistros !== undefined) {
                                total = parseInt(batch[0].TotalRegistros, 10) || batch.length;
                            } else {
                                total = batch.length;
                            }
                            todos = todos.concat(batch);
                            if (todos.length < total && batch.length === pageSize) {
                                fetchPage(pageIndex + 1);
                            } else {
                                onComplete(todos, total);
                            }
                        } catch (e) {
                            if (onError) onError(e);
                        }
                    },
                    error: function(xhr) {
                        var msg = extraerMensajeErrorAjaxAux(xhr) || 'Error al consultar detalle';
                        if (onError) onError(new Error(msg));
                    }
                });
            }

            fetchPage(0);
        }

        function columnasDataTableAux(nombres) {
            return (nombres || []).map(function(col) {
                return {
                    title: col,
                    data: col,
                    defaultContent: '',
                    render: function(data, type) {
                        if (COLUMNAS_MONTO_AUX.indexOf(col) >= 0) {
                            if (type === 'display' || type === 'filter') {
                                return formatearSaldoMonedaAux(data);
                            }
                            return parseMontoLocalAux(data);
                        }
                        if (type === 'display' || type === 'filter') {
                            return (data !== undefined && data !== null) ? String(data) : '';
                        }
                        return data;
                    }
                };
            });
        }

        function marcarMontosNegativosAux(row, data, columnas) {
            $.each(columnas, function(i, col) {
                if (COLUMNAS_MONTO_AUX.indexOf(col) >= 0 && parseMontoLocalAux(data[col]) < 0) {
                    $('td', row).eq(i).addClass('monto-negativo');
                }
            });
        }

        function crearDataTableAuxiliares(selector, datos, columnas, orden) {
            var $tabla = $(selector);
            if ($.fn.DataTable.isDataTable(selector)) {
                $tabla.DataTable().destroy();
            }
            $tabla.empty();

            var dt = $tabla.DataTable({
                data: datos || [],
                columns: columnasDataTableAux(columnas),
                pageLength: 25,
                lengthMenu: [[25, 50, 100, 200], [25, 50, 100, 200]],
                deferRender: true,
                language: {
                    url: 'https://cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json'
                },
                order: orden || [[0, 'asc']],
                responsive: false,
                scrollX: true,
                scrollY: '200px',
                scrollCollapse: false,
                dom: 'tlip',
                searching: false,
                createdRow: function(row, data) {
                    marcarMontosNegativosAux(row, data, columnas);
                },
                initComplete: function() {
                    ajustarAlturaScrollAuxiliares();
                    sincronizarColumnasAuxiliares();
                    setTimeout(sincronizarColumnasAuxiliares, 50);
                    setTimeout(sincronizarColumnasAuxiliares, 200);
                },
                drawCallback: function() {
                    ajustarAlturaScrollAuxiliares();
                    sincronizarColumnasAuxiliares();
                }
            });
            return dt;
        }

        function sincronizarColumnasAuxiliares() {
            if (!dataTableAuxiliaresDetalle) return;
            try {
                dataTableAuxiliaresDetalle.columns.adjust();
            } catch (e1) { }
            var $wrapper = $('#tablaAuxiliaresDetalle').closest('.dataTables_wrapper');
            if (!$wrapper.length) return;
            var $body = $wrapper.find('.dataTables_scrollBody');
            var $headInner = $wrapper.find('.dataTables_scrollHeadInner');
            var $headTable = $headInner.find('table');
            var $bodyTable = $body.find('table');
            var ancho = ($body.length ? $body.width() : $wrapper.width()) || '100%';
            $headInner.css({ width: '100%', 'padding-right': '' });
            $headTable.add($bodyTable).css({ width: ancho, 'table-layout': 'fixed' });
            if ($body.length && $wrapper.find('.dataTables_scrollHead').length) {
                var sbw = $body[0].offsetWidth - $body[0].clientWidth;
                if (sbw > 0) {
                    $wrapper.find('.dataTables_scrollHead').css('padding-right', sbw + 'px');
                }
                $body.off('scroll.auxSync').on('scroll.auxSync', function() {
                    $wrapper.find('.dataTables_scrollHead').scrollLeft($body.scrollLeft());
                });
            }
            try {
                dataTableAuxiliaresDetalle.columns.adjust();
            } catch (e2) { }
        }

        function ajustarAlturaScrollAuxiliares() {
            $('#contenedorTabsAuxiliares .auxiliares-grid-wrapper').each(function() {
                var $gridWrap = $(this);
                if (!$gridWrap.is(':visible')) return;
                var $wrapper = $gridWrap.find('.dataTables_wrapper');
                var $scroll = $wrapper.find('.dataTables_scroll');
                var $scrollHead = $scroll.find('.dataTables_scrollHead');
                var $scrollBody = $scroll.find('.dataTables_scrollBody');
                if (!$scroll.length || !$scrollBody.length) return;
                var scrollDivHeight = $scroll.height();
                if (scrollDivHeight < 100) {
                    var footerRowH = 0;
                    $wrapper.find('.dataTables_length, .dataTables_info, .dataTables_paginate').each(function() {
                        footerRowH = Math.max(footerRowH, $(this).outerHeight(true));
                    });
                    scrollDivHeight = $wrapper.height() - footerRowH - 8;
                }
                var headHeight = $scrollHead.outerHeight() || 0;
                var scrollH = Math.max(200, scrollDivHeight - headHeight);
                $scrollBody.css({ height: scrollH + 'px', minHeight: scrollH + 'px', maxHeight: scrollH + 'px' });
            });
            sincronizarColumnasAuxiliares();
        }

        function extraerMensajeErrorAjaxAux(xhr) {
            if (!xhr) return '';
            try {
                var txt = xhr.responseText || '';
                if (!txt) return '';
                var outer = JSON.parse(txt);
                var inner = outer.d;
                if (typeof inner === 'string') {
                    if (inner.indexOf('Invalid web service call') >= 0) {
                        return 'Error de comunicación con el servidor. Recargue la página e intente de nuevo.';
                    }
                    return inner;
                }
                if (inner && inner.Message) return inner.Message;
            } catch (e) { }
            return '';
        }

        function parseListarResponse(response) {
            var responseData = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
            if (responseData && responseData.Success && responseData.Data !== undefined) {
                return typeof responseData.Data === 'string' ? JSON.parse(responseData.Data) : (responseData.Data || []);
            }
            if (responseData && !responseData.Success) {
                throw new Error(responseData.Message || 'Error al consultar');
            }
            return [];
        }

        function mostrarOverlayAuxiliares(mensaje) {
            $('#loadingAuxiliaresOverlay .texto-carga').text(mensaje || 'Cargando, espere por favor...');
            $('#loadingAuxiliaresOverlay').show();
        }

        function ocultarOverlayAuxiliares() {
            $('#loadingAuxiliaresOverlay').hide();
        }

        function buscarAuxiliares() {
            var params = obtenerParametrosFiltros();
            var btn = $('#btnBuscarAuxiliares');
            var htmlOriginal = btn.html();
            destruirTablasAuxiliares();
            btn.prop('disabled', true);
            mostrarOverlayAuxiliares('Consultando auxiliares, espere por favor...');

            var payloadFiltros = {
                codigosRubroJson: params.codigosRubroJson,
                tiposAuxiliarJson: params.tiposAuxiliarJson,
                numeroAsociado: params.numeroAsociado,
                mesHistorial: params.mesHistorial,
                anioHistorial: params.anioHistorial,
                versionHistorial: params.versionHistorial,
                pageSize: 500,
                pageIndex: 0,
                sortColumn: 1,
                sortDirection: 'DESC'
            };

            var datosResumen = [];
            var datosDetalle = [];
            var pendientes = 2;

            function terminarBusqueda() {
                pendientes--;
                if (pendientes > 0) return;
                btn.prop('disabled', false).html(htmlOriginal);
                ocultarOverlayAuxiliares();
                mostrarPestanasAuxiliares(datosResumen, datosDetalle);
            }

            $.ajax({
                type: 'POST',
                url: 'Auxiliares.aspx/ListarAuxiliaresResumen',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                data: JSON.stringify(payloadFiltros),
                success: function(r) {
                    try {
                        datosResumen = parseListarResponse(r);
                    } catch (e) {
                        datosResumen = [];
                        if (typeof showToast === 'function') showToast('error', 'Error', e.message);
                    }
                },
                error: function(xhr) {
                    datosResumen = [];
                    var msg = extraerMensajeErrorAjaxAux(xhr) || 'Error al consultar resumen';
                    if (typeof showToast === 'function') showToast('error', 'Error', msg);
                },
                complete: terminarBusqueda
            });

            cargarTodosAuxiliaresDetalle(payloadFiltros, function(detalle, total) {
                datosDetalle = detalle;
                totalRegistrosDetalleAux = total;
                terminarBusqueda();
            }, function(err) {
                datosDetalle = [];
                totalRegistrosDetalleAux = 0;
                if (typeof showToast === 'function') {
                    showToast('error', 'Error', err.message || 'Error al consultar detalle');
                }
                terminarBusqueda();
            });
        }

        function destruirTablasAuxiliares() {
            $(window).off('resize.auxiliaresGrid');
            $('#contenedorResumenAuxPivot').empty().off('click.auxResumenPivot keydown.auxResumenPivot');
            if ($.fn.DataTable.isDataTable('#tablaAuxiliaresDetalle')) {
                $('#tablaAuxiliaresDetalle').DataTable().destroy();
                $('#tablaAuxiliaresDetalle').empty();
            }
            dataTableAuxiliaresDetalle = null;
        }

        function mostrarPestanasAuxiliares(datosResumen, datosDetalle) {
            datosAuxiliaresResumenActual = datosResumen || [];
            datosAuxiliaresDetalleActual = datosDetalle || [];

            if (!datosAuxiliaresResumenActual.length && !datosAuxiliaresDetalleActual.length) {
                $('#placeholderAuxiliares').show();
                $('#contenedorTabsAuxiliares').hide();
                $('#placeholderAuxiliares .texto p').text('No hay auxiliares para los filtros seleccionados.');
                ocultarBarrasTotalesAux();
                $('#btnExportarExcelAuxiliares').prop('disabled', true);
                return;
            }

            $('#placeholderAuxiliares').hide();
            $('#contenedorTabsAuxiliares').css('display', 'flex').show();
            $('#btnExportarExcelAuxiliares').prop('disabled', false);

            mostrarTablaResumenAux(datosAuxiliaresResumenActual);
            mostrarTablaDetalleAux(datosAuxiliaresDetalleActual);
        }

        function escapeHtmlAux(text) {
            var div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        function agruparResumenAuxPorRubro(datos) {
            var map = {};
            var orden = [];
            $.each(datos || [], function(i, row) {
                var rubro = (row['Rubro'] !== undefined && row['Rubro'] !== null && String(row['Rubro']).trim() !== '')
                    ? String(row['Rubro']).trim()
                    : '(Sin rubro)';
                if (!map[rubro]) {
                    map[rubro] = { nombre: rubro, tipos: [], totalCant: 0, totalAsociados: 0, totalSaldo: 0 };
                    orden.push(rubro);
                }
                var cant = parseInt(row['Cantidad Auxiliares'], 10) || 0;
                var cantAsoc = parseInt(row['Cantidad Asociados'], 10) || 0;
                var saldoNum = parseMontoLocalAux(row['Saldo']);
                map[rubro].tipos.push({
                    tipo: (row['Tipo Auxiliar'] !== undefined && row['Tipo Auxiliar'] !== null) ? String(row['Tipo Auxiliar']) : '',
                    cantidad: cant,
                    cantAsociados: cantAsoc,
                    saldoFmt: row['Saldo'],
                    saldoNum: saldoNum
                });
                map[rubro].totalCant += cant;
                map[rubro].totalAsociados += cantAsoc;
                map[rubro].totalSaldo += saldoNum;
            });
            orden.forEach(function(k) {
                var b = map[k];
                b.totalSaldo = 0;
                for (var j = 0; j < b.tipos.length; j++) {
                    b.totalSaldo += b.tipos[j].saldoNum;
                }
            });
            return orden.map(function(k) { return map[k]; });
        }

        function toggleRubroPivotAux($rowRubro, expandir) {
            var key = $rowRubro.attr('data-rubro-key');
            var $host = $('#contenedorResumenAuxPivot');
            var abrir = (expandir === true) ? true : (expandir === false) ? false : ($rowRubro.attr('aria-expanded') !== 'true');
            $rowRubro.attr('aria-expanded', abrir ? 'true' : 'false').toggleClass('is-expanded', abrir);
            $host.find('.aux-pivot-row-tipo[data-rubro-key="' + key + '"]').prop('hidden', !abrir);
        }

        function aplicarTotalesGlobalesAuxiliares(sumCant, sumAsoc, sumSaldo, totalRegistrosDetalle) {
            $('#totalAuxiliaresGlobal').text(sumCant || 0);
            $('#totalAsociadosGlobal').text(sumAsoc || 0);
            var $saldo = $('#totalSaldoGlobal');
            $saldo.text(formatearSaldoMonedaAux(sumSaldo || 0)).toggleClass('monto-negativo', (sumSaldo || 0) < 0);
            var reg = totalRegistrosDetalle !== undefined && totalRegistrosDetalle !== null
                ? totalRegistrosDetalle
                : (totalRegistrosDetalleAux > 0 ? totalRegistrosDetalleAux : (datosAuxiliaresDetalleActual || []).length);
            $('#totalRegistrosDetalleGlobal').text(reg);
            var hayDatos = (sumCant > 0) || (reg > 0) || ((datosAuxiliaresResumenActual || []).length > 0);
            $('#barTotalesAuxiliaresGlobal').toggle(hayDatos);
        }

        function mostrarTablaResumenAux(datos) {
            var sumCant = 0;
            var sumAsoc = 0;
            var sumSaldo = 0;
            var rubros = agruparResumenAuxPorRubro(datos);
            var html = '';
            var $host = $('#contenedorResumenAuxPivot');

            if (!rubros.length) {
                html = '<p class="aux-resumen-vacio">No hay datos de resumen.</p>';
            } else {
                html += '<div class="aux-pivot-contenedor">';
                html += '<div class="aux-pivot-toolbar">';
                html += '<div class="aux-pivot-dimensiones">';
                html += '<span class="aux-pivot-pill"><i class="fas fa-caret-down"></i> Rubro</span>';
                html += '<span class="aux-pivot-pill"><i class="fas fa-caret-down"></i> Tipo auxiliar</span>';
                html += '</div>';
                html += '<div class="aux-pivot-acciones">';
                html += '<button type="button" class="aux-pivot-btn" id="btnExpandirTodoResumenAux"><i class="fas fa-expand-alt"></i> Expandir todo</button>';
                html += '<button type="button" class="aux-pivot-btn" id="btnContraerTodoResumenAux"><i class="fas fa-compress-alt"></i> Contraer todo</button>';
                html += '</div></div>';
                html += '<table class="aux-pivot-tabla" id="tablaAuxiliaresResumenPivot">';
                html += '<thead><tr>';
                html += '<th class="col-etiqueta">Rubro / Tipo auxiliar</th>';
                html += '<th class="col-cantidad">Auxiliares</th>';
                html += '<th class="col-asociados">Asociados</th>';
                html += '<th class="col-saldo">Saldo</th>';
                html += '</tr></thead><tbody>';

                rubros.forEach(function(bloque, idx) {
                    sumCant += bloque.totalCant;
                    sumAsoc += bloque.totalAsociados;
                    sumSaldo += bloque.totalSaldo;
                    var key = 'rubro-' + idx;
                    var saldoRubroNeg = bloque.totalSaldo < 0;
                    html += '<tr class="aux-pivot-row-rubro is-expanded" data-rubro-key="' + key + '" aria-expanded="true" role="button" tabindex="0">';
                    html += '<td class="aux-pivot-cell-label">';
                    html += '<i class="fas fa-chevron-right aux-pivot-chevron" aria-hidden="true"></i>';
                    html += '<span>' + escapeHtmlAux(bloque.nombre) + '</span></td>';
                    html += '<td class="aux-pivot-cantidad">' + bloque.totalCant + '</td>';
                    html += '<td class="aux-pivot-cantidad">' + bloque.totalAsociados + '</td>';
                    html += '<td class="aux-pivot-monto' + (saldoRubroNeg ? ' monto-negativo' : '') + '">' + escapeHtmlAux(formatearSaldoMonedaAux(bloque.totalSaldo)) + '</td>';
                    html += '</tr>';

                    bloque.tipos.forEach(function(t) {
                        var saldoNeg = t.saldoNum < 0;
                        html += '<tr class="aux-pivot-row-tipo" data-rubro-key="' + key + '">';
                        html += '<td class="aux-pivot-cell-label">' + escapeHtmlAux(t.tipo) + '</td>';
                        html += '<td class="aux-pivot-cantidad">' + t.cantidad + '</td>';
                        html += '<td class="aux-pivot-cantidad">' + t.cantAsociados + '</td>';
                        html += '<td class="aux-pivot-monto' + (saldoNeg ? ' monto-negativo' : '') + '">' + escapeHtmlAux(formatearSaldoMonedaAux(t.saldoNum)) + '</td>';
                        html += '</tr>';
                    });
                });

                html += '</tbody></table></div>';
            }

            $host.html(html);

            $host.off('click.auxResumenPivot keydown.auxResumenPivot');
            $host.on('click.auxResumenPivot', '.aux-pivot-row-rubro', function() {
                toggleRubroPivotAux($(this));
            });
            $host.on('keydown.auxResumenPivot', '.aux-pivot-row-rubro', function(e) {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    toggleRubroPivotAux($(this));
                }
            });
            $host.on('click.auxResumenPivot', '#btnExpandirTodoResumenAux', function(e) {
                e.preventDefault();
                $host.find('.aux-pivot-row-rubro').each(function() {
                    toggleRubroPivotAux($(this), true);
                });
            });
            $host.on('click.auxResumenPivot', '#btnContraerTodoResumenAux', function(e) {
                e.preventDefault();
                $host.find('.aux-pivot-row-rubro').each(function() {
                    toggleRubroPivotAux($(this), false);
                });
            });

            aplicarTotalesGlobalesAuxiliares(sumCant, sumAsoc, sumSaldo);
        }

        function mostrarTablaDetalleAux(datos) {
            dataTableAuxiliaresDetalle = crearDataTableAuxiliares(
                '#tablaAuxiliaresDetalle',
                datos,
                COLUMNAS_DETALLE_AUX,
                [[0, 'desc']]
            );
            $(window).off('resize.auxiliaresGrid').on('resize.auxiliaresGrid', function() {
                ajustarAlturaScrollAuxiliares();
            });
            setTimeout(ajustarAlturaScrollAuxiliares, 0);
            setTimeout(ajustarAlturaScrollAuxiliares, 80);
            setTimeout(ajustarAlturaScrollAuxiliares, 200);
            var filas = (datos || []).length;
            var regDet = totalRegistrosDetalleAux > 0 ? totalRegistrosDetalleAux : filas;
            var sumCant = 0;
            var sumAsoc = 0;
            var sumSaldo = 0;
            agruparResumenAuxPorRubro(datosAuxiliaresResumenActual).forEach(function(b) {
                sumCant += b.totalCant;
                sumAsoc += b.totalAsociados;
                sumSaldo += b.totalSaldo;
            });
            aplicarTotalesGlobalesAuxiliares(sumCant, sumAsoc, sumSaldo, regDet);
        }

        function ocultarBarrasTotalesAux() {
            $('#barTotalesAuxiliaresGlobal').hide();
        }

        function parseMontoLocalAux(val) {
            if (val === undefined || val === null || val === '') return 0;
            if (typeof val === 'number' && !isNaN(val)) return val;
            var s = String(val).trim().replace(/\s/g, '').replace(/\u00a0/g, '');
            if (s === '' || s === '-') return 0;
            var neg = false;
            if (/^\(.+\)$/.test(s)) {
                neg = true;
                s = s.slice(1, -1);
            } else if (s.indexOf('-') >= 0) {
                neg = true;
            }
            // FORMAT(..., 'C') y similares: quitar símbolo de moneda y letras
            s = s.replace(/[^\d,.]/g, '');
            if (s === '' || s === '-') return 0;
            var lastComma = s.lastIndexOf(',');
            var lastDot = s.lastIndexOf('.');
            if (lastComma > lastDot) s = s.replace(/\./g, '').replace(',', '.');
            else if (lastDot > lastComma) s = s.replace(/,/g, '');
            else if (lastComma >= 0) s = s.replace(/\./g, '').replace(',', '.');
            var n = parseFloat(s);
            if (isNaN(n)) return 0;
            return neg ? -n : n;
        }

        function formatearMontoN2Aux(n) {
            return n.toLocaleString('es-ES', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        }

        function formatearSaldoMonedaAux(n) {
            var num = (typeof n === 'number' && !isNaN(n)) ? n : parseMontoLocalAux(n);
            if (isNaN(num)) num = 0;
            var neg = num < 0;
            var abs = Math.abs(num);
            var cuerpo = abs.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            return (neg ? '-' : '') + '$' + cuerpo;
        }

        function prepararResumenExcelExpandido() {
            var rubros = agruparResumenAuxPorRubro(datosAuxiliaresResumenActual);
            var filas = [];
            rubros.forEach(function(bloque) {
                var oRubro = {};
                oRubro['Rubro / Tipo auxiliar'] = bloque.nombre;
                oRubro['Auxiliares'] = bloque.totalCant;
                oRubro['Asociados'] = bloque.totalAsociados;
                oRubro['Saldo'] = formatearSaldoMonedaAux(bloque.totalSaldo);
                oRubro['EsFilaRubro'] = true;
                filas.push(oRubro);
                bloque.tipos.forEach(function(t) {
                    var oTipo = {};
                    oTipo['Rubro / Tipo auxiliar'] = '    ' + t.tipo;
                    oTipo['Auxiliares'] = t.cantidad;
                    oTipo['Asociados'] = t.cantAsociados;
                    oTipo['Saldo'] = formatearSaldoMonedaAux(t.saldoNum);
                    filas.push(oTipo);
                });
            });
            return filas;
        }

        function prepararDetalleExcel() {
            var filas = [];
            (datosAuxiliaresDetalleActual || []).forEach(function(row) {
                var o = {};
                COLUMNAS_DETALLE_AUX.forEach(function(col) {
                    o[col] = (row[col] !== undefined && row[col] !== null) ? row[col] : '';
                });
                filas.push(o);
            });
            return filas;
        }

        function exportarAuxiliaresAExcel() {
            var resumen = prepararResumenExcelExpandido();
            var detalle = prepararDetalleExcel();
            if (!resumen.length && !detalle.length) {
                if (typeof showToast === 'function') {
                    showToast('warning', 'Sin datos', 'No hay datos para exportar');
                }
                return;
            }
            var btn = $('#btnExportarExcelAuxiliares');
            var htmlOriginal = btn.html();
            btn.prop('disabled', true);
            mostrarOverlayAuxiliares('Exportando a Excel, espere por favor...');
            var filtrosExcel = obtenerEtiquetasFiltrosAuxiliaresExcel();
            $.ajax({
                type: 'POST',
                url: 'Auxiliares.aspx/ExportarAExcel',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                data: JSON.stringify({
                    nombreReporte: 'Auxiliares',
                    datosResumen: resumen,
                    datosDetalle: detalle,
                    codigosRubroJson: filtrosExcel.codigosRubroJson,
                    tiposAuxiliarJson: filtrosExcel.tiposAuxiliarJson,
                    numeroAsociado: filtrosExcel.numeroAsociado,
                    mesHistorial: filtrosExcel.mesHistorial,
                    anioHistorial: filtrosExcel.anioHistorial,
                    versionHistorial: filtrosExcel.versionHistorial,
                    rubrosFiltroTexto: filtrosExcel.rubrosTexto ? filtrosExcel.rubrosTexto.join(', ') : null,
                    tiposAuxiliarFiltroTexto: filtrosExcel.tiposAuxiliarTexto ? filtrosExcel.tiposAuxiliarTexto.join(', ') : null,
                    etiquetaAsociado: filtrosExcel.etiquetaAsociado
                }),
                success: function(response) {
                    try {
                        var rd = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        if (rd && rd.Resultado === 'SUCCESS' && rd.NombreArchivo) {
                            var link = document.createElement('a');
                            link.href = 'Auxiliares.aspx?action=download&file=' + encodeURIComponent(rd.NombreArchivo);
                            link.download = rd.NombreArchivo;
                            document.body.appendChild(link);
                            link.click();
                            document.body.removeChild(link);
                            if (typeof showToast === 'function') {
                                showToast('success', 'Éxito', 'Archivo Excel generado correctamente');
                            }
                        } else if (typeof showToast === 'function') {
                            showToast('error', 'Error', rd ? (rd.Mensaje || 'Error al exportar') : 'Error al exportar');
                        }
                    } catch (e) {
                        if (typeof showToast === 'function') {
                            showToast('error', 'Error', 'Error al procesar la exportación');
                        }
                    }
                },
                error: function() {
                    if (typeof showToast === 'function') {
                        showToast('error', 'Error', 'Error al exportar a Excel');
                    }
                },
                complete: function() {
                    ocultarOverlayAuxiliares();
                    btn.prop('disabled', false).html(htmlOriginal);
                }
            });
        }

        function limpiarFiltros() {
            $('#ddlRubro').val(null).trigger('change');
            $('#ddlTipoAuxiliar').val(null).trigger('change');
            limpiarAsociadoSeleccionado();
            limpiarPeriodoHistorial();
            datosAuxiliaresResumenActual = [];
            datosAuxiliaresDetalleActual = [];
            totalRegistrosDetalleAux = 0;
            $('#placeholderAuxiliares').show();
            $('#contenedorTabsAuxiliares').hide();
            $('#placeholderAuxiliares .texto p').text('Utiliza los filtros y haz clic en "Buscar" para ver los auxiliares');
            ocultarBarrasTotalesAux();
            destruirTablasAuxiliares();
            $('#btnExportarExcelAuxiliares').prop('disabled', true);
        }
    </script>
</body>
</html>
