/**
 * Acciones de asociado (Transacciones, Movimientos, Estado de cuenta) — misma lógica que GestionSocios.aspx.
 * Requiere: jQuery, Bootstrap 5, DataTables, smart-chips (crearChipTipoDocumento), showToast en la página.
 */
(function (global) {
    'use strict';

    var SOCIOS = '../Socios/GestionSocios.aspx';
    var TRANS = 'Transacciones.aspx';

    function urlTransaccionesWebMethod(methodName) {
        var root = (typeof global.SEMGA_TRANSACCIONES_PAGE_URL === 'string' && global.SEMGA_TRANSACCIONES_PAGE_URL)
            ? global.SEMGA_TRANSACCIONES_PAGE_URL.replace(/\/+$/, '')
            : TRANS;
        return root + '/' + methodName;
    }

    function toast(msg, tipo) {
        if (typeof showToast === 'function') {
            var t = tipo === 'error' ? 'error' : tipo === 'success' ? 'success' : tipo === 'warning' ? 'warning' : 'info';
            showToast(t, '', msg);
        } else {
            window.alert(msg);
        }
    }

    var formateadorMonedaSocios = new Intl.NumberFormat('es-US', { style: 'currency', currency: 'USD' });
    var configuracionesChipRubros = {
        'AH': { color: 'bg-success', icono: 'fas fa-piggy-bank', nombre: 'Ahorro' },
        'AP': { color: 'bg-info', icono: 'fas fa-coins', nombre: 'Aporte' },
        'PR': { color: 'bg-warning', icono: 'fas fa-hand-holding-usd', nombre: 'Préstamo' },
        'CR': { color: 'bg-danger', icono: 'fas fa-credit-card', nombre: 'Crédito' },
        'IN': { color: 'bg-primary', icono: 'fas fa-chart-line', nombre: 'Inversión' }
    };
    var movimientosSocioEstado = {
        start: 0,
        length: 20,
        total: 0,
        orderColumn: 'Fecha',
        orderDir: 'DESC',
        cargando: false,
        silenciarOrden: false
    };
    var tablaMovimientosSocio = null;
    var socioMovimientosEnConsulta = null;

    function escaparHtmlSocios(texto) {
        return $('<div>').text(texto ?? '').html();
    }

    function formatearFechaHora(fecha) {
        if (!fecha) return 'N/A';
        var date;
        if (typeof fecha === 'string' && fecha.indexOf('/Date(') >= 0) {
            var timestamp = parseInt(fecha.match(/\d+/)[0], 10);
            date = new Date(timestamp);
        } else {
            date = new Date(fecha);
        }
        if (isNaN(date.getTime())) return 'N/A';
        return date.toLocaleString('es-ES', {
            day: '2-digit', month: '2-digit', year: 'numeric',
            hour: '2-digit', minute: '2-digit', hour12: true
        });
    }

    function obtenerMovimientoId(movimiento) {
        if (!movimiento) return null;
        return movimiento.IDMovimiento || movimiento.MovimientoID || movimiento.IdMovimiento || movimiento.MovimientoId || null;
    }

    function obtenerDescripcionMovimiento(movimiento) {
        if (!movimiento) return 'N/A';
        var partes = [];
        if (movimiento.CodigoTransaccion) partes.push(movimiento.CodigoTransaccion);
        if (movimiento.DescripcionTransaccion) partes.push(movimiento.DescripcionTransaccion);
        if (partes.length === 0 && movimiento.Descripcion) partes.push(movimiento.Descripcion);
        return partes.length > 0 ? partes.join(' - ') : 'N/A';
    }

    function crearChipRubroMovimiento(movimiento) {
        if (!movimiento) {
            return '<span class="badge bg-secondary"><i class="fas fa-tag me-1"></i>N/D</span>';
        }
        var codigoOriginal = (movimiento.CodigoRubro || movimiento.Rubro || '').toString().trim().toUpperCase();
        var clave = codigoOriginal.length > 2 ? codigoOriginal.substring(0, 2) : codigoOriginal;
        var config = configuracionesChipRubros[codigoOriginal] || configuracionesChipRubros[clave] || { color: 'bg-secondary', icono: 'fas fa-tag', nombre: 'N/D' };
        var descripcion = movimiento.DescripcionRubro || movimiento.RubroDescripcion || config.nombre || 'N/D';
        var codigoMostrar = clave || codigoOriginal || 'ND';
        var textoCompleto = codigoMostrar + '-' + descripcion;
        return '<span class="badge ' + config.color + '"><i class="' + config.icono + ' me-1"></i>' + escaparHtmlSocios(textoCompleto) + '</span>';
    }

    function formatearMontoMovimiento(valor) {
        if (valor === null || valor === undefined || valor === '') {
            return formateadorMonedaSocios.format(0);
        }
        var numero = valor;
        if (typeof numero === 'string') {
            numero = numero.replace(/\s/g, '').replace(',', '.');
        }
        var monto = Number(numero);
        if (Number.isNaN(monto)) {
            return escaparHtmlSocios(valor);
        }
        return formateadorMonedaSocios.format(monto);
    }

    function obtenerValorOrdenFecha(fecha) {
        if (!fecha) return 0;
        if (typeof fecha === 'string' && fecha.indexOf('/Date(') >= 0) {
            var timestamp = parseInt(fecha.match(/\d+/)[0], 10);
            return Number.isNaN(timestamp) ? 0 : timestamp;
        }
        var parsed = new Date(fecha);
        return Number.isNaN(parsed.getTime()) ? 0 : parsed.getTime();
    }

    function obtenerIndiceColumnaMovimientos(columna) {
        switch ((columna || '').toUpperCase()) {
            case 'TRANSACCION':
            case 'NUMERO': return 0;
            case 'FECHA': return 1;
            case 'RUBRO': return 2;
            case 'DETALLE':
            case 'DESCRIPCION': return 3;
            case 'MONTO': return 4;
            case 'OBSERVACIONES': return 5;
            default: return 1;
        }
    }

    function agregarSocioACache(socio) {
        if (!socio) return;
        global.__sociosCache = global.__sociosCache || [];
        var numero = Number(socio.NumeroAsociado);
        var indice = global.__sociosCache.findIndex(function (s) { return Number(s.NumeroAsociado) === numero; });
        if (indice >= 0) {
            global.__sociosCache[indice] = socio;
        } else {
            global.__sociosCache.push(socio);
        }
    }

    function obtenerSocioDeCache(numeroAsociado) {
        if (!global.__sociosCache || !Array.isArray(global.__sociosCache)) return null;
        return global.__sociosCache.find(function (s) { return Number(s.NumeroAsociado) === Number(numeroAsociado); }) || null;
    }

    function crearTituloMovimientosDesdeSocio(socio) {
        var numero = socio.NumeroAsociado || socio.Numero || '';
        var chipDocumento = typeof crearChipTipoDocumento === 'function'
            ? crearChipTipoDocumento(socio.TipoIdentificacion, socio.NumeroIdentificacion)
            : escaparHtmlSocios(socio.NumeroIdentificacion || '');
        var nombreCompleto = escaparHtmlSocios(
            [socio.Nombre, socio.SegundoNombre, socio.Apellido, socio.SegundoApellido].filter(Boolean).join(' ').trim() || 'Sin nombre'
        );
        return '<span class="badge bg-secondary">#' + numero + '</span>' +
            '<span class="fw-semibold">' + nombreCompleto + '</span>' +
            '<span class="d-inline-flex align-items-center chip-documento-modal">' + chipDocumento + '</span>';
    }

    function crearFilaMovimientoSocio(movimiento) {
        var movimientoId = obtenerMovimientoId(movimiento);
        var fechaOriginal = movimiento && (movimiento.FechaMovimiento || movimiento.Fecha || movimiento.FechaRegistro || movimiento.FechaCreacion);
        var fecha = formatearFechaHora(fechaOriginal);
        var descripcion = escaparHtmlSocios(obtenerDescripcionMovimiento(movimiento));
        var rubroChip = crearChipRubroMovimiento(movimiento);
        var observaciones = escaparHtmlSocios(movimiento && movimiento.Observaciones ? movimiento.Observaciones : '');
        var monto = formatearMontoMovimiento(movimiento && movimiento.Monto);
        var botonReimpresion = movimientoId
            ? '<button type="button" class="btn btn-sm btn-outline-primary" onclick="event.preventDefault(); event.stopPropagation(); SemgaTransAcciones.reimprimirComprobanteMovimiento(' + movimientoId + ')" title="Reimprimir comprobante"><i class="fas fa-print"></i></button>'
            : '<span class="text-muted">N/D</span>';
        var numeroTransaccion = (movimiento && movimiento.Transaccion) || movimientoId || '';
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

    function inicializarTablaMovimientos() {
        if (tablaMovimientosSocio) return;
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
                    render: function (data, type, row) {
                        if (type === 'sort' || type === 'type') return data || 0;
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

        $('#tablaMovimientosSocio').on('order.dt', function () {
            if (!tablaMovimientosSocio) return;
            if (movimientosSocioEstado.silenciarOrden) {
                movimientosSocioEstado.silenciarOrden = false;
                return;
            }
            if (movimientosSocioEstado.cargando) return;
            var orden = tablaMovimientosSocio.order();
            if (!orden || !orden.length) return;
            var mapColumnas = ['Transaccion', 'Fecha', 'Rubro', 'Detalle', 'Monto', 'Observaciones', 'Acciones'];
            var indice = orden[0][0];
            var nuevaColumna = mapColumnas[indice] || 'Fecha';
            var nuevaDireccion = (orden[0][1] || 'desc').toUpperCase();
            if (nuevaColumna === 'Acciones') {
                movimientosSocioEstado.silenciarOrden = true;
                tablaMovimientosSocio.order([
                    obtenerIndiceColumnaMovimientos(movimientosSocioEstado.orderColumn),
                    movimientosSocioEstado.orderDir.toLowerCase()
                ]).draw(false);
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

        $('#btnVerMasMovimientos').off('click.semgaTrans').on('click.semgaTrans', function () {
            if (!socioMovimientosEnConsulta || movimientosSocioEstado.cargando) return;
            cargarMovimientosSocio(socioMovimientosEnConsulta, false);
        });
    }

    function procesarResultadoMovimientos(resultado, esPrimerBloque) {
        var contenedorTabla = $('#contenedorTablaMovimientosSocio');
        var estado = $('#estadoMovimientosSocio');
        var spinner = $('#spinnerMovimientosSocio');

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

        var movimientos = Array.isArray(resultado.Data) ? resultado.Data : [];

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

        movimientos.forEach(function (movimiento) {
            tablaMovimientosSocio.row.add(crearFilaMovimientoSocio(movimiento));
        });

        var totalRegistros = Number(resultado.TotalRegistros || movimientosSocioEstado.total || movimientosSocioEstado.start + movimientos.length);
        movimientosSocioEstado.total = totalRegistros;
        movimientosSocioEstado.start += movimientos.length;

        movimientosSocioEstado.silenciarOrden = true;
        tablaMovimientosSocio.order([
            obtenerIndiceColumnaMovimientos(movimientosSocioEstado.orderColumn),
            movimientosSocioEstado.orderDir.toLowerCase()
        ]).draw(false);
        setTimeout(function () {
            movimientosSocioEstado.silenciarOrden = false;
        }, 0);

        tablaMovimientosSocio.columns.adjust();
        contenedorTabla.show();

        var hayMas = movimientosSocioEstado.start < movimientosSocioEstado.total;
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

    function cargarMovimientosSocio(numeroAsociado, esReinicio) {
        esReinicio = esReinicio === true;
        if (!numeroAsociado) return;
        if (movimientosSocioEstado.cargando) return;

        var esPrimerBloque = esReinicio || movimientosSocioEstado.start === 0;

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
            url: SOCIOS + '/ObtenerMovimientosSocio',
            contentType: 'application/json; charset=utf-8',
            data: JSON.stringify({
                numeroAsociado: numeroAsociado,
                start: movimientosSocioEstado.start,
                length: movimientosSocioEstado.length,
                orderColumn: movimientosSocioEstado.orderColumn,
                orderDir: movimientosSocioEstado.orderDir
            }),
            dataType: 'text',
            success: function (rawResponse) {
                var payload = rawResponse;
                if (typeof rawResponse === 'string') {
                    var limpio = rawResponse.trim();
                    if (limpio.indexOf('<') === 0 || limpio.indexOf('if') === 0) {
                        movimientosSocioEstado.cargando = false;
                        if (esPrimerBloque) {
                            $('#spinnerMovimientosSocio').addClass('d-none');
                            $('#contenedorTablaMovimientosSocio').hide();
                            $('#estadoMovimientosSocio').removeClass('d-none');
                            $('#estadoMovimientosSocio').find('p').text('Se recibió contenido inesperado del servidor.');
                        } else {
                            $('#btnVerMasMovimientos').prop('disabled', false).text('Ver más movimientos');
                        }
                        toast('Respuesta inesperada al solicitar movimientos.', 'error');
                        return;
                    }
                    try {
                        payload = JSON.parse(limpio);
                    } catch (e) {
                        movimientosSocioEstado.cargando = false;
                        if (esPrimerBloque) {
                            $('#spinnerMovimientosSocio').addClass('d-none');
                            $('#contenedorTablaMovimientosSocio').hide();
                            $('#estadoMovimientosSocio').removeClass('d-none');
                            $('#estadoMovimientosSocio').find('p').text('No se pudo interpretar la respuesta del servidor.');
                        } else {
                            $('#btnVerMasMovimientos').prop('disabled', false).text('Ver más movimientos');
                        }
                        toast('No se pudo interpretar la respuesta del servidor.', 'error');
                        return;
                    }
                }

                var datos = payload;
                if (payload && payload.d !== undefined) {
                    datos = payload.d;
                }
                if (typeof datos === 'string') {
                    try {
                        datos = JSON.parse(datos);
                    } catch (e2) {
                        movimientosSocioEstado.cargando = false;
                        if (esPrimerBloque) {
                            $('#spinnerMovimientosSocio').addClass('d-none');
                            $('#contenedorTablaMovimientosSocio').hide();
                            $('#estadoMovimientosSocio').removeClass('d-none');
                            $('#estadoMovimientosSocio').find('p').text('No se pudo interpretar los datos de movimientos.');
                        } else {
                            $('#btnVerMasMovimientos').prop('disabled', false).text('Ver más movimientos');
                        }
                        toast('No se pudo interpretar los datos de movimientos.', 'error');
                        return;
                    }
                }

                procesarResultadoMovimientos(datos, esPrimerBloque);
            },
            error: function (xhr, status, error) {
                movimientosSocioEstado.cargando = false;
                if (esPrimerBloque) {
                    $('#spinnerMovimientosSocio').addClass('d-none');
                    $('#contenedorTablaMovimientosSocio').hide();
                    $('#estadoMovimientosSocio').removeClass('d-none');
                    $('#estadoMovimientosSocio').find('p').text('Ocurrió un error al obtener los movimientos.');
                } else {
                    $('#btnVerMasMovimientos').prop('disabled', false).text('Ver más movimientos');
                }
                toast('Error al cargar movimientos: ' + error, 'error');
            }
        });
    }

    function actualizarTituloMovimientos(numeroAsociado) {
        var socio = obtenerSocioDeCache(numeroAsociado);
        if (socio) {
            $('#tituloMovimientosSocio').html(crearTituloMovimientosDesdeSocio(socio));
        } else {
            $('#tituloMovimientosSocio').html('<span class="badge bg-secondary">#' + numeroAsociado + '</span>');
            cargarSocioParaTitulo(numeroAsociado);
        }
    }

    function cargarSocioParaTitulo(numeroAsociado) {
        $.ajax({
            type: 'POST',
            url: SOCIOS + '/ObtenerSocioPorNumero',
            contentType: 'application/json; charset=utf-8',
            data: JSON.stringify({ numeroAsociado: numeroAsociado }),
            dataType: 'json',
            success: function (response) {
                if (typeof response.d === 'string') {
                    response.d = JSON.parse(response.d);
                }
                if (response.d && response.d.Success && response.d.Data) {
                    var socio = response.d.Data;
                    agregarSocioACache(socio);
                    if (numeroAsociado === socioMovimientosEnConsulta) {
                        $('#tituloMovimientosSocio').html(crearTituloMovimientosDesdeSocio(socio));
                    }
                }
            }
        });
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
            setTimeout(function () {
                movimientosSocioEstado.silenciarOrden = false;
            }, 0);
        }

        $('#estadoMovimientosSocio').addClass('d-none');
        $('#contenedorTablaMovimientosSocio').hide();
        $('#spinnerMovimientosSocio').removeClass('d-none');
        $('#verMasMovimientosContainer').hide();
        $('#btnVerMasMovimientos').prop('disabled', false).text('Ver más movimientos');

        var modal = new bootstrap.Modal(document.getElementById('modalMovimientosSocio'));
        modal.show();

        cargarMovimientosSocio(numeroAsociado, true);
    }

    function verTransaccionesSocio(numeroAsociado) {
        var socio = obtenerSocioDeCache(numeroAsociado);
        var titulo = socio
            ? [socio.Nombre, socio.Apellido].filter(Boolean).join(' ').trim()
            : '';
        $('#tituloTransaccionesSocio').html(
            titulo
                ? '<span class="badge bg-secondary">#' + numeroAsociado + '</span> ' + escaparHtmlSocios(titulo)
                : '<span class="badge bg-secondary">#' + numeroAsociado + '</span>'
        );
        $('#estadoTransaccionesSocio').addClass('d-none');
        $('#contenedorTablaTransaccionesSocio').hide();
        $('#spinnerTransaccionesSocio').removeClass('d-none');

        var modal = new bootstrap.Modal(document.getElementById('modalTransaccionesSocio'));
        modal.show();

        $.ajax({
            type: 'POST',
            url: SOCIOS + '/ObtenerTransaccionesSocio',
            contentType: 'application/json; charset=utf-8',
            data: JSON.stringify({ numeroAsociado: numeroAsociado }),
            dataType: 'json',
            success: function (response) {
                $('#spinnerTransaccionesSocio').addClass('d-none');
                var data = response.d;
                if (typeof data === 'string') data = JSON.parse(data);
                if (!data.Success) {
                    toast(data.Message || 'Error al cargar transacciones', 'error');
                    $('#estadoTransaccionesSocio').removeClass('d-none').find('p').text(data.Message || 'Error al cargar.');
                    return;
                }
                var lista = data.Data || [];
                var tbody = $('#tbodyTransaccionesSocio');
                tbody.empty();
                if (lista.length === 0) {
                    $('#estadoTransaccionesSocio').removeClass('d-none');
                } else {
                    $('#contenedorTablaTransaccionesSocio').show();
                    lista.forEach(function (t) {
                        var fechaHora = t.FechaHora
                            ? (typeof t.FechaHora === 'string' && t.FechaHora.indexOf('/Date(') >= 0
                                ? new Date(parseInt(t.FechaHora.match(/\d+/)[0], 10)).toLocaleString('es-PA')
                                : t.FechaHora)
                            : 'N/A';
                        var btnImprimir = '<button type="button" class="btn btn-sm btn-outline-primary" onclick="event.preventDefault(); event.stopPropagation(); SemgaTransAcciones.imprimirComprobanteLotePorId(' + t.IDTransaccion + ')" title="Imprimir comprobante"><i class="fas fa-print"></i></button>';
                        tbody.append(
                            '<tr><td>' + (t.IDTransaccion || '') + '</td><td>' + fechaHora + '</td><td>' + (t.Cajero || 'N/A') + '</td><td>' + (t.CantTran || 0) + '</td><td>' + btnImprimir + '</td></tr>'
                        );
                    });
                }
            },
            error: function () {
                $('#spinnerTransaccionesSocio').addClass('d-none');
                $('#estadoTransaccionesSocio').removeClass('d-none').find('p').text('Error al cargar transacciones.');
                toast('Error al cargar transacciones', 'error');
            }
        });
    }

    function imprimirComprobanteLotePorId(idTrans) {
        if (typeof global.imprimirComprobanteLotePorId === 'function') {
            global.imprimirComprobanteLotePorId(idTrans);
            return;
        }
        $.ajax({
            type: 'POST',
            url: urlTransaccionesWebMethod('GenerarComprobanteLote'),
            data: JSON.stringify({ idTrans: idTrans }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (response) {
                if (response.d && response.d.Resultado === 'SUCCESS' && typeof global.mostrarModalComprobante === 'function') {
                    global.mostrarModalComprobante(response.d.Html, '', '');
                } else {
                    toast((response.d && response.d.Mensaje) || 'Error al generar comprobante.', 'error');
                }
            },
            error: function (xhr, status, err) {
                toast('Error al generar comprobante: ' + (err || xhr.statusText), 'error');
            }
        });
    }

    function reimprimirComprobanteMovimiento(movimientoId) {
        if (!movimientoId) {
            toast('No se pudo determinar el movimiento a imprimir.', 'warning');
            return;
        }
        $.ajax({
            type: 'POST',
            url: SOCIOS + '/GenerarComprobanteMovimiento',
            contentType: 'application/json; charset=utf-8',
            data: JSON.stringify({ movimientoId: movimientoId.toString() }),
            dataType: 'json',
            success: function (response) {
                if (typeof response.d === 'string') {
                    response.d = JSON.parse(response.d);
                }
                if (response.d && response.d.Resultado === 'SUCCESS') {
                    imprimirComprobanteMovimiento(response.d.Html, movimientoId);
                } else {
                    var mensaje = response.d && response.d.Mensaje ? response.d.Mensaje : 'No fue posible generar el comprobante.';
                    toast(mensaje, 'error');
                }
            },
            error: function (xhr, status, error) {
                toast('Error al generar el comprobante: ' + error, 'error');
            }
        });
    }

    function imprimirComprobanteMovimiento(htmlContent, movimientoId) {
        marcarMovimientoImpreso(movimientoId);
        var ventanaImpresion = window.open('', '_blank', 'width=800,height=600');
        ventanaImpresion.document.write(
            '<!DOCTYPE html><html><head><title>Comprobante de Transacción</title>' +
            '<style>body{margin:0;padding:20px;font-family:Arial,sans-serif;}' +
            '.comprobante{height:auto!important;}.separator{display:block!important;}.no-print{display:none!important;}</style></head><body>' +
            htmlContent + '</body></html>'
        );
        ventanaImpresion.document.close();
        ventanaImpresion.onload = function () {
            setTimeout(function () {
                ventanaImpresion.print();
                ventanaImpresion.close();
            }, 200);
        };
    }

    function marcarMovimientoImpreso(movimientoId) {
        if (!movimientoId) return;
        $.ajax({
            type: 'POST',
            url: SOCIOS + '/MarcarComprobanteImpreso',
            contentType: 'application/json; charset=utf-8',
            data: JSON.stringify({ movimientoId: movimientoId.toString() }),
            dataType: 'json'
        });
    }

    function generarEstadoCuenta(numeroAsociado) {
        if (!numeroAsociado) {
            toast('No se pudo determinar el asociado.', 'warning');
            return;
        }
        $.ajax({
            type: 'POST',
            url: SOCIOS + '/GenerarEstadoCuenta',
            contentType: 'application/json; charset=utf-8',
            data: JSON.stringify({ numeroAsociado: numeroAsociado.toString() }),
            dataType: 'json',
            success: function (response) {
                if (typeof response.d === 'string') {
                    response.d = JSON.parse(response.d);
                }
                if (response.d && response.d.Resultado === 'SUCCESS') {
                    mostrarModalEstadoCuenta(response.d.Html);
                } else {
                    var mensaje = response.d && response.d.Mensaje ? response.d.Mensaje : 'No fue posible generar el estado de cuenta.';
                    toast(mensaje, 'error');
                }
            },
            error: function (xhr, status, error) {
                toast('Error al generar el estado de cuenta: ' + error, 'error');
            }
        });
    }

    function mostrarModalEstadoCuenta(htmlContent) {
        var modalHtml =
            '<div id="modalEstadoCuenta" class="estado-cuenta-modal-overlay">' +
            '<div class="estado-cuenta-modal">' +
            '<div class="estado-cuenta-modal-header">' +
            '<h5><i class="fas fa-file-invoice text-primary"></i> Estado de Cuenta</h5>' +
            '<button type="button" class="btn-close-custom" onclick="SemgaTransAcciones.cerrarModalEstadoCuenta()"><i class="fas fa-times"></i></button>' +
            '</div>' +
            '<div class="estado-cuenta-modal-body"><div class="estado-cuenta-container">' + htmlContent + '</div></div>' +
            '<div class="estado-cuenta-modal-footer">' +
            '<button type="button" class="btn btn-secondary" onclick="SemgaTransAcciones.cerrarModalEstadoCuenta()"><i class="fas fa-times"></i> Cerrar</button>' +
            '<button type="button" class="btn btn-primary" onclick="SemgaTransAcciones.imprimirEstadoCuentaDesdeModal()"><i class="fas fa-print"></i> Imprimir</button>' +
            '</div></div></div>';
        $('body').append(modalHtml);
        if (!$('#estadoCuentaModalStylesTrans').length) {
            $('head').append(
                '<style id="estadoCuentaModalStylesTrans">' +
                '.estado-cuenta-modal-overlay{position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,.7);display:flex;justify-content:center;align-items:center;z-index:10000;backdrop-filter:blur(3px);}' +
                '.estado-cuenta-modal{background:#fff;border-radius:12px;box-shadow:0 15px 35px rgba(0,0,0,.4);width:95%;max-width:1000px;max-height:95vh;overflow:hidden;display:flex;flex-direction:column;}' +
                '.estado-cuenta-modal-header{background:linear-gradient(135deg,#2c3e50,#34495e);color:#fff;padding:15px 20px;display:flex;justify-content:space-between;align-items:center;flex-shrink:0;}' +
                '.estado-cuenta-modal-header h5{margin:0;font-size:18px;font-weight:600;}' +
                '.btn-close-custom{background:rgba(255,255,255,.2);border:none;color:#fff;width:30px;height:30px;border-radius:50%;display:flex;align-items:center;justify-content:center;cursor:pointer;}' +
                '.estado-cuenta-modal-body{flex:1;overflow:auto;padding:20px;background:#f8f9fa;}' +
                '.estado-cuenta-container{background:#fff;border-radius:8px;padding:20px;box-shadow:0 2px 10px rgba(0,0,0,.1);}' +
                '.estado-cuenta-modal-footer{padding:15px 20px;background:#f8f9fa;border-top:1px solid #dee2e6;display:flex;justify-content:flex-end;gap:10px;flex-shrink:0;}' +
                '.estado-cuenta-container .no-print{display:none!important;}' +
                '</style>'
            );
        }
    }

    function cerrarModalEstadoCuenta() {
        $('#modalEstadoCuenta').remove();
    }

    function imprimirEstadoCuentaDesdeModal() {
        var ventanaImpresion = window.open('', '_blank', 'width=800,height=600');
        var contenidoEstadoCuenta = $('#modalEstadoCuenta .estado-cuenta-container').html();
        var el = document.getElementById('semgaEstadoCuentaPrintCss');
        var estilosCompletos = el ? el.textContent || el.innerText || '' : 'body{margin:0;padding:20px;font-size:12px;}';
        ventanaImpresion.document.write(
            '<!DOCTYPE html><html><head><title>Estado de Cuenta</title><style>' + estilosCompletos + '</style></head><body>' + contenidoEstadoCuenta + '</body></html>'
        );
        ventanaImpresion.document.close();
        setTimeout(function () {
            ventanaImpresion.print();
        }, 250);
    }

    /** Sincroniza caché de socio (mismo shape que GestionSocios) desde el objeto de Transacciones. */
    function syncSocioDesdeTransacciones(sel) {
        global.__sociosCache = global.__sociosCache || [];
        if (!sel || !sel.numeroAsociado) return;
        var parts = (sel.nombre || '').trim().split(/\s+/);
        var socio = {
            NumeroAsociado: parseInt(sel.numeroAsociado, 10),
            Nombre: parts[0] || sel.nombre || '',
            SegundoNombre: '',
            Apellido: parts.length > 1 ? parts.slice(1).join(' ') : '',
            SegundoApellido: '',
            TipoIdentificacion: sel.tipoDocumento || '',
            NumeroIdentificacion: sel.cedula || ''
        };
        agregarSocioACache(socio);
    }

    function setAccionesSocioHabilitadas(habilitado) {
        var $b = $('#btnAccSocTransacciones, #btnAccSocMovimientos, #btnAccSocEstadoCuenta');
        $b.prop('disabled', !habilitado);
        if (habilitado) {
            $b.removeClass('disabled');
        } else {
            $b.addClass('disabled');
        }
    }

    function initAccionesAsociadoTrans() {
        $('#btnAccSocTransacciones').on('click', function () {
            var n = global.semgaNumeroAsociadoTransacciones;
            if (!n) {
                toast('Seleccione un asociado.', 'warning');
                return;
            }
            verTransaccionesSocio(n);
        });
        $('#btnAccSocMovimientos').on('click', function () {
            var n = global.semgaNumeroAsociadoTransacciones;
            if (!n) {
                toast('Seleccione un asociado.', 'warning');
                return;
            }
            verMovimientosSocio(n);
        });
        $('#btnAccSocEstadoCuenta').on('click', function () {
            var n = global.semgaNumeroAsociadoTransacciones;
            if (!n) {
                toast('Seleccione un asociado.', 'warning');
                return;
            }
            generarEstadoCuenta(n);
        });
        setAccionesSocioHabilitadas(false);
    }

    global.SemgaTransAcciones = {
        init: initAccionesAsociadoTrans,
        syncSocio: syncSocioDesdeTransacciones,
        setAccionesHabilitadas: setAccionesSocioHabilitadas,
        verTransaccionesSocio: verTransaccionesSocio,
        verMovimientosSocio: verMovimientosSocio,
        generarEstadoCuenta: generarEstadoCuenta,
        imprimirComprobanteLotePorId: imprimirComprobanteLotePorId,
        reimprimirComprobanteMovimiento: reimprimirComprobanteMovimiento,
        cerrarModalEstadoCuenta: cerrarModalEstadoCuenta,
        imprimirEstadoCuentaDesdeModal: imprimirEstadoCuentaDesdeModal
    };
})(window);
