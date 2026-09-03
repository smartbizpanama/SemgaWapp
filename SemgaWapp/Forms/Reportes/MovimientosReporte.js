/* Reporte Movimientos: tabs resumen/detalle, overlay, totales globales */
(function () {
    var dataTableMovimientos = null;
    var datosMovimientosActual = [];
    var datosMovimientosResumenActual = [];
    var columnasDetalleMovActual = [];

    function mostrarOverlayMovimientos(mensaje) {
        $('#loadingMovimientosOverlay .texto-carga').text(mensaje || 'Cargando, espere por favor...');
        $('#loadingMovimientosOverlay').show();
    }

    function ocultarOverlayMovimientos() {
        $('#loadingMovimientosOverlay').hide();
    }

    function escapeHtmlMov(text) {
        var d = document.createElement('div');
        d.textContent = text;
        return d.innerHTML;
    }

    function parseMontoMov(val) {
        if (val === undefined || val === null || val === '') return 0;
        if (typeof val === 'number' && !isNaN(val)) return val;
        var s = String(val).trim().replace(/\s/g, '').replace(/\$/g, '');
        if (s === '' || s === '-') return 0;
        var lastComma = s.lastIndexOf(',');
        var lastDot = s.lastIndexOf('.');
        var decSep = lastComma > lastDot ? ',' : (lastDot > lastComma ? '.' : null);
        if (decSep === ',') {
            s = s.replace(/\./g, '').replace(',', '.');
        } else if (decSep === '.') {
            s = s.replace(/,/g, '');
        }
        var n = parseFloat(s);
        return isNaN(n) ? 0 : n;
    }

    function formatearSaldoMonedaMov(n) {
        var num = (typeof n === 'number' && !isNaN(n)) ? n : parseMontoMov(n);
        if (isNaN(num)) num = 0;
        var neg = num < 0;
        var abs = Math.abs(num);
        var cuerpo = abs.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        return (neg ? '-' : '') + '$' + cuerpo;
    }

    function esColumnaMontoMov(col) {
        return col === 'MontoDR' || col === 'MontoCR' || col === 'DR' || col === 'CR'
            || col === 'Débito' || col === 'Crédito' || col === 'Balance'
            || col === 'Monto' || col === 'Saldo';
    }

    /**
     * 9 columnas visibles — mismo orden y significado que ReporteMovimientos.html / spMovimientos_Listar.
     * CODIGO/TRAN: código + descripción de transacción | Rubro: descripción del rubro (Auxiliar/Rubro en SP).
     */
    var MOV_TABLA_DETALLE_COLS = [
        { label: 'No.', keys: ['NoRegistro', 'ID Movimiento'], className: 'col-no', width: '6%' },
        { label: 'Fecha', keys: ['FTranHora'], joinKeys: ['Fecha del Movimiento', 'Hora del Movimiento'], className: 'col-fecha', width: '10%' },
        { label: 'Asociado', keys: ['Asociado', 'Nombre Completo'], className: 'col-asociado', width: '17%' },
        {
            label: 'CODIGO/TRAN',
            className: 'col-codigo-tran',
            width: '15%',
            format: function (row) {
                var cod = leerValorColumnaMov(row, { keys: ['CodigoTransaccion', 'Código Transacción'] });
                var desc = leerValorColumnaMov(row, { keys: ['CodigoTran', 'Transacción', 'DescripcionTransaccion'] });
                if (cod && desc && String(cod).trim() !== String(desc).trim()) {
                    return String(cod).trim() + ' — ' + String(desc).trim();
                }
                return desc || cod || '';
            }
        },
        { label: 'Rubro', keys: ['Rubro', 'Auxiliar', 'Código Rubro'], className: 'col-rubro', width: '11%' },
        { label: 'Cuenta', keys: ['Cuenta'], className: 'col-cuenta', width: '11%' },
        { label: 'tipo', keys: ['Tipo', 'Tipo Auxiliar'], className: 'col-tipo', width: '14%' },
        { label: 'DR', keys: ['MontoDR', 'Débito'], monto: true, className: 'col-dr', width: '8%' },
        { label: 'CR', keys: ['MontoCR', 'Crédito'], monto: true, className: 'col-cr', width: '8%' }
    ];

    function valorCeldaDetalleMovDesdeFila(row, colDef) {
        if (typeof colDef.format === 'function') {
            var fmt = colDef.format(row);
            return (fmt !== undefined && fmt !== null) ? String(fmt) : '';
        }
        var raw = leerValorColumnaMov(row, colDef);
        if (colDef.monto) return formatearSaldoMonedaMov(raw);
        return (raw !== undefined && raw !== null) ? String(raw) : '';
    }

    function buildColumnasDataTableMov() {
        return MOV_TABLA_DETALLE_COLS.map(function (colDef) {
            var cls = ((colDef.className || '') + ' text-center').trim();
            return {
                title: colDef.label,
                className: cls,
                width: colDef.width,
                defaultContent: '',
                render: function (data, type, row) {
                    var v = valorCeldaDetalleMovDesdeFila(row, colDef);
                    if (type === 'sort' || type === 'type') return v;
                    return escapeHtmlMov(v);
                },
                createdCell: function (td, cellData, rowData) {
                    if (colDef.monto) {
                        $(td).addClass('monto');
                        if (parseMontoMov(leerValorColumnaMov(rowData, colDef)) < 0) {
                            $(td).addClass('monto-negativo');
                        }
                    }
                }
            };
        });
    }

    function leerValorColumnaMov(row, colDef) {
        if (!row || !colDef) return '';
        var i, k, v, parts = [];
        if (colDef.joinKeys && colDef.joinKeys.length) {
            for (i = 0; i < colDef.joinKeys.length; i++) {
                v = row[colDef.joinKeys[i]];
                if (v !== undefined && v !== null && String(v).trim() !== '') parts.push(String(v).trim());
            }
            if (parts.length) return parts.join(' ');
        }
        for (i = 0; i < colDef.keys.length; i++) {
            k = colDef.keys[i];
            v = row[k];
            if (v !== undefined && v !== null && String(v).trim() !== '') return v;
        }
        return '';
    }

    function obtenerColumnasDetalleMov() {
        return MOV_TABLA_DETALLE_COLS.map(function (c) { return c.label; });
    }

    function valorCeldaDetalleMov(colLabel, row) {
        var colDef = null;
        for (var i = 0; i < MOV_TABLA_DETALLE_COLS.length; i++) {
            if (MOV_TABLA_DETALLE_COLS[i].label === colLabel) {
                colDef = MOV_TABLA_DETALLE_COLS[i];
                break;
            }
        }
        if (!colDef) {
            var v = row[colLabel];
            return (v !== undefined && v !== null) ? String(v) : '';
        }
        if (typeof colDef.format === 'function') {
            var fmt = colDef.format(row);
            return (fmt !== undefined && fmt !== null) ? String(fmt) : '';
        }
        var raw = leerValorColumnaMov(row, colDef);
        if (colDef.monto) return formatearSaldoMonedaMov(raw);
        return (raw !== undefined && raw !== null) ? String(raw) : '';
    }

    function calcularTotalesMovDesdeResumen(datos) {
        var reg = 0, dr = 0, cr = 0;
        (datos || []).forEach(function (row) {
            reg += parseInt(row.Movimientos || row['Movimientos'] || 0, 10) || 0;
            dr += parseMontoMov(row['Débito'] !== undefined ? row['Débito'] : row.Debito);
            cr += parseMontoMov(row['Crédito'] !== undefined ? row['Crédito'] : row.Credito);
        });
        return { reg: reg, dr: dr, cr: cr, bal: dr - cr };
    }

    function aplicarTotalesGlobalesMov(t) {
        $('#totalRegistrosMovGlobal').text(t.reg);
        var $dr = $('#totalDrMovGlobal');
        var $cr = $('#totalCrMovGlobal');
        var $bal = $('#totalBalMovGlobal');
        $dr.text(formatearSaldoMonedaMov(t.dr)).toggleClass('monto-negativo', t.dr < 0);
        $cr.text(formatearSaldoMonedaMov(t.cr)).toggleClass('monto-negativo', t.cr < 0);
        $bal.text(formatearSaldoMonedaMov(t.bal)).toggleClass('monto-negativo', t.bal < 0);
    }

    /** Agrupa filas de spMovimientos_ReporteResumen (Rubro → Tipo Auxiliar). */
    function agruparResumenMovDesdeSp(datos) {
        var map = {}, orden = [];
        (datos || []).forEach(function (row) {
            var cod = String(row['Código Rubro'] || row.CodigoRubro || '').trim() || 'SIN_RUBRO';
            var nombre = String(row.Rubro || cod).trim();
            if (!map[cod]) {
                map[cod] = { key: cod, nombre: nombre, tipos: [], registros: 0, dr: 0, cr: 0 };
                orden.push(cod);
            }
            var b = map[cod];
            var mov = parseInt(row.Movimientos || row['Movimientos'] || 0, 10) || 0;
            var dr = parseMontoMov(row['Débito'] !== undefined ? row['Débito'] : row.Debito);
            var cr = parseMontoMov(row['Crédito'] !== undefined ? row['Crédito'] : row.Credito);
            var tipoNombre = String(row['Tipo Auxiliar'] || row.Tipo || '(Sin tipo)').trim();
            b.tipos.push({ nombre: tipoNombre, registros: mov, dr: dr, cr: cr, bal: dr - cr });
            b.registros += mov;
            b.dr += dr;
            b.cr += cr;
        });
        return orden.map(function (c) {
            var b = map[c];
            b.bal = b.dr - b.cr;
            return b;
        });
    }

    function celdaMontoPivotMov(n) {
        var cls = 'mov-pivot-monto' + (n < 0 ? ' monto-negativo' : '');
        return '<td class="' + cls + '">' + escapeHtmlMov(formatearSaldoMonedaMov(n)) + '</td>';
    }

    function mostrarResumenMovPivot(datos) {
        var rubros = agruparResumenMovDesdeSp(datos);
        var $host = $('#contenedorResumenMovPivot');
        $host.off('click.movPivot keydown.movPivot');
        if (!rubros.length) {
            $host.html('<p style="text-align:center;color:#6c757d;padding:24px;">No hay datos de resumen.</p>');
            return;
        }
        var html = '<table class="mov-pivot-tabla"><thead><tr>';
        html += '<th class="col-etiqueta">Rubro / Tipo</th><th class="col-registros">Registros</th>';
        html += '<th class="col-monto">DR</th><th class="col-monto">CR</th><th class="col-monto">Balance</th></tr></thead><tbody>';
        rubros.forEach(function (bloque, idx) {
            var key = 'rubro-' + idx;
            html += '<tr class="mov-pivot-row-rubro is-expanded" data-rubro-key="' + key + '" tabindex="0" aria-expanded="true">';
            html += '<td class="mov-pivot-cell-label"><span class="mov-pivot-chevron">&#9654;</span><span>' + escapeHtmlMov(bloque.nombre) + '</span></td>';
            html += '<td class="mov-pivot-registros">' + bloque.registros + '</td>';
            html += celdaMontoPivotMov(bloque.dr) + celdaMontoPivotMov(bloque.cr) + celdaMontoPivotMov(bloque.bal);
            html += '</tr>';
            (bloque.tipos || []).forEach(function (t) {
                html += '<tr class="mov-pivot-row-tipo" data-rubro-key="' + key + '">';
                html += '<td class="mov-pivot-cell-label">' + escapeHtmlMov(t.nombre) + '</td>';
                html += '<td class="mov-pivot-registros">' + t.registros + '</td>';
                html += celdaMontoPivotMov(t.dr) + celdaMontoPivotMov(t.cr) + celdaMontoPivotMov(t.bal);
                html += '</tr>';
            });
        });
        html += '</tbody></table>';
        $host.html(html);
        $host.on('click.movPivot', '.mov-pivot-row-rubro', function () {
            var key = $(this).attr('data-rubro-key');
            var abrir = $(this).attr('aria-expanded') !== 'true';
            $(this).attr('aria-expanded', abrir ? 'true' : 'false').toggleClass('is-expanded', abrir);
            $host.find('.mov-pivot-row-tipo[data-rubro-key="' + key + '"]').toggle(abrir);
        });
    }

    function sincronizarColumnasMovimientos() {
        if (!dataTableMovimientos) return;
        var api = dataTableMovimientos;
        try {
            api.columns.adjust();
        } catch (e1) { }
        var $wrapper = $('#tablaMovimientosDatos').closest('.dataTables_wrapper');
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
            $body.off('scroll.movSync').on('scroll.movSync', function () {
                $wrapper.find('.dataTables_scrollHead').scrollLeft($body.scrollLeft());
            });
        }
        try {
            api.columns.adjust();
        } catch (e2) { }
    }

    function ajustarAlturaScrollMovimientos() {
        $('#contenedorTabsMovimientos .movimientos-grid-wrapper').each(function () {
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
                $wrapper.find('.dataTables_length, .dataTables_info, .dataTables_paginate').each(function () {
                    footerRowH = Math.max(footerRowH, $(this).outerHeight(true));
                });
                scrollDivHeight = $wrapper.height() - footerRowH - 8;
            }
            var headHeight = $scrollHead.outerHeight() || 0;
            var scrollH = Math.max(200, scrollDivHeight - headHeight);
            $scrollBody.css({ height: scrollH + 'px', minHeight: scrollH + 'px', maxHeight: scrollH + 'px' });
        });
        sincronizarColumnasMovimientos();
    }

    function destruirTablaMovimientos() {
        $(window).off('resize.movimientosGrid');
        var $tabla = $('#tablaMovimientosDatos');
        if ($.fn.DataTable.isDataTable($tabla)) {
            $tabla.DataTable().clear().destroy();
        }
        dataTableMovimientos = null;
        $tabla.empty();
        $tabla.append('<thead><tr></tr></thead><tbody></tbody>');
        $('#contenedorResumenMovPivot').empty();
        columnasDetalleMovActual = [];
    }

    function mostrarMovimientosResultado(datosResumen, datosDetalle) {
        datosMovimientosResumenActual = Array.isArray(datosResumen) ? datosResumen : [];
        datosMovimientosActual = Array.isArray(datosDetalle) ? datosDetalle : [];
        destruirTablaMovimientos();
        if (!datosMovimientosResumenActual.length && !datosMovimientosActual.length) {
            $('#placeholderMovimientos').show();
            $('#contenedorTabsMovimientos').hide();
            $('#barTotalesMovimientosGlobal').hide();
            $('#btnImprimirMovimientos').prop('disabled', true);
            $('#btnExportarExcelMovimientos').prop('disabled', true);
            return;
        }
        $('#placeholderMovimientos').hide();
        $('#contenedorTabsMovimientos').css('display', 'flex').show();
        columnasDetalleMovActual = obtenerColumnasDetalleMov();
        mostrarResumenMovPivot(datosMovimientosResumenActual);
        var $tabla = $('#tablaMovimientosDatos');
        dataTableMovimientos = $tabla.DataTable({
            data: datosMovimientosActual,
            columns: buildColumnasDataTableMov(),
            pageLength: 25,
            lengthMenu: [[25, 50, 100, 200], [25, 50, 100, 200]],
            dom: 'tlip',
            searching: false,
            deferRender: true,
            scrollX: true,
            scrollY: '200px',
            scrollCollapse: false,
            autoWidth: false,
            order: [[1, 'asc']],
            language: {
                url: 'https://cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json',
                emptyTable: 'No hay movimientos en el detalle para el período.'
            },
            initComplete: function () {
                ajustarAlturaScrollMovimientos();
                sincronizarColumnasMovimientos();
                setTimeout(sincronizarColumnasMovimientos, 50);
                setTimeout(sincronizarColumnasMovimientos, 200);
            },
            drawCallback: function () {
                ajustarAlturaScrollMovimientos();
                sincronizarColumnasMovimientos();
            }
        });
        $(window).off('resize.movimientosGrid').on('resize.movimientosGrid', function () {
            ajustarAlturaScrollMovimientos();
        });
        setTimeout(ajustarAlturaScrollMovimientos, 0);
        setTimeout(ajustarAlturaScrollMovimientos, 80);
        setTimeout(ajustarAlturaScrollMovimientos, 200);
        aplicarTotalesGlobalesMov(calcularTotalesMovDesdeResumen(datosMovimientosResumenActual));
        $('#barTotalesMovimientosGlobal').show();
        $('#btnImprimirMovimientos').prop('disabled', false);
        $('#btnExportarExcelMovimientos').prop('disabled', false);
    }

    window.buscarMovimientos = function () {
        var params = obtenerParametrosMovimientosParaServidor();
        if (params.error) {
            showToast('warning', 'Fecha requerida', params.error);
            return;
        }
        var btnBuscar = $('#btnBuscarMovimientos');
        btnBuscar.prop('disabled', true);
        mostrarOverlayMovimientos('Consultando movimientos, espere por favor...');
        var payload = JSON.stringify({
            idUsuario: params.idUsuario,
            numeroAsociado: params.numeroAsociado,
            fechaDesde: params.fechaDesde,
            fechaHasta: params.fechaHasta,
            codigoRubro: params.codigoRubro,
            codigoTransaccion: params.codigoTransaccion,
            mesHistorial: params.mesHistorial,
            anioHistorial: params.anioHistorial,
            versionHistorial: params.versionHistorial
        });
        var datosResumen = [];
        var datosDetalle = [];
        var pendientes = 2;

        function parseListarResponse(response) {
            try {
                var rd = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                if (rd && rd.Success && rd.Data !== undefined) {
                    return Array.isArray(rd.Data) ? rd.Data : [];
                }
            } catch (e) { }
            return [];
        }

        function terminarBusquedaMov() {
            pendientes--;
            if (pendientes > 0) return;
            ocultarOverlayMovimientos();
            btnBuscar.prop('disabled', false);
            mostrarMovimientosResultado(datosResumen, datosDetalle);
        }

        $.ajax({
            type: 'POST',
            url: 'Movimientos.aspx/ListarMovimientosResumen',
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            data: payload,
            success: function (r) { datosResumen = parseListarResponse(r); },
            error: function () { datosResumen = []; },
            complete: terminarBusquedaMov
        });

        $.ajax({
            type: 'POST',
            url: 'Movimientos.aspx/BuscarMovimientosTabla',
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            data: payload,
            success: function (r) { datosDetalle = parseListarResponse(r); },
            error: function () { datosDetalle = []; },
            complete: terminarBusquedaMov
        });
    };

    function prepararResumenMovExcelExpandido() {
        var rubros = agruparResumenMovDesdeSp(datosMovimientosResumenActual);
        var filas = [];
        rubros.forEach(function (bloque) {
            filas.push({
                'Rubro / Tipo': bloque.nombre,
                'Registros': bloque.registros,
                'DR': formatearSaldoMonedaMov(bloque.dr),
                'CR': formatearSaldoMonedaMov(bloque.cr),
                'Balance': formatearSaldoMonedaMov(bloque.bal),
                'EsFilaRubro': true
            });
            (bloque.tipos || []).forEach(function (t) {
                filas.push({
                    'Rubro / Tipo': '    ' + t.nombre,
                    'Registros': t.registros,
                    'DR': formatearSaldoMonedaMov(t.dr),
                    'CR': formatearSaldoMonedaMov(t.cr),
                    'Balance': formatearSaldoMonedaMov(t.bal)
                });
            });
        });
        return filas;
    }

    function prepararDetalleMovExcel() {
        var cols = columnasDetalleMovActual.length
            ? columnasDetalleMovActual.slice()
            : obtenerColumnasDetalleMov();
        var filas = [];
        (datosMovimientosActual || []).forEach(function (row) {
            var o = {};
            cols.forEach(function (col) {
                o[col] = valorCeldaDetalleMov(col, row);
            });
            filas.push(o);
        });
        return { filas: filas, columnas: cols };
    }

    function iniciarDescargaExcelMov(nombreArchivo) {
        window.location.href = 'Movimientos.aspx?action=download&file=' + encodeURIComponent(nombreArchivo);
    }

    function obtenerEtiquetasFiltrosMovimientosExcel() {
        var params = typeof obtenerParametrosMovimientosParaServidor === 'function'
            ? obtenerParametrosMovimientosParaServidor()
            : { error: 'Parámetros no disponibles' };
        if (params.error) return params;

        var idUsuario = $('#ddlUsuario').val();
        var codigoRubro = $('#ddlRubro').val();
        var codigoTransaccion = $('#ddlTransaccion').val();
        var etiquetaUsuario = idUsuario ? $('#ddlUsuario option:selected').text().trim() : null;
        var etiquetaRubro = codigoRubro ? $('#ddlRubro option:selected').text().trim() : null;
        var etiquetaTransaccion = codigoTransaccion ? $('#ddlTransaccion option:selected').text().trim() : null;
        var etiquetaAsociado = null;
        if (typeof asociadoSeleccionado !== 'undefined' && asociadoSeleccionado && asociadoSeleccionado.numeroAsociado) {
            etiquetaAsociado = (asociadoSeleccionado.nombre || '').trim();
            if (etiquetaAsociado) {
                etiquetaAsociado += ' (N° ' + asociadoSeleccionado.numeroAsociado + ')';
            } else {
                etiquetaAsociado = 'N° ' + asociadoSeleccionado.numeroAsociado;
            }
        }

        return $.extend({}, params, {
            etiquetaUsuario: etiquetaUsuario,
            etiquetaAsociado: etiquetaAsociado,
            etiquetaRubro: etiquetaRubro,
            etiquetaTransaccion: etiquetaTransaccion
        });
    }

    window.exportarMovimientosExcel = function () {
        var resumen = prepararResumenMovExcelExpandido();
        var det = prepararDetalleMovExcel();
        if (!resumen.length && !det.filas.length) {
            showToast('warning', 'Sin datos', 'No hay datos para exportar. Ejecute una búsqueda primero.');
            return;
        }
        var filtros = obtenerEtiquetasFiltrosMovimientosExcel();
        if (filtros.error) {
            showToast('warning', 'Validación', filtros.error);
            return;
        }
        var btn = $('#btnExportarExcelMovimientos');
        btn.prop('disabled', true);
        mostrarOverlayMovimientos('Exportando a Excel, espere por favor...');
        $.ajax({
            type: 'POST',
            url: 'Movimientos.aspx/ExportarMovimientosExcel',
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            data: JSON.stringify({
                datosResumen: resumen,
                datosDetalle: det.filas,
                columnasDetalle: det.columnas,
                idUsuario: filtros.idUsuario,
                numeroAsociado: filtros.numeroAsociado,
                fechaDesde: filtros.fechaDesde,
                fechaHasta: filtros.fechaHasta,
                codigoRubro: filtros.codigoRubro,
                codigoTransaccion: filtros.codigoTransaccion,
                mesHistorial: filtros.mesHistorial,
                anioHistorial: filtros.anioHistorial,
                versionHistorial: filtros.versionHistorial,
                etiquetaUsuario: filtros.etiquetaUsuario,
                etiquetaAsociado: filtros.etiquetaAsociado,
                etiquetaRubro: filtros.etiquetaRubro,
                etiquetaTransaccion: filtros.etiquetaTransaccion
            }),
            success: function (response) {
                try {
                    var responseData = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                    if (responseData && responseData.Resultado === 'SUCCESS' && responseData.NombreArchivo) {
                        iniciarDescargaExcelMov(responseData.NombreArchivo);
                        showToast('success', 'Éxito', 'Archivo Excel generado correctamente');
                    } else {
                        showToast('error', 'Error', responseData && responseData.Mensaje ? responseData.Mensaje : 'No se pudo generar el Excel');
                    }
                } catch (e) {
                    showToast('error', 'Error', 'Error al procesar la exportación');
                }
            },
            error: function (xhr) {
                var msg = 'Error al exportar a Excel';
                if (xhr && xhr.responseText) {
                    try {
                        var err = JSON.parse(xhr.responseText);
                        if (err && err.Message) msg = err.Message;
                    } catch (ignore) { }
                }
                showToast('error', 'Error', msg);
            },
            complete: function () {
                ocultarOverlayMovimientos();
                btn.prop('disabled', false);
            }
        });
    };

    function cargarHtmlReporteImpresionMov(callback) {
        var params = obtenerParametrosMovimientosParaServidor();
        if (params.error) {
            showToast('warning', 'Fecha requerida', params.error);
            if (typeof callback === 'function') callback(false);
            return;
        }
        var btn = $('#btnImprimirMovimientos');
        btn.prop('disabled', true);
        mostrarOverlayMovimientos('Generando reporte para impresión, espere por favor...');
        $.ajax({
            type: 'POST',
            url: 'Movimientos.aspx/BuscarMovimientos',
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            data: JSON.stringify({
                idUsuario: params.idUsuario,
                numeroAsociado: params.numeroAsociado,
                fechaDesde: params.fechaDesde,
                fechaHasta: params.fechaHasta,
                codigoRubro: params.codigoRubro,
                codigoTransaccion: params.codigoTransaccion,
                mesHistorial: params.mesHistorial,
                anioHistorial: params.anioHistorial,
                versionHistorial: params.versionHistorial
            }),
            success: function (response) {
                try {
                    var rd = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                    if (rd && rd.Success && rd.Html) {
                        window.htmlReporteMovimientos = rd.Html;
                        if (typeof callback === 'function') callback(true);
                        return;
                    }
                    showToast('error', 'Impresión', (rd && rd.Message) ? rd.Message : 'No se pudo generar el reporte');
                } catch (e) {
                    showToast('error', 'Impresión', 'Error al procesar el reporte');
                }
                if (typeof callback === 'function') callback(false);
            },
            error: function () {
                showToast('error', 'Impresión', 'Error al consultar el reporte');
                if (typeof callback === 'function') callback(false);
            },
            complete: function () {
                ocultarOverlayMovimientos();
                if (datosMovimientosActual.length || datosMovimientosResumenActual.length) {
                    btn.prop('disabled', false);
                }
            }
        });
    }

    window.imprimirTablaMovimientos = function () {
        if (!datosMovimientosActual.length && !datosMovimientosResumenActual.length) {
            showToast('warning', 'Impresión', 'No hay datos para imprimir');
            return;
        }
        if (typeof imprimirReporteMovimientos !== 'function') {
            showToast('error', 'Impresión', 'Función de impresión no disponible');
            return;
        }
        if (window.htmlReporteMovimientos && String(window.htmlReporteMovimientos).trim() !== '') {
            imprimirReporteMovimientos();
            return;
        }
        cargarHtmlReporteImpresionMov(function (ok) {
            if (ok) imprimirReporteMovimientos();
        });
    };

    $(document).on('shown.bs.tab.movGrid', '#tabDetalladoMovBtn', function () {
        setTimeout(function () {
            ajustarAlturaScrollMovimientos();
            sincronizarColumnasMovimientos();
        }, 0);
        setTimeout(sincronizarColumnasMovimientos, 80);
        setTimeout(sincronizarColumnasMovimientos, 250);
    });

    var _limpiarOriginal = window.limpiarFiltros;
    window.limpiarFiltros = function () {
        if (typeof _limpiarOriginal === 'function') {
            _limpiarOriginal();
        }
        destruirTablaMovimientos();
        datosMovimientosActual = [];
        datosMovimientosResumenActual = [];
        $('#placeholderMovimientos').show();
        $('#contenedorTabsMovimientos').hide();
        $('#barTotalesMovimientosGlobal').hide();
    };
})();
