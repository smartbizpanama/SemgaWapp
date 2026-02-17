# Lista completa de mosaicos y opciones de menú - SemgaWapp

Listado para control de acceso por usuario en base de datos. Cada fila es una opción que puede restringirse por rol o usuario.

---

## 1. DASHBOARD PRINCIPAL (Dashboard.aspx)

| # | Clave (para BD) | Nombre visible | URL destino | Notas |
|---|-----------------|----------------|-------------|-------|
| 1 | DASH_SOCIOS | Gestión de Socios | Forms/Socios/GestionSocios.aspx | |
| 2 | DASH_MOVIMIENTOS | Movimientos de Cuentas | Forms/Transacciones/Transacciones.aspx | |
| 3 | DASH_AUXILIARES | Gestión de Auxiliares | Forms/Auxiliares/AuxiliaresAsociados.aspx | |
| 4 | DASH_REPORTES | Reportes y Estadísticas | Forms/Reportes/dashboardReportes.aspx | |
| 5 | DASH_FINANZAS | Finanzas | Forms/Finanzas/Finanzas.aspx | Solo Gerente/Admin (nivel ≤1) |
| 6 | DASH_LOGS | Logs y Auditorías | Forms/Logs/DetalleLogs.aspx | Solo nivel ≤1 |
| 7 | DASH_SISTEMAS | Configuraciones del Sistema | Forms/Mantenimientos/dashboardSistemas.aspx | Solo Administrador (nivel 0) |
| 8 | DASH_AYUDA | Ayuda | Forms/Help/helpDashboard.aspx | |

---

## 2. DASHBOARD REPORTES (Forms/Reportes/dashboardReportes.aspx)

| # | Clave (para BD) | Nombre visible | URL destino |
|---|-----------------|----------------|-------------|
| 9 | REP_REPORTES | Reportes del Sistema | Forms/Reportes/Reportes.aspx |
| 10 | REP_HISTORIAL | Tablas Históricas | Forms/Logs/historialTablas.aspx?origen=reportes |
| 11 | REP_MOVIMIENTOS | Movimientos | Forms/Reportes/Movimientos.aspx |

---

## 3. DASHBOARD AYUDA (Forms/Help/helpDashboard.aspx)

| # | Clave (para BD) | Nombre visible | URL destino |
|---|-----------------|----------------|-------------|
| 12 | AYUDA_DOC | Documentación de Aplicación | Forms/Help/Documentacion.aspx |
| 13 | AYUDA_PROCESOS | Manual de Procesos Técnicos | Forms/Help/procesosTecnicos.aspx |

---

## 4. DASHBOARD SISTEMAS (Forms/Mantenimientos/dashboardSistemas.aspx)

| # | Clave (para BD) | Nombre visible | URL destino |
|---|-----------------|----------------|-------------|
| 14 | SIST_USUARIOS | Gestión de Usuarios | Forms/Mantenimientos/GestionUsuarios.aspx |
| 15 | SIST_MANTENIMIENTOS | Tablas de Tipo | Forms/Mantenimientos/Mantenimientos.aspx |
| 16 | SIST_PARAMS | Parámetros del Sistema | Forms/Mantenimientos/appParams.aspx |
| 17 | SIST_RESPALDOS | Respaldo de Datos | Forms/Sistemas/Respaldos.aspx |
| 18 | SIST_HISTORIAL | Tablas Históricas | Forms/Logs/historialTablas.aspx?origen=sistemas |

---

## 5. OPCIONES DENTRO DE MANTENIMIENTOS (sidebar – misma página Mantenimientos.aspx)

Son pestañas/tabs dentro de **Mantenimientos.aspx**. Útiles si quieres controlar acceso a cada tipo de tabla.

| # | Clave (para BD) | Nombre visible | Tab/Sección |
|---|-----------------|----------------|-------------|
| 19 | MANT_CUENTAS | Cuentas | cuentas |
| 20 | MANT_ROLES | Roles de Usuario | roles |
| 21 | MANT_DEPARTAMENTOS | Departamentos | departamentos |
| 22 | MANT_TIPO_IDENTIFICACION | Tipo Identificación | tipo-identificacion |
| 23 | MANT_TIPO_ASOCIADOS | Tipo Asociados | tipo-asociados |
| 24 | MANT_PARENTEZCOS | Parentezcos | parentezcos |
| 25 | MANT_ESTATUS_ASOCIADOS | Estatus Asociados | estatus-asociados |
| 26 | MANT_CODIGOS_TRANSACCION | Códigos Transacción | codigos-transacciones |
| 27 | MANT_RUBROS | Rubros | rubros |
| 28 | MANT_TIPOS_AUXILIARES | Tipos Auxiliares | tipos-auxiliares |
| 29 | MANT_NIVELES_ESTUDIO | Niveles de Estudio | niveles-estudio |
| 30 | MANT_PROFESIONES | Profesiones | profesiones |
| 31 | MANT_OCUPACIONES | Ocupaciones | ocupaciones |
| 32 | MANT_EMPRESAS | Empresas | empresas |
| 33 | MANT_PAISES | Países | paises |
| 34 | MANT_PROVINCIAS | Provincias | provincias |
| 35 | MANT_DISTRITOS | Distritos | distritos |
| 36 | MANT_CORREGIMIENTOS | Corregimientos | corregimientos |

---

## Resumen por tipo

- **Mosaicos del Dashboard principal:** 8
- **Mosaicos en Dashboard Reportes:** 3
- **Mosaicos en Dashboard Ayuda:** 2
- **Mosaicos en Dashboard Sistemas:** 5
- **Opciones sidebar Mantenimientos:** 18  

**Total opciones listadas:** 36

---

## Páginas sin mosaico directo (acceso por flujo)

- `Forms/Transacciones/comprobanteText.aspx` (comprobante desde Transacciones)
- `Login.aspx`
- `Dashboard.aspx` (raíz)
- `Forms/Mantenimientos/TestMantenimientos.aspx` (pruebas)

Si quieres controlar también el acceso al Dashboard raíz o al Login, puedes añadir claves como `DASH_ROOT` y `LOGIN`.
