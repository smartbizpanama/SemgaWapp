Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Web.Script.Serialization
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Reflection
Imports System.Text
Imports System.Text.RegularExpressions
Imports System.Linq
Imports SBSqlClient
Imports SBUtility

Public Class procesosTecnicos
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
            ModGlobal.EscribirLog("Obteniendo lista de formularios para procesos técnicos")

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
    Public Shared Function ObtenerProcesosTecnicos(rutaFormulario As String) As String
        Dim resultado As String = ""
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("Obteniendo procesos técnicos del formulario: " & rutaFormulario)

            Dim procesos As New Dictionary(Of String, Object)

            ' Obtener rutas de archivos
            Dim rutaVB As String = rutaFormulario.Replace(".aspx", ".aspx.vb")
            Dim rutaASPX As String = rutaFormulario
            Dim rutaVBCompleta As String = HttpContext.Current.Server.MapPath("~/" & rutaVB)
            Dim rutaASPXCompleta As String = HttpContext.Current.Server.MapPath("~/" & rutaASPX)

            Dim codigoVB As String = ""
            Dim codigoASPX As String = ""

            ' Leer archivos
            If File.Exists(rutaVBCompleta) Then
                codigoVB = File.ReadAllText(rutaVBCompleta, Encoding.UTF8)
            End If

            If File.Exists(rutaASPXCompleta) Then
                codigoASPX = File.ReadAllText(rutaASPXCompleta, Encoding.UTF8)
            End If

            ' Analizar lógica de cliente (JavaScript)
            Dim logicaCliente As List(Of Object) = AnalizarLogicaCliente(codigoASPX)

            ' Analizar lógica de servidor (VB.NET)
            Dim logicaServidor As List(Of Object) = AnalizarLogicaServidor(codigoVB)

            ' Analizar base de datos
            Dim baseDatos As Dictionary(Of String, Object) = AnalizarBaseDatos(codigoVB, codigoASPX)

            ' Generar flujos de procesos
            Dim flujoProcesos As List(Of Object) = GenerarFlujoProcesos(codigoVB, codigoASPX, baseDatos)

            procesos("LogicaCliente") = logicaCliente
            procesos("LogicaServidor") = logicaServidor
            procesos("BaseDatos") = baseDatos
            procesos("FlujoProcesos") = flujoProcesos

            Dim response As New With {
                .Resultado = "SUCCESS",
                .Data = serializer.Serialize(procesos),
                .Mensaje = ""
            }

            resultado = serializer.Serialize(response)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerProcesosTecnicos: " & ex.Message & " | StackTrace: " & ex.StackTrace)
            Dim errorResponse As New With {
                .Resultado = "ERROR",
                .Data = "",
                .Mensaje = "Error al obtener procesos técnicos: " & ex.Message
            }
            resultado = serializer.Serialize(errorResponse)
        End Try

        Return resultado
    End Function

    Private Shared Function AnalizarLogicaCliente(codigoASPX As String) As List(Of Object)
        Dim logicaCliente As New List(Of Object)

        If String.IsNullOrEmpty(codigoASPX) Then
            Return logicaCliente
        End If

        Try
            ' Extraer código JavaScript del archivo ASPX
            Dim patronScript As String = "<script[^>]*>([\s\S]*?)</script>"
            Dim matchesScript As MatchCollection = Regex.Matches(codigoASPX, patronScript, RegexOptions.IgnoreCase Or RegexOptions.Multiline)

            For Each match As Match In matchesScript
                Dim codigoJS As String = match.Groups(1).Value

                ' Buscar funciones JavaScript
                Dim patronFuncion As String = "function\s+(\w+)\s*\([^)]*\)\s*\{([\s\S]*?)\}"
                Dim matchesFuncion As MatchCollection = Regex.Matches(codigoJS, patronFuncion, RegexOptions.Multiline)

                For Each matchFuncion As Match In matchesFuncion
                    Dim nombreFuncion As String = matchFuncion.Groups(1).Value
                    Dim cuerpoFuncion As String = matchFuncion.Groups(2).Value

                    ' Buscar llamadas AJAX
                    Dim tieneAjax As Boolean = cuerpoFuncion.Contains("$.ajax") OrElse cuerpoFuncion.Contains("$.post") OrElse cuerpoFuncion.Contains("$.get")

                    ' Buscar eventos
                    Dim eventos As New List(Of String)
                    Dim patronEvento As String = "\$\([^)]*\)\.(on|click|change|submit|keypress|keyup|keydown|blur|focus)\s*\([^)]*\)"
                    Dim matchesEvento As MatchCollection = Regex.Matches(codigoJS, patronEvento, RegexOptions.IgnoreCase)
                    For Each matchEvento As Match In matchesEvento
                        eventos.Add(matchEvento.Value)
                    Next

                ' Generar descripción del proceso sin código
                Dim procesoDescripcion As String = GenerarDescripcionProcesoCliente(nombreFuncion, cuerpoFuncion, tieneAjax)
                
                logicaCliente.Add(New With {
                    .Nombre = nombreFuncion,
                    .Descripcion = "Función JavaScript que " & If(tieneAjax, "realiza llamadas AJAX al servidor", "manipula el DOM"),
                    .Proceso = procesoDescripcion,
                    .Eventos = eventos
                })
                Next

                ' Buscar event handlers directos
                Dim patronHandler As String = "\$\([^)]*\)\.(on|click|change|submit)\s*\([^)]*function[^}]*\{([\s\S]*?)\}"
                Dim matchesHandler As MatchCollection = Regex.Matches(codigoJS, patronHandler, RegexOptions.Multiline)
                For Each matchHandler As Match In matchesHandler
                    Dim tipoEvento As String = matchHandler.Groups(1).Value
                    Dim cuerpoHandler As String = matchHandler.Groups(2).Value

                    Dim procesoHandler As String = GenerarDescripcionProcesoCliente("Event Handler: " & tipoEvento, cuerpoHandler, False)
                    
                    logicaCliente.Add(New With {
                        .Nombre = "Event Handler: " & tipoEvento,
                        .Descripcion = "Manejador de evento " & tipoEvento & " que se ejecuta en el cliente",
                        .Proceso = procesoHandler,
                        .Eventos = New List(Of String) From {tipoEvento}
                    })
                Next
            Next

        Catch ex As Exception
            ModGlobal.EscribirLog("Error al analizar lógica de cliente: " & ex.Message)
        End Try

        Return logicaCliente
    End Function

    Private Shared Function AnalizarLogicaServidor(codigoVB As String) As List(Of Object)
        Dim logicaServidor As New List(Of Object)

        If String.IsNullOrEmpty(codigoVB) Then
            Return logicaServidor
        End If

        Try
            ' Buscar métodos WebMethod
            Dim patronWebMethod As String = "<WebMethod\([^)]*\)>\s*(?:<ScriptMethod\([^)]*\)>\s*)?Public\s+(?:Shared\s+)?Function\s+(\w+)\s*\([^)]*\)"
            Dim matchesWebMethod As MatchCollection = Regex.Matches(codigoVB, patronWebMethod, RegexOptions.Multiline Or RegexOptions.IgnoreCase)

            For Each match As Match In matchesWebMethod
                Dim nombreMetodo As String = match.Groups(1).Value
                Dim inicioMetodo As Integer = codigoVB.IndexOf(match.Value)
                Dim finMetodo As Integer = codigoVB.IndexOf("End Function", inicioMetodo)

                If finMetodo = -1 Then finMetodo = codigoVB.Length

                Dim cuerpoMetodo As String = ""
                If inicioMetodo >= 0 AndAlso finMetodo > inicioMetodo Then
                    cuerpoMetodo = codigoVB.Substring(inicioMetodo, finMetodo - inicioMetodo)
                End If

                ' Buscar validaciones
                Dim validaciones As New List(Of String)
                If cuerpoMetodo.Contains("If String.IsNullOrEmpty") Then
                    validaciones.Add("Validación de campos vacíos")
                End If
                If cuerpoMetodo.Contains("If") AndAlso cuerpoMetodo.Contains("Then") Then
                    validaciones.Add("Validaciones condicionales")
                End If
                If cuerpoMetodo.Contains("Try") AndAlso cuerpoMetodo.Contains("Catch") Then
                    validaciones.Add("Manejo de excepciones")
                End If

                ' Buscar objetos de BD utilizados
                Dim objetosBD As New List(Of Object)
                Dim objetoSQL As String = ObtenerObjetoSQLDelMetodo(cuerpoMetodo)
                If Not String.IsNullOrEmpty(objetoSQL) AndAlso objetoSQL <> "No identificado" Then
                    Dim tipoObjeto As String = "SP"
                    If objetoSQL.ToUpper().StartsWith("SELECT") Then
                        tipoObjeto = "SELECT"
                    ElseIf objetoSQL.ToUpper().StartsWith("UPDATE") Then
                        tipoObjeto = "UPDATE"
                    ElseIf objetoSQL.ToUpper().Contains("VIEW") Then
                        tipoObjeto = "VIEW"
                    End If

                    objetosBD.Add(New With {
                        .Tipo = tipoObjeto,
                        .Nombre = objetoSQL,
                        .Descripcion = "Objeto SQL utilizado en el método"
                    })
                End If

                ' Generar descripción del proceso sin código
                Dim procesoDescripcion As String = GenerarDescripcionProcesoServidor(nombreMetodo, cuerpoMetodo, objetoSQL, validaciones)
                
                logicaServidor.Add(New With {
                    .Nombre = nombreMetodo,
                    .Descripcion = GenerarDescripcionMetodo(nombreMetodo, objetoSQL, cuerpoMetodo),
                    .Proceso = procesoDescripcion,
                    .Metodo = nombreMetodo,
                    .Validaciones = validaciones,
                    .ObjetosBD = objetosBD
                })
            Next

        Catch ex As Exception
            ModGlobal.EscribirLog("Error al analizar lógica de servidor: " & ex.Message)
        End Try

        Return logicaServidor
    End Function

    Private Shared Function AnalizarBaseDatos(codigoVB As String, codigoASPX As String) As Dictionary(Of String, Object)
        Dim baseDatos As New Dictionary(Of String, Object)
        Dim storedProcedures As New List(Of Object)
        Dim tablas As New List(Of Object)
        Dim funciones As New List(Of Object)
        Dim triggers As New List(Of Object)

        Try
            ' Buscar SPs en el código VB - solo marcar como encontrados, no agregar aún
            Dim patronSP As String = "(?:Exec|EXEC)\s+([\w\._]+)"
            Dim matchesSP As MatchCollection = Regex.Matches(codigoVB, patronSP, RegexOptions.IgnoreCase)
            Dim spsEncontradosEnCodigo As New HashSet(Of String)

            For Each match As Match In matchesSP
                Dim nombreSP As String = match.Groups(1).Value.Trim()
                If nombreSP.StartsWith("sp") Then
                    spsEncontradosEnCodigo.Add(nombreSP)
                End If
            Next

            ' Buscar tablas en SELECT, UPDATE, INSERT, DELETE
            Dim patronTabla As String = "(?:FROM|INTO|UPDATE|JOIN)\s+(?:\[?dbo\]?\.)?\[?(\w+)\]?"
            Dim matchesTabla As MatchCollection = Regex.Matches(codigoVB, patronTabla, RegexOptions.IgnoreCase)
            Dim tablasEncontradas As New HashSet(Of String)

            For Each match As Match In matchesTabla
                Dim nombreTabla As String = match.Groups(1).Value.Trim()
                If Not tablasEncontradas.Contains(nombreTabla) AndAlso nombreTabla.StartsWith("tb") Then
                    tablasEncontradas.Add(nombreTabla)
                    tablas.Add(New With {
                        .Nombre = nombreTabla,
                        .Descripcion = "Tabla utilizada en operaciones de base de datos"
                    })
                End If
            Next

            ' Buscar funciones
            Dim patronFuncion As String = "(?:dbo\.)?fn(\w+)"
            Dim matchesFuncion As MatchCollection = Regex.Matches(codigoVB, patronFuncion, RegexOptions.IgnoreCase)
            Dim funcionesEncontradas As New HashSet(Of String)

            For Each match As Match In matchesFuncion
                Dim nombreFuncion As String = "fn" & match.Groups(1).Value.Trim()
                If Not funcionesEncontradas.Contains(nombreFuncion) Then
                    funcionesEncontradas.Add(nombreFuncion)
                    funciones.Add(New With {
                        .Nombre = nombreFuncion,
                        .Descripcion = "Función de base de datos utilizada"
                    })
                End If
            Next

            ' Leer scripts de BD para obtener información completa
            Dim rutaScriptsBD As String = HttpContext.Current.Server.MapPath("~/DbScripts/xprt")
            If Directory.Exists(rutaScriptsBD) Then
                ' Buscar archivos de SPs - analizar solo los que se usan en el código
                Dim archivosSP As String() = Directory.GetFiles(rutaScriptsBD, "*.StoredProcedure.sql")
                For Each archivoSP As String In archivosSP
                    Dim nombreArchivo As String = Path.GetFileNameWithoutExtension(archivoSP)
                    Dim nombreSP As String = nombreArchivo.Replace(".StoredProcedure", "")
                    ' Quitar prefijo "dbo." si existe
                    If nombreSP.StartsWith("dbo.") Then
                        nombreSP = nombreSP.Substring(4)
                    End If
                    If nombreSP.StartsWith("sp") AndAlso spsEncontradosEnCodigo.Contains(nombreSP) Then
                        ' Obtener descripción desde la tabla de BD
                        Dim resultadoAnalisis As Dictionary(Of String, Object) = ObtenerDescripcionDesdeBD(nombreSP, "SP")
                        Dim descripcionSP As String = If(resultadoAnalisis.ContainsKey("Descripcion"), resultadoAnalisis("Descripcion").ToString(), "")
                        Dim spsLlamados As New List(Of String)
                        If resultadoAnalisis.ContainsKey("SPsLlamados") AndAlso resultadoAnalisis("SPsLlamados") IsNot Nothing Then
                            Dim spsLlamadosStr As String = resultadoAnalisis("SPsLlamados").ToString()
                            If Not String.IsNullOrEmpty(spsLlamadosStr) Then
                                spsLlamados.AddRange(spsLlamadosStr.Split(","c).Select(Function(s) s.Trim()).Where(Function(s) Not String.IsNullOrEmpty(s)))
                            End If
                        End If
                        
                        ' Agregar el SP con la descripción (sin mostrar la descripción en el listado)
                        storedProcedures.Add(New With {
                            .Nombre = nombreSP,
                            .Descripcion = descripcionSP, ' Guardamos la descripción pero no la mostramos en el listado
                            .SPsLlamados = spsLlamados
                        })
                    End If
                Next

                ' Buscar archivos de tablas
                Dim archivosTabla As String() = Directory.GetFiles(rutaScriptsBD, "*.Table.sql")
                For Each archivoTabla As String In archivosTabla
                    Dim nombreArchivo As String = Path.GetFileNameWithoutExtension(archivoTabla)
                    Dim nombreTabla As String = nombreArchivo.Replace(".Table", "")
                    ' Quitar prefijo "dbo." si existe
                    If nombreTabla.StartsWith("dbo.") Then
                        nombreTabla = nombreTabla.Substring(4)
                    End If
                    If nombreTabla.StartsWith("tb") AndAlso Not tablasEncontradas.Contains(nombreTabla) Then
                        If codigoVB.Contains(nombreTabla) Then
                            tablasEncontradas.Add(nombreTabla)
                            tablas.Add(New With {
                                .Nombre = nombreTabla,
                                .Descripcion = "Tabla definida en DbScripts/xprt"
                            })
                        End If
                    End If
                Next

                ' Buscar funciones
                Dim archivosFuncion As String() = Directory.GetFiles(rutaScriptsBD, "*.UserDefinedFunction.sql")
                For Each archivoFuncion As String In archivosFuncion
                    Dim nombreArchivo As String = Path.GetFileNameWithoutExtension(archivoFuncion)
                    Dim nombreFuncion As String = nombreArchivo.Replace(".UserDefinedFunction", "")
                    ' Quitar prefijo "dbo." si existe
                    If nombreFuncion.StartsWith("dbo.") Then
                        nombreFuncion = nombreFuncion.Substring(4)
                    End If
                    If nombreFuncion.StartsWith("fn") AndAlso Not funcionesEncontradas.Contains(nombreFuncion) Then
                        If codigoVB.Contains(nombreFuncion) Then
                            funcionesEncontradas.Add(nombreFuncion)
                            funciones.Add(New With {
                                .Nombre = nombreFuncion,
                                .Descripcion = "Función definida en DbScripts/xprt"
                            })
                        End If
                    End If
                Next
            End If

        Catch ex As Exception
            ModGlobal.EscribirLog("Error al analizar base de datos: " & ex.Message)
        End Try

        baseDatos("StoredProcedures") = storedProcedures
        baseDatos("Tablas") = tablas
        baseDatos("Funciones") = funciones
        baseDatos("Triggers") = triggers

        Return baseDatos
    End Function

    Private Shared Function GenerarFlujoProcesos(codigoVB As String, codigoASPX As String, baseDatos As Dictionary(Of String, Object)) As List(Of Object)
        Dim flujos As New List(Of Object)

        Try
            ' Buscar métodos WebMethod para generar flujos
            Dim patronWebMethod As String = "<WebMethod\([^)]*\)>\s*(?:<ScriptMethod\([^)]*\)>\s*)?Public\s+(?:Shared\s+)?Function\s+(\w+)\s*\([^)]*\)"
            Dim matchesWebMethod As MatchCollection = Regex.Matches(codigoVB, patronWebMethod, RegexOptions.Multiline Or RegexOptions.IgnoreCase)

            For Each match As Match In matchesWebMethod
                Dim nombreMetodo As String = match.Groups(1).Value
                Dim inicioMetodo As Integer = codigoVB.IndexOf(match.Value)
                Dim finMetodo As Integer = codigoVB.IndexOf("End Function", inicioMetodo)

                If finMetodo = -1 Then finMetodo = codigoVB.Length

                Dim cuerpoMetodo As String = ""
                If inicioMetodo >= 0 AndAlso finMetodo > inicioMetodo Then
                    cuerpoMetodo = codigoVB.Substring(inicioMetodo, finMetodo - inicioMetodo)
                End If

                ' Buscar llamadas en JavaScript
                Dim patronLlamadaJS As String = nombreMetodo & "[\s\S]{0,500}?"
                Dim matchLlamadaJS As Match = Regex.Match(codigoASPX, patronLlamadaJS, RegexOptions.IgnoreCase)

                Dim pasos As New List(Of Object)

                ' Paso 1: Llamada desde cliente
                pasos.Add(New With {
                    .Nombre = "Llamada desde Cliente",
                    .Descripcion = "El cliente (JavaScript) realiza una llamada AJAX al método " & nombreMetodo,
                    .Tipo = "cliente",
                    .ObjetosBD = New List(Of Object)
                })

                ' Paso 2: Validaciones en servidor
                If cuerpoMetodo.Contains("If") OrElse cuerpoMetodo.Contains("String.IsNullOrEmpty") Then
                    pasos.Add(New With {
                        .Nombre = "Validaciones en Servidor",
                        .Descripcion = "El servidor valida los parámetros recibidos",
                        .Tipo = "validacion",
                        .ObjetosBD = New List(Of Object)
                    })
                End If

                ' Paso 3: Operación en BD
                Dim objetoSQL As String = ObtenerObjetoSQLDelMetodo(cuerpoMetodo)
                If Not String.IsNullOrEmpty(objetoSQL) AndAlso objetoSQL <> "No identificado" Then
                    Dim objetosBD As New List(Of Object)
                    Dim tipoObjeto As String = "SP"
                    If objetoSQL.ToUpper().StartsWith("SELECT") Then
                        tipoObjeto = "SELECT"
                    ElseIf objetoSQL.ToUpper().StartsWith("UPDATE") Then
                        tipoObjeto = "UPDATE"
                    End If

                    objetosBD.Add(New With {
                        .Tipo = tipoObjeto,
                        .Nombre = objetoSQL
                    })

                    pasos.Add(New With {
                        .Nombre = "Operación en Base de Datos",
                        .Descripcion = "Se ejecuta la operación en la base de datos: " & objetoSQL,
                        .Tipo = "database",
                        .ObjetosBD = objetosBD
                    })
                End If

                ' Paso 4: Respuesta al cliente
                pasos.Add(New With {
                    .Nombre = "Respuesta al Cliente",
                    .Descripcion = "El servidor retorna los resultados al cliente en formato JSON",
                    .Tipo = "cliente",
                    .ObjetosBD = New List(Of Object)
                })

                flujos.Add(New With {
                    .Nombre = nombreMetodo,
                    .Descripcion = "Flujo completo del proceso " & nombreMetodo,
                    .Pasos = pasos
                })
            Next

        Catch ex As Exception
            ModGlobal.EscribirLog("Error al generar flujo de procesos: " & ex.Message)
        End Try

        Return flujos
    End Function

    Private Shared Function ObtenerObjetoSQLDelMetodo(cuerpoMetodo As String) As String
        ' Buscar UPDATE directo
        Dim patronUpdate As String = "sSql\s*=\s*[""'](UPDATE[\s\S]{0,2000}?)[""']"
        Dim matchUpdate As Match = Regex.Match(cuerpoMetodo, patronUpdate, RegexOptions.IgnoreCase Or RegexOptions.Multiline Or RegexOptions.Singleline)
        If matchUpdate.Success Then
            Return Regex.Replace(matchUpdate.Groups(1).Value.Trim(), "\s+", " ")
        End If

        ' Buscar SELECT directo
        Dim patronSelect As String = "sSql\s*=\s*[""'](SELECT[\s\S]{0,2000}?)[""']"
        Dim matchSelect As Match = Regex.Match(cuerpoMetodo, patronSelect, RegexOptions.IgnoreCase Or RegexOptions.Multiline Or RegexOptions.Singleline)
        If matchSelect.Success Then
            Return Regex.Replace(matchSelect.Groups(1).Value.Trim(), "\s+", " ")
        End If

        ' Buscar Exec con nombre de SP
        Dim patronExec As String = "(?:Exec|EXEC)\s+([\w\._]+)"
        Dim matchExec As Match = Regex.Match(cuerpoMetodo, patronExec, RegexOptions.IgnoreCase Or RegexOptions.Multiline)
        If matchExec.Success Then
            Return matchExec.Groups(1).Value.Trim()
        End If

        ' Buscar sSql = "Exec spNombre"
        Dim patronExecString As String = "sSql\s*=\s*[""']Exec\s+([\w\._]+)[""']"
        Dim matchExecString As Match = Regex.Match(cuerpoMetodo, patronExecString, RegexOptions.IgnoreCase Or RegexOptions.Multiline)
        If matchExecString.Success Then
            Return matchExecString.Groups(1).Value.Trim()
        End If

        Return "No identificado"
    End Function

    Private Shared Function GenerarDescripcionMetodo(nombreMetodo As String, objetoSQL As String, cuerpoMetodo As String) As String
        Dim descripcion As String = ""
        Dim nombreUpper As String = nombreMetodo.ToUpper()

        If nombreUpper.Contains("OBTENER") OrElse nombreUpper.Contains("GET") Then
            descripcion = "Obtiene información desde la base de datos"
        ElseIf nombreUpper.Contains("GUARDAR") OrElse nombreUpper.Contains("SAVE") OrElse nombreUpper.Contains("CREAR") Then
            descripcion = "Guarda o crea un nuevo registro en la base de datos"
        ElseIf nombreUpper.Contains("BUSCAR") OrElse nombreUpper.Contains("SEARCH") Then
            descripcion = "Busca registros aplicando criterios de búsqueda"
        ElseIf nombreUpper.Contains("ELIMINAR") OrElse nombreUpper.Contains("DELETE") Then
            descripcion = "Elimina un registro del sistema"
        ElseIf nombreUpper.Contains("ACTUALIZAR") OrElse nombreUpper.Contains("UPDATE") Then
            descripcion = "Actualiza información de un registro existente"
        Else
            descripcion = "Ejecuta la operación: " & nombreMetodo
        End If

        Return descripcion
    End Function

    Private Shared Function ObtenerDescripcionDesdeBD(nombreObjeto As String, tipoObjeto As String) As Dictionary(Of String, Object)
        Dim resultado As New Dictionary(Of String, Object)
            Dim descripcion As String = ""
            Dim spsLlamados As String = ""
            Dim tablasUtilizadas As String = ""
            
            Try
            Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            
            Dim sSql As String = "SELECT DescripcionLogica, SPsLlamados, TablasUtilizadas FROM tbObjetosBD_Descripciones WHERE NombreObjeto = @NombreObjeto AND TipoObjeto = @TipoObjeto AND snEliminado = 0"
            
            With objSql.Parametros
                .Clear()
                .Add("@NombreObjeto", nombreObjeto)
                .Add("@TipoObjeto", tipoObjeto)
            End With
            
            Dim dt As DataTable = objSql.GetDataTableSql(sSql)
            
            If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
                descripcion = If(IsDBNull(dt.Rows(0)("DescripcionLogica")), "", dt.Rows(0)("DescripcionLogica").ToString())
                spsLlamados = If(IsDBNull(dt.Rows(0)("SPsLlamados")), "", dt.Rows(0)("SPsLlamados").ToString())
                resultado("TablasUtilizadas") = If(IsDBNull(dt.Rows(0)("TablasUtilizadas")), "", dt.Rows(0)("TablasUtilizadas").ToString())
            End If
            
            ' Si no se encontró en la BD, usar descripción genérica
            If String.IsNullOrEmpty(descripcion) Then
                descripcion = GenerarDescripcionSP(nombreObjeto, "")
            End If
            
        Catch ex As Exception
            ModGlobal.EscribirLog("Error al obtener descripción desde BD para " & nombreObjeto & ": " & ex.Message)
            descripcion = GenerarDescripcionSP(nombreObjeto, "")
        End Try
        
        resultado("Descripcion") = descripcion
        resultado("SPsLlamados") = spsLlamados
        
        Return resultado
    End Function

    Private Shared Function ObtenerDescripcionEstaticaSP(nombreSP As String) As Dictionary(Of String, Object)
        Dim resultado As New Dictionary(Of String, Object)
        Dim descripcion As String = ""
        Dim spsLlamados As New List(Of String)
        
        ' Diccionario estático de descripciones basado en análisis real de los archivos SQL
        Select Case nombreSP
            Case "spAuxiliares_GuardarAuxiliar"
                descripcion = "Guarda o actualiza un auxiliar asociado en la base de datos. Realiza 6 validaciones: verifica que número de asociado, código de rubro y tipo de auxiliar sean requeridos, valida que el asociado exista en tbAsociados, que el rubro exista en tbRubros, y que el tipo de auxiliar sea válido para el rubro en tbTiposAuxiliares. Si @ID = 0, crea un nuevo auxiliar: genera un consecutivo automático desde tbControlConsecutivos, realiza un INSERT en tbAuxiliares con todos los campos (Cuota, Saldo, MontoOriginal, TasaInteres, etc.), y retorna el nuevo ID. Si @ID > 0, actualiza el auxiliar existente con un UPDATE en tbAuxiliares. Utiliza transacciones (BEGIN TRANSACTION/COMMIT) para garantizar la integridad de los datos. Incluye manejo de excepciones con TRY-CATCH. Retorna 'SUCCESS' o 'ERROR' con mensaje descriptivo."
                
            Case "spAuxiliares_ObtenerAuxiliares"
                descripcion = "Obtiene todos los auxiliares activos con información completa. Consulta la tabla tbAuxiliares haciendo JOIN con tbAsociados (para nombre completo), tbTipoDocumentos (tipo de documento), tbRubros (descripción del rubro), tbTiposAuxiliares (descripción del tipo), y tbUsuarios (usuario creador y modificador). Aplica filtros WHERE para obtener solo auxiliares activos (snEliminado = 0 y snActivo = 1) y asociados no eliminados. Retorna información completa incluyendo ID, cuenta formateada, datos del asociado, rubro, tipo, montos (Cuota, Saldo, MontoOriginal, MontoPignorado), tasas, y fechas formateadas. Ordena por ID descendente."
                
            Case "spAuxiliares_ObtenerRubros"
                descripcion = "Obtiene todos los rubros disponibles en el sistema. Consulta la tabla tbRubros filtrando por registros no eliminados (snEliminado = 0). Retorna CodigoRubro y Descripcion. Ordena alfabéticamente por Descripcion. Utilizado para llenar dropdowns de selección de rubros."
                
            Case "spAuxiliares_ObtenerTiposAuxiliares"
                descripcion = "Obtiene todos los tipos de auxiliares disponibles. Consulta la tabla tbTiposAuxiliares filtrando por registros no eliminados (snEliminado = 0). Retorna TipoAuxiliar, Descripcion, CodigoRubro, ID (como IdTipoAuxiliar) y Tasa. Utiliza DISTINCT para evitar duplicados. Ordena alfabéticamente por Descripcion. Utilizado para llenar dropdowns de selección de tipos de auxiliares."
                
            Case "spAuxiliares_FiltrarAuxiliares"
                descripcion = "Filtra auxiliares aplicando criterios de búsqueda opcionales. Consulta tbAuxiliares con múltiples JOINs: tbAsociados, tbTipoDocumentos, tbRubros, tbTiposAuxiliares, y tbUsuarios. Aplica filtros dinámicos WHERE: @Busqueda busca en nombre, apellido, descripción de rubro/tipo, número de identificación, y cuenta formateada usando LIKE con comodines. @TipoAuxiliar filtra por ID del auxiliar. @CodigoRubro filtra por código de rubro. Solo muestra auxiliares y asociados no eliminados (snEliminado = 0). Retorna información completa similar a spAuxiliares_ObtenerAuxiliares. Ordena por ID descendente."
                
            Case "spAuxiliares_EliminarAuxiliar"
                descripcion = "Elimina lógicamente un auxiliar (soft delete). Realiza 3 validaciones: verifica que ID y NumeroAsociado sean requeridos, que el auxiliar exista en tbAuxiliares, y que no tenga movimientos asociados en tbMovimientos (si tiene movimientos, no permite eliminar). Utiliza transacciones (BEGIN TRANSACTION/COMMIT) para garantizar integridad. Realiza un UPDATE en tbAuxiliares estableciendo snEliminado = 1, FechaElimina = GETDATE(), UsuarioElimina, y SysLastSessionID. Incluye manejo de excepciones con TRY-CATCH. Retorna 'SUCCESS' o 'ERROR' con mensaje descriptivo."
                
            Case "spBuscarAsociadoPorID"
                descripcion = "Busca un asociado específico por su número de asociado. Consulta tbAsociados con JOINs a tbTipoAsociado y tbTipoDocumentos. Retorna información básica: NumeroAsociado, NombreCompleto (concatenado), NumeroIdentificacion, tipo de documento, tipo de asociado. Además, cuenta los auxiliares activos del asociado usando subconsulta a tbAuxiliares, y retorna los auxiliares en formato JSON mediante una subconsulta a la vista vwAuxiliaresPorAsociados con FOR JSON AUTO. Solo muestra asociados no eliminados (snEliminado = 0). Ordena por nombre y apellido."
                
            Case "spBuscarAsociados"
                descripcion = "Busca asociados aplicando criterios de búsqueda parcial. Consulta tbAsociados con JOINs a tbTipoAsociado y tbTipoDocumentos. Aplica búsqueda con LIKE en múltiples campos: Nombre, SegundoNombre, Apellido, SegundoApellido, NumeroIdentificacion, y NumeroAsociado (convertido a VARCHAR). Retorna TOP 10 resultados con información básica: NumeroAsociado, NombreCompleto, NumeroIdentificacion, tipo de documento, tipo de asociado. Cuenta los auxiliares activos del asociado y retorna los auxiliares en formato JSON mediante subconsulta a la vista vwAuxiliaresPorAsociados. Solo muestra asociados no eliminados (snEliminado = 0). Ordena por nombre y apellido."
                
            Case "spGestionSocios_ObtenerSocios"
                descripcion = "Obtiene una lista de socios aplicando múltiples filtros opcionales. Consulta tbAsociados con múltiples JOINs LEFT JOIN: tbTipoAsociado, tbUsuarios (creador y modificador), tbEmpresas, tbOcupaciones, tbPaises (trabajo y residencia), tbProvincias (trabajo y residencia), tbDistritos (trabajo y residencia), tbCorregimientos (trabajo y residencia). Aplica filtros dinámicos WHERE: @FiltroNombre busca con LIKE en Nombre, Apellido, SegundoNombre, SegundoApellido. @FiltroTipo filtra por IdTipoAsociado. @FiltroEstatus filtra por Estatus. @FiltroTipoDocumento filtra por TipoIdentificacion. @FiltroIdentificacion busca con LIKE en NumeroIdentificacion. Solo muestra socios no eliminados (snEliminado = 0). Cuenta los auxiliares activos del socio. Retorna información completa del socio incluyendo datos personales, contacto, ubicación, laborales, y descripciones de las entidades relacionadas. Incluye manejo de excepciones con TRY-CATCH. Ordena por NumeroAsociado descendente."
                
            Case "spGestionSocios_ObtenerSocioPorNumero"
                descripcion = "Obtiene información completa de un socio específico por su número de asociado. Consulta tbAsociados con los mismos múltiples JOINs LEFT JOIN que spGestionSocios_ObtenerSocios: tbTipoAsociado, tbUsuarios, tbEmpresas, tbOcupaciones, tbPaises, tbProvincias, tbDistritos, tbCorregimientos. Filtra por NumeroAsociado específico y solo muestra socios no eliminados (snEliminado = 0). Retorna información completa del socio incluyendo todos los datos personales, de contacto, ubicación, laborales, y descripciones de las entidades relacionadas. Cuenta los auxiliares activos del socio. Incluye manejo de excepciones con TRY-CATCH."
                
            Case "spGestionSocios_CrearSocio"
                descripcion = "Crea un nuevo socio en el sistema. Realiza validación de duplicados: verifica que no exista otro socio con el mismo NumeroIdentificacion y snEliminado = 0 en tbAsociados. Si ya existe, retorna error. Si no existe, realiza un INSERT en tbAsociados con todos los campos: datos personales (IdTipoAsociado, Nombre, Apellidos, Estatus, TipoIdentificacion, NumeroIdentificacion, Sexo, FechaNacimiento), datos de contacto (teléfonos, CorreoElectronico), datos de ubicación (Provincia, Distrito, Corregimiento, Dirección tanto de residencia como de trabajo), datos laborales (LugarTrabajo, Ocupacion, NivelEstudio, Profesion), países de residencia y trabajo. Establece FechaCreacion = GETDATE(), UsuarioCrea, SysLastSessionID, y snEliminado = 0. Utiliza TRY-CATCH para manejo de errores. Retorna el NumeroAsociado creado usando SCOPE_IDENTITY()."
                
            Case "spGestionSocios_ActualizarSocio"
                descripcion = "Actualiza información de un socio existente. Realiza validaciones similares a spGestionSocios_CrearSocio para evitar duplicados de identificación. Realiza un UPDATE en tbAsociados actualizando todos los campos: datos personales, contacto, ubicación, laborales. Establece FechaModificacion = GETDATE() y UsuarioModifica. Utiliza TRY-CATCH para manejo de errores."
                
            Case "spGestionSocios_EliminarAsociado"
                descripcion = "Elimina lógicamente un asociado del sistema (soft delete). Realiza validaciones para verificar que el asociado exista y no tenga relaciones que impidan su eliminación. Actualiza el campo snEliminado = 1 en tbAsociados. Utiliza transacciones y manejo de excepciones."
                
            Case "spAuxiliares_ActivarDesactivar"
                descripcion = "Activa o desactiva un auxiliar cambiando su estado. Realiza 3 validaciones: verifica que ID y NumeroAsociado sean requeridos, y que el auxiliar exista en tbAuxiliares. Utiliza transacciones (BEGIN TRANSACTION/COMMIT). Realiza un UPDATE en tbAuxiliares estableciendo snActivo = @snActivo (1 para activar, 0 para desactivar), FechaModificacion = GETDATE(), UsuarioModifica, y SysLastSessionID. Incluye manejo de excepciones con TRY-CATCH. Retorna mensaje de éxito indicando si fue activado o desactivado."
                
            Case "spAuxiliares_ModificarMontoPignorado"
                descripcion = "Modifica el monto pignorado de un auxiliar específico. Valida que el auxiliar exista y pertenezca al asociado especificado en tbAuxiliares. Realiza un UPDATE en tbAuxiliares actualizando MontoPignorado = @NuevoMonto, FechaModificacion = GETDATE(), UsuarioModifica, y SysLastSessionID. Verifica que la actualización se realizó correctamente usando @@ROWCOUNT. Incluye manejo de excepciones con TRY-CATCH. Retorna mensaje de éxito."
                
            Case "spBeneficiarios_ObtenerBeneficiarios"
                descripcion = "Obtiene todos los beneficiarios de un socio específico. Consulta tbBeneficiarios con LEFT JOIN a tbParentezcos para obtener la descripción del parentesco. Filtra por NumeroAsociado y solo muestra beneficiarios no eliminados (snEliminado = 0). Retorna IDBeneficiario, NumeroAsociado, Nombre, Apellido, TipoIdentificacion, NumeroIdentificacion, IDParentezco, Porcentaje, y Parentezco. Incluye manejo de excepciones con TRY-CATCH. Ordena por nombre y apellido."
                
            Case "spBeneficiarios_CrearBeneficiario"
                descripcion = "Crea un nuevo beneficiario para un socio. Realiza validación crítica: calcula el porcentaje total de todos los beneficiarios existentes del asociado y verifica que al agregar el nuevo porcentaje no se exceda el 100%. Si excede, retorna error. Si es válido, realiza un INSERT en tbBeneficiarios con todos los campos: NumeroAsociado, Nombre, Apellido, TipoIdentificacion, NumeroIdentificacion, IDParentezco, Porcentaje, UsuarioCrea, FechaHoraCrea = GETDATE(), SysLastSessionID, y snEliminado = 0. Incluye manejo de excepciones con TRY-CATCH. Retorna 'SUCCESS' o 'ERROR' con mensaje."
                
            Case "spBeneficiarios_ActualizarBeneficiario"
                descripcion = "Actualiza información de un beneficiario existente. Similar a spBeneficiarios_CrearBeneficiario, valida que el porcentaje total no exceda 100% considerando el porcentaje actualizado. Realiza un UPDATE en tbBeneficiarios actualizando los campos del beneficiario. Establece campos de auditoría de modificación. Utiliza TRY-CATCH para manejo de errores."
                
            Case "spBeneficiarios_EliminarBeneficiario"
                descripcion = "Elimina lógicamente un beneficiario (soft delete). Realiza un UPDATE en tbBeneficiarios estableciendo snEliminado = 1. Incluye campos de auditoría. Utiliza TRY-CATCH para manejo de errores."
                
            Case "spBeneficiarios_ObtenerParentezcos"
                descripcion = "Obtiene todos los tipos de parentesco disponibles. Consulta tbParentezcos filtrando por registros no eliminados. Retorna IDParentezco y Parentezco. Utilizado para llenar dropdowns de selección de parentesco en formularios de beneficiarios."
                
            Case "spMovimientos_GuardarMovimiento"
                descripcion = "Guarda un nuevo movimiento financiero en el sistema. Este SP tiene lógica compleja: Primero llama a spMovimiento_Validar para validar el movimiento (verifica saldos, límites, estado del auxiliar). Si es un préstamo (CodigoRubro = 'PR'), llama a spAuxiliares_CalcularIntereses para calcular intereses pendientes. Luego inicia una transacción. Si hay intereses pendientes, crea dos movimientos separados: uno para intereses (que no afecta el saldo del auxiliar) y otro para capital (que sí afecta el saldo). Si no hay intereses, crea solo el movimiento de capital. Actualiza el saldo del auxiliar en tbAuxiliares. Crea registros en tbMovimientos con los datos del movimiento. Retorna los IDs de los movimientos creados (CapitalMovimientoID e InteresesMovimientoID). Utiliza transacciones para garantizar integridad. Incluye manejo completo de excepciones."
                spsLlamados.Add("spMovimiento_Validar")
                spsLlamados.Add("spAuxiliares_CalcularIntereses")
                
            Case "spMovimiento_Validar"
                descripcion = "Valida si un movimiento puede ser realizado. Verifica que el auxiliar exista, esté activo y no eliminado. Valida que el código de transacción sea válido. Verifica saldos y límites según el tipo de transacción. Retorna @Resultado (BIT) y @Mensaje con el resultado de la validación. Utilizado por spMovimientos_GuardarMovimiento antes de crear el movimiento."
                
            Case "spAuxiliares_CalcularIntereses"
                descripcion = "Calcula los intereses pendientes de un auxiliar de préstamo. Consulta tbAuxiliares para obtener datos del préstamo (TasaInteres, Saldo, FechaUltCalculoInteres). Calcula los intereses desde la última fecha de cálculo hasta la fecha actual. Actualiza los campos InteresCalculado y FechaUltCalculoInteres en tbAuxiliares. Retorna mensaje de error si hay algún problema. Utilizado por spMovimientos_GuardarMovimiento para calcular intereses antes de procesar un pago."
                
            Case "spMovimientos_ListarPorSocio"
                descripcion = "Obtiene el historial de movimientos de un socio específico. Consulta tbMovimientos filtrando por NumeroAsociado. Puede aplicar filtros adicionales por auxiliar, rango de fechas, o tipo de movimiento. Retorna información completa de los movimientos incluyendo fechas, montos, códigos de transacción, y saldos. Incluye manejo de excepciones."
                
            Case "spMovimientos_ObtenerDatosComprobante"
                descripcion = "Obtiene los datos necesarios para generar un comprobante de movimiento. Consulta tbMovimientos y hace JOINs con tbAsociados, tbAuxiliares, y otras tablas relacionadas para obtener información completa del movimiento, asociado, y auxiliar. Retorna datos formateados para impresión de comprobantes."
                
            Case "spAsociados_ObtenerEstadoCuenta"
                descripcion = "Obtiene el estado de cuenta completo de un asociado. Consulta tbAsociados, tbAuxiliares, y tbMovimientos para calcular saldos, intereses, y resumen financiero del asociado. Puede incluir información de todos los auxiliares del asociado con sus respectivos saldos y movimientos recientes."
                
            Case "spAuxiliares_ObtenerHistorialIntereses"
                descripcion = "Obtiene el historial de cálculo de intereses de un auxiliar. Consulta la tabla de historial de intereses o tbAuxiliares para obtener información sobre cuándo se calcularon intereses, montos calculados, y pagos realizados. Utilizado para mostrar el detalle de intereses en la interfaz."
                
            Case Else
                ' Para SPs no documentados, usar descripción genérica basada en el nombre
                descripcion = GenerarDescripcionSP(nombreSP, "")
        End Select
        
        resultado("Descripcion") = descripcion
        resultado("SPsLlamados") = spsLlamados
        
        Return resultado
    End Function

    Private Shared Function AnalizarLogicaSP(contenidoSP As String, nombreSP As String) As String
        Dim descripcion As New StringBuilder()
        Dim nombreUpper As String = nombreSP.ToUpper()
        
        ' Determinar tipo de operación principal
        Dim esInsert As Boolean = contenidoSP.Contains("INSERT INTO") AndAlso Not contenidoSP.Contains("INSERT INTO #")
        Dim esUpdatePrincipal As Boolean = False
        ' Buscar UPDATEs que no sean de tbControlConsecutivos
        Dim patronUpdate As String = "UPDATE\s+(?:\[?dbo\]?\.)?\[?(\w+)\]?"
        Dim matchesUpdate As MatchCollection = Regex.Matches(contenidoSP, patronUpdate, RegexOptions.IgnoreCase)
        For Each match As Match In matchesUpdate
            If match.Groups.Count > 1 Then
                Dim tablaUpdate As String = match.Groups(1).Value.Trim()
                If tablaUpdate <> "tbControlConsecutivos" AndAlso tablaUpdate.StartsWith("tb") Then
                    esUpdatePrincipal = True
                    Exit For
                End If
            End If
        Next
        Dim esSelect As Boolean = contenidoSP.Contains("SELECT ") AndAlso Not contenidoSP.Contains("SELECT 'ERROR'") AndAlso Not contenidoSP.Contains("SELECT 'SUCCESS'") AndAlso Not contenidoSP.Contains("SELECT SCOPE_IDENTITY()")
        Dim esDelete As Boolean = contenidoSP.Contains("DELETE FROM")
        Dim tieneTransaccion As Boolean = contenidoSP.Contains("BEGIN TRANSACTION") OrElse contenidoSP.Contains("BEGIN TRY")
        
        ' Identificar tablas principales utilizadas
        Dim tablas As New HashSet(Of String)
        ' Patrones para diferentes operaciones SQL
        Dim patronesTabla As String() = {
            "INSERT\s+INTO\s+(?:\[?dbo\]?\.)?\[?(\w+)\]?",
            "UPDATE\s+(?:\[?dbo\]?\.)?\[?(\w+)\]?",
            "DELETE\s+FROM\s+(?:\[?dbo\]?\.)?\[?(\w+)\]?",
            "FROM\s+(?:\[?dbo\]?\.)?\[?(\w+)\]?",
            "JOIN\s+(?:\[?dbo\]?\.)?\[?(\w+)\]?",
            "INNER\s+JOIN\s+(?:\[?dbo\]?\.)?\[?(\w+)\]?",
            "LEFT\s+JOIN\s+(?:\[?dbo\]?\.)?\[?(\w+)\]?",
            "RIGHT\s+JOIN\s+(?:\[?dbo\]?\.)?\[?(\w+)\]?"
        }
        
        For Each patron As String In patronesTabla
            Dim matchesTabla As MatchCollection = Regex.Matches(contenidoSP, patron, RegexOptions.IgnoreCase)
            For Each match As Match In matchesTabla
                If match.Groups.Count > 1 Then
                    Dim tabla As String = match.Groups(1).Value.Trim()
                    If tabla.StartsWith("tb") AndAlso tabla.Length > 2 Then
                        tablas.Add(tabla)
                    End If
                End If
            Next
        Next
        
        ' Identificar validaciones
        Dim validaciones As New List(Of String)
        If contenidoSP.Contains("IF @") OrElse contenidoSP.Contains("IF EXISTS") OrElse contenidoSP.Contains("IF NOT EXISTS") Then
            ' Contar validaciones
            Dim patronValidacion As String = "IF\s+(?:@\w+|EXISTS|NOT\s+EXISTS)"
            Dim matchesValidacion As MatchCollection = Regex.Matches(contenidoSP, patronValidacion, RegexOptions.IgnoreCase)
            If matchesValidacion.Count > 0 Then
                validaciones.Add(matchesValidacion.Count & " validaciones de parámetros y existencia de registros")
            End If
        End If
        
        ' Construir descripción detallada
        If nombreUpper.Contains("OBTENER") OrElse nombreUpper.Contains("GET") OrElse nombreUpper.Contains("LISTAR") Then
            descripcion.Append("Obtiene y retorna información desde la base de datos. ")
            If tablas.Count > 0 Then
                descripcion.Append("Consulta las tablas: " & String.Join(", ", tablas) & ". ")
            End If
            If contenidoSP.Contains("WHERE") Then
                descripcion.Append("Aplica filtros según los parámetros recibidos. ")
            End If
        ElseIf nombreUpper.Contains("GUARDAR") OrElse nombreUpper.Contains("SAVE") OrElse nombreUpper.Contains("CREAR") Then
            descripcion.Append("Guarda o crea un nuevo registro en la base de datos. ")
            If validaciones.Count > 0 Then
                descripcion.Append(String.Join(" ", validaciones) & ". ")
            End If
            If esInsert Then
                descripcion.Append("Realiza un INSERT en ")
                If tablas.Count > 0 Then
                    descripcion.Append(String.Join(" y ", tablas) & ". ")
                End If
            End If
            If esUpdatePrincipal Then
                descripcion.Append("Realiza un UPDATE en ")
                If tablas.Count > 0 Then
                    descripcion.Append(String.Join(" y ", tablas) & ". ")
                End If
            End If
            If contenidoSP.Contains("tbControlConsecutivos") Then
                descripcion.Append("Genera un nuevo consecutivo automáticamente. ")
            End If
            If tieneTransaccion Then
                descripcion.Append("Utiliza transacciones para garantizar la integridad de los datos. ")
            End If
        ElseIf nombreUpper.Contains("BUSCAR") OrElse nombreUpper.Contains("SEARCH") OrElse nombreUpper.Contains("FILTRAR") Then
            descripcion.Append("Busca registros aplicando criterios de búsqueda. ")
            If tablas.Count > 0 Then
                descripcion.Append("Consulta en las tablas: " & String.Join(", ", tablas) & ". ")
            End If
            If contenidoSP.Contains("LIKE") OrElse contenidoSP.Contains("%") Then
                descripcion.Append("Soporta búsqueda parcial de texto. ")
            End If
        ElseIf nombreUpper.Contains("ELIMINAR") OrElse nombreUpper.Contains("DELETE") Then
            descripcion.Append("Elimina un registro del sistema. ")
            If contenidoSP.Contains("snEliminado") Then
                descripcion.Append("Realiza eliminación lógica (soft delete) actualizando el campo snEliminado. ")
            Else
                descripcion.Append("Realiza eliminación física del registro. ")
            End If
            If tablas.Count > 0 Then
                descripcion.Append("Elimina de la tabla: " & String.Join(", ", tablas) & ". ")
            End If
        ElseIf nombreUpper.Contains("ACTUALIZAR") OrElse nombreUpper.Contains("UPDATE") Then
            descripcion.Append("Actualiza información de un registro existente. ")
            If validaciones.Count > 0 Then
                descripcion.Append(String.Join(" ", validaciones) & ". ")
            End If
            If tablas.Count > 0 Then
                descripcion.Append("Actualiza la tabla: " & String.Join(", ", tablas) & ". ")
            End If
        ElseIf nombreUpper.Contains("CALCULAR") Then
            descripcion.Append("Realiza cálculos o procesamiento de datos. ")
            If tablas.Count > 0 Then
                descripcion.Append("Utiliza datos de las tablas: " & String.Join(", ", tablas) & ". ")
            End If
        Else
            descripcion.Append("Ejecuta operaciones en la base de datos. ")
            If tablas.Count > 0 Then
                descripcion.Append("Trabaja con las tablas: " & String.Join(", ", tablas) & ". ")
            End If
        End If
        
        ' Agregar información sobre manejo de errores
        If contenidoSP.Contains("BEGIN TRY") AndAlso contenidoSP.Contains("BEGIN CATCH") Then
            descripcion.Append("Incluye manejo de excepciones con TRY-CATCH para capturar y reportar errores. ")
        End If
        
        ' Agregar información sobre retorno de datos
        If contenidoSP.Contains("SELECT SCOPE_IDENTITY()") Then
            descripcion.Append("Retorna el ID del registro creado. ")
        ElseIf contenidoSP.Contains("SELECT 'ERROR'") OrElse contenidoSP.Contains("SELECT 'SUCCESS'") Then
            descripcion.Append("Retorna un resultado indicando éxito o error de la operación. ")
        End If
        
        Return descripcion.ToString().Trim()
    End Function

    Private Shared Function GenerarDescripcionSP(nombreSP As String, contenidoSP As String) As String
        ' Función de respaldo si no se puede analizar
        Dim nombreUpper As String = nombreSP.ToUpper()

        If nombreUpper.Contains("OBTENER") OrElse nombreUpper.Contains("GET") OrElse nombreUpper.Contains("LISTAR") Then
            Return "Obtiene y retorna una lista de registros desde la base de datos"
        ElseIf nombreUpper.Contains("GUARDAR") OrElse nombreUpper.Contains("SAVE") OrElse nombreUpper.Contains("CREAR") Then
            Return "Guarda o crea un nuevo registro en la base de datos. Valida datos antes de realizar la operación"
        ElseIf nombreUpper.Contains("BUSCAR") OrElse nombreUpper.Contains("SEARCH") OrElse nombreUpper.Contains("FILTRAR") Then
            Return "Busca registros aplicando criterios de búsqueda y filtros"
        ElseIf nombreUpper.Contains("ELIMINAR") OrElse nombreUpper.Contains("DELETE") Then
            Return "Elimina lógicamente un registro del sistema (soft delete)"
        ElseIf nombreUpper.Contains("ACTUALIZAR") OrElse nombreUpper.Contains("UPDATE") Then
            Return "Actualiza información de un registro existente en la base de datos"
        ElseIf nombreUpper.Contains("CALCULAR") Then
            Return "Realiza cálculos o procesamiento de datos"
        Else
            Return "Ejecuta operaciones en la base de datos"
        End If
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

            Dim objSql As SBSqlClientInterface = ModGlobal.GetDbaObject(connectionString)
            Dim definicion As String = ""

            Select Case tipo.ToUpper()
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

                Case "FUNCTION"
                    ' Obtener definición de función
                    Dim sSql As String = "SELECT OBJECT_DEFINITION(OBJECT_ID('dbo." & nombreObjeto & "')) AS Definition " &
                                         "UNION ALL " &
                                         "SELECT OBJECT_DEFINITION(OBJECT_ID('" & nombreObjeto & "')) AS Definition"
                    
                    Dim dt As DataTable = objSql.GetDataTableSql(sSql)

                    If objSql.MensajeError <> "" Then
                        sSql = "SELECT m.definition AS Definition " &
                               "FROM sys.objects o " &
                               "INNER JOIN sys.sql_modules m ON m.object_id = o.object_id " &
                               "WHERE o.name = '" & nombreObjeto & "' AND o.type = 'FN'"
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
                        definicion = "No se encontró la definición de la función: " & nombreObjeto
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
    Public Shared Function ObtenerDescripcionLogica(nombreObjeto As String, tipoObjeto As String) As String
        Dim resultado As String = ""
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("Obteniendo descripción lógica de: " & nombreObjeto & " (Tipo: " & tipoObjeto & ")")

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

            ' Obtener descripción desde la tabla
            Dim resultadoBD As Dictionary(Of String, Object) = ObtenerDescripcionDesdeBD(nombreObjeto, tipoObjeto)
            Dim descripcionBD As String = If(resultadoBD.ContainsKey("Descripcion"), resultadoBD("Descripcion").ToString(), "")
            Dim spsLlamadosBD As String = If(resultadoBD.ContainsKey("SPsLlamados"), resultadoBD("SPsLlamados").ToString(), "")
            Dim tablasUtilizadasBD As String = If(resultadoBD.ContainsKey("TablasUtilizadas"), resultadoBD("TablasUtilizadas").ToString(), "")

            Dim response As New With {
                .Resultado = "SUCCESS",
                .Data = New With {
                    .Descripcion = descripcionBD,
                    .SPsLlamados = spsLlamadosBD,
                    .TablasUtilizadas = tablasUtilizadasBD
                },
                .Mensaje = ""
            }

            resultado = serializer.Serialize(response)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerDescripcionLogica: " & ex.Message & " | StackTrace: " & ex.StackTrace)
            Dim errorResponse As New With {
                .Resultado = "ERROR",
                .Data = New With {
                    .Descripcion = "",
                    .SPsLlamados = "",
                    .TablasUtilizadas = ""
                },
                .Mensaje = "Error al obtener descripción lógica: " & ex.Message
            }
            resultado = serializer.Serialize(errorResponse)
        End Try

        Return resultado
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ObtenerEstructuraTabla(nombreTabla As String) As String
        Dim resultado As String = ""
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("Obteniendo estructura de tabla: " & nombreTabla)

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

            Dim objSql As SBSqlClientInterface = ModGlobal.GetDbaObject(connectionString)
            
            ' Obtener información de columnas de la tabla
            Dim sSql As String = "SELECT " &
                "c.COLUMN_NAME AS NombreCampo, " &
                "c.DATA_TYPE AS TipoDato, " &
                "CASE WHEN c.CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN c.DATA_TYPE + '(' + CAST(c.CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + ')' " &
                "     WHEN c.NUMERIC_PRECISION IS NOT NULL AND c.NUMERIC_SCALE IS NOT NULL THEN c.DATA_TYPE + '(' + CAST(c.NUMERIC_PRECISION AS VARCHAR) + ',' + CAST(c.NUMERIC_SCALE AS VARCHAR) + ')' " &
                "     WHEN c.NUMERIC_PRECISION IS NOT NULL THEN c.DATA_TYPE + '(' + CAST(c.NUMERIC_PRECISION AS VARCHAR) + ')' " &
                "     ELSE c.DATA_TYPE END AS TipoDatoCompleto, " &
                "CASE WHEN c.IS_NULLABLE = 'YES' THEN 'Sí' ELSE 'No' END AS PermiteNull, " &
                "ISNULL(c.COLUMN_DEFAULT, '') AS ValorPorDefecto, " &
                "CASE WHEN pk.COLUMN_NAME IS NOT NULL THEN 'Sí' ELSE 'No' END AS EsClavePrimaria " &
                "FROM INFORMATION_SCHEMA.COLUMNS c " &
                "LEFT JOIN (" &
                "    SELECT ku.TABLE_NAME, ku.COLUMN_NAME " &
                "    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc " &
                "    INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE ku ON tc.CONSTRAINT_TYPE = 'PRIMARY KEY' AND tc.CONSTRAINT_NAME = ku.CONSTRAINT_NAME " &
                "    WHERE tc.TABLE_SCHEMA = 'dbo' AND tc.TABLE_NAME = @NombreTabla " &
                ") pk ON c.COLUMN_NAME = pk.COLUMN_NAME AND c.TABLE_NAME = pk.TABLE_NAME " &
                "WHERE c.TABLE_SCHEMA = 'dbo' AND c.TABLE_NAME = @NombreTabla " &
                "ORDER BY c.ORDINAL_POSITION"

            With objSql.Parametros
                .Clear()
                .Add("@NombreTabla", nombreTabla)
            End With

            Dim dt As DataTable = objSql.GetDataTableSql(sSql)

            If objSql.MensajeError <> "" Then
                Throw New Exception("Error en BD: " & objSql.MensajeError)
            End If

            Dim columnas As New List(Of Object)
            If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
                For Each row As DataRow In dt.Rows
                    columnas.Add(New With {
                        .NombreCampo = row("NombreCampo").ToString(),
                        .TipoDato = row("TipoDato").ToString(),
                        .TipoDatoCompleto = row("TipoDatoCompleto").ToString(),
                        .PermiteNull = row("PermiteNull").ToString(),
                        .ValorPorDefecto = If(IsDBNull(row("ValorPorDefecto")), "", row("ValorPorDefecto").ToString()),
                        .EsClavePrimaria = row("EsClavePrimaria").ToString()
                    })
                Next
            End If

            Dim response As New With {
                .Resultado = "SUCCESS",
                .Data = New With {
                    .NombreTabla = nombreTabla,
                    .Columnas = columnas
                },
                .Mensaje = ""
            }

            resultado = serializer.Serialize(response)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerEstructuraTabla: " & ex.Message & " | StackTrace: " & ex.StackTrace)
            Dim errorResponse As New With {
                .Resultado = "ERROR",
                .Data = New With {
                    .NombreTabla = nombreTabla,
                    .Columnas = New List(Of Object)
                },
                .Mensaje = "Error al obtener estructura de tabla: " & ex.Message
            }
            resultado = serializer.Serialize(errorResponse)
        End Try

        Return resultado
    End Function

    Private Shared Function GenerarDescripcionProcesoCliente(nombreFuncion As String, cuerpoFuncion As String, tieneAjax As Boolean) As String
        Dim proceso As String = ""
        
        If tieneAjax Then
            proceso = "La función " & nombreFuncion & " realiza una llamada AJAX al servidor. "
            
            ' Detectar qué tipo de operación
            If cuerpoFuncion.Contains("Obtener") OrElse cuerpoFuncion.Contains("Get") OrElse cuerpoFuncion.Contains("Listar") Then
                proceso &= "Solicita datos al servidor y procesa la respuesta para actualizar la interfaz de usuario."
            ElseIf cuerpoFuncion.Contains("Guardar") OrElse cuerpoFuncion.Contains("Save") OrElse cuerpoFuncion.Contains("Crear") Then
                proceso &= "Envía datos al servidor para guardar o crear un nuevo registro. Muestra mensajes de confirmación o error al usuario."
            ElseIf cuerpoFuncion.Contains("Eliminar") OrElse cuerpoFuncion.Contains("Delete") Then
                proceso &= "Solicita la eliminación de un registro al servidor. Confirma la operación con el usuario antes de ejecutarla."
            ElseIf cuerpoFuncion.Contains("Actualizar") OrElse cuerpoFuncion.Contains("Update") Then
                proceso &= "Envía datos actualizados al servidor. Valida los cambios antes de enviarlos."
            Else
                proceso &= "Comunica con el servidor para realizar una operación específica."
            End If
        Else
            proceso = "La función " & nombreFuncion & " manipula elementos del DOM y gestiona la interacción del usuario con la interfaz."
        End If
        
        Return proceso
    End Function

    Private Shared Function GenerarDescripcionProcesoServidor(nombreMetodo As String, cuerpoMetodo As String, objetoSQL As String, validaciones As List(Of String)) As String
        Dim proceso As String = "El método " & nombreMetodo & " recibe una solicitud del cliente. "
        
        ' Agregar validaciones
        If validaciones.Count > 0 Then
            proceso &= "Primero valida los parámetros recibidos: " & String.Join(", ", validaciones) & ". "
        End If
        
        ' Agregar operación en BD
        If Not String.IsNullOrEmpty(objetoSQL) AndAlso objetoSQL <> "No identificado" Then
            proceso &= "Luego ejecuta la operación en la base de datos mediante " & objetoSQL & ". "
        End If
        
        ' Agregar respuesta
        proceso &= "Finalmente, retorna los resultados al cliente en formato JSON."
        
        Return proceso
    End Function

End Class
