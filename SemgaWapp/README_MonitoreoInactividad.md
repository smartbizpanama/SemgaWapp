# Sistema de Monitoreo de Inactividad del Usuario

## Descripción
Sistema que detecta cuando un usuario está inactivo y muestra una alerta antes de cerrar automáticamente la sesión por seguridad.

## Características
- ✅ **Monitoreo automático** de actividad del usuario
- ✅ **Alerta visual** con countdown antes del cierre de sesión
- ✅ **Configuración flexible** mediante parámetros del sistema
- ✅ **Opciones de usuario** para continuar o cerrar sesión
- ✅ **Integración completa** con el sistema de autenticación

## Parámetros de Configuración

### MONITOREAR_INACTIVIDAD
- **Valor**: `1` (habilitado) o `0` (deshabilitado)
- **Descripción**: Habilita o deshabilita el monitoreo de inactividad
- **Grupo**: SEGURIDAD

### TIEMPO_MONITOREAR_INACTIVIDAD
- **Valor**: Número entero (minutos)
- **Descripción**: Tiempo en minutos antes de mostrar la alerta
- **Valor por defecto**: `5` minutos
- **Grupo**: SEGURIDAD

## Funcionamiento

### 1. Detección de Inactividad
El sistema monitorea los siguientes eventos del usuario:
- `mousedown` - Clic del mouse
- `mousemove` - Movimiento del mouse
- `keypress` - Presión de teclas
- `scroll` - Desplazamiento de página
- `touchstart` - Toque en dispositivos táctiles
- `click` - Cualquier clic

### 2. Secuencia de Alerta
1. **Usuario inactivo** por el tiempo configurado
2. **Alerta visual** con modal de advertencia
3. **Countdown** de 1 minuto para respuesta
4. **Opciones**:
   - **Continuar**: Resetea el timer y mantiene la sesión
   - **Cerrar Sesión**: Cierra la sesión inmediatamente
5. **Cierre automático** si no hay respuesta

### 3. Modal de Advertencia
- **Diseño**: Modal centrado con fondo estático
- **Contenido**: 
  - Icono de reloj
  - Mensaje explicativo
  - Countdown visual
  - Botones de acción
- **Estilo**: Bootstrap 5 con colores de advertencia

## Archivos del Sistema

### Backend (VB.NET)
- **`Dashboard.aspx.vb`**: WebMethods para parámetros y cierre de sesión
- **`VariablesSession.vb`**: Constantes para parámetros de sesión

### Frontend (JavaScript)
- **`Scripts/inactivity-monitor.js`**: Lógica principal del monitoreo
- **`Dashboard.aspx`**: Integración del script
- **`Forms/Socios/GestionSocios.aspx`**: Integración del script

### Base de Datos
- **`Database_Data_ParametrosInactividad.sql`**: Script de inserción de parámetros

## Instalación

### 1. Ejecutar Script SQL
```sql
-- Ejecutar el script de parámetros
EXEC Database_Data_ParametrosInactividad.sql
```

### 2. Verificar Parámetros
```sql
SELECT * FROM tbParamsKeys 
WHERE ParamKey IN ('MONITOREAR_INACTIVIDAD', 'TIEMPO_MONITOREAR_INACTIVIDAD')
```

### 3. Configurar Valores
```sql
-- Habilitar monitoreo con 5 minutos de timeout
UPDATE tbParamsKeys SET ParamValue = '1' WHERE ParamKey = 'MONITOREAR_INACTIVIDAD'
UPDATE tbParamsKeys SET ParamValue = '5' WHERE ParamKey = 'TIEMPO_MONITOREAR_INACTIVIDAD'
```

## Uso

### Habilitar Monitoreo
1. Establecer `MONITOREAR_INACTIVIDAD = '1'`
2. Configurar `TIEMPO_MONITOREAR_INACTIVIDAD` (ej: `'5'` para 5 minutos)
3. Reiniciar la aplicación

### Deshabilitar Monitoreo
1. Establecer `MONITOREAR_INACTIVIDAD = '0'`
2. Reiniciar la aplicación

### Cambiar Tiempo de Timeout
1. Actualizar `TIEMPO_MONITOREAR_INACTIVIDAD` con el valor deseado
2. Reiniciar la aplicación

## Personalización

### Cambiar Tiempo de Advertencia
En `Scripts/inactivity-monitor.js`, línea 60:
```javascript
this.warningTime = 1; // minuto de advertencia por defecto
```

### Modificar Eventos Monitoreados
En `Scripts/inactivity-monitor.js`, líneas 25-32:
```javascript
this.resetEvents = [
    'mousedown', 'mousemove', 'keypress', 'scroll', 'touchstart', 'click'
];
```

### Personalizar Modal de Advertencia
En `Scripts/inactivity-monitor.js`, función `createWarningModal()` (líneas 150-200)

## Logs y Debugging

### Consola del Navegador
El sistema genera logs detallados en la consola:
- `🔍 Iniciando sistema de monitoreo de inactividad...`
- `📊 Parámetros de inactividad: {habilitado: true, tiempo: "5 minutos"}`
- `⏰ Iniciando monitoreo de inactividad (5 minutos)`
- `🔄 Timer de inactividad reseteado (5 minutos)`
- `⚠️ Mostrando advertencia de inactividad`
- `✅ Usuario eligió continuar la sesión`
- `🚪 Cerrando sesión por inactividad`

### Verificar Estado
```javascript
// En la consola del navegador
console.log(window.inactivityMonitor);
```

## Seguridad

### Características de Seguridad
- ✅ **Cierre automático** de sesión por inactividad
- ✅ **Limpieza completa** de variables de sesión
- ✅ **Redirección forzada** al login
- ✅ **Prevención de bypass** del modal
- ✅ **Logging de eventos** de seguridad

### Consideraciones
- El sistema **no puede ser deshabilitado** desde el frontend
- Los parámetros se cargan **desde el servidor** en cada sesión
- El modal tiene **backdrop estático** para prevenir cierre accidental
- La sesión se cierra **inmediatamente** al agotarse el tiempo

## Troubleshooting

### El monitoreo no se inicia
1. Verificar que `MONITOREAR_INACTIVIDAD = '1'`
2. Revisar la consola del navegador para errores
3. Verificar que los scripts se cargan correctamente

### El modal no aparece
1. Verificar que Bootstrap 5 esté cargado
2. Revisar errores de JavaScript en la consola
3. Verificar que el tiempo configurado no sea muy corto

### La sesión no se cierra
1. Verificar que el WebMethod `CerrarSesionPorInactividad` funcione
2. Revisar logs del servidor
3. Verificar configuración de autenticación

## Compatibilidad

### Navegadores Soportados
- ✅ Chrome 80+
- ✅ Firefox 75+
- ✅ Safari 13+
- ✅ Edge 80+

### Dependencias
- ✅ jQuery 3.6.0+
- ✅ Bootstrap 5.1.3+
- ✅ Font Awesome 6.0+

## Mantenimiento

### Actualizaciones
- Revisar logs de consola regularmente
- Monitorear parámetros de configuración
- Verificar funcionamiento en diferentes navegadores

### Backup
- Respaldar configuración de `tbParamsKeys`
- Documentar cambios en parámetros
- Mantener versiones del script JavaScript





