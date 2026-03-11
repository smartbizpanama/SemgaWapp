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
        html, body { margin: 0; padding: 0; height: 100%; overflow: hidden; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f8f9fa; }
        #form1 { margin: 0; height: 100%; min-height: 100%; display: flex; flex-direction: column; overflow: hidden; }
        .container-app { padding: 16px; flex: 1; min-height: 0; box-sizing: border-box; display: flex; flex-direction: column; overflow: hidden; }
        .card-section { background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); padding: 16px; flex: 1; min-height: 0; display: flex; flex-direction: column; overflow: hidden; border: 1px solid #e9ecef; }
        .cabecera-fija { flex-shrink: 0; background: white; padding-bottom: 10px; border-bottom: 1px solid #e9ecef; margin-bottom: 10px; }
        .header-row { display: flex; justify-content: space-between; align-items: center; gap: 16px; flex-wrap: wrap; }
        .header-row .filtro-label { font-size: 14px; font-weight: 500; color: #495057; margin: 0; white-space: nowrap; }
        .header-row .filtro-group { display: flex; align-items: center; gap: 8px; flex: 1; max-width: 360px; }
        .filtro-permisos-wrap { position: relative; max-width: 360px; flex: 1; }
        .filtro-permisos-wrap input { width: 100%; padding: 8px 32px 8px 12px; border: 1px solid #dee2e6; border-radius: 6px; font-size: 14px; }
        .filtro-permisos-wrap input:focus { border-color: #0d6efd; outline: 0; box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.25); }
        .filtro-permisos-wrap .btn-clear-filtro { position: absolute; right: 8px; top: 50%; transform: translateY(-50%); width: 22px; height: 22px; padding: 0; border: none; background: #adb5bd; color: white; border-radius: 50%; cursor: pointer; font-size: 12px; display: none; align-items: center; justify-content: center; }
        .filtro-permisos-wrap .btn-clear-filtro:hover { background: #6c757d; }
        .filtro-permisos-wrap.has-text .btn-clear-filtro { display: flex; }
        .btn-guardar { background: linear-gradient(135deg, #28a745, #20c997); color: white; border: none; padding: 8px 18px; border-radius: 6px; font-weight: 600; font-size: 13px; display: inline-flex; align-items: center; gap: 6px; cursor: pointer; transition: all 0.2s; }
        .btn-guardar:hover { opacity: 0.95; transform: translateY(-1px); color: white; }
        .msg-empty { color: #6c757d; text-align: center; padding: 24px; }
        .tabla-scroll { flex: 1 1 0; min-height: 120px; overflow-y: auto; overflow-x: hidden; }
        /* Árbol de menús - poco espacio entre niveles, sin desfase entre bloques */
        .menu-tree { list-style: none; padding: 0; margin: 0; }
        .menu-tree .menu-tree { padding-left: 10px; margin-left: 2px; margin-top: 2px; margin-bottom: 0; border-left: 2px solid #dee2e6; }
        .menu-node { display: flex; align-items: flex-start; gap: 8px; padding: 4px 6px; border-radius: 4px; margin: 0; }
        .menu-node + .menu-node { margin-top: 2px; }
        .menu-node:hover { background: #f8f9fa; }
        .menu-node.node-padre { font-weight: 600; color: #1e3a8a; background: #e7f1ff; }
        .menu-node.node-hijo { padding-left: 4px; color: #495057; }
        #menuTreeRoot > li > .menu-tree { margin-bottom: 0; }
        #menuTreeRoot ul { margin: 0; }
        .menu-node .node-toggle { width: 22px; height: 22px; border: none; background: transparent; color: #495057; cursor: pointer; border-radius: 4px; display: inline-flex; align-items: center; justify-content: center; flex-shrink: 0; }
        .menu-node .node-toggle:hover { background: rgba(0,0,0,0.06); }
        .menu-node .node-toggle i { transition: transform 0.2s; }
        .menu-node.collapsed .node-toggle i { transform: rotate(-90deg); }
        .menu-node.collapsed > .menu-tree { display: none; }
        .menu-node .node-icon { width: 24px; text-align: center; color: #1e3a8a; font-size: 16px; flex-shrink: 0; }
        .menu-node.node-hijo .node-icon { color: #6c757d; }
        .menu-node .node-content { flex: 1; min-width: 0; }
        .menu-node .node-text { font-size: 14px; }
        .menu-node .node-check { flex-shrink: 0; margin-top: 2px; }
        .menu-node .form-check-input { width: 18px; height: 18px; border: 2px solid #0d6efd; cursor: pointer; }
        .menu-node .form-check-input:checked { background-color: #0d6efd; border-color: #0d6efd; }
        .menu-node .form-check-input:focus { box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.35); }
        .node-placeholder { width: 22px; flex-shrink: 0; }
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
                                <input type="text" id="inputFiltroPermisos" class="form-control" placeholder="Nombre o URL..." autocomplete="off" />
                                <button type="button" class="btn-clear-filtro" id="btnClearFiltro" title="Limpiar filtro">&#215;</button>
                            </div>
                        </div>
                        <button type="button" id="btnGuardar" class="btn-guardar" style="display: none;">
                            <i class="fas fa-save"></i> Guardar permisos
                        </button>
                    </div>
                </div>
                <div class="tabla-scroll" id="tablaScroll">
                    <ul class="menu-tree" id="menuTreeRoot"></ul>
                </div>
                <p class="msg-empty" id="msgEmptyPermisos" style="display: none;">No hay opciones de men&#250; configuradas. Ejecute los scripts de <code>tbMenuPrincipal</code> y <code>tbMenuUsuario</code> en la base de datos.</p>
            </div>
        </div>
    </form>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        $(function () {
            var menuItems = [];
            var userIdActual = null;

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

            function buildTree(items) {
                var byParent = {};
                items.forEach(function (m) {
                    var pid = parseInt(m.IdParent != null ? m.IdParent : m.idparent, 10);
                    if (isNaN(pid) || pid === 0) pid = 0;
                    if (!byParent[pid]) byParent[pid] = [];
                    byParent[pid].push(m);
                });
                if (byParent[0]) byParent[0].sort(function (a, b) { return (a.Orden || 0) - (b.Orden || 0); });
                Object.keys(byParent).forEach(function (pid) {
                    if (pid !== '0') byParent[pid].sort(function (a, b) { return (a.Orden || 0) - (b.Orden || 0); });
                });
                return byParent;
            }

            function renderNode(item, children, level, byParent) {
                var idMenu = item.IdMenu != null ? item.IdMenu : item.idmenu;
                var isPadre = children && children.length > 0;
                var permitido = item.Permitido === true || item.Permitido === 1;
                var iconClass = (item.Icon || 'fas fa-circle').trim();
                if (iconClass.indexOf('fa-') === 0) iconClass = 'fas ' + iconClass;

                var $li = $('<li class="menu-node' + (isPadre ? ' node-padre collapsed' : ' node-hijo') + '" data-id="' + idMenu + '"></li>');

                if (isPadre) {
                    $li.append('<button type="button" class="node-toggle" aria-label="Expandir/Contraer"><i class="fas fa-chevron-down"></i></button>');
                } else {
                    $li.append('<span class="node-placeholder"></span>');
                }

                $li.append('<span class="node-icon"><i class="' + iconClass + '"></i></span>');
                var url = (item.Url || '').trim();
                var $content = $('<span class="node-content" title="' + (url ? url.replace(/"/g, '&quot;') : '') + '" data-url="' + (url ? url.replace(/"/g, '&quot;') : '') + '"></span>');
                $content.append('<span class="node-text">' + (item.TextoMenu || '') + '</span>');
                $li.append($content);
                $li.append('<span class="node-check"><input type="checkbox" class="form-check-input permiso-cb" data-id="' + idMenu + '" ' + (permitido ? 'checked' : '') + ' /></span>');

                if (isPadre && children.length && byParent) {
                    var $ul = $('<ul class="menu-tree"></ul>');
                    children.forEach(function (c) {
                        var cid = parseInt(c.IdMenu != null ? c.IdMenu : c.idmenu, 10) || c.IdMenu || c.idmenu;
                        $ul.append(renderNode(c, byParent[cid] || [], level + 1, byParent));
                    });
                    $li.append($ul);
                }

                return $li;
            }

            function getIdToParentMap() {
                var map = {};
                menuItems.forEach(function (m) {
                    var pid = parseInt(m.IdParent, 10);
                    map[m.IdMenu] = (isNaN(pid) || pid === 0) ? 0 : pid;
                });
                return map;
            }

            function renderTree() {
                var byParent = buildTree(menuItems);
                var roots = byParent[0] || [];
                var $root = $('#menuTreeRoot');
                $root.empty();
                roots.forEach(function (r) {
                    var rid = parseInt(r.IdMenu != null ? r.IdMenu : r.idmenu, 10) || r.IdMenu || r.idmenu;
                    $root.append(renderNode(r, byParent[rid] || [], 0, byParent));
                });

                $('#menuTreeRoot').off('click', '.node-toggle').on('click', '.node-toggle', function (e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var $node = $(this).closest('.menu-node');
                    var $children = $node.children('.menu-tree');
                    if ($node.hasClass('collapsed')) {
                        $node.removeClass('collapsed');
                        $children.show();
                    } else {
                        $node.addClass('collapsed');
                        $children.hide();
                    }
                });

                $('#menuTreeRoot').off('change', '.permiso-cb').on('change', '.permiso-cb', function () {
                    var $cb = $(this);
                    if ($cb.prop('checked')) {
                        var idToParent = getIdToParentMap();
                        var parentId = idToParent[$cb.data('id')];
                        while (parentId && parentId !== 0) {
                            $('#menuTreeRoot').find('.permiso-cb[data-id="' + parentId + '"]').prop('checked', true);
                            parentId = idToParent[parentId];
                        }
                    }
                });

                aplicarFiltroPermisos();
            }

            function aplicarFiltroPermisos() {
                var q = ($('#inputFiltroPermisos').val() || '').trim().toLowerCase();
                var $wrap = $('#filtroPermisosWrap');
                if (q.length) $wrap.addClass('has-text'); else $wrap.removeClass('has-text');
                if (!q.length) {
                    $('#menuTreeRoot').find('.menu-node').show();
                    $('#menuTreeRoot .menu-tree').each(function () {
                        $(this).toggle(!$(this).parent().hasClass('collapsed'));
                    });
                    return;
                }
                $('#menuTreeRoot .menu-node').each(function () {
                    var $n = $(this);
                    var text = ($n.find('.node-text').text() || '').toLowerCase();
                    var url = ($n.find('.node-content').attr('data-url') || $n.find('.node-content').attr('title') || '').toLowerCase();
                    var match = text.indexOf(q) !== -1 || url.indexOf(q) !== -1;
                    $n.toggle(match);
                    if (match) $n.parents('.menu-node').show().removeClass('collapsed');
                    $n.find('.menu-tree').toggle(match);
                });
            }

            $('#inputFiltroPermisos').on('input keyup', function () { aplicarFiltroPermisos(); });
            $('#btnClearFiltro').on('click', function () {
                $('#inputFiltroPermisos').val('').focus();
                $('#filtroPermisosWrap').removeClass('has-text');
                aplicarFiltroPermisos();
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
                        menuItems = d || [];
                        if (menuItems.length === 0) {
                            $('#msgEmptyPermisos').show();
                            $('.cabecera-fija').hide();
                            $('#tablaScroll').hide();
                        } else {
                            $('#msgEmptyPermisos').hide();
                            $('.cabecera-fija').show();
                            $('#tablaScroll').show();
                            renderTree();
                            $('#btnGuardar').show();
                        }
                    },
                    error: function () { alert('Error al cargar opciones de men\u00fa.'); }
                });
            }

            $('#btnGuardar').on('click', function () {
                if (!userIdActual) { alert('Usuario no definido.'); return; }
                var ids = [];
                $('.permiso-cb:checked').each(function () { ids.push(parseInt($(this).data('id'), 10)); });
                $.ajax({
                    type: 'POST',
                    url: 'PermisosMenu.aspx/GuardarPermisos',
                    data: JSON.stringify({ idUsuario: parseInt(userIdActual, 10), idsMenuJson: JSON.stringify(ids) }),
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
