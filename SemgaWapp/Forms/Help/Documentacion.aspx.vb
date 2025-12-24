Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Web.Script.Serialization
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Reflection
Imports System.Text
Imports System.Text.RegularExpressions
Imports SBSqlClient
Imports SBUtility

Public Class Documentacion
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Verificar sesión
        If Session(VariablesSesion.UsuarioId) Is Nothing Then
            Response.Redirect("~/Login.aspx")
            Return
        End If
    End Sub

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ObtenerListaFormularios() As String
        Dim resultado As String = ""
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("Obteniendo lista de formularios del sistema")

            ' Lista de formularios del sistema
            Dim formularios As New List(Of Object) From {
                New With {.Nombre = "Auxiliares", .Ruta = "Forms/Auxiliares/AuxiliaresAsociados.aspx"},
                New With {.Nombre = "Socios", .Ruta = "Forms/Socios/GestionSocios.aspx"},
                New With {.Nombre = "Transacciones", .Ruta = "Forms/Transacciones/Transacciones.aspx"},
                New With {.Nombre = "Finanzas", .Ruta = "Forms/Finanzas/Finanzas.aspx"},
                New With {.Nombre = "Mantenimientos", .Ruta = "Forms/Mantenimientos/Mantenimientos.aspx"},
                New With {.Nombre = "Gestión de Usuarios", .Ruta = "Forms/Mantenimientos/GestionUsuarios.aspx"},
                New With {.Nombre = "Parámetros", .Ruta = "Forms/Mantenimientos/appParams.aspx"},
                New With {.Nombre = "Reportes", .Ruta = "Forms/Reportes/Reportes.aspx"},
                New With {.Nombre = "Dashboard Reportes", .Ruta = "Forms/Reportes/dashboardReportes.aspx"},
                New With {.Nombre = "Logs", .Ruta = "Forms/Logs/Logs.aspx"},
                New With {.Nombre = "Logs Auditoría", .Ruta = "Forms/Logs/LogsAuditoria.aspx"},
                New With {.Nombre = "Logs Aplicación", .Ruta = "Forms/Logs/LogsAplicacion.aspx"},
                New With {.Nombre = "Logs Accesos", .Ruta = "Forms/Logs/LogsAccesos.aspx"},
                New With {.Nombre = "Detalle Logs", .Ruta = "Forms/Logs/DetalleLogs.aspx"},
                New With {.Nombre = "Historial Tablas", .Ruta = "Forms/Logs/historialTablas.aspx"},
                New With {.Nombre = "Respaldos", .Ruta = "Forms/Sistemas/Respaldos.aspx"},
                New With {.Nombre = "Dashboard Sistemas", .Ruta = "Forms/Mantenimientos/dashboardSistemas.aspx"}
            }

            Dim response As New With {
                .Resultado = "SUCCESS",
                .Data = serializer.Serialize(formularios),
                .Mensaje = ""
            }

            resultado = serializer.Serialize(response)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerListaFormularios: " & ex.Message)
            Dim errorResponse As New With {
                .Resultado = "ERROR",
                .Data = "",
                .Mensaje = "Error al obtener formularios: " & ex.Message
            }
            resultado = serializer.Serialize(errorResponse)
        End Try

        Return resultado
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ObtenerMetodosFormulario(rutaFormulario As String) As String
        Dim resultado As String = ""
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("Obteniendo métodos del formulario: " & rutaFormulario)

            Dim metodos As New List(Of Object)

            ' Obtener el archivo VB.NET correspondiente
            Dim rutaVB As String = rutaFormulario.Replace(".aspx", ".aspx.vb")
            Dim rutaCompleta As String = HttpContext.Current.Server.MapPath("~/" & rutaVB)

            If File.Exists(rutaCompleta) Then
                ' Leer el archivo y analizar métodos
                Try
                    Dim codigo As String = File.ReadAllText(rutaCompleta, Encoding.UTF8)
                    metodos = AnalizarMetodosWebMethod(codigo, rutaVB)
                    
                    ' Leer también el archivo ASPX para analizar el uso en frontend
                    Dim rutaASPX As String = rutaFormulario.Replace(".aspx.vb", ".aspx")
                    Dim rutaASPXCompleta As String = HttpContext.Current.Server.MapPath("~/" & rutaASPX)
                    If File.Exists(rutaASPXCompleta) Then
                        Try
                            Dim codigoFrontend As String = File.ReadAllText(rutaASPXCompleta, Encoding.UTF8)
                            metodos = MejorarDescripcionesConFrontend(metodos, codigoFrontend, codigo)
                        Catch ex As Exception
                            ModGlobal.EscribirLog("Error al leer archivo ASPX: " & ex.Message)
                        End Try
                    End If
                    
                    ' Si no se encontraron métodos, usar los predefinidos
                    If metodos Is Nothing OrElse metodos.Count = 0 Then
                        ModGlobal.EscribirLog("No se encontraron métodos en el análisis, usando métodos predefinidos para: " & rutaFormulario)
                        metodos = ObtenerMetodosPredefinidos(rutaFormulario)
                    End If
                Catch ex As Exception
                    ModGlobal.EscribirLog("Error al analizar código VB.NET: " & ex.Message & " | Usando métodos predefinidos para: " & rutaFormulario)
                    metodos = ObtenerMetodosPredefinidos(rutaFormulario)
                End Try
            Else
                ModGlobal.EscribirLog("Archivo VB.NET no encontrado en: " & rutaCompleta & " | Usando métodos predefinidos")
                ' Si no se encuentra el archivo, usar métodos predefinidos por formulario
                metodos = ObtenerMetodosPredefinidos(rutaFormulario)
            End If

            Dim response As New With {
                .Resultado = "SUCCESS",
                .Data = serializer.Serialize(metodos),
                .Mensaje = ""
            }

            resultado = serializer.Serialize(response)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerMetodosFormulario: " & ex.Message & " | StackTrace: " & ex.StackTrace)
            Dim errorResponse As New With {
                .Resultado = "ERROR",
                .Data = "",
                .Mensaje = "Error al obtener métodos: " & ex.Message
            }
            resultado = serializer.Serialize(errorResponse)
        End Try

        Return resultado
    End Function

    Private Shared Function AnalizarMetodosWebMethod(codigo As String, nombreArchivo As String) As List(Of Object)
        Dim metodos As New List(Of Object)

        ' Patrón mejorado para encontrar métodos WebMethod
        ' Puede tener WebMethod con o sin parámetros, ScriptMethod opcional, Public Shared Function o Public Function
        Dim patrones As String() = {
            "<WebMethod\([^)]*\)>\s*(?:<ScriptMethod\([^)]*\)>\s*)?Public\s+Shared\s+Function\s+(\w+)\s*\([^)]*\)",
            "<WebMethod\([^)]*\)>\s*(?:<ScriptMethod\([^)]*\)>\s*)?Public\s+Function\s+(\w+)\s*\([^)]*\)",
            "<WebMethod\(\)>\s*(?:<ScriptMethod\([^)]*\)>\s*)?Public\s+Shared\s+Function\s+(\w+)\s*\([^)]*\)",
            "<WebMethod\(\)>\s*(?:<ScriptMethod\([^)]*\)>\s*)?Public\s+Function\s+(\w+)\s*\([^)]*\)"
        }

        Dim matches As New List(Of Match)
        
        For Each patron As String In patrones
            Dim matchesPatron As MatchCollection = Regex.Matches(codigo, patron, RegexOptions.Multiline Or RegexOptions.IgnoreCase Or RegexOptions.Singleline)
            For Each match As Match In matchesPatron
                matches.Add(match)
            Next
        Next

        ' Usar un HashSet para evitar duplicados
        Dim metodosEncontrados As New HashSet(Of String)

        For Each match As Match In matches
            Dim nombreMetodo As String = match.Groups(1).Value
            
            ' Evitar duplicados
            If metodosEncontrados.Contains(nombreMetodo) Then
                Continue For
            End If
            metodosEncontrados.Add(nombreMetodo)

            ' Buscar el cuerpo del método para encontrar ejecuciones SQL
            Dim inicioMetodo As Integer = codigo.IndexOf(match.Value)
            Dim finMetodo As Integer = codigo.IndexOf("End Function", inicioMetodo)

            If finMetodo = -1 Then finMetodo = codigo.Length

            Dim cuerpoMetodo As String = ""
            If inicioMetodo >= 0 AndAlso finMetodo > inicioMetodo Then
                Try
                    cuerpoMetodo = codigo.Substring(inicioMetodo, finMetodo - inicioMetodo)
                Catch ex As Exception
                    ModGlobal.EscribirLog("Error al extraer cuerpo del método " & nombreMetodo & ": " & ex.Message)
                    cuerpoMetodo = ""
                End Try
            End If

            ' Buscar ejecuciones de SP o SELECT
            Dim objetoSQL As String = ObtenerObjetoSQLDelMetodo(cuerpoMetodo)
            Dim tipo As String = "SP"
            Dim descripcion As String = GenerarDescripcionMetodo(nombreMetodo, objetoSQL, cuerpoMetodo)

            ' Determinar tipo basado en el objeto SQL encontrado
            If Not String.IsNullOrEmpty(objetoSQL) AndAlso objetoSQL <> "No identificado" Then
                Dim objetoUpper As String = objetoSQL.ToUpper().Trim()
                ' Verificar si es un UPDATE directo
                If objetoUpper.StartsWith("UPDATE") Then
                    tipo = "UPDATE"
                ' Verificar si es un SELECT directo
                ElseIf objetoUpper.StartsWith("SELECT") OrElse 
                   objetoUpper.StartsWith("SELECT TOP") OrElse 
                   objetoUpper.StartsWith("SELECT DISTINCT") OrElse
                   objetoUpper.StartsWith("WITH") Then
                    tipo = "SELECT"
                ElseIf objetoUpper.Contains("VIEW") AndAlso Not objetoUpper.StartsWith("EXEC") Then
                    tipo = "VIEW"
                Else
                    ' Por defecto es un SP
                    tipo = "SP"
                End If
            Else
                ' Si no se encontró SQL, verificar si es un método que no accede a BD
                If EsMetodoSinBaseDatos(cuerpoMetodo) Then
                    tipo = "METHOD"
                    objetoSQL = "" ' No tiene objeto SQL
                    descripcion = GenerarDescripcionMetodoSinSQL(nombreMetodo, cuerpoMetodo)
                Else
                    ' Si no se puede determinar, marcarlo como genérico
                    tipo = "GENERICO"
                    objetoSQL = "No identificado"
                End If
            End If

            metodos.Add(New With {
                .Nombre = nombreMetodo,
                .Descripcion = descripcion,
                .ObjetoSQL = objetoSQL,
                .Tipo = tipo
            })
        Next

        Return metodos
    End Function

    Private Shared Function MejorarDescripcionesConFrontend(metodos As List(Of Object), codigoFrontend As String, codigoBackend As String) As List(Of Object)
        ' Crear nueva lista con métodos mejorados
        Dim metodosMejorados As New List(Of Object)
        
        ' Serializar y deserializar para poder acceder a propiedades
        Dim serializer As New JavaScriptSerializer()
        Dim metodosJson As String = serializer.Serialize(metodos)
        Dim metodosDiccionario As List(Of Dictionary(Of String, Object)) = serializer.Deserialize(Of List(Of Dictionary(Of String, Object)))(metodosJson)
        
        For Each metodoDict As Dictionary(Of String, Object) In metodosDiccionario
            Dim nombreMetodo As String = If(metodoDict.ContainsKey("Nombre"), metodoDict("Nombre").ToString(), "")
            Dim descripcionOriginal As String = If(metodoDict.ContainsKey("Descripcion"), metodoDict("Descripcion").ToString(), "")
            Dim objetoSQL As String = If(metodoDict.ContainsKey("ObjetoSQL"), metodoDict("ObjetoSQL").ToString(), "")
            Dim tipo As String = If(metodoDict.ContainsKey("Tipo"), metodoDict("Tipo").ToString(), "SP")
            
            If String.IsNullOrEmpty(nombreMetodo) Then
                metodosMejorados.Add(New With {
                    .Nombre = nombreMetodo,
                    .Descripcion = descripcionOriginal,
                    .ObjetoSQL = objetoSQL,
                    .Tipo = tipo
                })
                Continue For
            End If
            
            ' Buscar llamadas AJAX al método en el frontend
            ' Buscar tanto en la URL del AJAX como en funciones que llamen al método
            Dim patronesBusqueda As String() = {
                nombreMetodo & "[\s\S]{0,3000}?",  ' Método y contexto posterior
                "url[^""']*?" & Regex.Escape(nombreMetodo) & "[\s\S]{0,3000}?",  ' En URL de AJAX
                "function[^{]*" & nombreMetodo & "[\s\S]{0,3000}?"  ' Función que contiene el método
            }
            
            Dim contexto As String = ""
            For Each patron As String In patronesBusqueda
                Dim matchAjax As Match = Regex.Match(codigoFrontend, patron, RegexOptions.IgnoreCase Or RegexOptions.Multiline)
                If matchAjax.Success Then
                    ' Extraer contexto alrededor de la llamada
                    Dim inicioContexto As Integer = Math.Max(0, matchAjax.Index - 300)
                    Dim finContexto As Integer = Math.Min(codigoFrontend.Length, matchAjax.Index + matchAjax.Length + 3000)
                    If finContexto > inicioContexto Then
                        contexto = codigoFrontend.Substring(inicioContexto, finContexto - inicioContexto)
                        If contexto.Length > 100 Then
                            Exit For
                        End If
                    End If
                End If
            Next
            
            ' Si encontramos contexto, analizar uso
            If Not String.IsNullOrEmpty(contexto) AndAlso contexto.Length > 100 Then
                ' Analizar qué elementos del DOM se llenan
                Dim usoEnUI As String = AnalizarUsoEnFrontend(nombreMetodo, contexto)
                
                If Not String.IsNullOrEmpty(usoEnUI) Then
                    descripcionOriginal = descripcionOriginal & " " & usoEnUI
                End If
            End If
            
            ' Agregar método mejorado
            metodosMejorados.Add(New With {
                .Nombre = nombreMetodo,
                .Descripcion = descripcionOriginal,
                .ObjetoSQL = objetoSQL,
                .Tipo = tipo
            })
        Next
        
        Return metodosMejorados
    End Function

    Private Shared Function AnalizarUsoEnFrontend(nombreMetodo As String, contexto As String) As String
        Dim uso As String = ""
        Dim contextoUpper As String = contexto.ToUpper()
        
        ' Buscar referencias a elementos del DOM (selects, inputs, etc.)
        Dim elementosUsados As New List(Of String)
        
        ' Buscar selects que se llenan - patrones mejorados
        Dim patronSelect As String = "\$\([""']#([a-zA-Z_][a-zA-Z0-9_]*?)[""']\)|getElementById\([""']([a-zA-Z_][a-zA-Z0-9_]*?)[""']\)|querySelector\([""']#([a-zA-Z_][a-zA-Z0-9_]*?)[""']\)|selectFiltro\s*=\s*\$\([""']#([a-zA-Z_][a-zA-Z0-9_]*?)[""']\)|selectModal\s*=\s*\$\([""']#([a-zA-Z_][a-zA-Z0-9_]*?)[""']\)"
        Dim matchesSelect As MatchCollection = Regex.Matches(contexto, patronSelect, RegexOptions.IgnoreCase)
        For Each match As Match In matchesSelect
            For i As Integer = 1 To match.Groups.Count - 1
                If match.Groups(i).Success AndAlso Not String.IsNullOrEmpty(match.Groups(i).Value) Then
                    Dim elementoId As String = match.Groups(i).Value
                    ' Filtrar IDs válidos (no variables comunes de jQuery)
                    If Not elementosUsados.Contains(elementoId) AndAlso 
                       elementoId.Length > 2 AndAlso 
                       Not elementoId.ToUpper().Equals("THIS") AndAlso
                       Not elementoId.ToUpper().Equals("EVENT") Then
                        elementosUsados.Add(elementoId)
                    End If
                End If
            Next
        Next
        
        ' Buscar patrones comunes de uso
        If contextoUpper.Contains("APPEND") OrElse contextoUpper.Contains(".HTML(") OrElse contextoUpper.Contains(".TEXT(") Then
            ' Se usa para llenar elementos
            If contextoUpper.Contains("SELECT") OrElse contextoUpper.Contains("OPTION") Then
                ' Se usa para llenar dropdowns
                If elementosUsados.Count > 0 Then
                    Dim ids As String = String.Join(", #", elementosUsados.Take(8))
                    uso = "Se utiliza en el frontend para llenar los dropdowns (select) con IDs: #" & ids & ". Los datos retornados se usan para poblar las opciones de estos controles."
                Else
                    uso = "Se utiliza en el frontend para llenar dropdowns o listas desplegables con datos dinámicos."
                End If
            ElseIf contextoUpper.Contains("TABLE") OrElse contextoUpper.Contains("TBODY") OrElse contextoUpper.Contains("DATATABLE") Then
                uso = "Se utiliza en el frontend para poblar tablas de datos."
            ElseIf contextoUpper.Contains("INPUT") OrElse contextoUpper.Contains("VAL(") Then
                uso = "Se utiliza en el frontend para establecer valores en campos de formulario."
            End If
        ElseIf contextoUpper.Contains("FILTR") OrElse contextoUpper.Contains("SEARCH") OrElse contextoUpper.Contains("BUSCAR") Then
            uso = "Se utiliza en el frontend para aplicar filtros o búsquedas en la interfaz."
        ElseIf contextoUpper.Contains("VALID") Then
            uso = "Se utiliza en el frontend para validaciones o verificaciones de datos."
        End If
        
        ' Analizar nombres específicos de métodos conocidos
        Dim nombreUpper As String = nombreMetodo.ToUpper()
        If nombreUpper.Contains("TIPO") AndAlso nombreUpper.Contains("ASOCIADO") Then
            uso = "Se utiliza para llenar el dropdown de tipo de asociado en el formulario de edición de socios (#tipoAsociado) y también en el filtro de búsqueda (#filtroTipo). Retorna IdTipoAsociado y TipoAsociado para poblar las opciones del select."
        ElseIf nombreUpper.Contains("STATUS") AndAlso nombreUpper.Contains("ASOCIADO") Then
            uso = "Se utiliza para llenar el dropdown de estatus del asociado en el formulario de edición (#estatus) y en el filtro de búsqueda (#filtroEstatus). Retorna CodStatusAsociado y StatusAsociado."
        ElseIf nombreUpper.Contains("TIPO") AndAlso nombreUpper.Contains("DOCUMENTO") Then
            uso = "Se utiliza para llenar los dropdowns de tipo de documento de identificación en el formulario principal (#tipoIdentificacion), en el filtro (#filtroTipoDocumento) y en los formularios de beneficiarios (#beneficiarioTipoIdentificacion, #editarBeneficiarioTipoIdentificacion). Retorna CodTipoDoc y TipoDocumento."
        ElseIf nombreUpper.Contains("PARAMETRO") AndAlso nombreUpper.Contains("SISTEMA") Then
            uso = "Obtiene parámetros del sistema desde la sesión o configuración. No accede a base de datos. Se utiliza para obtener valores de configuración requeridos por la aplicación en tiempo de ejecución."
        ElseIf nombreUpper.Contains("NIVEL") AndAlso nombreUpper.Contains("ESTUDIO") Then
            uso = "Se utiliza para llenar el dropdown de nivel de estudio en el formulario de datos personales del socio."
        ElseIf nombreUpper.Contains("PROFESION") Then
            uso = "Se utiliza para llenar el dropdown de profesión en el formulario de datos personales del socio."
        ElseIf nombreUpper.Contains("PARENTEZCO") Then
            uso = "Se utiliza para llenar el dropdown de parentesco en el formulario de beneficiarios del socio."
        ElseIf nombreUpper.Contains("PAIS") Then
            uso = "Se utiliza para llenar los dropdowns de país en el formulario de datos de contacto del socio (país de origen y país de residencia)."
        ElseIf nombreUpper.Contains("PROVINCIA") Then
            uso = "Se utiliza para llenar los dropdowns de provincia en el formulario de datos de contacto del socio."
        ElseIf nombreUpper.Contains("DISTRITO") Then
            uso = "Se utiliza para llenar los dropdowns de distrito en el formulario de datos de contacto del socio."
        ElseIf nombreUpper.Contains("CORREGIMIENTO") Then
            uso = "Se utiliza para llenar los dropdowns de corregimiento en el formulario de datos de contacto del socio."
        ElseIf nombreUpper.Contains("EMPRESA") Then
            uso = "Se utiliza para llenar el dropdown de empresa en el formulario de datos laborales del socio."
        ElseIf nombreUpper.Contains("OCUPACION") Then
            uso = "Se utiliza para llenar el dropdown de ocupación en el formulario de datos laborales del socio."
        End If
        
        Return uso
    End Function

    Private Shared Function GenerarDescripcionMetodo(nombreMetodo As String, objetoSQL As String, cuerpoMetodo As String) As String
        Dim descripcion As String = ""
        Dim nombreUpper As String = nombreMetodo.ToUpper()

        ' Generar descripción basada en el nombre del método
        If nombreUpper.Contains("OBTENER") OrElse nombreUpper.Contains("GET") Then
            If nombreUpper.Contains("LISTA") OrElse nombreUpper.Contains("LISTAR") OrElse nombreUpper.Contains("LIST") Then
                descripcion = "Obtiene y retorna una lista de registros desde la base de datos"
            ElseIf nombreUpper.Contains("RUBRO") Then
                descripcion = "Obtiene todos los rubros disponibles en el sistema"
            ElseIf nombreUpper.Contains("TIPO") AndAlso nombreUpper.Contains("AUXILIAR") Then
                descripcion = "Obtiene los tipos de auxiliares disponibles en el sistema"
            ElseIf nombreUpper.Contains("AUXILIAR") Then
                descripcion = "Obtiene información completa de los auxiliares asociados"
            ElseIf nombreUpper.Contains("SOCIO") Then
                descripcion = "Obtiene información detallada de socios del sistema"
            ElseIf nombreUpper.Contains("REPORTE") Then
                descripcion = "Obtiene la lista de reportes disponibles para el usuario"
            ElseIf nombreUpper.Contains("PARAMETRO") OrElse nombreUpper.Contains("PARAM") Then
                descripcion = "Obtiene parámetros de configuración del sistema"
            ElseIf nombreUpper.Contains("USUARIO") Then
                descripcion = "Obtiene información de usuarios del sistema"
            Else
                descripcion = "Obtiene información específica desde la base de datos"
            End If

        ElseIf nombreUpper.Contains("BUSCAR") OrElse nombreUpper.Contains("SEARCH") OrElse nombreUpper.Contains("FILTRAR") Then
            If nombreUpper.Contains("SOCIO") Then
                descripcion = "Busca socios utilizando diferentes criterios de búsqueda (nombre, ID, identificación, etc.)"
            ElseIf nombreUpper.Contains("AUXILIAR") Then
                descripcion = "Busca auxiliares aplicando filtros y criterios de búsqueda"
            ElseIf nombreUpper.Contains("ASOCIADO") Then
                descripcion = "Busca asociados por número de asociado, nombre o identificación"
            Else
                descripcion = "Realiza una búsqueda de registros aplicando criterios y filtros"
            End If

        ElseIf nombreUpper.Contains("GUARDAR") OrElse nombreUpper.Contains("SAVE") OrElse nombreUpper.Contains("CREAR") OrElse nombreUpper.Contains("CREATE") OrElse nombreUpper.Contains("INSERTAR") Then
            If nombreUpper.Contains("AUXILIAR") Then
                descripcion = "Guarda o actualiza un auxiliar asociado en la base de datos"
            ElseIf nombreUpper.Contains("SOCIO") Then
                descripcion = "Guarda o actualiza información de un socio en el sistema"
            ElseIf nombreUpper.Contains("USUARIO") Then
                descripcion = "Crea o actualiza un usuario del sistema con sus permisos y roles"
            ElseIf nombreUpper.Contains("TRANSACCION") Then
                descripcion = "Registra una nueva transacción en el sistema"
            Else
                descripcion = "Guarda o crea un nuevo registro en la base de datos"
            End If

        ElseIf nombreUpper.Contains("ELIMINAR") OrElse nombreUpper.Contains("DELETE") OrElse nombreUpper.Contains("BORRAR") Then
            descripcion = "Elimina un registro del sistema (marca como eliminado lógicamente)"

        ElseIf nombreUpper.Contains("MARCAR") AndAlso (nombreUpper.Contains("IMPRESO") OrElse nombreUpper.Contains("COMPROBANTE")) Then
            descripcion = "Marca un comprobante como impreso actualizando el campo snImpreso en la tabla tbMovimientos. Este método ejecuta un UPDATE directo en la base de datos."
        ElseIf nombreUpper.Contains("ACTUALIZAR") OrElse nombreUpper.Contains("UPDATE") OrElse nombreUpper.Contains("MODIFICAR") Then
            descripcion = "Actualiza información de un registro existente en la base de datos"

        ElseIf nombreUpper.Contains("EJECUTAR") OrElse nombreUpper.Contains("EXECUTE") OrElse nombreUpper.Contains("RUN") Then
            If nombreUpper.Contains("REPORTE") OrElse nombreUpper.Contains("COMANDO") Then
                descripcion = "Ejecuta un comando SQL o reporte y retorna los resultados"
            Else
                descripcion = "Ejecuta una operación específica en el sistema"
            End If

        ElseIf nombreUpper.Contains("VALIDAR") OrElse nombreUpper.Contains("VALIDATE") Then
            descripcion = "Valida datos o condiciones antes de realizar una operación"

        ElseIf nombreUpper.Contains("OBTENERDEFINICION") OrElse nombreUpper.Contains("GETDEFINITION") Then
            descripcion = "Obtiene la definición SQL completa de un objeto de base de datos (stored procedure o vista)"

        ElseIf nombreUpper.Contains("LISTAR") OrElse nombreUpper.Contains("LIST") Then
            descripcion = "Lista todos los registros de una tabla o entidad"

        ElseIf nombreUpper.Contains("CALCULAR") OrElse nombreUpper.Contains("CALCULATE") Then
            descripcion = "Realiza cálculos o procesamiento de datos"

        ElseIf nombreUpper.Contains("IMPRIMIR") OrElse nombreUpper.Contains("PRINT") Then
            descripcion = "Genera o imprime un documento o reporte"

        ElseIf nombreUpper.Contains("EXPORTAR") OrElse nombreUpper.Contains("EXPORT") Then
            descripcion = "Exporta datos a un formato externo (Excel, PDF, etc.)"

        ElseIf nombreUpper.Contains("IMPORTAR") OrElse nombreUpper.Contains("IMPORT") Then
            descripcion = "Importa datos desde un archivo externo"

        Else
            ' Si no se encuentra un patrón, generar descripción genérica basada en el objeto SQL
            If Not String.IsNullOrEmpty(objetoSQL) AndAlso objetoSQL <> "No identificado" Then
                If objetoSQL.ToUpper().Contains("OBTENER") OrElse objetoSQL.ToUpper().Contains("GET") Then
                    descripcion = "Obtiene datos desde la base de datos mediante el objeto: " & objetoSQL
                ElseIf objetoSQL.ToUpper().Contains("BUSCAR") OrElse objetoSQL.ToUpper().Contains("SEARCH") Then
                    descripcion = "Busca información en la base de datos usando: " & objetoSQL
                ElseIf objetoSQL.ToUpper().Contains("GUARDAR") OrElse objetoSQL.ToUpper().Contains("SAVE") OrElse objetoSQL.ToUpper().Contains("INSERT") Then
                    descripcion = "Guarda o inserta datos en la base de datos usando: " & objetoSQL
                Else
                    descripcion = "Ejecuta una operación en la base de datos usando: " & objetoSQL
                End If
            Else
                descripcion = "Ejecuta la operación: " & nombreMetodo & " en el sistema"
            End If
        End If

        Return descripcion
    End Function

    Private Shared Function ObtenerObjetoSQLDelMetodo(cuerpoMetodo As String) As String
        ' Buscar patrones comunes de ejecución SQL en orden de prioridad
        
        ' 1. Buscar UPDATE directo en sSql = "UPDATE ..."
        ' Patrón mejorado que captura UPDATEs multilínea
        Dim patronUpdate As String = "sSql\s*=\s*[""'](UPDATE[\s\S]{0,2000}?)[""']"
        Dim matchUpdate As Match = Regex.Match(cuerpoMetodo, patronUpdate, RegexOptions.IgnoreCase Or RegexOptions.Multiline Or RegexOptions.Singleline)
        If matchUpdate.Success Then
            Dim updateSql As String = matchUpdate.Groups(1).Value.Trim()
            ' Limpiar posibles saltos de línea y espacios extra
            updateSql = Regex.Replace(updateSql, "\s+", " ")
            Return updateSql
        End If

        ' 2. Buscar UPDATE con Dim sSql As String = "UPDATE ..."
        Dim patronUpdateDim As String = "Dim\s+sSql\s+As\s+String\s*=\s*[""'](UPDATE[\s\S]{0,2000}?)[""']"
        Dim matchUpdateDim As Match = Regex.Match(cuerpoMetodo, patronUpdateDim, RegexOptions.IgnoreCase Or RegexOptions.Multiline Or RegexOptions.Singleline)
        If matchUpdateDim.Success Then
            Dim updateSql As String = matchUpdateDim.Groups(1).Value.Trim()
            updateSql = Regex.Replace(updateSql, "\s+", " ")
            Return updateSql
        End If
        
        ' 3. Buscar SELECT directo en sSql = "SELECT ..."
        ' Patrón mejorado que captura SELECTs multilínea
        Dim patronSelect As String = "sSql\s*=\s*[""'](SELECT[\s\S]{0,2000}?)[""']"
        Dim matchSelect As Match = Regex.Match(cuerpoMetodo, patronSelect, RegexOptions.IgnoreCase Or RegexOptions.Multiline Or RegexOptions.Singleline)
        If matchSelect.Success Then
            Dim selectSql As String = matchSelect.Groups(1).Value.Trim()
            ' Limpiar posibles saltos de línea y espacios extra
            selectSql = Regex.Replace(selectSql, "\s+", " ")
            Return selectSql
        End If

        ' 4. Buscar SELECT con Dim sSql As String = "SELECT ..."
        Dim patronSelectDim As String = "Dim\s+sSql\s+As\s+String\s*=\s*[""'](SELECT[\s\S]{0,2000}?)[""']"
        Dim matchSelectDim As Match = Regex.Match(cuerpoMetodo, patronSelectDim, RegexOptions.IgnoreCase Or RegexOptions.Multiline Or RegexOptions.Singleline)
        If matchSelectDim.Success Then
            Dim selectSql As String = matchSelectDim.Groups(1).Value.Trim()
            selectSql = Regex.Replace(selectSql, "\s+", " ")
            Return selectSql
        End If

        ' 3. Buscar Exec con nombre de SP
        Dim patronExec As String = "(?:Exec|EXEC)\s+([\w\._]+)"
        Dim matchExec As Match = Regex.Match(cuerpoMetodo, patronExec, RegexOptions.IgnoreCase Or RegexOptions.Multiline)
        If matchExec.Success Then
            Return matchExec.Groups(1).Value.Trim()
        End If

        ' 4. Buscar sSql = "Exec spNombre"
        Dim patronExecString As String = "sSql\s*=\s*[""']Exec\s+([\w\._]+)[""']"
        Dim matchExecString As Match = Regex.Match(cuerpoMetodo, patronExecString, RegexOptions.IgnoreCase Or RegexOptions.Multiline)
        If matchExecString.Success Then
            Return matchExecString.Groups(1).Value.Trim()
        End If

        ' 5. Buscar ExecuteNonQuerySql("...") para UPDATEs
        Dim patronExecuteNonQuery As String = "ExecuteNonQuerySql\s*\([""']([^""']+)[""']\)"
        Dim matchExecuteNonQuery As Match = Regex.Match(cuerpoMetodo, patronExecuteNonQuery, RegexOptions.IgnoreCase Or RegexOptions.Multiline)
        If matchExecuteNonQuery.Success Then
            Dim contenido As String = matchExecuteNonQuery.Groups(1).Value.Trim()
            ' Si es un UPDATE, devolverlo completo
            If contenido.ToUpper().StartsWith("UPDATE") Then
                Return contenido
            End If
        End If

        ' 6. Buscar GetDataTableSql("...")
        Dim patronGetData As String = "GetDataTableSql\s*\([""']([^""']+)[""']\)"
        Dim matchGetData As Match = Regex.Match(cuerpoMetodo, patronGetData, RegexOptions.IgnoreCase Or RegexOptions.Multiline)
        If matchGetData.Success Then
            Dim contenido As String = matchGetData.Groups(1).Value.Trim()
            ' Si es un UPDATE, devolverlo completo
            If contenido.ToUpper().StartsWith("UPDATE") Then
                Return contenido
            End If
            ' Si es un SELECT, devolverlo completo
            If contenido.ToUpper().StartsWith("SELECT") Then
                Return contenido
            End If
            ' Si contiene Exec, extraer el nombre del SP
            If contenido.ToUpper().StartsWith("EXEC") Or contenido.ToUpper().StartsWith("Exec") Then
                Dim matchExecEnContenido As Match = Regex.Match(contenido, "(?:Exec|EXEC)\s+([\w\._]+)", RegexOptions.IgnoreCase)
                If matchExecEnContenido.Success Then
                    Return matchExecEnContenido.Groups(1).Value.Trim()
                End If
            End If
            Return contenido
        End If

        ' 7. Buscar cualquier variable sSql = "algo"
        Dim patronVariable As String = "sSql\s*=\s*[""']([^""']+)[""']"
        Dim matchVariable As Match = Regex.Match(cuerpoMetodo, patronVariable, RegexOptions.IgnoreCase Or RegexOptions.Multiline)
        If matchVariable.Success Then
            Dim contenido As String = matchVariable.Groups(1).Value.Trim()
            ' Si es un UPDATE, devolverlo completo
            If contenido.ToUpper().StartsWith("UPDATE") Then
                Return contenido
            End If
            ' Si es un SELECT, devolverlo completo
            If contenido.ToUpper().StartsWith("SELECT") Then
                Return contenido
            End If
            Return contenido
        End If

        Return "No identificado"
    End Function

    Private Shared Function EsMetodoSinBaseDatos(cuerpoMetodo As String) As Boolean
        ' Verificar si el método NO contiene llamadas a base de datos
        ' Indicadores de que NO accede a BD:
        ' - No tiene GetDataTableSql
        ' - No tiene ExecuteNonQuerySql
        ' - No tiene Exec o EXEC
        ' - No tiene SELECT directo
        ' - Puede tener GetAppKey, ConfigurationManager, Session, etc.

        Dim cuerpoUpper As String = cuerpoMetodo.ToUpper()

        ' Si contiene llamadas a BD, NO es método sin BD
        If cuerpoUpper.Contains("GETDATATABLESQL") OrElse
           cuerpoUpper.Contains("EXECUTENONQUERYSQL") OrElse
           cuerpoUpper.Contains("EXECUTESCALARSQL") OrElse
           cuerpoUpper.Contains(" EXEC ") OrElse
           cuerpoUpper.Contains(" EXEC(") OrElse
           cuerpoUpper.Contains("EXEC ") OrElse
           (cuerpoUpper.Contains("SELECT ") AndAlso (cuerpoUpper.Contains("FROM ") OrElse cuerpoUpper.Contains(" FROM "))) Then
            Return False
        End If

        ' Indicadores de método sin BD:
        ' - Accede a configuración
        ' - Accede a sesión
        ' - Hace validaciones
        ' - Retorna valores calculados
        If cuerpoUpper.Contains("GETAPPKEY") OrElse
           cuerpoUpper.Contains("CONFIGURATIONMANAGER") OrElse
           cuerpoUpper.Contains("SESSION(") OrElse
           cuerpoUpper.Contains("HTTPCONTEXT.CURRENT.SESSION") OrElse
           cuerpoUpper.Contains("RETURN ") OrElse
           cuerpoUpper.Contains("NEW WITH {") Then
            Return True
        End If

        Return False
    End Function

    Private Shared Function GenerarDescripcionMetodoSinSQL(nombreMetodo As String, cuerpoMetodo As String) As String
        Dim descripcion As String = ""
        Dim nombreUpper As String = nombreMetodo.ToUpper()
        Dim cuerpoUpper As String = cuerpoMetodo.ToUpper()

        ' Detectar qué tipo de método es sin acceso a BD
        If nombreUpper.Contains("PARAMETRO") OrElse nombreUpper.Contains("PARAM") Then
            If cuerpoUpper.Contains("GETAPPKEY") OrElse cuerpoUpper.Contains("CONFIGURATIONMANAGER") Then
                descripcion = "Obtiene un parámetro de configuración del sistema desde el archivo de configuración (Web.config o App.config). No accede a la base de datos."
            Else
                descripcion = "Obtiene parámetros del sistema. No accede a la base de datos."
            End If
        ElseIf nombreUpper.Contains("SESSION") Then
            descripcion = "Gestiona o obtiene información de la sesión del usuario. No accede a la base de datos."
        ElseIf nombreUpper.Contains("VALIDAR") OrElse nombreUpper.Contains("VALIDATE") Then
            descripcion = "Valida datos o condiciones en el código. No accede a la base de datos."
        ElseIf nombreUpper.Contains("CALCULAR") OrElse nombreUpper.Contains("CALCULATE") Then
            descripcion = "Realiza cálculos o procesamiento de datos en memoria. No accede a la base de datos."
        ElseIf nombreUpper.Contains("OBTENER") OrElse nombreUpper.Contains("GET") Then
            descripcion = "Obtiene información desde configuración, sesión u otras fuentes. No accede a la base de datos."
        Else
            descripcion = "Método que no accede a la base de datos. Ejecuta operaciones en memoria o accede a configuración del sistema."
        End If

        Return descripcion
    End Function

    Private Shared Function ObtenerMetodosPredefinidos(rutaFormulario As String) As List(Of Object)
        Dim metodos As New List(Of Object)

        ' Métodos predefinidos por formulario
        Select Case rutaFormulario
            Case "Forms/Auxiliares/AuxiliaresAsociados.aspx"
                metodos.AddRange({
                    New With {.Nombre = "ObtenerRubros", .Descripcion = "Obtiene todos los rubros disponibles en el sistema. Los rubros representan categorías de productos financieros (ahorros, préstamos, etc.)", .ObjetoSQL = "spAuxiliares_ObtenerRubros", .Tipo = "SP"},
                    New With {.Nombre = "ObtenerTiposAuxiliares", .Descripcion = "Obtiene todos los tipos de auxiliares disponibles. Cada tipo representa una variante de producto dentro de un rubro (ej: Ahorro Corriente, Ahorro a Plazo, etc.)", .ObjetoSQL = "spAuxiliares_ObtenerTiposAuxiliares", .Tipo = "SP"},
                    New With {.Nombre = "ObtenerTiposAuxiliaresPorRubro", .Descripcion = "Obtiene los tipos de auxiliares filtrados por un rubro específico. Útil para mostrar solo los tipos relevantes según la categoría seleccionada", .ObjetoSQL = "spAuxiliares_ObtenerTiposAuxiliaresPorRubro", .Tipo = "SP"},
                    New With {.Nombre = "ObtenerAuxiliares", .Descripcion = "Obtiene todos los auxiliares asociados con información completa incluyendo datos del asociado, rubro, tipo y estado del producto", .ObjetoSQL = "spAuxiliares_ObtenerAuxiliares", .Tipo = "SP"},
                    New With {.Nombre = "GuardarAuxiliar", .Descripcion = "Guarda o actualiza un auxiliar asociado en la base de datos. Valida datos y relaciones antes de realizar la operación", .ObjetoSQL = "spAuxiliares_Guardar", .Tipo = "SP"},
                    New With {.Nombre = "BuscarAsociadoPorID", .Descripcion = "Busca un asociado específico por su número de identificación. Retorna información completa del asociado para asociarlo a un auxiliar", .ObjetoSQL = "spAuxiliares_BuscarAsociadoPorID", .Tipo = "SP"},
                    New With {.Nombre = "BuscarAsociados", .Descripcion = "Busca asociados utilizando diferentes criterios de búsqueda como nombre, número de asociado o número de identificación. Soporta búsqueda parcial", .ObjetoSQL = "spAuxiliares_BuscarAsociados", .Tipo = "SP"}
                })
            Case "Forms/Socios/GestionSocios.aspx"
                metodos.AddRange({
                    New With {.Nombre = "ObtenerTiposAsociado", .Descripcion = "Obtiene todos los tipos de asociado disponibles desde la tabla tbTipoAsociado. Se utiliza para llenar el dropdown de tipo de asociado en el formulario de edición de socios (#tipoAsociado) y también en el filtro de búsqueda (#filtroTipo). Retorna IdTipoAsociado y TipoAsociado para poblar las opciones del select.", .ObjetoSQL = "SELECT IdTipoAsociado, TipoAsociado FROM tbTipoAsociado ORDER BY TipoAsociado", .Tipo = "SELECT"},
                    New With {.Nombre = "ObtenerStatusAsociado", .Descripcion = "Obtiene todos los estatus de asociado disponibles desde la tabla tbStatusAsociado. Se utiliza para llenar el dropdown de estatus del asociado en el formulario de edición (#estatus) y en el filtro de búsqueda (#filtroEstatus). Retorna CodStatusAsociado y StatusAsociado para poblar las opciones del select.", .ObjetoSQL = "SELECT CodStatusAsociado, StatusAsociado FROM tbStatusAsociado ORDER BY StatusAsociado", .Tipo = "SELECT"},
                    New With {.Nombre = "ObtenerTiposDocumento", .Descripcion = "Obtiene todos los tipos de documento de identificación disponibles. Se utiliza para llenar los dropdowns de tipo de documento en el formulario principal (#tipoIdentificacion), en el filtro (#filtroTipoDocumento) y en los formularios de beneficiarios (#beneficiarioTipoIdentificacion, #editarBeneficiarioTipoIdentificacion). Retorna CodTipoDoc y TipoDocumento.", .ObjetoSQL = "SELECT CodTipoDoc, TipoDocumento FROM tbTipoDocumentos ORDER BY TipoDocumento", .Tipo = "SELECT"},
                    New With {.Nombre = "ObtenerParametroSistema", .Descripcion = "Obtiene un parámetro de configuración del sistema desde la sesión HTTP. No accede a la base de datos. Se utiliza para obtener valores de configuración requeridos por la aplicación en tiempo de ejecución, como configuraciones de mayúsculas automáticas u otros parámetros del sistema almacenados en sesión.", .ObjetoSQL = "", .Tipo = "METHOD"},
                    New With {.Nombre = "ObtenerNivelesEstudio", .Descripcion = "Obtiene los niveles de estudio disponibles desde tbNivelesEstudio. Se utiliza para llenar el dropdown de nivel de estudio en el formulario de datos personales del socio (tab Datos Personales del modal de edición).", .ObjetoSQL = "SELECT Code, Descripcion FROM tbNivelesEstudio WHERE snEliminado = 0 ORDER BY Code", .Tipo = "SELECT"},
                    New With {.Nombre = "ObtenerProfesiones", .Descripcion = "Obtiene las profesiones disponibles desde tbProfesiones. Se utiliza para llenar el dropdown de profesión en el formulario de datos personales del socio.", .ObjetoSQL = "SELECT Code, Descripcion FROM tbProfesiones WHERE snEliminado = 0 ORDER BY Code", .Tipo = "SELECT"},
                    New With {.Nombre = "ObtenerParentezcos", .Descripcion = "Obtiene los tipos de parentesco disponibles. Se utiliza para llenar el dropdown de parentesco en el formulario de beneficiarios del socio.", .ObjetoSQL = "", .Tipo = "SELECT"},
                    New With {.Nombre = "ObtenerEmpresas", .Descripcion = "Obtiene las empresas disponibles desde tbEmpresas. Se utiliza para llenar el dropdown de empresa en el formulario de datos laborales del socio.", .ObjetoSQL = "SELECT Code, Descripcion FROM tbEmpresas WHERE snEliminado = 0 ORDER BY Code", .Tipo = "SELECT"},
                    New With {.Nombre = "ObtenerOcupaciones", .Descripcion = "Obtiene las ocupaciones disponibles. Se utiliza para llenar el dropdown de ocupación en el formulario de datos laborales del socio.", .ObjetoSQL = "", .Tipo = "SELECT"},
                    New With {.Nombre = "ObtenerPaises", .Descripcion = "Obtiene los países disponibles desde tbPaises. Se utiliza para llenar los dropdowns de país en el formulario de datos de contacto del socio (país de origen y país de residencia).", .ObjetoSQL = "SELECT Code, Descripcion FROM tbPaises WHERE snEliminado = 0 ORDER BY Descripcion", .Tipo = "SELECT"},
                    New With {.Nombre = "ObtenerProvincias", .Descripcion = "Obtiene las provincias disponibles desde tbProvincias. Se utiliza para llenar los dropdowns de provincia en el formulario de datos de contacto del socio.", .ObjetoSQL = "SELECT Code, CodePais, Descripcion FROM tbProvincias WHERE snEliminado = 0 ORDER BY Code", .Tipo = "SELECT"},
                    New With {.Nombre = "ObtenerDistritos", .Descripcion = "Obtiene los distritos disponibles desde tbDistritos. Se utiliza para llenar los dropdowns de distrito en el formulario de datos de contacto del socio.", .ObjetoSQL = "SELECT Code, CodeProvincia, Descripcion FROM tbDistritos WHERE snEliminado = 0 ORDER BY Code", .Tipo = "SELECT"},
                    New With {.Nombre = "ObtenerCorregimientos", .Descripcion = "Obtiene los corregimientos disponibles. Se utiliza para llenar los dropdowns de corregimiento en el formulario de datos de contacto del socio.", .ObjetoSQL = "", .Tipo = "SELECT"},
                    New With {.Nombre = "BuscarSocios", .Descripcion = "Busca socios del sistema utilizando diferentes criterios como nombre completo, número de identificación, número de socio o texto libre. Retorna resultados paginados que se muestran en la tabla principal del formulario utilizando DataTables.", .ObjetoSQL = "spSocios_Buscar", .Tipo = "SP"},
                    New With {.Nombre = "ObtenerSocioPorNumero", .Descripcion = "Obtiene información detallada y completa de un socio específico por su número de asociado. Se utiliza al abrir el modal de edición para cargar todos los datos del socio en los diferentes tabs (Datos Personales, Contacto, Referencias, Beneficiarios, Productos). Incluye datos personales, contactos, referencias, beneficiarios y productos asociados.", .ObjetoSQL = "spSocios_Obtener", .Tipo = "SP"},
                    New With {.Nombre = "CrearSocio", .Descripcion = "Crea un nuevo socio en el sistema con toda su información completa. Valida duplicados de identificación y datos requeridos antes de guardar. Se ejecuta desde el botón 'Guardar' del modal de edición cuando se crea un socio nuevo.", .ObjetoSQL = "spSocios_Guardar", .Tipo = "SP"},
                    New With {.Nombre = "ActualizarSocio", .Descripcion = "Actualiza la información de un socio existente en el sistema. Valida duplicados de identificación y datos requeridos antes de actualizar. Se ejecuta desde el botón 'Guardar' del modal de edición cuando se modifica un socio existente.", .ObjetoSQL = "spSocios_Actualizar", .Tipo = "SP"},
                    New With {.Nombre = "ObtenerBeneficiarios", .Descripcion = "Obtiene la lista de beneficiarios de un socio específico. Se utiliza para mostrar los beneficiarios en la tabla del tab 'Beneficiarios' del modal de edición.", .ObjetoSQL = "", .Tipo = "SP"},
                    New With {.Nombre = "CrearBeneficiario", .Descripcion = "Crea un nuevo beneficiario para un socio. Se ejecuta desde el formulario de beneficiarios dentro del modal de edición del socio.", .ObjetoSQL = "", .Tipo = "SP"},
                    New With {.Nombre = "ActualizarBeneficiario", .Descripcion = "Actualiza la información de un beneficiario existente. Se ejecuta desde el formulario de edición de beneficiarios.", .ObjetoSQL = "", .Tipo = "SP"},
                    New With {.Nombre = "EliminarBeneficiario", .Descripcion = "Elimina un beneficiario del sistema. Se ejecuta desde la tabla de beneficiarios en el tab correspondiente.", .ObjetoSQL = "", .Tipo = "SP"}
                })
            Case "Forms/Reportes/Reportes.aspx"
                metodos.AddRange({
                    New With {.Nombre = "ObtenerReportes", .Descripcion = "Obtiene la lista de reportes disponibles para el usuario actual, incluyendo permisos de acceso según su rol", .ObjetoSQL = "spReportes_Listar", .Tipo = "SP"},
                    New With {.Nombre = "EjecutarComandoReporte", .Descripcion = "Ejecuta el comando SQL asociado a un reporte específico y retorna los resultados. Valida permisos y parámetros antes de ejecutar", .ObjetoSQL = "SELECT", .Tipo = "SELECT"}
                })
            Case "Forms/Transacciones/Transacciones.aspx"
                metodos.AddRange({
                    New With {.Nombre = "BuscarAsociados", .Descripcion = "Busca asociados para seleccionar en transacciones. Retorna información básica del asociado y sus auxiliares disponibles", .ObjetoSQL = "spTransacciones_BuscarAsociados", .Tipo = "SP"},
                    New With {.Nombre = "ObtenerAuxiliaresAsociado", .Descripcion = "Obtiene todos los auxiliares activos de un asociado específico para poder seleccionar la cuenta en una transacción", .ObjetoSQL = "spTransacciones_ObtenerAuxiliaresAsociado", .Tipo = "SP"},
                    New With {.Nombre = "GuardarTransaccion", .Descripcion = "Registra una nueva transacción en el sistema. Valida saldos, límites y aplica movimientos a las cuentas involucradas", .ObjetoSQL = "spTransacciones_Guardar", .Tipo = "SP"},
                    New With {.Nombre = "ObtenerTransacciones", .Descripcion = "Obtiene el historial de transacciones aplicando filtros por fecha, asociado, auxiliar o tipo de transacción", .ObjetoSQL = "spTransacciones_Obtener", .Tipo = "SP"},
                    New With {.Nombre = "ValidarSaldo", .Descripcion = "Valida si un auxiliar tiene saldo suficiente para realizar una transacción de débito", .ObjetoSQL = "spTransacciones_ValidarSaldo", .Tipo = "SP"}
                })
            Case "Forms/Mantenimientos/GestionUsuarios.aspx"
                metodos.AddRange({
                    New With {.Nombre = "ObtenerUsuarios", .Descripcion = "Obtiene la lista de usuarios del sistema con sus roles, departamentos y estado (activo/inactivo)", .ObjetoSQL = "spUsuarios_Obtener", .Tipo = "SP"},
                    New With {.Nombre = "ObtenerUsuario", .Descripcion = "Obtiene información detallada de un usuario específico incluyendo permisos, roles y configuración", .ObjetoSQL = "spUsuarios_ObtenerPorId", .Tipo = "SP"},
                    New With {.Nombre = "GuardarUsuario", .Descripcion = "Crea o actualiza un usuario en el sistema. Encripta la contraseña y asigna roles y permisos según la configuración", .ObjetoSQL = "spUsuarios_Guardar", .Tipo = "SP"},
                    New With {.Nombre = "EliminarUsuario", .Descripcion = "Elimina lógicamente un usuario del sistema (no elimina físicamente para mantener auditoría)", .ObjetoSQL = "spUsuarios_Eliminar", .Tipo = "SP"},
                    New With {.Nombre = "CambiarContrasena", .Descripcion = "Cambia la contraseña de un usuario. Valida la contraseña actual y aplica políticas de seguridad", .ObjetoSQL = "spUsuarios_CambiarContrasena", .Tipo = "SP"}
                })
            Case "Forms/Mantenimientos/appParams.aspx"
                metodos.AddRange({
                    New With {.Nombre = "ObtenerParametros", .Descripcion = "Obtiene todos los parámetros de configuración del sistema como timeouts, configuraciones de backup, etc.", .ObjetoSQL = "spParametros_Obtener", .Tipo = "SP"},
                    New With {.Nombre = "GuardarParametro", .Descripcion = "Guarda o actualiza un parámetro de configuración del sistema. Algunos cambios pueden requerir reinicio del servidor", .ObjetoSQL = "spParametros_Guardar", .Tipo = "SP"}
                })
            Case "Forms/Mantenimientos/Mantenimientos.aspx"
                metodos.AddRange({
                    New With {.Nombre = "ObtenerTablaTipo", .Descripcion = "Obtiene todos los registros de una tabla de tipo específica (ej: tipos de documentos, estados, categorías)", .ObjetoSQL = "spMantenimientos_ObtenerTablaTipo", .Tipo = "SP"},
                    New With {.Nombre = "GuardarTablaTipo", .Descripcion = "Guarda o actualiza un registro en una tabla de tipo. Valida códigos duplicados y relaciones", .ObjetoSQL = "spMantenimientos_GuardarTablaTipo", .Tipo = "SP"},
                    New With {.Nombre = "EliminarTablaTipo", .Descripcion = "Elimina lógicamente un registro de tabla de tipo si no está siendo utilizado en otras tablas", .ObjetoSQL = "spMantenimientos_EliminarTablaTipo", .Tipo = "SP"},
                    New With {.Nombre = "ListarCorregimientos", .Descripcion = "Lista todos los corregimientos con sus relaciones (país, provincia, distrito). Acepta filtros opcionales por código, país, provincia, distrito y descripción. Utiliza stored procedure spCorregimientos_Listar.", .ObjetoSQL = "spCorregimientos_Listar", .Tipo = "SP"},
                    New With {.Nombre = "GuardarCorregimiento", .Descripcion = "Guarda o actualiza un corregimiento. Valida códigos duplicados y genera código automáticamente si es necesario. Utiliza stored procedure spCorregimientos_Guardar.", .ObjetoSQL = "spCorregimientos_Guardar", .Tipo = "SP"},
                    New With {.Nombre = "EliminarCorregimiento", .Descripcion = "Elimina lógicamente un corregimiento (soft delete). Utiliza stored procedure spCorregimientos_Eliminar.", .ObjetoSQL = "spCorregimientos_Eliminar", .Tipo = "SP"},
                    New With {.Nombre = "GuardarEmpresa", .Descripcion = "Guarda o actualiza una empresa. Valida códigos duplicados. Utiliza stored procedure spEmpresas_Guardar.", .ObjetoSQL = "spEmpresas_Guardar", .Tipo = "SP"},
                    New With {.Nombre = "EliminarEmpresa", .Descripcion = "Elimina lógicamente una empresa (soft delete). Utiliza stored procedure spEmpresas_Eliminar.", .ObjetoSQL = "spEmpresas_Eliminar", .Tipo = "SP"},
                    New With {.Nombre = "GuardarOcupacion", .Descripcion = "Guarda o actualiza una ocupación. Valida códigos duplicados. Utiliza stored procedure spOcupaciones_Guardar.", .ObjetoSQL = "spOcupaciones_Guardar", .Tipo = "SP"},
                    New With {.Nombre = "EliminarOcupacion", .Descripcion = "Elimina lógicamente una ocupación (soft delete). Valida que la ocupación no esté siendo utilizada en tbAsociados.Ocupacion antes de eliminar. Si está en uso, retorna error y no permite la eliminación. Utiliza stored procedure spOcupaciones_Eliminar.", .ObjetoSQL = "spOcupaciones_Eliminar", .Tipo = "SP"},
                    New With {.Nombre = "GuardarNivelEstudio", .Descripcion = "Guarda o actualiza un nivel de estudio. Valida códigos duplicados. Utiliza stored procedure spNivelesEstudio_Guardar.", .ObjetoSQL = "spNivelesEstudio_Guardar", .Tipo = "SP"},
                    New With {.Nombre = "EliminarNivelEstudio", .Descripcion = "Elimina lógicamente un nivel de estudio (soft delete). Valida que el nivel de estudio no esté siendo utilizado en tbAsociados.NivelEstudio antes de eliminar. Si está en uso, retorna error y no permite la eliminación. Utiliza stored procedure spNivelesEstudio_Eliminar.", .ObjetoSQL = "spNivelesEstudio_Eliminar", .Tipo = "SP"},
                    New With {.Nombre = "GuardarPais", .Descripcion = "Guarda o actualiza un país. Valida códigos ISO duplicados y convierte el código a mayúsculas. Utiliza stored procedure spPaises_Guardar.", .ObjetoSQL = "spPaises_Guardar", .Tipo = "SP"},
                    New With {.Nombre = "EliminarPais", .Descripcion = "Elimina lógicamente un país (soft delete). Utiliza stored procedure spPaises_Eliminar.", .ObjetoSQL = "spPaises_Eliminar", .Tipo = "SP"},
                    New With {.Nombre = "GuardarProvincia", .Descripcion = "Guarda o actualiza una provincia. Valida códigos duplicados por país. Utiliza stored procedure spProvincias_Guardar.", .ObjetoSQL = "spProvincias_Guardar", .Tipo = "SP"},
                    New With {.Nombre = "EliminarProvincia", .Descripcion = "Elimina lógicamente una provincia (soft delete). Utiliza stored procedure spProvincias_Eliminar.", .ObjetoSQL = "spProvincias_Eliminar", .Tipo = "SP"},
                    New With {.Nombre = "GuardarDistrito", .Descripcion = "Guarda o actualiza un distrito. Valida códigos duplicados por provincia y genera código automáticamente si es necesario. Utiliza stored procedure spDistritos_Guardar.", .ObjetoSQL = "spDistritos_Guardar", .Tipo = "SP"},
                    New With {.Nombre = "EliminarDistrito", .Descripcion = "Elimina lógicamente un distrito (soft delete). Utiliza stored procedure spDistritos_Eliminar.", .ObjetoSQL = "spDistritos_Eliminar", .Tipo = "SP"}
                })
            Case "Forms/Reportes/dashboardReportes.aspx"
                ' Formulario menú sin métodos - retornar lista vacía
                ' No agregar métodos para que se muestre "Formulario Menú sin métodos definidos..."
            Case "Forms/Mantenimientos/dashboardSistemas.aspx"
                ' Formulario menú sin métodos - retornar lista vacía
                ' No agregar métodos para que se muestre "Formulario Menú sin métodos definidos..."
            Case "Forms/Logs/DetalleLogs.aspx"
                ' Formulario menú sin métodos - retornar lista vacía
                ' No agregar métodos para que se muestre "Formulario Menú sin métodos definidos..."
            Case Else
                metodos.Add(New With {.Nombre = "Métodos no documentados", .Descripcion = "Los métodos de este formulario aún no están documentados", .ObjetoSQL = "", .Tipo = ""})
        End Select

        Return metodos
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ObtenerDefinicionSQL(nombreObjeto As String, tipo As String) As String
        Dim resultado As String = ""
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("Obteniendo definición SQL de: " & nombreObjeto & " (Tipo: " & tipo & ")")

            ' Verificar sesión y conexión
            Dim usuarioId As Integer = 0
            If HttpContext.Current.Session(VariablesSesion.UsuarioId) IsNot Nothing Then
                Integer.TryParse(HttpContext.Current.Session(VariablesSesion.UsuarioId).ToString(), usuarioId)
            End If

            If usuarioId = 0 Then
                Throw New Exception("Usuario no autenticado")
            End If

            Dim connectionString As String = ""
            If HttpContext.Current.Session(VariablesSesion.ConnectionString) IsNot Nothing Then
                connectionString = HttpContext.Current.Session(VariablesSesion.ConnectionString).ToString()
            End If

            If String.IsNullOrEmpty(connectionString) Then
                Throw New Exception("Cadena de conexión no encontrada")
            End If

            Dim objSql As SBSqlClientInterface = GetDbaObject(connectionString)
            Dim definicion As String = ""

            Select Case tipo.ToUpper()
                Case "UPDATE"
                    ' Para UPDATEs, el nombreObjeto ya contiene el SQL completo
                    definicion = nombreObjeto
                Case "SELECT"
                    ' Para SELECTs, el nombreObjeto ya contiene el SQL completo
                    definicion = nombreObjeto
                Case "SP"
                    ' Obtener definición de stored procedure
                    Dim sSql As String = "SELECT OBJECT_DEFINITION(OBJECT_ID('dbo." & nombreObjeto & "')) AS Definition " &
                                         "UNION ALL " &
                                         "SELECT OBJECT_DEFINITION(OBJECT_ID('" & nombreObjeto & "')) AS Definition"
                    
                    Dim dt As DataTable = objSql.GetDataTableSql(sSql)

                    If objSql.MensajeError <> "" Then
                        ' Intentar con sys.sql_modules
                        sSql = "SELECT m.definition AS Definition " &
                               "FROM sys.procedures p " &
                               "INNER JOIN sys.sql_modules m ON m.object_id = p.object_id " &
                               "WHERE p.name = '" & nombreObjeto & "'"
                        dt = objSql.GetDataTableSql(sSql)
                    End If

                    If objSql.MensajeError <> "" Then
                        Throw New Exception("Error en BD: " & objSql.MensajeError)
                    End If

                    If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
                        For Each row As DataRow In dt.Rows
                            If row("Definition") IsNot DBNull.Value AndAlso Not String.IsNullOrEmpty(row("Definition").ToString()) Then
                                definicion = row("Definition").ToString()
                                Exit For
                            End If
                        Next
                    End If

                    If String.IsNullOrEmpty(definicion) Then
                        definicion = "No se encontró la definición del stored procedure: " & nombreObjeto
                    End If

                Case "VIEW"
                    ' Obtener definición de vista
                    Dim sSql As String = "SELECT OBJECT_DEFINITION(OBJECT_ID('dbo." & nombreObjeto & "')) AS Definition " &
                                         "UNION ALL " &
                                         "SELECT OBJECT_DEFINITION(OBJECT_ID('" & nombreObjeto & "')) AS Definition"
                    
                    Dim dt As DataTable = objSql.GetDataTableSql(sSql)

                    If objSql.MensajeError <> "" Then
                        ' Intentar con sys.sql_modules
                        sSql = "SELECT m.definition AS Definition " &
                               "FROM sys.views v " &
                               "INNER JOIN sys.sql_modules m ON m.object_id = v.object_id " &
                               "WHERE v.name = '" & nombreObjeto & "'"
                        dt = objSql.GetDataTableSql(sSql)
                    End If

                    If objSql.MensajeError <> "" Then
                        Throw New Exception("Error en BD: " & objSql.MensajeError)
                    End If

                    If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
                        For Each row As DataRow In dt.Rows
                            If row("Definition") IsNot DBNull.Value AndAlso Not String.IsNullOrEmpty(row("Definition").ToString()) Then
                                definicion = row("Definition").ToString()
                                Exit For
                            End If
                        Next
                    End If

                    If String.IsNullOrEmpty(definicion) Then
                        definicion = "No se encontró la definición de la vista: " & nombreObjeto
                    End If

                Case "SELECT"
                    ' Si nombreObjeto es un SELECT completo, mostrarlo directamente
                    If nombreObjeto.ToUpper().Trim().StartsWith("SELECT") Then
                        definicion = nombreObjeto
                    Else
                        definicion = "SELECT * FROM " & nombreObjeto
                    End If

                Case Else
                    definicion = "Tipo no soportado: " & tipo
            End Select

            Dim response As New With {
                .Resultado = "SUCCESS",
                .Data = definicion,
                .Mensaje = ""
            }

            resultado = serializer.Serialize(response)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerDefinicionSQL: " & ex.Message & " | StackTrace: " & ex.StackTrace)
            Dim errorResponse As New With {
                .Resultado = "ERROR",
                .Data = "",
                .Mensaje = "Error al obtener definición SQL: " & ex.Message
            }
            resultado = serializer.Serialize(errorResponse)
        End Try

        Return resultado
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function EjecutarSelect(comandoSQL As String) As String
        Dim resultado As String = ""
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("Ejecutando SELECT: " & comandoSQL)

            ' Verificar sesión
            Dim usuarioId As Integer = 0
            If HttpContext.Current.Session(VariablesSesion.UsuarioId) IsNot Nothing Then
                Integer.TryParse(HttpContext.Current.Session(VariablesSesion.UsuarioId).ToString(), usuarioId)
            End If

            If usuarioId = 0 Then
                Throw New Exception("Usuario no autenticado")
            End If

            Dim connectionString As String = ""
            If HttpContext.Current.Session(VariablesSesion.ConnectionString) IsNot Nothing Then
                connectionString = HttpContext.Current.Session(VariablesSesion.ConnectionString).ToString()
            End If

            If String.IsNullOrEmpty(connectionString) Then
                Throw New Exception("Cadena de conexión no encontrada")
            End If

            ' Validar que sea un SELECT o vista (seguridad)
            Dim comandoUpper As String = comandoSQL.ToUpper().Trim()
            Dim esSelect As Boolean = comandoUpper.StartsWith("SELECT") OrElse 
                                      comandoUpper.StartsWith("SELECT TOP") OrElse 
                                      comandoUpper.StartsWith("SELECT DISTINCT") OrElse
                                      comandoUpper.StartsWith("WITH")
            
            ' Si no es SELECT, verificar si es una vista
            Dim esVista As Boolean = False
            If Not esSelect Then
                ' Verificar si es el nombre de una vista
                Dim objSqlVerificar As SBSqlClientInterface = GetDbaObject(connectionString)
                Dim sSqlVerificar As String = "SELECT COUNT(*) AS Existe FROM sys.views WHERE name = '" & comandoSQL.Replace("'", "''") & "'"
                Dim dtVerificar As DataTable = objSqlVerificar.GetDataTableSql(sSqlVerificar)
                If dtVerificar IsNot Nothing AndAlso dtVerificar.Rows.Count > 0 Then
                    esVista = Convert.ToInt32(dtVerificar.Rows(0)("Existe")) > 0
                End If
            End If

            If Not esSelect AndAlso Not esVista Then
                Throw New Exception("Solo se permiten consultas SELECT o vistas por seguridad")
            End If

            ' Ejecutar consulta
            Dim objSql As SBSqlClientInterface = GetDbaObject(connectionString)
            Dim sSqlEjecutar As String = If(esVista, "SELECT * FROM " & comandoSQL, comandoSQL)
            Dim dt As DataTable = objSql.GetDataTableSql(sSqlEjecutar)

            If objSql.MensajeError <> "" Then
                Throw New Exception("Error en BD: " & objSql.MensajeError)
            End If

            ' Convertir DataTable a lista de objetos
            Dim resultados As New List(Of Dictionary(Of String, Object))
            If dt IsNot Nothing Then
                For Each row As DataRow In dt.Rows
                    Dim fila As New Dictionary(Of String, Object)
                    For Each col As DataColumn In dt.Columns
                        fila(col.ColumnName) = If(row(col) Is DBNull.Value, Nothing, row(col))
                    Next
                    resultados.Add(fila)
                Next
            End If

            Dim response As New With {
                .Resultado = "SUCCESS",
                .Data = serializer.Serialize(resultados),
                .Mensaje = ""
            }

            resultado = serializer.Serialize(response)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en EjecutarSelect: " & ex.Message & " | StackTrace: " & ex.StackTrace)
            Dim errorResponse As New With {
                .Resultado = "ERROR",
                .Data = "",
                .Mensaje = "Error al ejecutar consulta: " & ex.Message
            }
            resultado = serializer.Serialize(errorResponse)
        End Try

        Return resultado
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function BuscarSPVista(nombreSP As String) As String
        Dim resultado As String = ""
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("Buscando referencias de SP/Vista/Tabla: " & nombreSP)

            Dim resultados As New List(Of Object)

            ' Obtener lista de formularios
            Dim formularios As New List(Of Object) From {
                New With {.Nombre = "Auxiliares", .Ruta = "Forms/Auxiliares/AuxiliaresAsociados.aspx"},
                New With {.Nombre = "Socios", .Ruta = "Forms/Socios/GestionSocios.aspx"},
                New With {.Nombre = "Transacciones", .Ruta = "Forms/Transacciones/Transacciones.aspx"},
                New With {.Nombre = "Finanzas", .Ruta = "Forms/Finanzas/Finanzas.aspx"},
                New With {.Nombre = "Mantenimientos", .Ruta = "Forms/Mantenimientos/Mantenimientos.aspx"},
                New With {.Nombre = "Gestión de Usuarios", .Ruta = "Forms/Mantenimientos/GestionUsuarios.aspx"},
                New With {.Nombre = "Parámetros", .Ruta = "Forms/Mantenimientos/appParams.aspx"},
                New With {.Nombre = "Reportes", .Ruta = "Forms/Reportes/Reportes.aspx"},
                New With {.Nombre = "Dashboard Reportes", .Ruta = "Forms/Reportes/dashboardReportes.aspx"},
                New With {.Nombre = "Logs", .Ruta = "Forms/Logs/Logs.aspx"},
                New With {.Nombre = "Logs Auditoría", .Ruta = "Forms/Logs/LogsAuditoria.aspx"},
                New With {.Nombre = "Logs Aplicación", .Ruta = "Forms/Logs/LogsAplicacion.aspx"},
                New With {.Nombre = "Logs Accesos", .Ruta = "Forms/Logs/LogsAccesos.aspx"},
                New With {.Nombre = "Detalle Logs", .Ruta = "Forms/Logs/DetalleLogs.aspx"},
                New With {.Nombre = "Historial Tablas", .Ruta = "Forms/Logs/historialTablas.aspx"},
                New With {.Nombre = "Respaldos", .Ruta = "Forms/Sistemas/Respaldos.aspx"},
                New With {.Nombre = "Dashboard Sistemas", .Ruta = "Forms/Mantenimientos/dashboardSistemas.aspx"}
            }

            ' Buscar en cada formulario
            For Each formulario In formularios
                Dim rutaVB As String = formulario.Ruta.Replace(".aspx", ".aspx.vb")
                Dim rutaCompleta As String = HttpContext.Current.Server.MapPath("~/" & rutaVB)

                If File.Exists(rutaCompleta) Then
                    Try
                        Dim codigo As String = File.ReadAllText(rutaCompleta, Encoding.UTF8)
                        Dim metodos As List(Of Object) = AnalizarMetodosWebMethod(codigo, rutaVB)

                        ' Buscar métodos que usen el SP/vista
                        Dim metodosQueUsanSP As New List(Of Object)
                        For Each metodoObj In metodos
                            Dim metodoNombre As String = If(metodoObj.Nombre IsNot Nothing, metodoObj.Nombre.ToString(), "")
                            Dim objetoSQL As String = If(metodoObj.ObjetoSQL IsNot Nothing, metodoObj.ObjetoSQL.ToString(), "")
                            Dim descripcion As String = If(metodoObj.Descripcion IsNot Nothing, metodoObj.Descripcion.ToString(), "")
                            Dim tipo As String = If(metodoObj.Tipo IsNot Nothing, metodoObj.Tipo.ToString(), "GENERICO")

                            ' Buscar el nombre del SP/vista en el objeto SQL
                            ' Puede estar como: "spNombre", "Exec spNombre", "dbo.spNombre", etc.
                            Dim objetoSQLUpper As String = objetoSQL.ToUpper()
                            Dim nombreSPUpper As String = nombreSP.ToUpper()

                            ' Verificar si el objeto SQL contiene el nombre del SP/vista/tabla
                            If Not String.IsNullOrEmpty(objetoSQL) AndAlso objetoSQL <> "No identificado" Then
                                ' Buscar coincidencias exactas o parciales para SP/Vista
                                Dim coincide As Boolean = objetoSQLUpper.Contains(nombreSPUpper) OrElse
                                   objetoSQLUpper.Contains("EXEC " & nombreSPUpper) OrElse
                                   objetoSQLUpper.Contains("EXECUTE " & nombreSPUpper) OrElse
                                   objetoSQLUpper.Contains("DBO." & nombreSPUpper) OrElse
                                   objetoSQLUpper.Contains("[" & nombreSPUpper & "]") OrElse
                                   objetoSQLUpper = nombreSPUpper OrElse
                                   objetoSQLUpper.EndsWith(" " & nombreSPUpper) OrElse
                                   objetoSQLUpper.EndsWith("." & nombreSPUpper)
                                
                                ' Buscar también para tablas (FROM, INTO, JOIN, UPDATE, etc.)
                                If Not coincide Then
                                    coincide = objetoSQLUpper.Contains("FROM " & nombreSPUpper) OrElse
                                               objetoSQLUpper.Contains("FROM [" & nombreSPUpper & "]") OrElse
                                               objetoSQLUpper.Contains("FROM DBO." & nombreSPUpper) OrElse
                                               objetoSQLUpper.Contains("INTO " & nombreSPUpper) OrElse
                                               objetoSQLUpper.Contains("INTO [" & nombreSPUpper & "]") OrElse
                                               objetoSQLUpper.Contains("INTO DBO." & nombreSPUpper) OrElse
                                               objetoSQLUpper.Contains("UPDATE " & nombreSPUpper) OrElse
                                               objetoSQLUpper.Contains("UPDATE [" & nombreSPUpper & "]") OrElse
                                               objetoSQLUpper.Contains("UPDATE DBO." & nombreSPUpper) OrElse
                                               objetoSQLUpper.Contains("JOIN " & nombreSPUpper) OrElse
                                               objetoSQLUpper.Contains("JOIN [" & nombreSPUpper & "]") OrElse
                                               objetoSQLUpper.Contains("JOIN DBO." & nombreSPUpper) OrElse
                                               objetoSQLUpper.Contains("DELETE FROM " & nombreSPUpper) OrElse
                                               objetoSQLUpper.Contains("DELETE FROM [" & nombreSPUpper & "]") OrElse
                                               objetoSQLUpper.Contains("DELETE FROM DBO." & nombreSPUpper)
                                End If
                                
                                If coincide Then
                                    metodosQueUsanSP.Add(New With {
                                        .Nombre = metodoNombre,
                                        .Descripcion = descripcion,
                                        .ObjetoSQL = objetoSQL,
                                        .Tipo = tipo
                                    })
                                End If
                            End If

                            ' También buscar en el código del método directamente
                            Dim codigoUpper As String = codigo.ToUpper()
                            If codigoUpper.Contains(nombreSPUpper) Then
                                ' Extraer el cuerpo del método para verificar
                                Dim patronMetodo As String = "Function\s+" & Regex.Escape(metodoNombre) & "\s*\([^)]*\)[\s\S]{0,5000}?End\s+Function"
                                Dim matchMetodo As Match = Regex.Match(codigo, patronMetodo, RegexOptions.IgnoreCase Or RegexOptions.Multiline)
                                If matchMetodo.Success Then
                                    Dim cuerpoMetodo As String = matchMetodo.Value
                                    Dim cuerpoMetodoUpper As String = cuerpoMetodo.ToUpper()
                                    
                                    ' Buscar en el cuerpo del método
                                    Dim coincideEnCuerpo As Boolean = cuerpoMetodoUpper.Contains(nombreSPUpper)
                                    
                                    ' Si no coincide directamente, buscar patrones de tabla
                                    If Not coincideEnCuerpo Then
                                        coincideEnCuerpo = cuerpoMetodoUpper.Contains("FROM " & nombreSPUpper) OrElse
                                                           cuerpoMetodoUpper.Contains("INTO " & nombreSPUpper) OrElse
                                                           cuerpoMetodoUpper.Contains("UPDATE " & nombreSPUpper) OrElse
                                                           cuerpoMetodoUpper.Contains("JOIN " & nombreSPUpper) OrElse
                                                           cuerpoMetodoUpper.Contains("DELETE FROM " & nombreSPUpper) OrElse
                                                           cuerpoMetodoUpper.Contains("EXEC " & nombreSPUpper) OrElse
                                                           cuerpoMetodoUpper.Contains("EXECUTE " & nombreSPUpper)
                                    End If
                                    
                                    If coincideEnCuerpo Then
                                        ' Verificar si ya no está en la lista
                                        Dim yaExiste As Boolean = False
                                        For Each metodoExistente In metodosQueUsanSP
                                            If metodoExistente.Nombre.ToString() = metodoNombre Then
                                                yaExiste = True
                                                Exit For
                                            End If
                                        Next
                                        If Not yaExiste Then
                                            metodosQueUsanSP.Add(New With {
                                                .Nombre = metodoNombre,
                                                .Descripcion = descripcion,
                                                .ObjetoSQL = objetoSQL,
                                                .Tipo = tipo
                                            })
                                        End If
                                    End If
                                End If
                            End If
                        Next

                        ' Si se encontraron métodos que usan el SP/vista, agregar el formulario a los resultados
                        If metodosQueUsanSP.Count > 0 Then
                            resultados.Add(New With {
                                .NombreFormulario = formulario.Nombre,
                                .RutaFormulario = formulario.Ruta,
                                .Metodos = metodosQueUsanSP
                            })
                        End If
                    Catch ex As Exception
                        ModGlobal.EscribirLog("Error al analizar formulario " & formulario.Ruta & ": " & ex.Message)
                    End Try
                End If
            Next

            Dim response As New With {
                .Resultado = "SUCCESS",
                .Data = serializer.Serialize(resultados),
                .Mensaje = ""
            }

            resultado = serializer.Serialize(response)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en BuscarSPVista: " & ex.Message & " | StackTrace: " & ex.StackTrace)
            Dim errorResponse As New With {
                .Resultado = "ERROR",
                .Data = "",
                .Mensaje = "Error al buscar SP/Vista/Tabla: " & ex.Message
            }
            resultado = serializer.Serialize(errorResponse)
        End Try

        Return resultado
    End Function

End Class
