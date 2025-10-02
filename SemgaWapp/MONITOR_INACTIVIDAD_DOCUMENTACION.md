# Monitor de Inactividad - Documentación Técnica

## Descripción General
Sistema de monitoreo de inactividad que detecta cuando el usuario ha estado inactivo por un tiempo determinado y muestra una advertencia antes de cerrar la sesión automáticamente.

## Configuración
- **Archivo:** `Scripts/inactivity-monitor-final.js`
- **Versión actual:** 2.6
- **Parámetros:** Configurados en base de datos (tabla de parámetros)
- **Optimización:** Los parámetros se cargan una sola vez al hacer login, no en cada reinicio del timer

## Eventos que Reinician el Timer
El contador de inactividad se reinicia cuando se detecta cualquiera de los siguientes eventos:

### Eventos de Mouse
- **`mousedown`** - Presionar cualquier botón del mouse
- **`mousemove`** - Mover el mouse por la pantalla
- **`click`** - Hacer clic en cualquier elemento

### Eventos de Teclado
- **`keypress`** - Presionar cualquier tecla del teclado

### Eventos de Scroll
- **`scroll`** - Hacer scroll en la página (rueda del mouse, barras de desplazamiento, etc.)

### Eventos Táctiles
- **`touchstart`** - Tocar la pantalla en dispositivos táctiles

## Condiciones para Reiniciar
El timer solo se reinicia si se cumplen todas las siguientes condiciones:

### 1. **No hay advertencia activa** (`!isWarningActive`)
**¿Qué significa?**
- El sistema tiene una variable booleana `isWarningActive` que indica si actualmente se está mostrando el modal de advertencia al usuario
- Cuando `isWarningActive = true`, significa que el usuario ya está en la fase de advertencia (modal visible con countdown)
- **¿Por qué es importante?** Una vez que aparece la advertencia, el usuario debe tomar una decisión (Seguir Conectado o Cerrar Sesión). No tiene sentido seguir reiniciando el timer con actividad normal, ya que el usuario ya está en "tiempo extra"

**Ejemplo práctico:**
- Usuario inactivo por 1 minuto → Aparece advertencia → `isWarningActive = true`
- Aunque el usuario mueva el mouse, el timer NO se reinicia porque ya está en fase de advertencia
- Solo se reinicia si hace clic en "Seguir Conectado"

### 2. **No hay petición en progreso** (`!isRequestInProgress`)
**¿Qué significa?**
- El sistema hace peticiones al servidor para obtener los parámetros de configuración (tiempo de inactividad, etc.)
- La variable `isRequestInProgress` indica si actualmente hay una petición HTTP en curso
- **¿Por qué es importante?** Evita hacer múltiples peticiones simultáneas al servidor, lo que podría causar problemas de rendimiento o respuestas inconsistentes

**Ejemplo práctico:**
- Usuario mueve el mouse → Sistema inicia petición al servidor → `isRequestInProgress = true`
- Usuario mueve el mouse otra vez → Sistema NO inicia nueva petición (evita spam)
- Cuando la petición termina → `isRequestInProgress = false` → Sistema puede hacer nuevas peticiones

### 3. **Debounce de 2 segundos**
**¿Qué significa?**
- El "debounce" es una técnica que evita que una función se ejecute demasiadas veces en un período corto
- En este caso, el sistema solo reinicia el timer si han pasado al menos 2 segundos desde el último evento de actividad
- **¿Por qué es importante?** Sin debounce, cada movimiento de mouse, cada tecla presionada, cada scroll reiniciaría el timer, haciendo que nunca se active la advertencia

**Ejemplo práctico:**
- Usuario mueve el mouse → Timer se reinicia
- Usuario mueve el mouse 0.5 segundos después → Timer NO se reinicia (muy pronto)
- Usuario mueve el mouse 3 segundos después → Timer SÍ se reinicia (han pasado más de 2 segundos)

**Código de implementación:**
```javascript
let lastActivityTime = Date.now();
const debounceDelay = 2000; // 2 segundos

if (now - lastActivityTime > debounceDelay) {
    // Solo reiniciar si han pasado más de 2 segundos
    lastActivityTime = now;
    getInactivityParams();
}
```

## Comportamiento del Sistema

### Flujo Normal
1. **Inicio:** El sistema inicia el monitoreo al cargar la página
2. **Inactividad:** Si no hay actividad por el tiempo configurado menos 1 minuto, aparece la advertencia
3. **Advertencia:** Se muestra un modal con countdown de 1 minuto
4. **Decisión del usuario:**
   - **"Seguir Conectado":** Reinicia completamente el timer
   - **"Cerrar Sesión":** Cierra la sesión inmediatamente
   - **Sin acción:** Cierra la sesión automáticamente al terminar el countdown

### Botón "Seguir Conectado"
Cuando el usuario hace clic en "Seguir Conectado":
- Se detiene el countdown del modal
- Se cierra el overlay de advertencia
- Se limpian todos los timers existentes
- Se reinicia el monitoreo desde cero
- Se vuelven a configurar los eventos de detección

## Archivos que Incluyen el Monitor
- `Dashboard.aspx` (v=2.6)
- `Forms/Transacciones/Transacciones.aspx` (v=2.6)
- `Forms/Auxiliares/AuxiliaresAsociados.aspx` (v=2.6)
- `Forms/Socios/GestionSocios.aspx` (v=2.6)

## Optimización de Rendimiento (v2.6)
**Cambio importante:** Los parámetros de inactividad ahora se cargan una sola vez al hacer login, en lugar de hacer peticiones HTTP en cada reinicio del timer.

### Mejoras en v2.6:
- **Eliminación completa de peticiones HTTP** durante la sesión
- **Parámetros almacenados en memoria** para acceso instantáneo
- **Control de carga única** con flag `paramsLoaded`
- **Reinicio del timer** usando parámetros ya cargados

### Ventajas de la Optimización:
- **Rendimiento mejorado:** Elimina peticiones HTTP innecesarias
- **Menor carga del servidor:** Reduce las consultas a la base de datos
- **Mejor experiencia de usuario:** Sin latencia en el reinicio del timer
- **Consistencia:** Los parámetros se mantienen constantes durante toda la sesión

### Comportamiento:
- **Al hacer login:** Se cargan todos los parámetros del sistema en la sesión
- **Durante la navegación:** El monitor lee los parámetros desde la sesión (sin peticiones HTTP)
- **Cambios de configuración:** Se aplican en el siguiente login (comportamiento esperado)

### WebMethods:
- **`ObtenerParametrosInactividadSesion`:** Nueva versión optimizada que lee desde la sesión
- **`ObtenerParametrosInactividad`:** Versión anterior mantenida para compatibilidad

## Logs de Debugging
El sistema incluye logs detallados para debugging:
- `🔄 Reiniciando sesión - Botón "Seguir Conectado" presionado`
- `⏰ Iniciando monitoreo de inactividad: X minutos`
- `⏰ Advertencia se mostrará en: X segundos`
- `⚠️ Mostrando advertencia de inactividad`
- `🔄 Actividad detectada - Reiniciando timer de inactividad`
- `🛑 Countdown del modal detenido`
- `⏰ Tiempo agotado - Cerrando sesión automáticamente`

## Notas Técnicas
- El sistema usa `setTimeout` para el timer principal
- El countdown del modal usa `setInterval`
- Se implementa debounce para evitar reinicios excesivos
- Los eventos se configuran con `addEventListener` y `true` para captura
- El sistema maneja múltiples timers simultáneos de forma segura
