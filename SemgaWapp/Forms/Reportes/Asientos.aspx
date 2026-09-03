<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Asientos.aspx.vb" Inherits="SemgaWapp.Asientos" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Reporte de Asientos</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css"/>
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

        * {
            box-sizing: border-box;
        }

        html, body {
            overflow-x: hidden;
        }
        
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
            box-sizing: border-box;
            min-height: 0;
        }
        
        .barra-reporte-asientos {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
            flex-shrink: 0;
        }

        .barra-reporte-asientos .titulo-reporte {
            font-size: 18px;
            font-weight: 700;
            color: #2c3e50;
            white-space: nowrap;
        }

        .barra-reporte-asientos .filters-section {
            flex: 1;
            margin-bottom: 0;
            padding: 8px 12px;
        }

        .barra-reporte-asientos .back-btn {
            flex-shrink: 0;
            padding: 6px 14px;
            font-size: 13px;
        }

        .back-btn {
            background: linear-gradient(135deg, #87CEEB, #5F9EA0);
            color: white;
            border: none;
            padding: 6px 14px;
            border-radius: 6px;
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
            margin-bottom: 15px;
            flex-shrink: 0;
            min-height: fit-content;
        }
        
        .filters-title {
            font-size: 16px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .filter-group {
            display: flex;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .filter-label {
            font-weight: 500;
            color: #495057;
            font-size: 13px;
            white-space: nowrap;
            margin: 0;
            display: block;
        }
        
        .filter-input {
            padding: 5px 8px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            background: white;
            color: #495057;
            font-size: 13px;
            transition: all 0.3s ease;
        }
        
        .filter-input:focus {
            outline: none;
            border-color: #87CEEB;
            box-shadow: 0 0 0 2px rgba(135, 206, 235, 0.25);
        }

        .filters-table {
            width: 100%;
            border-collapse: collapse;
        }

        .filters-table tr {
            vertical-align: middle;
        }

        .filters-table td {
            padding: 4px 6px;
            vertical-align: middle;
        }

        .filters-table .filter-row-main .filter-td-label {
            width: 1%;
            white-space: nowrap;
            padding-right: 4px;
        }

        .filters-table .filter-row-main .filter-td-periodo {
            width: 1%;
            padding-right: 12px;
        }

        .filters-table .filter-row-main .filter-td-fecha {
            width: 1%;
            padding-right: 12px;
        }

        .filters-table .filter-row-main .filter-td-actions {
            text-align: right;
            white-space: nowrap;
            width: 99%;
            padding-left: 8px;
        }

        .filters-table .filter-row-main .filter-td-actions .btn-buscar,
        .filters-table .filter-row-main .filter-td-actions .btn-limpiar,
        .filters-table .filter-row-main .filter-td-actions .btn-exportar-excel,
        .filters-table .filter-row-main .filter-td-actions .btn-exportar-excel-icon,
        .filters-table .filter-row-main .filter-td-actions .btn-imprimir {
            margin-left: 8px;
        }

        .filters-table .filter-row-main .filter-td-actions .btn-buscar:first-child {
            margin-left: 0;
        }

        .filters-table .filter-input--fecha {
            width: 108px;
            min-width: 108px;
            max-width: 108px;
        }

        /* Dropdown de año dentro del datepicker Flatpickr */
        .flatpickr-current-month .numInputWrapper {
            display: none !important;
        }
        .flatpickr-year-dropdown {
            appearance: menulist;
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.3);
            border-radius: 4px;
            color: inherit;
            cursor: pointer;
            font-size: inherit;
            font-weight: normal;
            padding: 2px 6px;
            margin-left: 4px;
            outline: none;
            min-width: 60px;
        }
        .flatpickr-year-dropdown:hover,
        .flatpickr-year-dropdown:focus {
            background: rgba(255,255,255,0.25);
        }

        .filters-table .filter-input {
            box-sizing: border-box;
        }

        .btn-buscar {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            border: none;
            padding: 6px 14px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-buscar:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.4);
        }

        .btn-limpiar {
            background: #6c757d;
            color: white;
            border: none;
            padding: 6px 14px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-limpiar:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        .table-container {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            min-height: 0;
        }

        .contenedor-tabs-asientos {
            flex: 1;
            min-height: 0;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        /* Pestañas al estilo modal crear/editar socio (GestionSocios.aspx) */
        #contenedorTabsAsientos .nav-tabs {
            flex-shrink: 0;
            border-bottom: 1px solid #e9ecef;
            margin-bottom: 0;
            margin-top: 0;
        }

        #contenedorTabsAsientos .nav-tabs .nav-link {
            border: none;
            color: #6c757d;
            font-weight: 500;
            padding: 12px 20px;
            border-radius: 0;
        }

        #contenedorTabsAsientos .nav-tabs .nav-link.active {
            background: #5a9fd4;
            color: white;
        }

        #contenedorTabsAsientos .nav-tabs .nav-link:hover:not(.active) {
            color: #5a9fd4;
            background: #f8f9fa;
        }

        .tab-content-asientos {
            flex: 1;
            min-height: 0;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            padding-top: 15px;
            border-top: 1px solid #dee2e6;
        }

        .tab-content-asientos .tab-pane {
            flex: 1;
            min-height: 0;
            overflow: hidden;
            display: none;
        }

        .tab-content-asientos .tab-pane.active {
            display: flex;
            flex-direction: column;
        }

        .btn-imprimir {
            background: linear-gradient(135deg, #6c757d, #495057);
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
        }

        .btn-imprimir:hover {
            color: white;
            transform: translateY(-1px);
        }

        .btn-imprimir:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        #tablaAsientosResumen th,
        #tablaAsientosResumen td {
            text-align: center !important;
        }

        #tablaAsientosResumen td.monto-negativo,
        #tablaAsientos td.monto-negativo,
        .table-container .dataTables_scrollBody td.monto-negativo {
            color: #c0392b !important;
            font-weight: 600;
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
        }

        .btn-exportar-excel:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.4);
        }

        .btn-exportar-excel:disabled {
            background: #6c757d;
            cursor: not-allowed;
            transform: none;
        }

        .btn-exportar-excel-icon {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            border: none;
            width: 34px;
            height: 34px;
            padding: 0;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            vertical-align: middle;
            transition: all 0.3s ease;
            box-sizing: border-box;
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

        .loading-asientos-overlay {
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

        .loading-asientos-overlay .spinner-asientos {
            width: 60px;
            height: 60px;
            border: 4px solid rgba(255, 255, 255, 0.3);
            border-top-color: #87CEEB;
            border-radius: 50%;
            animation: spin-asientos 0.8s linear infinite;
        }

        .loading-asientos-overlay .texto-carga {
            margin-top: 20px;
            font-size: 18px;
            font-weight: 500;
        }

        @keyframes spin-asientos {
            to { transform: rotate(360deg); }
        }

        /* Grid: tabla con scroll y paginación siempre debajo de los datos */
        .asientos-grid-wrapper {
            flex: 1;
            min-height: 0;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .asientos-grid-wrapper .dataTables_wrapper {
            flex: 1;
            display: grid;
            grid-template-rows: 1fr auto;
            grid-template-columns: 1fr auto 1fr;
            min-height: 0;
            overflow: hidden;
        }

        .asientos-grid-wrapper .dataTables_scroll {
            grid-row: 1;
            grid-column: 1 / -1;
            min-height: 0;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .asientos-grid-wrapper .dataTables_scrollBody {
            flex: 1;
            min-height: 0;
            overflow-y: auto !important;
            overflow-x: auto !important;
            height: 100% !important;
        }

        .asientos-grid-wrapper .dataTables_scrollBody::-webkit-scrollbar {
            height: 8px;
            width: 8px;
        }

        .asientos-grid-wrapper .dataTables_scrollBody::-webkit-scrollbar-track {
            background: #f8f9fa;
            border-radius: 4px;
        }

        .asientos-grid-wrapper .dataTables_scrollBody::-webkit-scrollbar-thumb {
            background: #6c757d;
            border-radius: 4px;
        }

        /* Fila única debajo de la tabla: leyenda (izq) | dropdown (centro) | botones paginación (der) */
        .asientos-grid-wrapper .dataTables_length {
            grid-row: 2;
            grid-column: 2;
            align-self: center;
            justify-self: center;
            padding: 10px 0;
            flex-shrink: 0;
        }

        .asientos-grid-wrapper .dataTables_info {
            grid-row: 2;
            grid-column: 1;
            align-self: center;
            justify-self: start;
            padding: 10px 0;
            flex-shrink: 0;
        }

        .asientos-grid-wrapper .dataTables_paginate {
            grid-row: 2;
            grid-column: 3;
            align-self: center;
            justify-self: end;
            padding: 10px 0;
            flex-shrink: 0;
        }

        .asientos-grid-wrapper .dataTables_wrapper > .row,
        .asientos-grid-wrapper .dataTables_wrapper .row [class*="col-"] {
            display: contents;
        }

        .asientos-grid-wrapper .dataTables_scroll {
            border-bottom: 1px solid #dee2e6;
        }

        .asientos-grid-wrapper .dataTables_wrapper .row:last-child {
            margin-top: 0;
        }

        .contenedor-grid-asientos {
            flex: 1;
            min-height: 0;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .asientos-totales-bar {
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

        .asientos-totales-bar .totales-titulo {
            font-weight: 700;
            margin-right: 8px;
        }

        .asientos-totales-bar .totales-montos {
            display: flex;
            flex-wrap: wrap;
            gap: 16px 28px;
            align-items: center;
            justify-content: flex-end;
            text-align: right;
        }

        .asientos-totales-bar .totales-montos span {
            white-space: nowrap;
        }

        .asientos-totales-bar .totales-montos b {
            color: #1a5276;
            font-weight: 700;
        }

        .asientos-totales-bar .totales-montos b.monto-negativo {
            color: #c0392b !important;
        }

        /* Resumen pivot: Grupo (padre) + Cuenta (hijo) */
        .asientos-resumen-pivot-scroll {
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

        .asientos-pivot-contenedor {
            width: 100%;
            max-width: 920px;
        }

        .asientos-pivot-toolbar {
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

        .asientos-pivot-dimensiones {
            display: flex;
            align-items: center;
            gap: 8px;
            flex: 1;
            min-width: 0;
        }

        .asientos-pivot-pill {
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
        }

        .asientos-pivot-pill i {
            font-size: 10px;
            color: #64748b;
        }

        .asientos-pivot-acciones {
            display: flex;
            gap: 6px;
        }

        .asientos-pivot-btn {
            padding: 5px 10px;
            font-size: 11px;
            font-weight: 600;
            color: #475569;
            background: #fff;
            border: 1px solid #cbd5e1;
            border-radius: 4px;
            cursor: pointer;
        }

        .asientos-pivot-btn:hover {
            background: #f1f5f9;
        }

        .asientos-pivot-tabla {
            width: 100%;
            max-width: 920px;
            table-layout: fixed;
            border-collapse: collapse;
            font-size: 12px;
            background: #fff;
        }

        .asientos-pivot-tabla thead th {
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

        .asientos-pivot-tabla thead th.col-etiqueta {
            text-align: center !important;
        }

        .asientos-pivot-tabla thead th.col-trans {
            width: 72px;
        }

        .asientos-pivot-tabla thead th.col-monto {
            width: 100px;
        }

        .asientos-pivot-tabla tbody td {
            padding: 7px 10px;
            border-bottom: 1px solid #e9ecef;
            border-right: 1px solid #e9ecef;
            vertical-align: middle;
        }

        .asientos-pivot-tabla tbody td:last-child {
            border-right: none;
        }

        .asientos-pivot-cell-label {
            text-align: left !important;
            color: #212529;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .asientos-pivot-trans {
            text-align: right !important;
            font-variant-numeric: tabular-nums;
            white-space: nowrap;
            padding-right: 10px !important;
        }

        .asientos-pivot-monto {
            text-align: right !important;
            font-variant-numeric: tabular-nums;
            white-space: nowrap;
            padding-right: 10px !important;
        }

        .asientos-pivot-monto.monto-negativo {
            color: #c0392b !important;
            font-weight: 600;
        }

        .table-container .asientos-pivot-tabla thead th {
            text-align: center !important;
        }

        .table-container .asientos-pivot-tabla tbody td.asientos-pivot-cell-label {
            text-align: left !important;
        }

        .table-container .asientos-pivot-tabla tbody td.asientos-pivot-trans,
        .table-container .asientos-pivot-tabla tbody td.asientos-pivot-monto {
            text-align: right !important;
        }

        .asientos-pivot-row-grupo {
            cursor: pointer;
            user-select: none;
        }

        .asientos-pivot-row-grupo td {
            font-weight: 700;
            color: #1a3a5c;
            background-color: #e3f2fd !important;
        }

        .asientos-pivot-row-grupo:hover td {
            background-color: #d4e9f7 !important;
        }

        .asientos-pivot-row-grupo .asientos-pivot-cell-label {
            display: flex;
            align-items: center;
            gap: 8px;
            justify-content: flex-start;
        }

        .asientos-pivot-chevron {
            flex-shrink: 0;
            width: 12px;
            font-size: 10px;
            color: #5a9fd4;
            transition: transform 0.15s ease;
        }

        .asientos-pivot-row-grupo.is-expanded .asientos-pivot-chevron {
            transform: rotate(90deg);
        }

        .asientos-pivot-row-cuenta td {
            background: #fff;
        }

        .asientos-pivot-row-cuenta .asientos-pivot-cell-label {
            padding-left: 28px;
            color: #495057;
        }

        .asientos-pivot-row-cuenta:hover td {
            background: #f8f9fa;
        }

        .asientos-resumen-vacio {
            padding: 24px;
            text-align: center;
            color: #6c757d;
        }

        .table-responsive {
            flex: 1;
            min-height: 0;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .table th {
            background-color: #2c3e50;
            color: white;
            border: none;
            font-weight: 500;
            font-size: 13px;
            padding: 8px 6px;
            text-align: center !important;
            vertical-align: middle;
        }

        .table td {
            padding: 6px 6px;
            vertical-align: middle;
            border-top: 1px solid #dee2e6;
            font-size: 13px;
            word-wrap: break-word;
            text-align: center !important;
        }

        #tablaAsientos th,
        #tablaAsientos td {
            text-align: center !important;
        }

        .table-container .dataTables_wrapper .dataTables_scrollHead th,
        .table-container .dataTables_wrapper .dataTables_scrollBody td {
            text-align: center !important;
        }

        .table-container table:not(.asientos-pivot-tabla) th,
        .table-container table:not(.asientos-pivot-tabla) td {
            text-align: center !important;
        }

        #tablaAsientos {
            width: 100% !important;
            border-collapse: collapse;
            border: 1px solid rgba(0, 0, 0, 0.1);
        }

        .placeholder-mensaje {
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
            height: 100%;
            min-height: 200px;
        }

        .placeholder-mensaje .texto {
            text-align: center;
        }

        .placeholder-mensaje i {
            font-size: 48px;
            margin-bottom: 15px;
            opacity: 0.3;
        }

        @media (max-width: 992px) {
            .table-responsive {
                overflow-x: auto;
                -webkit-overflow-scrolling: touch;
            }
            #tablaAsientos,
            #tablaAsientosResumen {
                min-width: 600px;
            }
        }

        @media (max-width: 768px) {
            .barra-reporte-asientos {
                flex-wrap: wrap;
            }
            .barra-reporte-asientos .titulo-reporte {
                width: 100%;
            }
            .filters-table,
            .filters-table tbody,
            .filters-table tr.filter-row-main {
                display: block;
                width: 100%;
            }
            .filters-table .filter-row-main td {
                display: block;
                padding: 4px 0;
                width: 100% !important;
                text-align: left !important;
            }
            .filters-table .filter-input--fecha,
            .periodo-historial-picker {
                width: 100%;
                max-width: 100%;
                min-width: 0;
            }
            .filters-table .filter-row-main .filter-td-actions .btn-buscar,
            .filters-table .filter-row-main .filter-td-actions .btn-limpiar,
            .filters-table .filter-row-main .filter-td-actions .btn-imprimir,
            .filters-table .filter-row-main .filter-td-actions .btn-exportar-excel-icon {
                margin: 4px 8px 4px 0;
            }
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
            width: 200px;
            min-width: 160px;
            max-width: 220px;
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
            max-width: 220px;
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
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="main-container">
            <!-- Barra: título | filtros | volver -->
            <div class="barra-reporte-asientos">
                <div class="titulo-reporte">Reporte Asientos</div>
                <div class="filters-section">
                <table class="filters-table">
                    <tr class="filter-row-main">
                        <td class="filter-td-label">
                            <label class="filter-label" for="txtFechaDesde">Fecha Desde:</label>
                        </td>
                        <td class="filter-td-fecha">
                            <input type="text" id="txtFechaDesde" class="filter-input filter-input--fecha" placeholder="dd/MM/yyyy" />
                        </td>
                        <td class="filter-td-label">
                            <label class="filter-label" for="txtFechaHasta">Fecha Hasta:</label>
                        </td>
                        <td class="filter-td-fecha">
                            <input type="text" id="txtFechaHasta" class="filter-input filter-input--fecha" placeholder="dd/MM/yyyy" />
                        </td>
                        <td class="filter-td-label">
                            <label class="filter-label">Período historial</label>
                        </td>
                        <td class="filter-td-periodo">
                            <div id="pickerPeriodoHistorial" class="periodo-historial-picker" role="button" tabindex="0" aria-label="Seleccionar período de historial">Sin período</div>
                        </td>
                        <td class="filter-td-actions">
                            <button type="button" id="btnBuscarAsientos" class="btn-buscar" onclick="buscarAsientos()">
                                <i class="fas fa-search"></i>
                                Buscar
                            </button>
                            <button type="button" class="btn-limpiar" onclick="limpiarFiltros()">
                                <i class="fas fa-eraser"></i>
                                Limpiar
                            </button>
                            <button type="button" id="btnImprimirAsientos" class="btn-imprimir" disabled="disabled" onclick="imprimirAsientos()">
                                <i class="fas fa-print"></i> Imprimir
                            </button>
                            <button type="button" id="btnExportarExcelAsientos" class="btn-exportar-excel-icon" disabled="disabled" title="Exportar a Excel" aria-label="Exportar a Excel" onclick="exportarAsientosAExcel()">
                                <i class="fas fa-file-excel"></i>
                            </button>
                        </td>
                    </tr>
                </table>
                </div>
                <a href="dashboardReportes.aspx" class="back-btn">
                    <i class="fas fa-arrow-left"></i>
                    Volver
                </a>
            </div>

            <!-- Contenedor: placeholder o tabs Resumen / Detallado -->
            <div class="table-container">
                <div id="placeholderAsientos" class="placeholder-mensaje">
                    <div class="texto">
                        <i class="fas fa-search"></i>
                        <p style="font-size: 16px;">Utiliza los filtros y haz clic en "Buscar" para ver los asientos</p>
                    </div>
                </div>
                <div id="contenedorTabsAsientos" class="contenedor-tabs-asientos" style="display: none;">
                    <ul class="nav nav-tabs" id="asientosTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="tabResumenBtn" data-bs-toggle="tab" data-bs-target="#tabPaneResumen" type="button" role="tab" aria-controls="tabPaneResumen" aria-selected="true"><i class="fas fa-chart-pie me-2"></i>Resumen</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="tabDetalladoBtn" data-bs-toggle="tab" data-bs-target="#tabPaneDetallado" type="button" role="tab" aria-controls="tabPaneDetallado" aria-selected="false"><i class="fas fa-list-ul me-2"></i>Detallado</button>
                        </li>
                    </ul>
                    <div class="tab-content tab-content-asientos" id="asientosTabContent">
                        <div class="tab-pane fade show active" id="tabPaneResumen" role="tabpanel" aria-labelledby="tabResumenBtn">
                            <div class="contenedor-grid-asientos">
                                <div id="contenedorResumenAsientosPivot" class="asientos-resumen-pivot-scroll"></div>
                                <div class="asientos-totales-bar" id="barTotalesResumen" style="display: none;">
                                    <span class="totales-titulo">Totales</span>
                                    <div class="totales-montos">
                                        <span>Asientos (IDs distintos): <b id="totalTxnDesdeDetalleResumen">0</b></span>
                                        <span>Débito: <b id="totalResumenDebito">0,00</b></span>
                                        <span>Crédito: <b id="totalResumenCredito">0,00</b></span>
                                        <span>Balance: <b id="totalResumenBalance">0,00</b></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="tabPaneDetallado" role="tabpanel" aria-labelledby="tabDetalladoBtn">
                            <div class="contenedor-grid-asientos">
                                <div class="asientos-grid-wrapper">
                                    <table id="tablaAsientos" class="table table-hover table-striped">
                                        <thead><tr></tr></thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                                <div class="asientos-totales-bar" id="barTotalesDetalle" style="display: none;">
                                    <span class="totales-titulo">Totales</span>
                                    <div class="totales-montos">
                                        <span>Asientos (IDs distintos): <b id="totalTxnDetalle">0</b></span>
                                        <span>Débito: <b id="totalDetalleDebito">0,00</b></span>
                                        <span>Crédito: <b id="totalDetalleCredito">0,00</b></span>
                                        <span>Balance: <b id="totalDetalleBalance">0,00</b></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal período historial -->
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
    </form>

    <div id="loadingAsientosOverlay" class="loading-asientos-overlay" style="display: none;">
        <div class="spinner-asientos"></div>
        <div class="texto-carga">Cargando, espere por favor...</div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/es.js"></script>
    <script src="../../Scripts/inactivity-monitor-final.js?v=2.6"></script>
    <script src="../../Scripts/notifications.js?v=2"></script>

    <script type="text/javascript">
        var dataTableAsientos = null;
        var datosAsientosActual = [];
        var datosAsientosResumenActual = [];
        var COLUMNAS_RESUMEN_ASIENTOS_EXCEL = ['Grupo / Cuenta', 'Trans.', 'Débito', 'Crédito', 'Balance'];
        /** Orden de columnas del último spAsientos_Reporte (detallado). */
        var columnasDetalleAsientosActual = [];
        /** Totales de spAsientos_ListarTotales (mismo para resumen y detalle). */
        var totalesGlobalesSp = null;
        var ultimaFechaDesdeAsientosYyyymmdd = '';
        var ultimaFechaHastaAsientosYyyymmdd = '';
        var periodoHistorialSeleccionado = null;
        var modalPeriodoHistorialBs = null;
        var periodosHistorialCatalogo = [];

        var NOMBRES_MESES_HISTORIAL = [
            'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
            'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
        ];

        function normalizarPeriodoHistorialItem(item) {
            return {
                anio: parseInt(item.AnioHistorial != null ? item.AnioHistorial : item.anioHistorial, 10),
                mes: parseInt(item.MesHistorial != null ? item.MesHistorial : item.mesHistorial, 10),
                version: parseInt(item.VersionHistorial != null ? item.VersionHistorial : item.versionHistorial, 10)
            };
        }

        function cargarPeriodosHistorialAsientos() {
            $.ajax({
                type: 'POST',
                url: 'Asientos.aspx/ListarPeriodosHistorialAsientos',
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
            } else if (!opciones.placeholder) {
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

        function obtenerEtiquetaPeriodoHistorialAsientos() {
            if (!periodoHistorialSeleccionado) return '';
            return NOMBRES_MESES_HISTORIAL[periodoHistorialSeleccionado.mes - 1] + ' ' +
                periodoHistorialSeleccionado.anio + ' v' + periodoHistorialSeleccionado.version;
        }

        function obtenerParametrosBusquedaAsientos() {
            var params = {
                fechaDesde: ultimaFechaDesdeAsientosYyyymmdd,
                fechaHasta: ultimaFechaHastaAsientosYyyymmdd,
                mesHistorial: null,
                anioHistorial: null,
                versionHistorial: null
            };
            if (periodoHistorialSeleccionado) {
                params.mesHistorial = periodoHistorialSeleccionado.mes;
                params.anioHistorial = periodoHistorialSeleccionado.anio;
                params.versionHistorial = periodoHistorialSeleccionado.version;
            }
            return params;
        }

        function crearConfigFlatpickrConAnoDropdown() {
            var anoActual = new Date().getFullYear();
            var minDate = new Date(anoActual - 20, 0, 1);
            var maxDate = new Date(anoActual + 2, 11, 31);
            return {
                locale: "es",
                dateFormat: "d/m/Y",
                altInput: true,
                altFormat: "d/m/Y",
                allowInput: true,
                minDate: minDate,
                maxDate: maxDate,
                onReady: function(selectedDates, dateStr, instance) {
                    var yearWrap = instance.calendarContainer.querySelector('.flatpickr-current-month .numInputWrapper');
                    if (!yearWrap) return;
                    yearWrap.style.display = 'none';
                    var container = yearWrap.parentNode;
                    var yearSelect = document.createElement('select');
                    yearSelect.className = 'flatpickr-year-dropdown';
                    var minY = minDate.getFullYear();
                    var maxY = maxDate.getFullYear();
                    for (var y = minY; y <= maxY; y++) {
                        var opt = document.createElement('option');
                        opt.value = y;
                        opt.textContent = y;
                        yearSelect.appendChild(opt);
                    }
                    yearSelect.value = instance.currentYear;
                    yearSelect.addEventListener('mousedown', function(e) { e.stopPropagation(); });
                    yearSelect.addEventListener('click', function(e) { e.stopPropagation(); });
                    yearSelect.addEventListener('change', function() {
                        var y = parseInt(this.value, 10);
                        instance.currentYear = y;
                        instance.redraw();
                    });
                    container.appendChild(yearSelect);
                },
                onMonthChange: function(selectedDates, dateStr, instance) {
                    var container = instance.calendarContainer;
                    var sel = container.querySelector('.flatpickr-year-dropdown');
                    if (sel) sel.value = instance.currentYear;
                }
            };
        }

        $(document).ready(function() {
            if (typeof initializeInactivityMonitoring === 'function') {
                initializeInactivityMonitoring();
            }

            var fechaHoy = new Date();
            var fechaHoyStr = fechaHoy.toLocaleDateString('es-ES', { day: '2-digit', month: '2-digit', year: 'numeric' });

            var configDesde = crearConfigFlatpickrConAnoDropdown();
            configDesde.defaultDate = fechaHoy;
            flatpickr("#txtFechaDesde", configDesde);

            var configHasta = crearConfigFlatpickrConAnoDropdown();
            configHasta.defaultDate = fechaHoy;
            flatpickr("#txtFechaHasta", configHasta);

            $('#txtFechaDesde').val(fechaHoyStr);
            $('#txtFechaHasta').val(fechaHoyStr);

            cargarPeriodosHistorialAsientos();

            $('#ddlAnioHistorial').on('change', onCambioAnioHistorial);
            $('#ddlMesHistorial').on('change', onCambioMesHistorial);
            $('#ddlVersionHistorial').on('change', actualizarEstadoBtnAplicarPeriodoHistorial);
            $('#pickerPeriodoHistorial').on('click keydown', function(e) {
                if ($(e.target).closest('.btn-quitar-periodo').length) return;
                if (e.type === 'keydown' && e.key !== 'Enter' && e.key !== ' ') return;
                if (e.type === 'keydown') e.preventDefault();
                abrirModalPeriodoHistorial();
            });
            $('#pickerPeriodoHistorial').on('click', '.btn-quitar-periodo', limpiarPeriodoHistorial);
            $('#btnAplicarPeriodoHistorial').on('click', aplicarPeriodoHistorialDesdeModal);

            $('#asientosTabs button[data-bs-toggle="tab"]').on('shown.bs.tab', function() {
                setTimeout(function() {
                    ajustarAlturaScrollAsientos();
                    if (dataTableAsientos) {
                        try { dataTableAsientos.columns.adjust(); } catch (ex) { }
                    }
                    refrescarTodasLasBarrasTotales();
                }, 0);
                setTimeout(function() {
                    refrescarTodasLasBarrasTotales();
                }, 200);
            });
        });

        function buscarAsientos() {
            var fechaDesde = $('#txtFechaDesde').val();
            var fechaHasta = $('#txtFechaHasta').val();

            if (!fechaDesde || fechaDesde.trim() === '') {
                if (typeof showToast === 'function') {
                    showToast('warning', 'Fecha requerida', 'La fecha desde es obligatoria');
                }
                return;
            }
            if (!fechaHasta || fechaHasta.trim() === '') {
                if (typeof showToast === 'function') {
                    showToast('warning', 'Fecha requerida', 'La fecha hasta es obligatoria');
                }
                return;
            }

            // Convertir dd/MM/yyyy a yyyyMMdd
            var partesDesde = fechaDesde.split('/');
            var partesHasta = fechaHasta.split('/');
            if (partesDesde.length !== 3 || partesHasta.length !== 3) {
                if (typeof showToast === 'function') {
                    showToast('warning', 'Formato inválido', 'Use el formato dd/MM/yyyy');
                }
                return;
            }
            var fechaDesdeStr = partesDesde[2] + partesDesde[1] + partesDesde[0];
            var fechaHastaStr = partesHasta[2] + partesHasta[1] + partesHasta[0];
            ultimaFechaDesdeAsientosYyyymmdd = fechaDesdeStr;
            ultimaFechaHastaAsientosYyyymmdd = fechaHastaStr;

            var btnBuscar = $('#btnBuscarAsientos');
            btnBuscar.prop('disabled', true);
            mostrarOverlayAsientos('Consultando asientos, espere por favor...');

            var payload = JSON.stringify(obtenerParametrosBusquedaAsientos());
            var datosResumen = [];
            var datosDetalle = [];
            totalesGlobalesSp = null;
            var pendientes = 3;

            function terminarBusqueda() {
                pendientes--;
                if (pendientes > 0) return;
                ocultarOverlayAsientos();
                btnBuscar.prop('disabled', false);
                mostrarPestanasAsientos(datosResumen, datosDetalle);
            }

            function parseListarResponse(response) {
                try {
                    var responseData = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                    if (responseData && responseData.Success && responseData.Data !== undefined) {
                        return typeof responseData.Data === 'string' ? JSON.parse(responseData.Data) : responseData.Data;
                    }
                } catch (e) { }
                return [];
            }

            function parseTotalesResponse(response) {
                var vacio = { Trans: '0', 'Débito': '0,00', 'Crédito': '0,00', 'Balance': '0,00' };
                try {
                    var responseData = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                    if (responseData && responseData.Success && responseData.Data) {
                        return responseData.Data;
                    }
                } catch (e) { }
                return vacio;
            }

            $.ajax({
                type: 'POST',
                url: 'Asientos.aspx/ListarAsientosResumen',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                data: payload,
                success: function(r) { datosResumen = parseListarResponse(r); },
                error: function() { datosResumen = []; },
                complete: terminarBusqueda
            });

            $.ajax({
                type: 'POST',
                url: 'Asientos.aspx/ListarAsientos',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                data: payload,
                success: function(r) { datosDetalle = parseListarResponse(r); },
                error: function() {
                    datosDetalle = [];
                    if (typeof showToast === 'function') {
                        showToast('error', 'Error', 'Error al consultar el detalle de asientos');
                    }
                },
                complete: terminarBusqueda
            });

            $.ajax({
                type: 'POST',
                url: 'Asientos.aspx/ListarTotalesAsientos',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                data: payload,
                success: function(r) { totalesGlobalesSp = parseTotalesResponse(r); },
                error: function() {
                    totalesGlobalesSp = { Trans: '0', 'Débito': '0,00', 'Crédito': '0,00', 'Balance': '0,00' };
                },
                complete: terminarBusqueda
            });
        }

        function destruirTablasAsientos() {
            $(window).off('resize.asientos');
            $('#contenedorResumenAsientosPivot').empty().off('click.asientosPivot keydown.asientosPivot');
            if (dataTableAsientos) {
                dataTableAsientos.destroy();
                dataTableAsientos = null;
            }
            $('#tablaAsientos tbody').empty();
            $('#tablaAsientos thead tr').empty();
            columnasDetalleAsientosActual = [];
        }

        /** Columnas del detalle según las claves que devuelve el SP (orden de la primera fila; nuevas al final). */
        function obtenerColumnasDetalleAsientos(datos) {
            datos = datos || [];
            if (!datos.length) {
                return columnasDetalleAsientosActual.slice();
            }
            var cols = [];
            var seen = {};
            for (var i = 0; i < datos.length; i++) {
                var row = datos[i];
                if (!row) continue;
                for (var k in row) {
                    if (Object.prototype.hasOwnProperty.call(row, k) && !seen[k]) {
                        seen[k] = true;
                        cols.push(k);
                    }
                }
            }
            return cols;
        }

        function valorCeldaDetalleAsientos(col, row) {
            if (col === 'Balance') {
                return obtenerTextoBalanceCelda(row);
            }
            if (esColumnaMontoAsientos(col)) {
                return valorCeldaMontoAsientos(col, row[col]);
            }
            return (row[col] !== undefined && row[col] !== null) ? row[col] : '';
        }

        function mostrarPestanasAsientos(datosResumen, datosDetalle) {
            destruirTablasAsientos();
            datosAsientosResumenActual = datosResumen || [];
            datosAsientosActual = datosDetalle || [];

            if ((!datosResumen || datosResumen.length === 0) && (!datosDetalle || datosDetalle.length === 0)) {
                totalesGlobalesSp = null;
                ocultarBarrasTotales();
                $('#placeholderAsientos').show();
                $('#contenedorTabsAsientos').hide();
                $('#btnExportarExcelAsientos').prop('disabled', true);
                $('#btnImprimirAsientos').prop('disabled', true);
                $('#placeholderAsientos .texto p').text('No hay asientos para el rango de fechas seleccionado.');
                return;
            }

            $('#placeholderAsientos').hide();
            $('#contenedorTabsAsientos').css('display', 'flex').show();

            mostrarTablaResumen(datosResumen || []);
            mostrarTablaAsientos(datosDetalle || []);

            $(window).on('resize.asientos', ajustarAlturaScrollAsientos);
            setTimeout(ajustarAlturaScrollAsientos, 0);
            setTimeout(ajustarAlturaScrollAsientos, 120);

            $('#btnExportarExcelAsientos').prop('disabled', !datosAsientosActual.length && !datosAsientosResumenActual.length);
            $('#btnImprimirAsientos').prop('disabled', !datosAsientosResumenActual.length && !datosAsientosActual.length);

            aplicarTotalesGlobalesSiHay();

            var tabResumen = document.querySelector('#tabResumenBtn');
            if (tabResumen && typeof bootstrap !== 'undefined') {
                var tab = new bootstrap.Tab(tabResumen);
                tab.show();
            }
        }

        /** Lectura tolerante de montos (acentos / distintos nombres de columna desde SQL). */
        function montoDebitoFila(row) {
            if (!row) return 0;
            var keys = ['Débito', 'Debito', 'DEBITO', 'debito'];
            for (var i = 0; i < keys.length; i++) {
                var v = row[keys[i]];
                if (v !== undefined && v !== null && String(v).trim() !== '') {
                    return parseMontoLocal(v);
                }
            }
            return 0;
        }

        function montoCreditoFila(row) {
            if (!row) return 0;
            var keys = ['Crédito', 'Credito', 'CREDITO', 'credito'];
            for (var i = 0; i < keys.length; i++) {
                var v = row[keys[i]];
                if (v !== undefined && v !== null && String(v).trim() !== '') {
                    return parseMontoLocal(v);
                }
            }
            return 0;
        }

        /** Valor numérico de balance por fila (columna SP o Débito − Crédito). */
        function obtenerBalanceLinea(row) {
            if (!row) return 0;
            var keysB = ['Balance', 'BALANCE', 'balance'];
            for (var j = 0; j < keysB.length; j++) {
                var b = row[keysB[j]];
                if (b !== undefined && b !== null && String(b).trim() !== '') {
                    return parseMontoLocal(b);
                }
            }
            return montoDebitoFila(row) - montoCreditoFila(row);
        }

        function obtenerTextoBalanceCelda(row) {
            return formatearSaldoMonedaAsientos(obtenerBalanceLinea(row));
        }

        function esColumnaMontoAsientos(col) {
            return col === 'Débito' || col === 'Crédito' || col === 'Balance';
        }

        function valorCeldaMontoAsientos(col, valor) {
            if (esColumnaMontoAsientos(col)) {
                return formatearSaldoMonedaAsientos(valor);
            }
            return String((valor !== undefined && valor !== null) ? valor : '');
        }

        function celdaTablaAsientos(col, valor) {
            var s = escapeHtml(valorCeldaMontoAsientos(col, valor));
            if (esColumnaMontoAsientos(col) && parseMontoLocal(valor) < 0) {
                return '<td class="monto-negativo">' + s + '</td>';
            }
            return '<td>' + s + '</td>';
        }

        function txnFilaResumenAsientos(row) {
            if (!row) return 0;
            var keys = ['Número de Transacciones', 'Numero de Transacciones', 'Trans.'];
            for (var i = 0; i < keys.length; i++) {
                var v = row[keys[i]];
                if (v !== undefined && v !== null && String(v).trim() !== '') {
                    return parseInt(v, 10) || 0;
                }
            }
            return 0;
        }

        function agruparResumenAsientosPorGrupo(datos) {
            var map = {};
            var orden = [];
            $.each(datos || [], function(i, row) {
                var grupo = (row['Grupo'] !== undefined && row['Grupo'] !== null && String(row['Grupo']).trim() !== '')
                    ? String(row['Grupo']).trim()
                    : '(Sin grupo)';
                if (!map[grupo]) {
                    map[grupo] = { nombre: grupo, cuentas: [], totalTxn: 0, totalDeb: 0, totalCred: 0, totalBal: 0 };
                    orden.push(grupo);
                }
                var etiqueta = (row['Cuenta'] !== undefined && row['Cuenta'] !== null && String(row['Cuenta']).trim() !== '')
                    ? String(row['Cuenta']).trim()
                    : ((row['Código de Cuenta'] || '') + ' | ' + (row['Nombre de la Cuenta'] || ''));
                map[grupo].cuentas.push({
                    etiqueta: etiqueta,
                    txn: txnFilaResumenAsientos(row),
                    deb: montoDebitoFila(row),
                    cred: montoCreditoFila(row),
                    bal: obtenerBalanceLinea(row)
                });
            });
            orden.forEach(function(k) {
                var b = map[k];
                b.totalTxn = 0;
                b.totalDeb = 0;
                b.totalCred = 0;
                b.totalBal = 0;
                for (var j = 0; j < b.cuentas.length; j++) {
                    b.totalTxn += b.cuentas[j].txn;
                    b.totalDeb += b.cuentas[j].deb;
                    b.totalCred += b.cuentas[j].cred;
                    b.totalBal += b.cuentas[j].bal;
                }
            });
            return orden.map(function(k) { return map[k]; });
        }

        function toggleGrupoPivotAsientos($rowGrupo, expandir) {
            var key = $rowGrupo.attr('data-grupo-key');
            var $host = $('#contenedorResumenAsientosPivot');
            var abrir = (expandir === true) ? true : (expandir === false) ? false : ($rowGrupo.attr('aria-expanded') !== 'true');
            $rowGrupo.attr('aria-expanded', abrir ? 'true' : 'false').toggleClass('is-expanded', abrir);
            $host.find('.asientos-pivot-row-cuenta[data-grupo-key="' + key + '"]').prop('hidden', !abrir);
        }

        function celdaMontoPivotAsientos(valor) {
            var n = (typeof valor === 'number') ? valor : parseMontoLocal(valor);
            var cls = 'asientos-pivot-monto' + (n < 0 ? ' monto-negativo' : '');
            return '<td class="' + cls + '">' + escapeHtml(formatearSaldoMonedaAsientos(n)) + '</td>';
        }

        function mostrarTablaResumen(datos) {
            var grupos = agruparResumenAsientosPorGrupo(datos);
            var html = '';
            var $host = $('#contenedorResumenAsientosPivot');

            if (!grupos.length) {
                html = '<p class="asientos-resumen-vacio">No hay datos de resumen.</p>';
            } else {
                html += '<div class="asientos-pivot-contenedor">';
                html += '<div class="asientos-pivot-toolbar">';
                html += '<div class="asientos-pivot-dimensiones">';
                html += '<span class="asientos-pivot-pill"><i class="fas fa-caret-down"></i> Grupo</span>';
                html += '<span class="asientos-pivot-pill"><i class="fas fa-caret-down"></i> Cuenta</span>';
                html += '</div>';
                html += '<div class="asientos-pivot-acciones">';
                html += '<button type="button" class="asientos-pivot-btn" id="btnExpandirTodoResumenAsientos"><i class="fas fa-expand-alt"></i> Expandir todo</button>';
                html += '<button type="button" class="asientos-pivot-btn" id="btnContraerTodoResumenAsientos"><i class="fas fa-compress-alt"></i> Contraer todo</button>';
                html += '</div></div>';
                html += '<table class="asientos-pivot-tabla" id="tablaAsientosResumenPivot">';
                html += '<thead><tr>';
                html += '<th class="col-etiqueta">Grupo / Cuenta</th>';
                html += '<th class="col-trans">Trans.</th>';
                html += '<th class="col-monto">Débito</th>';
                html += '<th class="col-monto">Crédito</th>';
                html += '<th class="col-monto">Balance</th>';
                html += '</tr></thead><tbody>';

                grupos.forEach(function(bloque, idx) {
                    var key = 'grupo-' + idx;
                    html += '<tr class="asientos-pivot-row-grupo is-expanded" data-grupo-key="' + key + '" aria-expanded="true" role="button" tabindex="0">';
                    html += '<td class="asientos-pivot-cell-label">';
                    html += '<i class="fas fa-chevron-right asientos-pivot-chevron" aria-hidden="true"></i>';
                    html += '<span>' + escapeHtml(bloque.nombre) + '</span></td>';
                    html += '<td class="asientos-pivot-trans">' + bloque.totalTxn + '</td>';
                    html += celdaMontoPivotAsientos(bloque.totalDeb);
                    html += celdaMontoPivotAsientos(bloque.totalCred);
                    html += celdaMontoPivotAsientos(bloque.totalBal);
                    html += '</tr>';

                    bloque.cuentas.forEach(function(c) {
                        html += '<tr class="asientos-pivot-row-cuenta" data-grupo-key="' + key + '">';
                        html += '<td class="asientos-pivot-cell-label">' + escapeHtml(c.etiqueta) + '</td>';
                        html += '<td class="asientos-pivot-trans">' + c.txn + '</td>';
                        html += celdaMontoPivotAsientos(c.deb);
                        html += celdaMontoPivotAsientos(c.cred);
                        html += celdaMontoPivotAsientos(c.bal);
                        html += '</tr>';
                    });
                });

                html += '</tbody></table></div>';
            }

            $host.html(html);

            $host.off('click.asientosPivot keydown.asientosPivot');
            $host.on('click.asientosPivot', '.asientos-pivot-row-grupo', function() {
                toggleGrupoPivotAsientos($(this));
            });
            $host.on('keydown.asientosPivot', '.asientos-pivot-row-grupo', function(e) {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    toggleGrupoPivotAsientos($(this));
                }
            });
            $host.on('click.asientosPivot', '#btnExpandirTodoResumenAsientos', function(e) {
                e.preventDefault();
                $host.find('.asientos-pivot-row-grupo').each(function() {
                    toggleGrupoPivotAsientos($(this), true);
                });
            });
            $host.on('click.asientosPivot', '#btnContraerTodoResumenAsientos', function(e) {
                e.preventDefault();
                $host.find('.asientos-pivot-row-grupo').each(function() {
                    toggleGrupoPivotAsientos($(this), false);
                });
            });
        }

        function prepararResumenAsientosExcelExpandido() {
            var grupos = agruparResumenAsientosPorGrupo(datosAsientosResumenActual);
            var filas = [];
            grupos.forEach(function(bloque) {
                var oGrupo = {};
                oGrupo['Grupo / Cuenta'] = bloque.nombre;
                oGrupo['Trans.'] = bloque.totalTxn;
                oGrupo['Débito'] = formatearSaldoMonedaAsientos(bloque.totalDeb);
                oGrupo['Crédito'] = formatearSaldoMonedaAsientos(bloque.totalCred);
                oGrupo['Balance'] = formatearSaldoMonedaAsientos(bloque.totalBal);
                oGrupo['EsFilaGrupo'] = true;
                filas.push(oGrupo);
                bloque.cuentas.forEach(function(c) {
                    var oCuenta = {};
                    oCuenta['Grupo / Cuenta'] = '    ' + c.etiqueta;
                    oCuenta['Trans.'] = c.txn;
                    oCuenta['Débito'] = formatearSaldoMonedaAsientos(c.deb);
                    oCuenta['Crédito'] = formatearSaldoMonedaAsientos(c.cred);
                    oCuenta['Balance'] = formatearSaldoMonedaAsientos(c.bal);
                    filas.push(oCuenta);
                });
            });
            return filas;
        }

        function mostrarTablaAsientos(datos) {
            datos = datos || [];
            columnasDetalleAsientosActual = obtenerColumnasDetalleAsientos(datos);
            var columnas = columnasDetalleAsientosActual;
            var $theadRow = $('#tablaAsientos thead tr');
            $theadRow.empty();
            $.each(columnas, function(i, c) {
                $theadRow.append('<th>' + escapeHtml(c) + '</th>');
            });
            var tbody = $('#tablaAsientos tbody');
            tbody.empty();
            $.each(datos, function(i, row) {
                var tr = '<tr>';
                $.each(columnas, function(j, col) {
                    tr += celdaTablaAsientos(col, valorCeldaDetalleAsientos(col, row));
                });
                tr += '</tr>';
                tbody.append(tr);
            });
            var orderIdx = columnas.indexOf('Fecha del Asiento');
            if (orderIdx < 0) orderIdx = 0;
            dataTableAsientos = $('#tablaAsientos').DataTable({
                language: { url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json' },
                pageLength: 25,
                lengthMenu: [[25, 50, 100, 200], [25, 50, 100, 200]],
                order: [[orderIdx, 'asc']],
                dom: 'tlip',
                search: false,
                scrollX: true,
                scrollY: 400,
                scrollCollapse: false,
                drawCallback: function() { ajustarAlturaScrollAsientos(); }
            });
        }

        function ajustarAlturaScrollAsientos() {
            $('.contenedor-tabs-asientos .asientos-grid-wrapper').each(function() {
                var $gridWrap = $(this);
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
                    scrollDivHeight = $wrapper.height() - footerRowH - 10;
                }
                var headHeight = $scrollHead.outerHeight() || 0;
                var scrollH = Math.max(200, scrollDivHeight - headHeight);
                $scrollBody.css({ 'height': scrollH + 'px', 'min-height': scrollH + 'px' });
            });
        }

        function construirTablaHtml(columnas, datos) {
            var html = '<table class="print-table"><thead><tr>';
            $.each(columnas, function(i, c) { html += '<th>' + escapeHtml(c) + '</th>'; });
            html += '</tr></thead><tbody>';
            if (!datos || datos.length === 0) {
                html += '<tr><td colspan="' + columnas.length + '">Sin registros</td></tr>';
            } else {
                $.each(datos, function(i, row) {
                    html += '<tr>';
                    $.each(columnas, function(j, col) {
                        var v = valorCeldaDetalleAsientos(col, row);
                        var rawMonto = esColumnaMontoAsientos(col) ? (col === 'Balance' ? obtenerBalanceLinea(row) : row[col]) : null;
                        var cls = (esColumnaMontoAsientos(col) && parseMontoLocal(rawMonto) < 0) ? ' class="monto-negativo"' : '';
                        html += '<td' + cls + '>' + escapeHtml(String(v !== undefined && v !== null ? v : '')) + '</td>';
                    });
                    html += '</tr>';
                });
            }
            html += '</tbody></table>';
            return html;
        }

        /** Totales centrados para impresión/PDF (encima de la tabla). */
        function construirBloqueTotalesImpreso(sumD, sumC, sumB, numTxn) {
            var txnPart = '';
            if (numTxn !== undefined && numTxn !== null) {
                txnPart = 'Asientos (IDs distintos): <b>' + escapeHtml(String(numTxn)) + '</b> &nbsp;|&nbsp; ';
            }
            var balCls = sumB < 0 ? ' class="monto-negativo"' : '';
            var inner = '<div class="print-totales-inner">' + txnPart +
                'Débito: <span>' + escapeHtml(formatearSaldoMonedaAsientos(sumD)) + '</span> &nbsp;|&nbsp; ' +
                'Crédito: <span>' + escapeHtml(formatearSaldoMonedaAsientos(sumC)) + '</span> &nbsp;|&nbsp; ' +
                'Balance: <span' + balCls + '>' + escapeHtml(formatearSaldoMonedaAsientos(sumB)) + '</span>' +
                '</div>';
            return '<div class="print-totales-wrap">' + inner + '</div>';
        }

        function imprimirAsientos() {
            if (!datosAsientosResumenActual.length && !datosAsientosActual.length) return;
            var fd = $('#txtFechaDesde').val() || '';
            var fh = $('#txtFechaHasta').val() || '';
            var colsR = COLUMNAS_RESUMEN_ASIENTOS_EXCEL;
            var colsD = obtenerColumnasDetalleAsientos(datosAsientosActual);
            var estilos = 'body{font-family:Segoe UI,sans-serif;font-size:11px;margin:16px;} h1{font-size:18px;text-align:center;} h2{font-size:14px;margin-top:20px;margin-bottom:8px;border-bottom:1px solid #333;padding-bottom:4px;} .meta{color:#555;margin-bottom:16px;text-align:center;} .print-table{width:100%;border-collapse:collapse;margin-top:8px;} .print-table th,.print-table td{border:1px solid #ccc;padding:4px 6px;text-align:center;} .print-table th{background:#2c3e50;color:#fff;} .page-break{page-break-before:always;padding-top:24px;} .print-totales-wrap{text-align:center;margin:6px 0 14px 0;width:100%;} .print-totales-inner{display:inline-block;text-align:center;padding:10px 20px;background:#f0f4f8;border:1px solid #ccc;font-size:11px;} .monto-negativo{color:#c0392b;font-weight:bold;}';
            var t = totalesGlobalesSp || {};
            var numTxn = parseInt((t.Trans !== undefined && t.Trans !== null) ? String(t.Trans) : '0', 10);
            if (isNaN(numTxn)) numTxn = 0;
            var sD = parseMontoLocal(t['Débito']);
            var sC = parseMontoLocal(t['Crédito']);
            var sB = parseMontoLocal(t['Balance']);
            var metaPeriodo = obtenerEtiquetaPeriodoHistorialAsientos();
            var body = '<h1>Reporte Asientos</h1><p class="meta">Fecha desde: ' + escapeHtml(fd) + ' &mdash; Fecha hasta: ' + escapeHtml(fh) +
                (metaPeriodo ? ' &mdash; Historial: ' + escapeHtml(metaPeriodo) : '') + '</p>';
            body += '<h2>Resumen</h2>' + construirBloqueTotalesImpreso(sD, sC, sB, numTxn);
            body += construirTablaHtml(colsR, prepararResumenAsientosExcelExpandido());
            body += '<div class="page-break"></div><h2>Detallado</h2>' + construirTablaHtml(colsD, prepararDatosDetalleExcel());
            body += construirBloqueTotalesImpreso(sD, sC, sB, numTxn);
            var w = window.open('', '_blank', 'width=900,height=700');
            if (!w) {
                if (typeof showToast === 'function') showToast('warning', 'Impresión', 'Permita ventanas emergentes para imprimir');
                return;
            }
            w.document.write('<!DOCTYPE html><html><head><meta charset="utf-8"/><title>Reporte Asientos</title><style>' + estilos + '</style></head><body>' + body + '</body></html>');
            w.document.close();
            w.focus();
            setTimeout(function() { w.print(); }, 300);
        }

        /** Filas detalle solo con columnas exportables (mismas que en pantalla). */
        function prepararDatosDetalleExcel() {
            var cols = obtenerColumnasDetalleAsientos(datosAsientosActual);
            var out = [];
            $.each(datosAsientosActual || [], function(i, row) {
                var o = {};
                $.each(cols, function(j, c) {
                    var v = valorCeldaDetalleAsientos(c, row);
                    o[c] = (v !== undefined && v !== null) ? String(v) : '';
                });
                out.push(o);
            });
            return out;
        }

        function exportarAsientosAExcel() {
            var tieneRes = datosAsientosResumenActual && datosAsientosResumenActual.length > 0;
            var tieneDet = datosAsientosActual && datosAsientosActual.length > 0;
            if (!tieneRes && !tieneDet) {
                if (typeof showToast === 'function') {
                    showToast('warning', 'Sin datos', 'No hay datos para exportar');
                }
                return;
            }
            var btn = $('#btnExportarExcelAsientos');
            btn.prop('disabled', true);
            mostrarOverlayAsientos('Exportando a Excel, espere por favor...');
            $.ajax({
                type: 'POST',
                url: 'Asientos.aspx/ExportarAExcel',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                data: JSON.stringify($.extend({
                    nombreReporte: 'Asientos',
                    datosResumen: prepararResumenAsientosExcelExpandido(),
                    datosDetalle: prepararDatosDetalleExcel(),
                    columnasDetalle: obtenerColumnasDetalleAsientos(datosAsientosActual)
                }, obtenerParametrosBusquedaAsientos())),
                success: function(response) {
                    try {
                        var rd = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        if (rd && rd.Resultado === 'SUCCESS' && rd.NombreArchivo) {
                            var link = document.createElement('a');
                            link.href = 'Asientos.aspx?action=download&file=' + encodeURIComponent(rd.NombreArchivo);
                            link.download = rd.NombreArchivo;
                            document.body.appendChild(link);
                            link.click();
                            document.body.removeChild(link);
                            if (typeof showToast === 'function') {
                                showToast('success', 'Éxito', 'Archivo Excel generado correctamente');
                            }
                        } else {
                            if (typeof showToast === 'function') {
                                showToast('error', 'Error', rd ? (rd.Mensaje || 'Error al exportar') : 'Error al exportar');
                            }
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
                    ocultarOverlayAsientos();
                    btn.prop('disabled', false);
                }
            });
        }

        function mostrarOverlayAsientos(mensaje) {
            $('#loadingAsientosOverlay .texto-carga').text(mensaje || 'Cargando, espere por favor...');
            $('#loadingAsientosOverlay').show();
        }

        function ocultarOverlayAsientos() {
            $('#loadingAsientosOverlay').hide();
        }

        function escapeHtml(text) {
            var div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        /** Convierte montos: es-ES (10.097,77) o FORMAT SQL N2 / en-US (10,097.77); el separador decimal es el último , o . */
        function parseMontoLocal(val) {
            if (val === undefined || val === null || val === '') return 0;
            if (typeof val === 'number' && !isNaN(val)) return val;
            var s = String(val).trim().replace(/\s/g, '').replace(/\u00a0/g, '');
            if (s === '' || s === '-') return 0;
            var neg = false;
            if (s.charAt(0) === '-') {
                neg = true;
                s = s.slice(1);
            }
            var lastComma = s.lastIndexOf(',');
            var lastDot = s.lastIndexOf('.');
            if (lastComma > lastDot) {
                s = s.replace(/\./g, '').replace(',', '.');
            } else if (lastDot > lastComma) {
                s = s.replace(/,/g, '');
            } else if (lastComma >= 0) {
                s = s.replace(/\./g, '').replace(',', '.');
            }
            var n = parseFloat(s);
            if (isNaN(n)) return 0;
            return neg ? -n : n;
        }

        function formatearMontoN2(n) {
            return n.toLocaleString('es-ES', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        }

        function formatearSaldoMonedaAsientos(n) {
            var num = (typeof n === 'number' && !isNaN(n)) ? n : parseMontoLocal(n);
            if (isNaN(num)) num = 0;
            var neg = num < 0;
            var abs = Math.abs(num);
            var cuerpo = abs.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            return (neg ? '-' : '') + '$' + cuerpo;
        }

        function aplicarMontoEnTotal($el, n) {
            $el.text(formatearSaldoMonedaAsientos(n));
            $el.toggleClass('monto-negativo', n < 0);
        }

        /** Pinta ambas barras con spAsientos_ListarTotales (mismos valores en Resumen y Detallado). */
        function aplicarTotalesGlobalesSiHay() {
            var t = totalesGlobalesSp;
            if (!t) {
                t = { Trans: '0', 'Débito': '0,00', 'Crédito': '0,00', 'Balance': '0,00' };
            }
            var trans = (t.Trans !== undefined && t.Trans !== null && String(t.Trans).trim() !== '') ? String(t.Trans) : '0';
            var debNum = parseMontoLocal(t['Débito']);
            var credNum = parseMontoLocal(t['Crédito']);
            var balNum = parseMontoLocal(t['Balance']);

            $('#totalTxnDesdeDetalleResumen, #totalTxnDetalle').text(trans);
            aplicarMontoEnTotal($('#totalResumenDebito, #totalDetalleDebito'), debNum);
            aplicarMontoEnTotal($('#totalResumenCredito, #totalDetalleCredito'), credNum);
            aplicarMontoEnTotal($('#totalResumenBalance, #totalDetalleBalance'), balNum);

            var hayDatos = (datosAsientosResumenActual && datosAsientosResumenActual.length) ||
                (datosAsientosActual && datosAsientosActual.length);
            if (hayDatos) {
                $('#barTotalesResumen, #barTotalesDetalle').show();
            } else {
                $('#barTotalesResumen, #barTotalesDetalle').hide();
            }
        }

        /** Recalcula ambas barras desde sp (útil tras cambiar de pestaña / columns.adjust). */
        function refrescarTodasLasBarrasTotales() {
            aplicarTotalesGlobalesSiHay();
        }

        function ocultarBarrasTotales() {
            totalesGlobalesSp = null;
            $('#barTotalesResumen, #barTotalesDetalle').hide();
            $('#totalResumenDebito, #totalResumenCredito, #totalResumenBalance, #totalDetalleDebito, #totalDetalleCredito, #totalDetalleBalance').removeClass('monto-negativo').text('0,00');
            $('#totalTxnDesdeDetalleResumen, #totalTxnDetalle').text('0');
        }

        function sumarColumnaNumerica(datos, col) {
            var t = 0;
            $.each(datos || [], function(i, row) {
                t += parseMontoLocal(row[col]);
            });
            return t;
        }

        function limpiarFiltros() {
            var fechaHoy = new Date();
            var fechaHoyStr = fechaHoy.toLocaleDateString('es-ES', { day: '2-digit', month: '2-digit', year: 'numeric' });

            $('#txtFechaDesde').val(fechaHoyStr);
            $('#txtFechaHasta').val(fechaHoyStr);

            var fpDesde = $('#txtFechaDesde')[0]._flatpickr;
            var fpHasta = $('#txtFechaHasta')[0]._flatpickr;
            if (fpDesde) fpDesde.setDate(fechaHoy, false);
            if (fpHasta) fpHasta.setDate(fechaHoy, false);

            limpiarPeriodoHistorial();

            $('#placeholderAsientos').show();
            $('#contenedorTabsAsientos').hide();
            $('#btnExportarExcelAsientos').prop('disabled', true);
            $('#btnImprimirAsientos').prop('disabled', true);
            $('#placeholderAsientos .texto p').text('Utiliza los filtros y haz clic en "Buscar" para ver los asientos');
            datosAsientosActual = [];
            datosAsientosResumenActual = [];
            totalesGlobalesSp = null;
            ultimaFechaDesdeAsientosYyyymmdd = '';
            ultimaFechaHastaAsientosYyyymmdd = '';
            ocultarBarrasTotales();
            destruirTablasAsientos();
        }
    </script>
</body>
</html>
