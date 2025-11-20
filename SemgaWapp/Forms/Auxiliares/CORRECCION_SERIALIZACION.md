# Corrección de Error de Serialización Circular

## 🚨 Problema Identificado
**Error:** `Se detectó una referencia circular al serializar un objeto de tipo 'System.Reflection.RuntimeModule'.`

## 🔍 Causa del Problema
El error ocurría porque se estaba intentando serializar directamente un `DataTable` con `JavaScriptSerializer`, lo cual puede generar referencias circulares cuando el DataTable contiene objetos complejos o referencias internas del framework.

## ✅ Solución Aplicada

### **Antes (Problemático):**
```vb.net
Dim dt As DataTable = objSql.GetDataTableSql(sSql)
Dim jsonData As String = New JavaScriptSerializer().Serialize(dt)
```

### **Después (Corregido):**
```vb.net
Dim dt As DataTable = objSql.GetDataTableSql(sSql)

' Crear lista de objetos simples para evitar referencias circulares
Dim asociados As New List(Of Object)

If dt.Rows.Count > 0 Then
    For i As Integer = 0 To dt.Rows.Count - 1
        Dim row As DataRow = dt.Rows(i)
        Dim asociado As New With {
            .NumeroAsociado = row("NumeroAsociado").ToString(),
            .NombreCompleto = row("NombreCompleto").ToString(),
            .NumeroIdentificacion = row("NumeroIdentificacion").ToString(),
            .TipoAsociado = row("TipoAsociado").ToString()
        }
        asociados.Add(asociado)
    Next
End If

Dim jsonData As String = New JavaScriptSerializer().Serialize(asociados)
```

## 🔧 WebMethods Corregidos

### **1. `BuscarAsociados(busqueda As String)`**
- ✅ Convertido DataTable a lista de objetos simples
- ✅ Campos: NumeroAsociado, NombreCompleto, NumeroIdentificacion, TipoAsociado
- ✅ Logs detallados agregados

### **2. `ObtenerAuxiliares()`**
- ✅ Convertido DataTable a lista de objetos simples
- ✅ Campos: ID, NumeroAsociado, NombreAsociado, CodigoRubro, DescripcionRubro, TipoAuxiliar, DescripcionTipoAuxiliar, Cuota, Saldo, MontoOriginal, TasaInteres, PagoMes, FechaOtorgado, FechaUltimoPago
- ✅ Manejo de valores NULL con `DBNull.Value`

### **3. `FiltrarAuxiliares(busqueda As String, tipoAuxiliar As String, codigoRubro As String)`**
- ✅ Convertido DataTable a lista de objetos simples
- ✅ Mismos campos que `ObtenerAuxiliares()`
- ✅ Manejo de valores NULL con `DBNull.Value`

## 🎯 Beneficios de la Corrección

### **1. Eliminación de Referencias Circulares**
- Los objetos anónimos (`New With {...}`) son simples y serializables
- No contienen referencias internas del framework
- Evitan problemas de serialización complejos

### **2. Mejor Control de Datos**
- Conversión explícita a `String` con `.ToString()`
- Manejo explícito de valores NULL con `DBNull.Value`
- Estructura de datos predecible y consistente

### **3. Logs Mejorados**
- Información detallada sobre la serialización
- Mejor debugging y monitoreo
- Identificación rápida de problemas

### **4. Rendimiento Optimizado**
- Serialización más rápida de objetos simples
- Menor uso de memoria
- Respuestas más eficientes

## 📋 Estructura de Datos Resultante

### **Para Asociados:**
```json
[
  {
    "NumeroAsociado": "123",
    "NombreCompleto": "Juan Pérez",
    "NumeroIdentificacion": "12345678",
    "TipoAsociado": "Cliente"
  }
]
```

### **Para Auxiliares:**
```json
[
  {
    "ID": "1",
    "NumeroAsociado": "123",
    "NombreAsociado": "Juan Pérez",
    "CodigoRubro": "AHO",
    "DescripcionRubro": "Ahorros",
    "TipoAuxiliar": "AHO001",
    "DescripcionTipoAuxiliar": "Ahorro Regular",
    "Cuota": "100.00",
    "Saldo": "5000.00",
    "MontoOriginal": "5000.00",
    "TasaInteres": "5.00",
    "PagoMes": "100.00",
    "FechaOtorgado": "2024-01-15",
    "FechaUltimoPago": "2024-01-15"
  }
]
```

## 🚀 Próximos Pasos

1. **Probar la búsqueda de asociados** - Debería funcionar sin errores de serialización
2. **Verificar la carga de auxiliares** - La tabla principal debería cargar correctamente
3. **Probar los filtros** - Los filtros de auxiliares deberían funcionar sin problemas
4. **Revisar los logs** - Los logs detallados ayudarán a identificar cualquier problema restante

## ⚠️ Consideraciones Adicionales

### **WebMethods que NO requieren corrección:**
- `ObtenerRubros()` - Retorna DataTable simple
- `ObtenerTiposAuxiliares()` - Retorna DataTable simple
- `ObtenerTiposAuxiliaresPorRubro()` - Retorna DataTable simple
- `ObtenerAuxiliar()` - Retorna objeto simple
- `GuardarAuxiliar()` - No serializa DataTable
- `EliminarAuxiliar()` - No serializa DataTable

### **Patrón a seguir en futuros WebMethods:**
```vb.net
' ❌ Evitar:
Dim jsonData As String = New JavaScriptSerializer().Serialize(dt)

' ✅ Usar:
Dim lista As New List(Of Object)
For Each row As DataRow In dt.Rows
    Dim objeto As New With {
        .Campo1 = row("Campo1").ToString(),
        .Campo2 = If(row("Campo2") Is DBNull.Value, "", row("Campo2").ToString())
    }
    lista.Add(objeto)
Next
Dim jsonData As String = New JavaScriptSerializer().Serialize(lista)
```

---
*Corrección aplicada el 24 de enero de 2025*
































