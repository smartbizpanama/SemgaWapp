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
            width: 100%;
            min-width: 130px;
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

        .filters-table td:nth-child(2),
        .filters-table td:nth-child(4) {
            width: auto;
            min-width: 150px;
        }

        .filters-table .filter-row-dates td:last-child {
            text-align: right;
            white-space: nowrap;
        }

        .filters-table .filter-row-dates td:last-child .btn-buscar,
        .filters-table .filter-row-dates td:last-child .btn-limpiar,
        .filters-table .filter-row-dates td:last-child .btn-exportar-excel {
            margin-left: 8px;
        }

        .filters-table .filter-row-dates td:last-child .btn-buscar:first-child {
            margin-left: 0;
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
            width: 100%;
            min-width: 150px;
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

        .table-container table th,
        .table-container table td {
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
            #tablaAsientos {
                min-width: 800px;
            }
        }

        @media (max-width: 768px) {
            .barra-reporte-asientos {
                flex-wrap: wrap;
            }
            .barra-reporte-asientos .titulo-reporte {
                width: 100%;
            }
            .filters-table {
                display: block;
            }
            .filters-table tr {
                display: block;
                margin-bottom: 10px;
            }
            .filters-table td {
                display: block;
                padding: 4px 0;
                width: 100% !important;
            }
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
                    <tr class="filter-row-dates">
                        <td>
                            <label class="filter-label">Fecha Desde:</label>
                        </td>
                        <td>
                            <input type="text" id="txtFechaDesde" class="filter-input" placeholder="dd/MM/yyyy" />
                        </td>
                        <td>
                            <label class="filter-label">Fecha Hasta:</label>
                        </td>
                        <td>
                            <input type="text" id="txtFechaHasta" class="filter-input" placeholder="dd/MM/yyyy" />
                        </td>
                        <td colspan="2" style="text-align: right;">
                            <button type="button" id="btnBuscarAsientos" class="btn-buscar" onclick="buscarAsientos()">
                                <i class="fas fa-search"></i>
                                Buscar
                            </button>
                            <button type="button" class="btn-limpiar" onclick="limpiarFiltros()">
                                <i class="fas fa-eraser"></i>
                                Limpiar
                            </button>
                            <button type="button" id="btnExportarExcelAsientos" class="btn-exportar-excel" disabled="disabled" onclick="exportarAsientosAExcel()">
                                <i class="fas fa-file-excel"></i> Exportar a Excel
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

            <!-- Contenedor de tabla -->
            <div class="table-container">
                <div id="placeholderAsientos" class="placeholder-mensaje">
                    <div class="texto">
                        <i class="fas fa-search"></i>
                        <p style="font-size: 16px;">Utiliza los filtros y haz clic en "Buscar" para ver los asientos</p>
                    </div>
                </div>
                <div id="contenedorTablaAsientos" class="contenedor-grid-asientos" style="display: none;">
                    <div class="asientos-grid-wrapper">
                        <table id="tablaAsientos" class="table table-hover table-striped">
                            <thead>
                                <tr>
                                    <th>ID Asiento</th>
                                    <th>Fecha del Asiento</th>
                                    <th>Hora del Asiento</th>
                                    <th>Código Tipo Asiento</th>
                                    <th>Tipo de Asiento</th>
                                    <th>ID Base</th>
                                    <th>Código de Cuenta</th>
                                    <th>Nombre de la Cuenta</th>
                                    <th>Débito</th>
                                    <th>Crédito</th>
                                    <th>Comentario</th>
                                    <th>¿Eliminado?</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/es.js"></script>
    <script src="../../Scripts/inactivity-monitor-final.js?v=2.6"></script>
    <script src="../../Scripts/notifications.js"></script>

    <script type="text/javascript">
        var dataTableAsientos = null;
        var datosAsientosActual = [];

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

            var btnBuscar = $('#btnBuscarAsientos');
            var htmlOriginal = btnBuscar.html();
            btnBuscar.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Buscando...');

            $.ajax({
                type: "POST",
                url: "Asientos.aspx/ListarAsientos",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({
                    fechaDesde: fechaDesdeStr,
                    fechaHasta: fechaHastaStr
                }),
                success: function(response) {
                    try {
                        var responseData = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        if (responseData && responseData.Success && responseData.Data !== undefined) {
                            var datos = typeof responseData.Data === 'string' ? JSON.parse(responseData.Data) : responseData.Data;
                            mostrarTablaAsientos(datos);
                        } else {
                            if (typeof showToast === 'function') {
                                showToast('error', 'Error', responseData ? (responseData.Message || 'Error al cargar asientos') : 'Error al cargar asientos');
                            }
                            mostrarTablaAsientos([]);
                        }
                    } catch (e) {
                        if (typeof showToast === 'function') {
                            showToast('error', 'Error', 'Error al procesar la respuesta');
                        }
                        mostrarTablaAsientos([]);
                    }
                },
                error: function(xhr, status, error) {
                    if (typeof showToast === 'function') {
                        showToast('error', 'Error', 'Error al consultar asientos');
                    }
                    mostrarTablaAsientos([]);
                },
                complete: function() {
                    btnBuscar.prop('disabled', false).html(htmlOriginal);
                }
            });
        }

        function mostrarTablaAsientos(datos) {
            if (dataTableAsientos) {
                $(window).off('resize.asientos');
                dataTableAsientos.destroy();
                dataTableAsientos = null;
            }

            var tbody = $('#tablaAsientos tbody');
            tbody.empty();

            if (!datos || datos.length === 0) {
                $('#placeholderAsientos').show();
                $('#contenedorTablaAsientos').hide();
                $('#btnExportarExcelAsientos').prop('disabled', true);
                $('#placeholderAsientos .texto p').text('No hay asientos para el rango de fechas seleccionado.');
                return;
            }

            $('#placeholderAsientos').hide();
            $('#contenedorTablaAsientos').css('display', 'flex').show();
            datosAsientosActual = datos;

            var columnas = ['ID Asiento', 'Fecha del Asiento', 'Hora del Asiento', 'Código Tipo Asiento', 'Tipo de Asiento', 'ID Base', 'Código de Cuenta', 'Nombre de la Cuenta', 'Débito', 'Crédito', 'Comentario', '¿Eliminado?'];

            $.each(datos, function(i, row) {
                var tr = '<tr>';
                $.each(columnas, function(j, col) {
                    var valor = (row[col] !== undefined && row[col] !== null) ? row[col] : '';
                    tr += '<td>' + escapeHtml(String(valor)) + '</td>';
                });
                tr += '</tr>';
                tbody.append(tr);
            });

            dataTableAsientos = $('#tablaAsientos').DataTable({
                language: {
                    url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json'
                },
                pageLength: 25,
                lengthMenu: [[25, 50, 100, 200], [25, 50, 100, 200]],
                order: [[1, 'asc']],
                dom: 'tlip',
                search: false,
                scrollX: true,
                scrollY: 400,
                scrollCollapse: false,
                drawCallback: function() {
                    ajustarAlturaScrollAsientos();
                }
            });
            setTimeout(ajustarAlturaScrollAsientos, 0);
            setTimeout(ajustarAlturaScrollAsientos, 120);
            $(window).on('resize.asientos', ajustarAlturaScrollAsientos);
            $('#btnExportarExcelAsientos').prop('disabled', false);
        }

        function ajustarAlturaScrollAsientos() {
            var $wrapper = $('.asientos-grid-wrapper .dataTables_wrapper');
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
        }

        function exportarAsientosAExcel() {
            if (!datosAsientosActual || datosAsientosActual.length === 0) {
                if (typeof showToast === 'function') {
                    showToast('warning', 'Sin datos', 'No hay datos para exportar');
                }
                return;
            }
            var btn = $('#btnExportarExcelAsientos');
            var htmlOriginal = btn.html();
            btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Exportando...');
            $.ajax({
                type: 'POST',
                url: 'Asientos.aspx/ExportarAExcel',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                data: JSON.stringify({
                    nombreReporte: 'Asientos',
                    datos: datosAsientosActual
                }),
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
                    btn.prop('disabled', false).html(htmlOriginal);
                }
            });
        }

        function escapeHtml(text) {
            var div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
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

            $('#placeholderAsientos').show();
            $('#contenedorTablaAsientos').hide();
            $('#btnExportarExcelAsientos').prop('disabled', true);
            $('#placeholderAsientos .texto p').text('Utiliza los filtros y haz clic en "Buscar" para ver los asientos');
            datosAsientosActual = [];
            if (dataTableAsientos) {
                $(window).off('resize.asientos');
                dataTableAsientos.destroy();
                dataTableAsientos = null;
            }
            $('#tablaAsientos tbody').empty();
        }
    </script>
</body>
</html>
