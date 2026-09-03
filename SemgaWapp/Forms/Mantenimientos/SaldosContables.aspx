<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SaldosContables.aspx.vb" Inherits="SemgaWapp.SaldosContables" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Saldos Contables</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <!-- Select2 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" rel="stylesheet" />
    <!-- Script de monitoreo de inactividad -->
    <script src="../../Scripts/inactivity-monitor-final.js?v=2.6"></script>
    <!-- Sistema de notificaciones toast global -->
    <script src="../../Scripts/notifications.js?v=1.0"></script>

    <style>
        html, body {
            height: 100vh;
            overflow: hidden;
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: #f8f9fa;
            display: flex;
            flex-direction: column;
        }

        .main-container {
            background: #ffffff;
            border-radius: 6px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin: 15px;
            padding: 15px;
            border: 1px solid #e9ecef;
            display: flex;
            flex-direction: column;
            height: calc(100vh - 30px);
            max-height: calc(100vh - 30px);
            overflow: hidden;
        }

        .header-section {
            background: #2c3e50;
            color: #fff;
            border-radius: 6px;
            padding: 12px 18px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .header-section h1 {
            font-size: 20px;
            margin: 0;
            font-weight: 600;
        }

        .back-btn {
            background: rgba(255,255,255,0.15);
            color: #fff;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: background 0.2s ease;
        }

        .back-btn:hover {
            background: rgba(255,255,255,0.3);
            color: #fff;
        }

        .content-area {
            flex: 1;
            min-height: 0;
            overflow: auto;
        }

        #tblCuentas th,
        #tblCuentas td {
            vertical-align: middle;
        }

        #tblCuentas .badge-codigo-cuenta {
            font-family: 'Consolas', 'Courier New', monospace;
            font-size: 13px;
        }

        #tblCuentas th.sortable {
            cursor: pointer;
            user-select: none;
            white-space: nowrap;
        }

        #tblCuentas th.sortable:hover {
            background-color: #f1f3f5;
        }

        #tblCuentas th .sort-icon {
            font-size: 12px;
            margin-left: 4px;
        }

        /* Ocultar spinners del campo de saldo */
        .no-spinner::-webkit-outer-spin-button,
        .no-spinner::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }

        .no-spinner {
            -moz-appearance: textfield;
            appearance: textfield;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="main-container">
            <div class="header-section">
                <h1><i class="fas fa-balance-scale me-2"></i>Saldos Contables</h1>
                <a href="dashboardSistemas.aspx" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Volver
                </a>
            </div>

            <div class="content-area">
                <div class="card">
                    <div class="card-body">
                        <!-- Filtros y Botones -->
                        <div class="row mb-2">
                            <div class="col-md-3">
                                <div class="d-flex align-items-center">
                                    <label class="form-label me-2 mb-0">Grupo:</label>
                                    <select id="ddlFiltroGrupoCuenta" class="form-select">
                                        <option value="">Todos</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="d-flex align-items-center">
                                    <label class="form-label me-2 mb-0">Código:</label>
                                    <div class="input-group">
                                        <input type="text" id="txtFiltroCodigoCuenta" class="form-control" placeholder="Buscar código..." />
                                        <button type="button" class="btn btn-outline-secondary btn-limpiar-campo" data-target="txtFiltroCodigoCuenta" title="Limpiar">
                                            <i class="fas fa-times"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="d-flex align-items-center">
                                    <label class="form-label me-2 mb-0">Nombre:</label>
                                    <div class="input-group">
                                        <input type="text" id="txtFiltroNombreCuenta" class="form-control" placeholder="Buscar nombre..." />
                                        <button type="button" class="btn btn-outline-secondary btn-limpiar-campo" data-target="txtFiltroNombreCuenta" title="Limpiar">
                                            <i class="fas fa-times"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="d-flex align-items-end gap-2">
                                    <button type="button" id="btnLimpiarFiltrosCuenta" class="btn btn-outline-secondary">
                                        <i class="fas fa-eraser me-1"></i>Limpiar todo
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Tabla -->
                        <div class="table-responsive">
                            <table id="tblCuentas" class="table table-hover">
                                <thead>
                                    <tr>
                                        <th class="sortable" data-col="ID">ID <i class="fas fa-sort sort-icon text-muted"></i></th>
                                        <th class="sortable" data-col="Cuenta">Cuenta <i class="fas fa-sort sort-icon text-muted"></i></th>
                                        <th class="sortable" data-col="Nombre">Nombre <i class="fas fa-sort sort-icon text-muted"></i></th>
                                        <th class="sortable" data-col="Grupo">Grupo <i class="fas fa-sort sort-icon text-muted"></i></th>
                                        <th class="sortable" data-col="Imputable">Imputable <i class="fas fa-sort sort-icon text-muted"></i></th>
                                        <th class="sortable text-end" data-col="Saldo">Saldo <i class="fas fa-sort sort-icon text-muted"></i></th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Los datos se cargarán dinámicamente -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Toast Container (lo gestiona notifications.js) -->
        <div id="toastContainer"></div>

        <!-- Modal Editar Saldo -->
        <div class="modal fade" id="modalSaldo" tabindex="-1" aria-labelledby="modalSaldoLabel" aria-hidden="true"
             data-bs-backdrop="static" data-bs-keyboard="false">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalSaldoLabel">
                            <i class="fas fa-balance-scale me-2"></i>Editar Saldo de Cuenta
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="formSaldo">
                            <input type="hidden" id="hdnIDCuenta" />
                            <div class="mb-3 d-flex gap-2">
                                <span id="txtCuentaInfo" class="badge bg-primary-subtle text-primary-emphasis fs-6 fw-normal text-start text-truncate flex-fill"></span>
                                <span class="badge bg-success-subtle text-success-emphasis fs-6 fw-normal text-center" style="width: 150px;">
                                    <i class="fa-solid fa-sack-dollar me-1"></i><span id="txtSaldoActual"></span>
                                </span>
                            </div>
                            <div class="mb-3">
                                <label for="txtNuevoSaldo" class="form-label">Nuevo saldo <span class="text-danger">*</span></label>
                                <input type="text" inputmode="decimal" id="txtNuevoSaldo" class="form-control no-spinner" placeholder="0.00" required />
                            </div>
                            <div class="mb-3">
                                <label for="txtMotivoSaldo" class="form-label">Motivo del cambio <span class="text-danger">*</span></label>
                                <textarea id="txtMotivoSaldo" class="form-control" rows="2" maxlength="500" placeholder="Justificación del ajuste de saldo..." required></textarea>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Cancelar
                        </button>
                        <button type="button" id="btnGuardarSaldo" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Select2 JS -->
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            if (typeof initializeInactivityMonitoring === 'function') {
                initializeInactivityMonitoring();
            }
            configurarEventos();
            cargarGruposCuenta();
        });

        let debounceFiltro = null;
        function cargarCuentasDebounced() {
            clearTimeout(debounceFiltro);
            debounceFiltro = setTimeout(cargarCuentas, 350);
        }

        let ordenActual = { col: null, dir: 'ASC' };

        function actualizarIconosOrden() {
            $('#tblCuentas thead th.sortable').each(function () {
                const $icon = $(this).find('.sort-icon');
                if ($(this).data('col') === ordenActual.col) {
                    $icon.removeClass('fa-sort text-muted')
                         .addClass(ordenActual.dir === 'ASC' ? 'fa-sort-up' : 'fa-sort-down');
                } else {
                    $icon.removeClass('fa-sort-up fa-sort-down').addClass('fa-sort text-muted');
                }
            });
        }

        function configurarEventos() {
            $('#btnLimpiarFiltrosCuenta').on('click', limpiarFiltros);
            $('#btnGuardarSaldo').on('click', guardarSaldo);
            $('#ddlFiltroGrupoCuenta').on('change', cargarCuentas);

            $('#txtFiltroCodigoCuenta, #txtFiltroNombreCuenta').on('input', cargarCuentasDebounced);
            $('#txtFiltroCodigoCuenta, #txtFiltroNombreCuenta').on('keypress', function (e) {
                if (e.which === 13) { e.preventDefault(); clearTimeout(debounceFiltro); cargarCuentas(); }
            });

            $('.btn-limpiar-campo').on('click', function () {
                const target = $(this).data('target');
                $('#' + target).val('');
                clearTimeout(debounceFiltro);
                cargarCuentas();
            });

            $('#tblCuentas thead').on('click', 'th.sortable', function () {
                const col = $(this).data('col');
                if (ordenActual.col === col) {
                    ordenActual.dir = (ordenActual.dir === 'ASC') ? 'DESC' : 'ASC';
                } else {
                    ordenActual.col = col;
                    ordenActual.dir = 'ASC';
                }
                actualizarIconosOrden();
                cargarCuentas();
            });

            $('#modalSaldo').on('shown.bs.modal', function () {
                $('#txtNuevoSaldo').trigger('focus');
            });
            $('#txtNuevoSaldo, #txtMotivoSaldo').on('input', function () {
                $(this).removeClass('is-invalid');
            });
        }

        function cargarGruposCuenta() {
            return $.ajax({
                type: "POST",
                url: "SaldosContables.aspx/ObtenerGruposCuenta",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    let responseData = response.d;
                    if (typeof responseData === 'string') responseData = JSON.parse(responseData);
                    if (responseData && responseData.Resultado === 'SUCCESS') {
                        llenarDropdownGrupos(JSON.parse(responseData.Datos));
                        cargarCuentas();
                    } else {
                        showToast('error', 'Error', responseData.Mensaje || 'Error al cargar grupos de cuenta');
                    }
                },
                error: function () {
                    showToast('error', 'Error', 'Error al cargar grupos de cuenta');
                }
            });
        }

        function llenarDropdownGrupos(grupos) {
            const $ddl = $('#ddlFiltroGrupoCuenta');
            $ddl.empty().append('<option value="">Todos</option>');
            grupos.forEach(function (grupo) {
                $ddl.append(`<option value="${grupo.IDGrupo}">${grupo.Descripcion}</option>`);
            });
        }

        function cargarCuentas() {
            const filtros = {
                IDGrupo: $('#ddlFiltroGrupoCuenta').val() || null,
                Codigo: $('#txtFiltroCodigoCuenta').val() || null,
                Nombre: $('#txtFiltroNombreCuenta').val() || null,
                OrderBy: ordenActual.col,
                OrderDir: ordenActual.dir
            };

            $.ajax({
                type: "POST",
                url: "SaldosContables.aspx/ListarCuentas",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ filtros: filtros }),
                dataType: "json",
                success: function (response) {
                    let responseData = response.d;
                    if (typeof responseData === 'string') responseData = JSON.parse(responseData);
                    if (responseData && responseData.Resultado === 'SUCCESS') {
                        mostrarCuentas(JSON.parse(responseData.Datos));
                    } else {
                        showToast('error', 'Error', responseData.Mensaje || 'Error al cargar cuentas');
                    }
                },
                error: function () {
                    showToast('error', 'Error', 'Error al cargar cuentas');
                }
            });
        }

        function formatoMoneda(valor) {
            const num = parseFloat(valor || 0);
            return '$' + num.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        }

        function mostrarCuentas(cuentas) {
            const tbody = $('#tblCuentas tbody');
            tbody.empty();

            if (!cuentas || cuentas.length === 0) {
                tbody.append('<tr><td colspan="7" class="text-center">No se encontraron cuentas</td></tr>');
                return;
            }

            cuentas.forEach(function (cuenta) {
                const grupoChip = crearChipGrupo(cuenta.GrupoDescripcion);
                const imputable = cuenta.snImputable === true || cuenta.snImputable === 1 || cuenta.snImputable === '1';
                const imputableChip = imputable
                    ? '<span class="badge bg-success">Sí</span>'
                    : '<span class="badge bg-secondary">No</span>';
                const nombre = (cuenta.Nombre || '').replace(/'/g, "\\'");
                const btnEditar = imputable
                    ? `<button type="button" class="btn btn-sm btn-outline-primary"
                            onclick="editarSaldo(${cuenta.ID}, '${cuenta.Codigo}', '${nombre}', ${parseFloat(cuenta.Saldo || 0)}); return false;">
                            <i class="fas fa-edit me-1"></i>Editar saldo
                        </button>`
                    : `<button type="button" class="btn btn-sm btn-outline-secondary" disabled
                            title="La cuenta no es imputable; su saldo no puede modificarse">
                            <i class="fas fa-lock me-1"></i>No imputable
                        </button>`;
                const row = `
                    <tr>
                        <td>${cuenta.ID}</td>
                        <td><span class="badge bg-primary badge-codigo-cuenta">${cuenta.Codigo}</span></td>
                        <td>${cuenta.Nombre || ''}</td>
                        <td>${grupoChip}</td>
                        <td>${imputableChip}</td>
                        <td class="text-end">${formatoMoneda(cuenta.Saldo)}</td>
                        <td>${btnEditar}</td>
                    </tr>`;
                tbody.append(row);
            });
        }

        function crearChipGrupo(grupoDescripcion) {
            if (!grupoDescripcion) {
                return '<span class="badge bg-secondary"><i class="fas fa-tag me-1"></i>Sin grupo</span>';
            }
            const g = grupoDescripcion.toLowerCase().trim();
            let config = { color: 'bg-secondary', icono: 'fas fa-tag' };
            if (g.includes('activo')) config = { color: 'bg-success', icono: 'fas fa-arrow-up' };
            else if (g.includes('pasivo')) config = { color: 'bg-danger', icono: 'fas fa-arrow-down' };
            else if (g.includes('capital')) config = { color: 'bg-primary', icono: 'fas fa-coins' };
            else if (g.includes('ingreso')) config = { color: 'bg-info', icono: 'fas fa-arrow-circle-up' };
            else if (g.includes('costo')) config = { color: 'bg-warning', icono: 'fas fa-dollar-sign' };
            else if (g.includes('gasto')) config = { color: 'bg-secondary', icono: 'fas fa-arrow-circle-down' };
            return `<span class="badge ${config.color}"><i class="${config.icono} me-1"></i>${grupoDescripcion}</span>`;
        }

        function limpiarFiltros() {
            $('#ddlFiltroGrupoCuenta').val('');
            $('#txtFiltroCodigoCuenta').val('');
            $('#txtFiltroNombreCuenta').val('');
            ordenActual = { col: null, dir: 'ASC' };
            actualizarIconosOrden();
            cargarCuentas();
        }

        function editarSaldo(id, codigo, nombre, saldo) {
            $('#hdnIDCuenta').val(id);
            $('#txtCuentaInfo').text(codigo + ' - ' + (nombre || ''));
            $('#txtSaldoActual').text(formatoMoneda(saldo));
            $('#txtNuevoSaldo').val('');
            $('#txtMotivoSaldo').val('');
            $('#txtNuevoSaldo, #txtMotivoSaldo').removeClass('is-invalid');
            $('#modalSaldo').modal('show');
        }

        function guardarSaldo() {
            const id = $('#hdnIDCuenta').val();
            const nuevoSaldoStr = $('#txtNuevoSaldo').val();
            const motivo = $('#txtMotivoSaldo').val().trim();

            $('#txtNuevoSaldo, #txtMotivoSaldo').removeClass('is-invalid');

            if (nuevoSaldoStr === '' || isNaN(parseFloat(nuevoSaldoStr))) {
                $('#txtNuevoSaldo').addClass('is-invalid').focus();
                return;
            }

            if (motivo === '') {
                $('#txtMotivoSaldo').addClass('is-invalid').focus();
                return;
            }

            const nuevoSaldo = parseFloat(nuevoSaldoStr);
            const cuentaInfo = $('#txtCuentaInfo').text();

            showConfirmToast(
                'warning',
                'Confirmar cambio de saldo',
                `¿Confirma cambiar el saldo de <strong>${cuentaInfo}</strong> a <strong>${formatoMoneda(nuevoSaldo)}</strong>?`,
                function () {
                    ejecutarGuardarSaldo(id, nuevoSaldo, motivo);
                }
            );
        }

        function ejecutarGuardarSaldo(id, nuevoSaldo, motivo) {
            $('#btnGuardarSaldo').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-1"></i>Guardando...');

            $.ajax({
                type: "POST",
                url: "SaldosContables.aspx/CambiarSaldoCuenta",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ id: parseInt(id, 10), nuevoSaldo: nuevoSaldo, motivo: motivo }),
                dataType: "json",
                success: function (response) {
                    let responseData = response.d;
                    if (typeof responseData === 'string') responseData = JSON.parse(responseData);
                    if (responseData && responseData.Resultado === 'SUCCESS') {
                        showToast('success', 'Éxito', responseData.Mensaje || 'Saldo actualizado correctamente');
                        $('#modalSaldo').modal('hide');
                        cargarCuentas();
                    } else {
                        showToast('error', 'Error', responseData.Mensaje || 'Error al actualizar el saldo');
                    }
                },
                error: function () {
                    showToast('error', 'Error', 'Error al actualizar el saldo');
                },
                complete: function () {
                    $('#btnGuardarSaldo').prop('disabled', false).html('<i class="fas fa-save me-1"></i>Guardar');
                }
            });
        }

    </script>
</body>
</html>
