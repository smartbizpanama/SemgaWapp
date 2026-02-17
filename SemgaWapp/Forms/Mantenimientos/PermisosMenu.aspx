<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PermisosMenu.aspx.vb" Inherits="SemgaWapp.PermisosMenu" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Permisos de Men&#250;</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <style>
        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
            overflow: hidden;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f8f9fa;
        }
        #form1 {
            margin: 0;
            height: 100%;
            min-height: 100%;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }
        .container-app {
            padding: 16px;
            flex: 1;
            min-height: 0;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }
        .card-section {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            padding: 16px;
            flex: 1;
            min-height: 0;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            border: 1px solid #e9ecef;
        }
        /* Cabecera siempre visible (fuera del scroll, nunca se oculta) */
        .cabecera-fija {
            flex-shrink: 0;
            background: white;
            padding-bottom: 10px;
            border-bottom: 1px solid #e9ecef;
            margin-bottom: 0;
        }
        .header-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
        }
        .header-row .filtro-label { font-size: 14px; font-weight: 500; color: #495057; margin: 0; white-space: nowrap; }
        .header-row .filtro-group { display: flex; align-items: center; gap: 8px; flex: 1; max-width: 360px; }
        .header-row .filtro-group .filtro-permisos-wrap { margin-bottom: 0; flex: 1; }
        .table-permisos { font-size: 13px; margin-bottom: 0; }
        .table-permisos thead th {
            background: #f8f9fa;
            font-weight: 600;
            color: #495057;
            border-bottom: 2px solid #dee2e6;
            position: sticky;
            top: 0;
            z-index: 5;
            background: #f8f9fa;
            box-shadow: 0 2px 0 0 #dee2e6;
        }
        .table-permisos thead th.th-permitir {
            text-align: center;
            vertical-align: middle;
        }
        .table-permisos thead th.th-permitir .form-check-input {
            margin: 0 auto;
            display: block;
        }
        .table-permisos tbody tr:hover { background: #f8f9fa; }
        .table-permisos td { vertical-align: middle; }
        .table-permisos td.td-permitir { text-align: center; }
        .grupo-padre { font-weight: 600; color: #1e3a8a; background: #e7f1ff !important; }
        .grupo-hijo { padding-left: 28px !important; color: #495057; }
        .td-icon { width: 42px; text-align: center; color: #1e3a8a; font-size: 16px; }
        .td-url { font-size: 12px; color: #6c757d; max-width: 280px; word-break: break-all; }
        /* Checkboxes más grandes y borde más intenso */
        .form-check-input.permiso-cb,
        .table-permisos .form-check-input {
            width: 18px;
            height: 18px;
            border: 2px solid #0d6efd;
            cursor: pointer;
        }
        .form-check-input.permiso-cb:checked,
        .table-permisos .form-check-input:checked {
            background-color: #0d6efd;
            border-color: #0d6efd;
        }
        .form-check-input.permiso-cb:focus,
        .table-permisos .form-check-input:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.35);
        }
        .btn-guardar {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            border: none;
            padding: 8px 18px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 13px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-guardar:hover { opacity: 0.95; transform: translateY(-1px); color: white; }
        .msg-empty { color: #6c757d; text-align: center; padding: 24px; }
        /* Único elemento con scroll: solo el contenido de la tabla */
        .tabla-scroll {
            flex: 1 1 0;
            min-height: 120px;
            overflow-y: auto;
            overflow-x: hidden;
        }
        .tabla-scroll table { width: 100%; }
        /* Filtro: input con clear (x) dentro */
        .filtro-permisos-wrap {
            position: relative;
            max-width: 360px;
            margin-bottom: 10px;
        }
        .filtro-permisos-wrap input {
            width: 100%;
            padding: 8px 32px 8px 12px;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            font-size: 14px;
        }
        .filtro-permisos-wrap input:focus {
            border-color: #0d6efd;
            outline: 0;
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.25);
        }
        .filtro-permisos-wrap .btn-clear-filtro {
            position: absolute;
            right: 8px;
            top: 50%;
            transform: translateY(-50%);
            width: 22px;
            height: 22px;
            padding: 0;
            border: none;
            background: #adb5bd;
            color: white;
            border-radius: 50%;
            cursor: pointer;
            font-size: 12px;
            line-height: 1;
            display: none;
            align-items: center;
            justify-content: center;
        }
        .filtro-permisos-wrap .btn-clear-filtro:hover {
            background: #6c757d;
        }
        .filtro-permisos-wrap .btn-clear-filtro { display: none; }
        .filtro-permisos-wrap.has-text .btn-clear-filtro { display: flex; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-app">
            <div class="card-section" id="sectionPermisos">
                <div class="cabecera-fija">
                    <div class="header-row">
                        <div class="filtro-group">
                            <label class="filtro-label" for="inputFiltroPermisos">Filtrar</label>
                            <div class="filtro-permisos-wrap" id="filtroPermisosWrap">
                                <input type="text" id="inputFiltroPermisos" class="form-control" placeholder="Nombre o URL destino..." autocomplete="off" />
                                <button type="button" class="btn-clear-filtro" id="btnClearFiltro" title="Limpiar filtro" aria-label="Limpiar filtro">&#215;</button>
                            </div>
                        </div>
                        <button type="button" id="btnGuardar" class="btn-guardar" style="display: none;">
                            <i class="fas fa-save"></i> Guardar permisos
                        </button>
                    </div>
                </div>
                <div class="tabla-scroll" id="tablaScroll">
                    <table class="table table-permisos table-hover">
                        <thead>
                            <tr>
                                <th style="width: 42px;"></th>
                                <th>Nombre</th>
                                <th>URL destino</th>
                                <th class="th-permitir" style="width: 80px;">
                                    <input type="checkbox" class="form-check-input" id="checkTodosPermitir" title="Seleccionar o deseleccionar todo" />
                                </th>
                            </tr>
                        </thead>
                        <tbody id="tbodyPermisos">
                        </tbody>
                    </table>
                </div>
                <p class="msg-empty" id="msgEmptyPermisos" style="display: none;">No hay opciones de men&#250; configuradas. Ejecute el script <code>tbMenuOpciones_Permisos.sql</code> en la base de datos.</p>
            </div>
        </div>
    </form>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        $(function () {
            var menuOpciones = [];
            var permisosUsuario = {};
            var userIdActual = null;

            // Icono por clave (relacionado a la opción)
            var iconosPorClave = {
                'DASH_SOCIOS': 'fa-users',
                'DASH_MOVIMIENTOS': 'fa-exchange-alt',
                'DASH_AUXILIARES': 'fa-users-cog',
                'DASH_REPORTES': 'fa-chart-bar',
                'DASH_FINANZAS': 'fa-dollar-sign',
                'DASH_LOGS': 'fa-clipboard-list',
                'DASH_SISTEMAS': 'fa-cogs',
                'DASH_AYUDA': 'fa-question-circle',
                'REP_REPORTES': 'fa-chart-line',
                'REP_HISTORIAL': 'fa-history',
                'REP_MOVIMIENTOS': 'fa-file-invoice',
                'AYUDA_DOC': 'fa-book',
                'AYUDA_PROCESOS': 'fa-cogs',
                'SIST_USUARIOS': 'fa-user-cog',
                'SIST_MANTENIMIENTOS': 'fa-table',
                'SIST_PARAMS': 'fa-cogs',
                'SIST_RESPALDOS': 'fa-database',
                'SIST_HISTORIAL': 'fa-history',
                'SIST_PERMISOS_MENU': 'fa-key',
                'MANT_CUENTAS': 'fa-wallet',
                'MANT_ROLES': 'fa-user-tag',
                'MANT_DEPARTAMENTOS': 'fa-building',
                'MANT_TIPO_IDENTIFICACION': 'fa-id-card',
                'MANT_TIPO_ASOCIADOS': 'fa-user-friends',
                'MANT_PARENTEZCOS': 'fa-users',
                'MANT_ESTATUS_ASOCIADOS': 'fa-user-check',
                'MANT_CODIGOS_TRANSACCION': 'fa-exchange-alt',
                'MANT_RUBROS': 'fa-list-alt',
                'MANT_TIPOS_AUXILIARES': 'fa-tools',
                'MANT_NIVELES_ESTUDIO': 'fa-graduation-cap',
                'MANT_PROFESIONES': 'fa-briefcase',
                'MANT_OCUPACIONES': 'fa-user-tie',
                'MANT_EMPRESAS': 'fa-building',
                'MANT_PAISES': 'fa-globe',
                'MANT_PROVINCIAS': 'fa-map',
                'MANT_DISTRITOS': 'fa-map-marked-alt',
                'MANT_CORREGIMIENTOS': 'fa-map-pin'
            };

            function getIcono(clave) {
                return iconosPorClave[clave] || 'fa-circle';
            }

            function getQueryParam(name) {
                var url = window.location.href;
                var i = url.indexOf('?');
                if (i === -1) return '';
                var q = url.substring(i + 1).split('&');
                for (var j = 0; j < q.length; j++) {
                    var kv = q[j].split('=');
                    if (kv[0] === name) return decodeURIComponent((kv[1] || '').replace(/\+/g, ' '));
                }
                return '';
            }

            function actualizarCheckTodos() {
                var total = $('.permiso-cb').length;
                var checked = $('.permiso-cb:checked').length;
                var $todo = $('#checkTodosPermitir');
                $todo.prop('checked', total > 0 && checked === total);
                $todo.prop('indeterminate', checked > 0 && checked < total);
            }

            $(document).on('change', '#checkTodosPermitir', function () {
                var checked = $(this).prop('checked');
                $('.permiso-cb').prop('checked', checked);
            });

            $(document).on('change', '.permiso-cb', function () {
                actualizarCheckTodos();
            });

            function aplicarFiltroPermisos() {
                var q = ($('#inputFiltroPermisos').val() || '').trim().toLowerCase();
                var $wrap = $('#filtroPermisosWrap');
                if (q.length) $wrap.addClass('has-text'); else $wrap.removeClass('has-text');
                $('#tbodyPermisos tr').each(function () {
                    var $tr = $(this);
                    var nombre = ($tr.find('td').eq(1).text() || '').toLowerCase();
                    var url = ($tr.find('td').eq(2).text() || '').toLowerCase();
                    var match = nombre.indexOf(q) !== -1 || url.indexOf(q) !== -1;
                    $tr.toggle(match);
                });
            }

            $('#inputFiltroPermisos').on('input keyup', function () {
                aplicarFiltroPermisos();
            });

            $('#btnClearFiltro').on('click', function () {
                $('#inputFiltroPermisos').val('').focus();
                $('#filtroPermisosWrap').removeClass('has-text');
                $('#tbodyPermisos tr').show();
            });

            function loadPermisosMenuUsuario(idUsuario) {
                if (!idUsuario) return;
                userIdActual = idUsuario;
                $.ajax({
                    type: 'POST',
                    url: 'PermisosMenu.aspx/ObtenerPermisosMenuUsuario',
                    data: JSON.stringify({ idUsuario: parseInt(idUsuario, 10) }),
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    success: function (res) {
                        var d = typeof res.d === 'string' ? JSON.parse(res.d) : res.d;
                        menuOpciones = d || [];
                        permisosUsuario = {};
                        if (menuOpciones.length) {
                            menuOpciones.forEach(function (m) {
                                permisosUsuario[m.IdMenuOpcion] = m.Permitido;
                            });
                        }
                        if (menuOpciones.length === 0) {
                            $('#msgEmptyPermisos').show();
                            $('.cabecera-fija').hide();
                            $('#tablaScroll').hide();
                        } else {
                            $('#msgEmptyPermisos').hide();
                            $('.cabecera-fija').show();
                            $('#tablaScroll').show();
                            renderGrid();
                            $('#btnGuardar').show();
                        }
                    },
                    error: function () { alert('Error al cargar opciones de men\u00fa.'); }
                });
            }

            function renderGrid() {
                var tbody = $('#tbodyPermisos');
                tbody.empty();
                var padres = menuOpciones.filter(function (m) { return !m.IdPadre || m.IdPadre === 0; });
                var hijos = menuOpciones.filter(function (m) { return m.IdPadre && m.IdPadre !== 0; });
                padres.sort(function (a, b) { return (a.Orden || 0) - (b.Orden || 0); });
                hijos.sort(function (a, b) { return (a.Orden || 0) - (b.Orden || 0); });
                padres.forEach(function (p) {
                    tbody.append(buildRow(p, false));
                    hijos.filter(function (h) { return h.IdPadre === p.IdMenuOpcion; }).forEach(function (h) {
                        tbody.append(buildRow(h, true));
                    });
                });
                hijos.filter(function (h) { return !padres.some(function (pa) { return pa.IdMenuOpcion === h.IdPadre; }); }).forEach(function (h) {
                    tbody.append(buildRow(h, false));
                });
                actualizarCheckTodos();
                aplicarFiltroPermisos();
            }

            function buildRow(opcion, esHijo) {
                var p = permisosUsuario[opcion.IdMenuOpcion];
                var permitido = (p === undefined) ? true : (p === true || p === 1);
                var icono = getIcono(opcion.Clave || '');
                var tr = $('<tr></tr>').addClass(esHijo ? 'grupo-hijo' : 'grupo-padre');
                tr.append($('<td class="td-icon"></td>').html('<i class="fas ' + icono + '"></i>'));
                tr.append($('<td></td>').text(opcion.Nombre || ''));
                tr.append($('<td class="td-url"></td>').text(opcion.UrlDestino || ''));
                tr.append($('<td class="td-permitir"></td>').html('<input type="checkbox" class="form-check-input permiso-cb" data-id="' + opcion.IdMenuOpcion + '" ' + (permitido ? 'checked' : '') + ' />'));
                return tr;
            }

            $('#btnGuardar').on('click', function () {
                if (!userIdActual) { alert('Usuario no definido.'); return; }
                var lista = [];
                $('.permiso-cb').each(function () {
                    lista.push({ IdMenuOpcion: parseInt($(this).data('id'), 10), Permitido: $(this).prop('checked') });
                });
                $.ajax({
                    type: 'POST',
                    url: 'PermisosMenu.aspx/GuardarPermisos',
                    data: JSON.stringify({ idUsuario: parseInt(userIdActual, 10), permisosJson: JSON.stringify(lista) }),
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    success: function (res) {
                        var d = (typeof res.d === 'string' ? res.d : (res.d || '')).toString();
                        if (d.indexOf('ERROR') === 0) { alert(d); return; }
                        if (window.parent && typeof window.parent.showToast === 'function') {
                            window.parent.showToast('success', 'Éxito', 'Permisos guardados correctamente.');
                        } else {
                            alert('Permisos guardados correctamente.');
                        }
                        loadPermisosMenuUsuario(userIdActual);
                    },
                    error: function () { alert('Error al guardar.'); }
                });
            });

            userIdActual = getQueryParam('userId');
            if (!userIdActual) {
                document.body.innerHTML = '<div class="p-4 text-center text-danger">Falta el par\u00e1metro userId. Abra esta pantalla desde Gesti\u00f3n de usuarios.</div>';
                return;
            }
            loadPermisosMenuUsuario(userIdActual);
        });
    </script>
</body>
</html>
