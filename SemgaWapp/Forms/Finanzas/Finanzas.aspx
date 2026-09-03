<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Finanzas.aspx.vb" Inherits="SemgaWapp.Finanzas" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Finanzas - Asientos Contables</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css" rel="stylesheet" />

    <style>
        body {
            background: #f5f7fb;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .main-wrapper {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .card-header {
            background: linear-gradient(135deg, #1e3a8a, #3b82f6);
            color: white;
        }

        .section-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .section-title i {
            color: #2563eb;
        }

        .table thead th {
            background-color: #f1f5f9;
            color: #475569;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-size: 0.75rem;
        }

        .totals-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 12px;
        }

        .totals-box .total-label {
            font-weight: 600;
            color: #475569;
        }

        .totals-box .total-value {
            font-size: 1.1rem;
            font-weight: 700;
        }

        .asiento-creado-box {
            background: linear-gradient(135deg, #1e3a8a, #3b82f6);
            color: white;
            border-radius: 8px;
            padding: 15px 20px;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .asiento-creado-label {
            font-weight: 600;
            font-size: 1rem;
            color: rgba(255, 255, 255, 0.9);
        }

        .asiento-creado-value {
            font-weight: 700;
            font-size: 1.5rem;
            color: white;
            letter-spacing: 1px;
        }

        .select2-container--bootstrap-5 .select2-selection {
            min-height: 38px;
        }

        .select2-container--bootstrap-5 .select2-selection__rendered {
            padding-top: 4px;
        }

        .remove-line-btn {
            color: #e11d48;
        }

        .remove-line-btn:hover {
            color: #be123c;
        }

        #tblDetalleAsiento thead th,
        #tblDetalleAsiento tbody td {
            text-align: center;
            vertical-align: middle;
        }

        .toast-confirm {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            min-width: 360px;
            z-index: 1060;
            box-shadow: 0 18px 45px rgba(15, 23, 42, 0.25);
        }

        .toast-confirm .toast-body {
            font-size: 0.95rem;
        }

        .toast-confirm .btn {
            min-width: 110px;
        }

        .formulario-bloqueado input,
        .formulario-bloqueado textarea,
        .formulario-bloqueado select,
        .formulario-bloqueado button:not(#btnImprimir):not(#btnNuevo) {
            background-color: #f8f9fa !important;
            cursor: not-allowed !important;
            opacity: 0.7;
        }

        .formulario-bloqueado .remove-line-btn {
            display: none;
        }

        .formulario-bloqueado #btnAgregarLinea {
            display: none;
        }

        .formulario-bloqueado #btnLimpiar {
            display: none;
        }

        .formulario-bloqueado #btnGuardar {
            display: none;
        }

        .formulario-bloqueado #btnNuevo {
            display: inline-block !important;
            cursor: pointer !important;
            opacity: 1 !important;
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
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.15);
        }
        .header-fechas-ref .fecha-ref-pill--real {
            background: linear-gradient(135deg, #0f766e 0%, #14b8a6 100%);
            color: #fff;
            border-color: rgba(255, 255, 255, 0.35);
        }
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
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="main-wrapper">
            <div class="card shadow-sm">
                <div class="card-header">
                    <div class="d-flex align-items-start justify-content-between flex-wrap gap-2 w-100">
                        <div class="flex-grow-1 min-width-0">
                            <div class="d-flex flex-wrap align-items-center gap-2 gap-md-3 header-title-with-fechas">
                                <h5 class="mb-0 flex-shrink-0 align-self-center"><i class="fas fa-balance-scale me-2"></i>Registro de Asientos Contables</h5>
                                <div id="fechasReferenciaHeader" class="header-fechas-ref d-flex flex-wrap align-items-center gap-2 flex-grow-1 min-width-0" aria-live="polite"></div>
                            </div>
                        </div>
                        <div class="flex-shrink-0">
                            <button type="button" class="btn btn-light btn-sm" onclick="volverDashboard()">
                                <i class="fas fa-arrow-left me-1"></i>Volver
                            </button>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="mb-4">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <label for="txtFecha" class="form-label">Fecha</label>
                                <input type="text" class="form-control" id="txtFecha" placeholder="dd/MM/yyyy" autocomplete="off" />
                                <input type="hidden" id="hdnFechaISO" />
                            </div>
                            <div class="col-md-9">
                                <label for="txtComentario" class="form-label">Comentario</label>
                                <textarea class="form-control" id="txtComentario" rows="2" placeholder="Detalle o descripción del asiento..."></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="mb-4">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <div class="section-title mb-0">
                                <i class="fas fa-list"></i>
                                Detalle del Asiento
                            </div>
                            <button type="button" id="btnAgregarLinea" class="btn btn-sm btn-primary">
                                <i class="fas fa-plus me-1"></i>Agregar cuenta
                            </button>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-striped align-middle" id="tblDetalleAsiento">
                                <thead>
                                    <tr>
                                        <th style="width: 35%;">Cuenta</th>
                                        <th style="width: 25%;">Saldo</th>
                                        <th style="width: 15%;">Débito</th>
                                        <th style="width: 15%;">Crédito</th>
                                        <th style="width: 10%;"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>

                        <div class="row mt-3">
                            <div class="col-md-6">
                                <div class="totals-box">
                                    <div class="row">
                                        <div class="col-4">
                                            <div class="total-label">Total Débito</div>
                                            <div class="total-value text-success" id="lblTotalDebito">0.00</div>
                                        </div>
                                        <div class="col-4">
                                            <div class="total-label">Total Crédito</div>
                                            <div class="total-value text-indigo" id="lblTotalCredito">0.00</div>
                                        </div>
                                        <div class="col-4">
                                            <div class="total-label">Balance</div>
                                            <div class="total-value text-success" id="lblBalance">0.00</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div id="divAsientoCreado" class="asiento-creado-box" style="display: none;">
                                    <div class="asiento-creado-label">Asiento Creado:</div>
                                    <div class="asiento-creado-value" id="lblAsientoCreado">-</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end gap-2">
                        <button type="button" id="btnLimpiar" class="btn btn-outline-secondary">
                            <i class="fas fa-eraser me-1"></i>Limpiar
                        </button>
                        <button type="button" id="btnGuardar" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Guardar Asiento
                        </button>
                        <button type="button" id="btnNuevo" class="btn" style="display: none; background: linear-gradient(135deg, #1e3a8a, #3b82f6); border: none; color: white;">
                            <i class="fas fa-plus me-1"></i>Nuevo
                        </button>
                        <button type="button" id="btnImprimir" class="btn btn-success" style="display: none;">
                            <i class="fas fa-print me-1"></i>Imprimir
                        </button>
                    </div>
                </div>
            </div>
            <div id="toastContainer" class="toast-container position-fixed top-0 end-0 p-3" style="z-index: 1060;"></div>
        </div>
    </form>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="../../Scripts/notifications.js?v=1.0"></script>

    <script>
        let cuentasCatalogo = [];
        const currencyFormatter = new Intl.NumberFormat('es-US', { style: 'currency', currency: 'USD' });
        function formatCurrency(value) {
            const number = Number(value);
            if (isNaN(number)) {
                return currencyFormatter.format(0);
            }
            return currencyFormatter.format(number);
        }

        function poblarSelectCuenta($select, selectedValue) {
            if (!$select || $select.length === 0) {
                return;
            }

            let optionsHtml = '<option value="">Seleccionar cuenta...</option>';
            cuentasCatalogo.forEach(function (cuenta) {
                const saldoAttr = isNaN(cuenta.Saldo) ? '' : cuenta.Saldo;
                const isSelected = selectedValue && cuenta.Cuenta === selectedValue ? ' selected' : '';
                optionsHtml += `<option value="${cuenta.Cuenta}" data-saldo="${saldoAttr}"${isSelected}>${cuenta.NombreCuenta}</option>`;
            });

            $select.html(optionsHtml);

            if ($.fn.select2 && $select.hasClass('select2-hidden-accessible')) {
                $select.trigger('change.select2');
            }
        }

        function actualizarSelectsCuentas() {
            $('#tblDetalleAsiento tbody tr').each(function () {
                const $fila = $(this);
                const $select = $fila.find('.cuenta-select');
                const valorActual = $select.val();

                poblarSelectCuenta($select, valorActual);

                const cuentaSeleccionada = cuentasCatalogo.find(function (item) {
                    return item.Cuenta === valorActual;
                });
                const saldoTexto = cuentaSeleccionada ? formatCurrency(cuentaSeleccionada.Saldo) : formatCurrency(0);
                $fila.find('.saldo-cuenta').text(saldoTexto);
            });
        }

        function obtenerFilasInicialesDetalle() {
            return 2;
        }

        function formatDateToDisplay(isoDate) {
            if (!isoDate) {
                return '';
            }
            const parts = isoDate.split('-');
            if (parts.length !== 3) {
                return '';
            }
            const [year, month, day] = parts;
            return `${day.padStart(2, '0')}/${month.padStart(2, '0')}/${year}`;
        }

        function parseDisplayDate(displayValue) {
            if (!displayValue) {
                return null;
            }
            const parts = displayValue.split('/');
            if (parts.length !== 3) {
                return null;
            }
            let [day, month, year] = parts;
            if (day.length === 1) day = `0${day}`;
            if (month.length === 1) month = `0${month}`;
            if (year.length === 2) {
                year = `20${year}`;
            }
            if (day.length !== 2 || month.length !== 2 || year.length !== 4) {
                return null;
            }
            const isoCandidate = `${year}-${month}-${day}`;
            const testDate = new Date(isoCandidate);
            if (Number.isNaN(testDate.getTime())) {
                return null;
            }
            return isoCandidate;
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

        $(document).ready(function () {
            semgaCargarFechasReferenciaTitulo('Finanzas.aspx/ObtenerFechasReferenciaTitulo');
            inicializarFormulario();
        });

        function inicializarFormulario() {
            const todayIso = new Date().toISOString().split('T')[0];
            $('#hdnFechaISO').val(todayIso);

            flatpickr('#txtFecha', {
                dateFormat: 'd/m/Y',
                defaultDate: todayIso,
                allowInput: true,
                locale: {
                    firstDayOfWeek: 1
                },
                onReady: function (selectedDates, dateStr, instance) {
                    instance.setDate(todayIso, false, 'Y-m-d');
                    $('#hdnFechaISO').val(todayIso);
                },
                onChange: function (selectedDates, dateStr, instance) {
                    if (selectedDates.length > 0) {
                        const isoDate = selectedDates[0].toISOString().split('T')[0];
                        $('#hdnFechaISO').val(isoDate);
                    }
                },
                onClose: function (selectedDates, dateStr, instance) {
                    if (selectedDates.length === 0) {
                        const isoDate = parseDisplayDate($('#txtFecha').val());
                        if (isoDate) {
                            $('#hdnFechaISO').val(isoDate);
                            instance.setDate(isoDate, false, 'Y-m-d');
                        } else {
                            $('#hdnFechaISO').val('');
                            showToast('warning', 'Validación', 'La fecha debe respetar el formato dd/MM/yyyy.');
                            $('#txtFecha').val('');
                        }
                    }
                }
            });

            cargarCuentas().then(function () {
                const filasIniciales = obtenerFilasInicialesDetalle();
                for (let i = 0; i < filasIniciales; i++) {
                    agregarLineaDetalle();
                }
            });

            $('#btnAgregarLinea').on('click', function () {
                agregarLineaDetalle();
            });

            $('#btnLimpiar').on('click', function () {
                limpiarFormulario();
            });

            $('#btnGuardar').on('click', function () {
                guardarAsiento();
            });

            $('#btnImprimir').on('click', function () {
                imprimirAsiento();
            });

            $('#btnNuevo').on('click', function () {
                window.location.reload();
            });
        }

        function bloquearFormulario() {
            // Agregar clase para bloquear
            $('.card-body').addClass('formulario-bloqueado');
            
            // Deshabilitar todos los campos
            $('#txtFecha').prop('disabled', true);
            $('#txtComentario').prop('disabled', true);
            $('#tblDetalleAsiento input, #tblDetalleAsiento select').prop('disabled', true);
            
            // Ocultar botones de acción y mostrar botón de imprimir
            $('#btnGuardar').hide();
            $('#btnLimpiar').hide();
            $('#btnAgregarLinea').hide();
            $('#btnImprimir').show();
        }

        function imprimirAsiento() {
            // Obtener datos del formulario
            const fecha = $('#txtFecha').val();
            const comentario = $('#txtComentario').val();
            const totalDebito = parseFloat($('#lblTotalDebito').text().replace(/[^0-9.-]/g, '')) || 0;
            const totalCredito = parseFloat($('#lblTotalCredito').text().replace(/[^0-9.-]/g, '')) || 0;
            
            // Obtener datos del asiento guardado
            const asientoId = window.asientoGuardado ? window.asientoGuardado.id : 0;
            const usuario = window.asientoGuardado ? window.asientoGuardado.usuario : '';
            
            // Obtener detalles de la tabla
            const detalles = [];
            $('#tblDetalleAsiento tbody tr').each(function() {
                const cuentaCodigo = $(this).find('.cuenta-select').val();
                if (cuentaCodigo) {
                    const cuentaSeleccionada = cuentasCatalogo.find(c => c.Cuenta === cuentaCodigo);
                    const nombreCuenta = cuentaSeleccionada ? cuentaSeleccionada.NombreCuenta : '';
                    const saldo = cuentaSeleccionada ? cuentaSeleccionada.Saldo : 0;
                    const debito = parseFloat($(this).find('.debit-input').val()) || 0;
                    const credito = parseFloat($(this).find('.credit-input').val()) || 0;
                    
                    if (debito > 0 || credito > 0) {
                        detalles.push({
                            NombreCuenta: nombreCuenta,
                            Saldo: saldo,
                            Debito: debito,
                            Credito: credito
                        });
                    }
                }
            });
            
            // Fecha y hora de impresión
            const ahora = new Date();
            const fechaHora = ahora.toLocaleString('es-ES', {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit'
            });
            
            // Generar HTML para impresión
            let detallesHtml = '';
            detalles.forEach(function(detalle) {
                detallesHtml += `
                    <tr>
                        <td style="padding: 8px; border: 1px solid #dee2e6; text-align: left;">${detalle.NombreCuenta}</td>
                        <td style="padding: 8px; border: 1px solid #dee2e6; text-align: right;">${formatCurrency(detalle.Saldo)}</td>
                        <td style="padding: 8px; border: 1px solid #dee2e6; text-align: right;">${detalle.Debito > 0 ? formatCurrency(detalle.Debito) : ''}</td>
                        <td style="padding: 8px; border: 1px solid #dee2e6; text-align: right;">${detalle.Credito > 0 ? formatCurrency(detalle.Credito) : ''}</td>
                    </tr>
                `;
            });
            
            const htmlImpresion = `
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <title>Asiento Contable</title>
                    <style>
                        @page {
                            size: letter;
                            margin: 1cm;
                        }
                        * {
                            -webkit-print-color-adjust: exact !important;
                            print-color-adjust: exact !important;
                            color-adjust: exact !important;
                        }
                        body {
                            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                            font-size: 12px;
                            color: #333;
                            margin: 0;
                            padding: 20px;
                        }
                        .header {
                            text-align: center;
                            margin-bottom: 30px;
                            border-bottom: 2px solid #2c3e50;
                            padding-bottom: 15px;
                        }
                        .header h1 {
                            margin: 0;
                            font-size: 24px;
                            color: #2c3e50;
                            font-weight: 600;
                        }
                        .info-section {
                            margin-bottom: 25px;
                        }
                        .asiento-id-container {
                            display: flex;
                            align-items: center;
                            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
                            color: white;
                            padding: 12px 20px;
                            border-radius: 6px;
                            margin-bottom: 15px;
                            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                        }
                        .asiento-id-label {
                            font-weight: 600;
                            font-size: 13px;
                            margin-right: 12px;
                            color: rgba(255,255,255,0.9);
                        }
                        .asiento-id-value {
                            font-weight: 700;
                            font-size: 18px;
                            color: white;
                            letter-spacing: 0.5px;
                        }
                        .info-row {
                            display: flex;
                            margin-bottom: 8px;
                        }
                        .info-label {
                            font-weight: 600;
                            width: 150px;
                            color: #495057;
                        }
                        .info-value {
                            flex: 1;
                            color: #212529;
                        }
                        .comentario-box {
                            background: #f8f9fa !important;
                            border: 1px solid #dee2e6;
                            border-radius: 4px;
                            padding: 10px;
                            margin-bottom: 20px;
                        }
                        .comentario-label {
                            font-weight: 600;
                            margin-bottom: 5px;
                            color: #495057;
                        }
                        .comentario-text {
                            color: #212529;
                        }
                        table {
                            width: 100%;
                            border-collapse: collapse;
                            margin-bottom: 20px;
                        }
                        thead th {
                            background-color: #2c3e50 !important;
                            color: white !important;
                            padding: 10px 8px;
                            text-align: center;
                            font-weight: 600;
                            border: 1px solid #1a252f;
                        }
                        tbody td {
                            padding: 8px;
                            border: 1px solid #dee2e6;
                        }
                        tbody tr:nth-child(even) {
                            background-color: #f8f9fa !important;
                        }
                        .totals-row {
                            font-weight: 700;
                            background-color: #e9ecef !important;
                        }
                        .totals-row td {
                            border-top: 2px solid #2c3e50;
                            padding: 10px 8px;
                        }
                        .footer {
                            margin-top: 30px;
                            padding-top: 15px;
                            border-top: 1px solid #dee2e6;
                            text-align: center;
                            font-size: 11px;
                            color: #6c757d;
                        }
                    </style>
                </head>
                <body>
                    <div class="header">
                        <h1>ASIENTO CONTABLE</h1>
                    </div>
                    
                    <div class="info-section">
                        <div class="asiento-id-container">
                            <div class="asiento-id-label">ID Asiento:</div>
                            <div class="asiento-id-value">${asientoId > 0 ? asientoId : 'N/A'}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Fecha:</div>
                            <div class="info-value">${fecha}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Usuario:</div>
                            <div class="info-value">${usuario || 'N/A'}</div>
                        </div>
                    </div>
                    
                    <div class="comentario-box">
                        <div class="comentario-label">Comentario:</div>
                        <div class="comentario-text">${comentario || ''}</div>
                    </div>
                    
                    <table>
                        <thead>
                            <tr>
                                <th style="width: 50%; background-color: #2c3e50 !important; color: white !important;">Nombre de Cuenta</th>
                                <th style="width: 20%; background-color: #2c3e50 !important; color: white !important;">Saldo Previo</th>
                                <th style="width: 15%; background-color: #2c3e50 !important; color: white !important;">Débito</th>
                                <th style="width: 15%; background-color: #2c3e50 !important; color: white !important;">Crédito</th>
                            </tr>
                        </thead>
                        <tbody>
                            ${detallesHtml}
                            <tr class="totals-row">
                                <td style="text-align: right; font-weight: 700;">TOTALES:</td>
                                <td style="text-align: right;">-</td>
                                <td style="text-align: right;">${formatCurrency(totalDebito)}</td>
                                <td style="text-align: right;">${formatCurrency(totalCredito)}</td>
                            </tr>
                        </tbody>
                    </table>
                    
                    <div class="footer">
                        <strong>Fecha y hora de impresión:</strong> ${fechaHora}
                    </div>
                </body>
                </html>
            `;
            
            // Crear iframe oculto para imprimir sin mostrar ventana
            const iframe = document.createElement('iframe');
            iframe.style.position = 'fixed';
            iframe.style.right = '0';
            iframe.style.bottom = '0';
            iframe.style.width = '0';
            iframe.style.height = '0';
            iframe.style.border = '0';
            iframe.style.opacity = '0';
            iframe.style.pointerEvents = 'none';
            document.body.appendChild(iframe);
            
            let impresionEjecutada = false;
            
            // Función para ejecutar la impresión
            const ejecutarImpresion = function() {
                if (impresionEjecutada) return;
                impresionEjecutada = true;
                
                try {
                    iframe.contentWindow.focus();
                    iframe.contentWindow.print();
                    
                    // Remover el iframe después de un tiempo
                    setTimeout(function() {
                        if (iframe && iframe.parentNode) {
                            document.body.removeChild(iframe);
                        }
                    }, 1000);
                } catch (e) {
                    console.error('Error al imprimir:', e);
                    if (iframe && iframe.parentNode) {
                        document.body.removeChild(iframe);
                    }
                }
            };
            
            // Escribir el contenido en el iframe
            const iframeDoc = iframe.contentDocument || iframe.contentWindow.document;
            iframeDoc.open();
            iframeDoc.write(htmlImpresion);
            iframeDoc.close();
            
            // Esperar a que cargue y luego imprimir
            iframe.onload = function() {
                setTimeout(ejecutarImpresion, 250);
            };
            
            // Fallback con timeout único
            setTimeout(function() {
                if (!impresionEjecutada && iframe.contentWindow) {
                    ejecutarImpresion();
                }
            }, 1000);
        }

        function cargarCuentas() {
            return $.ajax({
                type: 'POST',
                url: 'Finanzas.aspx/ObtenerCuentas',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (response) {
                    let data = response.d;
                    if (typeof data === 'string') {
                        data = JSON.parse(data);
                    }

                    if (data && data.Resultado === 'SUCCESS') {
                        cuentasCatalogo = JSON.parse(data.Datos).map(function (cuenta) {
                            const saldo = parseFloat(cuenta.Saldo);
                            return {
                                Cuenta: cuenta.Cuenta,
                                NombreCuenta: cuenta.NombreCuenta,
                                Saldo: isNaN(saldo) ? 0 : saldo
                            };
                        });
                    } else {
                        showToast('error', 'Error', data ? data.Mensaje : 'No se pudieron cargar las cuentas.');
                    }
                },
                error: function (xhr) {
                    console.error('Error al obtener cuentas:', xhr.responseText);
                    showToast('error', 'Error', 'No se pudieron cargar las cuentas.');
                }
            });
        }

        function agregarLineaDetalle() {
            const tbody = $('#tblDetalleAsiento tbody');
            const rowId = Date.now();
            const saldoInicial = formatCurrency(0);
            const nuevaFila = $(`
                <tr data-row-id="${rowId}">
                    <td>
                        <select class="form-select cuenta-select">
                            <option value="">Seleccionar cuenta...</option>
                        </select>
                    </td>
                    <td class="saldo-cuenta text-center text-muted">${saldoInicial}</td>
                    <td>
                        <input type="number" min="0" step="0.01" class="form-control text-center debit-input" placeholder="0.00" />
                    </td>
                    <td>
                        <input type="number" min="0" step="0.01" class="form-control text-center credit-input" placeholder="0.00" />
                    </td>
                    <td class="text-center">
                        <button type="button" class="btn btn-link remove-line-btn" title="Eliminar fila">
                            <i class="fas fa-trash"></i>
                        </button>
                    </td>
                </tr>
            `);

            tbody.append(nuevaFila);

            const $select = nuevaFila.find('.cuenta-select');
            poblarSelectCuenta($select);

            if ($.fn.select2) {
                $select.select2({
                    theme: 'bootstrap-5',
                    placeholder: 'Seleccionar cuenta...',
                    allowClear: true,
                    width: '100%'
                });
            }

            $select.on('change', function () {
                const selectedValue = $(this).val();
                const cuentaSeleccionada = cuentasCatalogo.find(function (item) {
                    return item.Cuenta === selectedValue;
                });
                const saldoTexto = cuentaSeleccionada ? formatCurrency(cuentaSeleccionada.Saldo) : '0.00';
                nuevaFila.find('.saldo-cuenta').text(saldoTexto);
            });

            nuevaFila.find('.debit-input').on('input', function () {
                if ($(this).val()) {
                    nuevaFila.find('.credit-input').val('');
                }
                recalcularTotales();
            });

            nuevaFila.find('.credit-input').on('input', function () {
                if ($(this).val()) {
                    nuevaFila.find('.debit-input').val('');
                }
                recalcularTotales();
            });

            nuevaFila.find('.remove-line-btn').on('click', function () {
                nuevaFila.remove();
                recalcularTotales();
            });

            recalcularTotales();
        }

        function recalcularTotales() {
            let totalDebito = 0;
            let totalCredito = 0;

            $('#tblDetalleAsiento tbody tr').each(function () {
                const debito = parseFloat($(this).find('.debit-input').val()) || 0;
                const credito = parseFloat($(this).find('.credit-input').val()) || 0;
                totalDebito += debito;
                totalCredito += credito;
            });

            $('#lblTotalDebito').text(formatCurrency(totalDebito));
            $('#lblTotalCredito').text(formatCurrency(totalCredito));

            const balance = totalDebito - totalCredito;
            const $lblBalance = $('#lblBalance');
            $lblBalance.text(formatCurrency(balance));
            $lblBalance.removeClass('text-danger text-success');
            if (Math.abs(balance) < 0.01) {
                $lblBalance.addClass('text-success');
            } else {
                $lblBalance.addClass('text-danger');
            }

            return {
                totalDebito,
                totalCredito
            };
        }

        function limpiarFormulario() {
            const todayIso = new Date().toISOString().split('T')[0];
            $('#hdnFechaISO').val(todayIso);
            if ($('#txtFecha')[0]._flatpickr) {
                $('#txtFecha')[0]._flatpickr.setDate(todayIso, true, 'Y-m-d');
            } else {
                $('#txtFecha').val(formatDateToDisplay(todayIso));
            }
            $('#txtComentario').val('');
            $('#tblDetalleAsiento tbody').empty();
            const filasIniciales = obtenerFilasInicialesDetalle();
            for (let i = 0; i < filasIniciales; i++) {
                agregarLineaDetalle();
            }
            recalcularTotales();
        }

        function validarFormulario(fechaIso, comentario, detalles) {
            const fechaVisible = $('#txtFecha').val();
            if (!fechaIso) {
                showToast('warning', 'Validación', 'Debe seleccionar una fecha.');
                return false;
            }

            if (!parseDisplayDate(fechaVisible)) {
                showToast('warning', 'Validación', 'La fecha debe respetar el formato dd/MM/yyyy.');
                return false;
            }

            if (!comentario || comentario.trim() === '') {
                showToast('warning', 'Validación', 'Debe ingresar un comentario para el asiento.');
                return false;
            }

            if (!detalles || detalles.length === 0) {
                showToast('warning', 'Validación', 'Debe agregar al menos una cuenta en el detalle.');
                return false;
            }

            let totalDebito = 0;
            let totalCredito = 0;

            for (let i = 0; i < detalles.length; i++) {
                const detalle = detalles[i];
                if (!detalle.Cuenta) {
                    showToast('warning', 'Validación', `Debe seleccionar una cuenta en la línea ${i + 1}.`);
                    return false;
                }

                const debito = parseFloat(detalle.Debito) || 0;
                const credito = parseFloat(detalle.Credito) || 0;

                if (debito === 0 && credito === 0) {
                    showToast('warning', 'Validación', `Debe ingresar un valor en débito o crédito en la línea ${i + 1}.`);
                    return false;
                }

                if (debito > 0 && credito > 0) {
                    showToast('warning', 'Validación', `Solo puede registrar débito o crédito (no ambos) en la línea ${i + 1}.`);
                    return false;
                }

                totalDebito += debito;
                totalCredito += credito;
            }

            if (Math.abs(totalDebito - totalCredito) > 0.009) {
                showToast('error', 'Validación', 'El asiento no está balanceado. El total de débitos debe ser igual al total de créditos.');
                return false;
            }

            return true;
        }

        function guardarAsiento() {
            const detalles = [];
            const comentario = $('#txtComentario').val();
            const filasSinMonto = [];
            const filasSinCuenta = [];

            $('#tblDetalleAsiento tbody tr').each(function (index) {
                const cuenta = $(this).find('.cuenta-select').val();
                const debito = parseFloat($(this).find('.debit-input').val()) || 0;
                const credito = parseFloat($(this).find('.credit-input').val()) || 0;

                if (cuenta && debito === 0 && credito === 0) {
                    filasSinMonto.push(index + 1);
                }

                if (!cuenta && (debito > 0 || credito > 0)) {
                    filasSinCuenta.push(index + 1);
                }

                if (cuenta && (debito > 0 || credito > 0)) {
                    detalles.push({
                        Cuenta: cuenta,
                        Debito: debito,
                        Credito: credito
                    });
                }
            });

            if (filasSinMonto.length > 0) {
                showToast('warning', 'Validación', `Las líneas ${filasSinMonto.join(', ')} tienen una cuenta sin monto.`);
                return;
            }

            if (filasSinCuenta.length > 0) {
                showToast('warning', 'Validación', `Las líneas ${filasSinCuenta.join(', ')} tienen montos sin cuenta.`);
                return;
            }

            const asiento = {
                Cabecera: {
                    Fecha: $('#hdnFechaISO').val(),
                    Comentario: comentario
                },
                Detalles: detalles
            };

            if (!validarFormulario(asiento.Cabecera.Fecha, asiento.Cabecera.Comentario, detalles)) {
                return;
            }

            showConfirmToast('warning', 'Confirmar guardado', '¿Desea guardar el asiento contable?', function () {
                ejecutarGuardarAsiento(asiento);
            }, function () {
                showToast('info', 'Operación cancelada', 'El asiento no fue guardado.');
            });
        }

        function ejecutarGuardarAsiento(asiento) {
            $.ajax({
                type: 'POST',
                url: 'Finanzas.aspx/GuardarAsiento',
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify({ asientoData: asiento }),
                dataType: 'json',
                beforeSend: function () {
                    $('#btnGuardar').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-1"></i>Guardando...');
                },
                success: function (response) {
                    let data = response.d;
                    if (typeof data === 'string') {
                        data = JSON.parse(data);
                    }

                    if (data && data.Resultado === 'SUCCESS') {
                        const asientoId = data.AsientoID || 0;
                        const usuario = data.Usuario || '';
                        
                        // Guardar datos para impresión
                        window.asientoGuardado = {
                            id: asientoId,
                            usuario: usuario
                        };
                        
                        // Mostrar el ID del asiento creado
                        if (asientoId > 0) {
                            $('#lblAsientoCreado').text(asientoId);
                            $('#divAsientoCreado').fadeIn(300);
                        }
                        
                        const recargaPromise = cargarCuentas();
                        if (recargaPromise && typeof recargaPromise.done === 'function') {
                            recargaPromise
                                .done(function () {
                                    actualizarSelectsCuentas();
                                    const mensaje = asientoId > 0 
                                        ? `${data.Mensaje || 'Asiento guardado correctamente.'} ID: ${asientoId}` 
                                        : (data.Mensaje || 'Asiento guardado correctamente.');
                                    showToast('success', 'Éxito', mensaje);
                                    bloquearFormulario();
                                })
                                .fail(function () {
                                    showToast('warning', 'Asiento guardado', 'El asiento se guardó, pero no se pudieron refrescar los saldos. Recargue manualmente las cuentas.');
                                    bloquearFormulario();
                                });
                        } else {
                            const mensaje = asientoId > 0 
                                ? `${data.Mensaje || 'Asiento guardado correctamente.'} ID: ${asientoId}` 
                                : (data.Mensaje || 'Asiento guardado correctamente.');
                            showToast('success', 'Éxito', mensaje);
                            bloquearFormulario();
                        }
                    } else {
                        showToast('error', 'Error', data ? data.Mensaje : 'No se pudo guardar el asiento.');
                    }
                },
                error: function (xhr) {
                    showToast('error', 'Error', xhr.responseText || 'Ocurrió un error al guardar el asiento.');
                },
                complete: function () {
                    $('#btnGuardar').prop('disabled', false).html('<i class="fas fa-save me-1"></i>Guardar Asiento');
                }
            });
        }

        function volverDashboard() {
            window.location.href = '../../Dashboard.aspx';
        }
	</script>
</body>
</html>
