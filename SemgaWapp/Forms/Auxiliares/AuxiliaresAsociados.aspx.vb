Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Web.Script.Serialization
Imports SBSqlClient
Imports SBUtility
Imports System.Data
Imports System.Web.Security
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq

Public Class AuxiliaresAsociados
	Inherits BasePage

	Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
		' Verificar sesión
		If Session(VariablesSesion.UsuarioId) Is Nothing Then
			Response.Redirect("~/Login.aspx")
			Return
		End If
		If ModGlobal.ValidarYRedirigirSiSinPermiso(HttpContext.Current) Then Return
	End Sub

	' Propiedad pública para exponer el nivel de acceso al JavaScript
	Public ReadOnly Property NivelAccesoUsuario() As Integer
		Get
			If Session(VariablesSesion.NivelAcceso) IsNot Nothing Then
				Return Convert.ToInt32(Session(VariablesSesion.NivelAcceso))
			Else
				Return 999
			End If
		End Get
	End Property

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerRubros() As Object
		Try
			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spAuxiliares_ObtenerRubros"
			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener rubros: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Data = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Crear lista de objetos simples para evitar referencias circulares
			Dim rubros As New List(Of Object)

			For Each row As DataRow In dt.Rows
				Dim rubro As New With {
					.CodigoRubro = row("CodigoRubro").ToString(),
					.Descripcion = row("Descripcion").ToString()
				}
				rubros.Add(rubro)
			Next

			Return New With {
				.Resultado = "SUCCESS",
				.Data = New JavaScriptSerializer().Serialize(rubros),
				.Mensaje = ""
			}
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ObtenerRubros: " & ex.Message)
			Return New With {
				.Resultado = "ERROR",
				.Data = "",
				.Mensaje = "Error al obtener rubros: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerTiposAuxiliares() As Object
		Try
			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spAuxiliares_ObtenerTiposAuxiliares"
			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener tipos de auxiliares: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Data = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Crear lista de objetos simples para evitar referencias circulares
			Dim tiposAuxiliares As New List(Of Object)

			For Each row As DataRow In dt.Rows
				Dim tipoAuxiliar As New With {
					.TipoAuxiliar = row("TipoAuxiliar").ToString(),
					.IdTipoAuxiliar = row("IdTipoAuxiliar").ToString(),
					.Descripcion = row("Descripcion").ToString(),
					.CodigoRubro = row("CodigoRubro").ToString(),
					.Tasa = If(row("Tasa") Is DBNull.Value, 0, Convert.ToDecimal(row("Tasa"))),
					.PorManejo = If(row("PorManejo") Is DBNull.Value, 0, Convert.ToDecimal(row("PorManejo"))),
					.PorCapitalizacion = If(row("PorCapitalizacion") Is DBNull.Value, 0, Convert.ToDecimal(row("PorCapitalizacion")))
				}
				tiposAuxiliares.Add(tipoAuxiliar)
			Next

			Return New With {
				.Resultado = "SUCCESS",
				.Data = New JavaScriptSerializer().Serialize(tiposAuxiliares),
				.Mensaje = ""
			}
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ObtenerTiposAuxiliares: " & ex.Message)
			Return New With {
				.Resultado = "ERROR",
				.Data = "",
				.Mensaje = "Error al obtener tipos de auxiliares: " & ex.Message
			}
		End Try
	End Function


	' WEBMETHOD NO UTILIZADO - Comentado porque se usa ObtenerTodosAuxiliares() en su lugar
	'<WebMethod()>
	'<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	'Public Shared Function ObtenerAuxiliares() As Object
	'	Try
	'		Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
	'		Dim sSql As String = "Exec spAuxiliares_ObtenerAuxiliares"
	'		ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
	'		Dim dt As DataTable = objSql.GetDataTableSql(sSql)

	'		' Verificar si hubo error en la base de datos
	'		If objSql.MensajeError <> "" Then
	'			ModGlobal.EscribirLog("Error en BD al obtener auxiliares: " & objSql.MensajeError)
	'			Return New With {
	'				.Resultado = "ERROR",
	'				.Data = "",
	'				.Mensaje = "Error en la base de datos: " & objSql.MensajeError
	'			}
	'		End If

	'		' Crear lista de objetos simples para evitar referencias circulares
	'		Dim auxiliares As New List(Of Object)

	'		For Each row As DataRow In dt.Rows
	'			Dim auxiliar As New With {
	'				.ID = row("ID").ToString(),
	'				.Cuenta = If(row("Cuenta") Is DBNull.Value, "", row("Cuenta").ToString()),
	'				.NumeroAsociado = row("NumeroAsociado").ToString(),
	'				.NombreAsociado = row("NombreAsociado").ToString(),
	'				.CodTipoDoc = If(row("CodTipoDoc") Is DBNull.Value, "", row("CodTipoDoc").ToString()),
	'				.NumeroIdentificacion = If(row("NumeroIdentificacion") Is DBNull.Value, "", row("NumeroIdentificacion").ToString()),
	'				.CodigoRubro = row("CodigoRubro").ToString(),
	'				.DescripcionRubro = row("DescripcionRubro").ToString(),
	'				.TipoAuxiliar = row("TipoAuxiliar").ToString(),
	'				.DescripcionTipoAuxiliar = row("DescripcionTipoAuxiliar").ToString(),
	'				.IdTipoAuxiliar = row("IdTipoAuxiliar").ToString(),
	'				.Cuota = row("Cuota").ToString(),
	'				.Saldo = row("Saldo").ToString(),
	'				.MontoOriginal = row("MontoOriginal").ToString(),
	'				.MontoPignorado = row("MontoPignorado").ToString(),
	'				.TasaInteres = row("TasaInteres").ToString(),
	'				.PagoMes = row("PagoMes").ToString(),
	'				.FechaOtorgado = If(row("FechaOtorgado") Is DBNull.Value, "", row("FechaOtorgado").ToString()),
	'				.FechaUltimoPago = If(row("FechaUltimoPago") Is DBNull.Value, "", row("FechaUltimoPago").ToString()),
	'				.FechaCreacion = If(row("FechaCreacion") Is DBNull.Value, "", row("FechaCreacion").ToString()),
	'				.UsuarioCrea = If(row("UsuarioCrea") Is DBNull.Value, "", row("UsuarioCrea").ToString()),
	'				.UsuarioModifica = If(row("UsuarioModifica") Is DBNull.Value, "", row("UsuarioModifica").ToString()),
	'				.snActivo = If(row("snActivo") Is DBNull.Value, False, Convert.ToBoolean(row("snActivo")))
	'			}
	'			auxiliares.Add(auxiliar)
	'		Next

	'		Return New With {
	'			.Resultado = "SUCCESS",
	'			.Data = New JavaScriptSerializer().Serialize(auxiliares),
	'			.Mensaje = ""
	'		}
	'	Catch ex As Exception
	'		ModGlobal.EscribirLog("Error en ObtenerAuxiliares: " & ex.Message)
	'		Return New With {
	'			.Resultado = "ERROR",
	'			.Data = "",
	'			.Mensaje = "Error al obtener auxiliares: " & ex.Message
	'		}
	'	End Try
	'End Function

	''' <summary>
	''' Obtiene auxiliares con paginación y ordenación server-side (mismo patrón que GestionSocios).
	''' filtrosJson: { FiltroBusqueda, CodigoRubro, IdTipoAuxiliar, PageSize, PageIndex, SortColumn, SortDirection }
	''' </summary>
	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerAuxiliares(filtrosJson As String) As String
		Try
			ModGlobal.EscribirLog("Ejecutando ObtenerAuxiliares (paginado)")
			Dim filtros = JsonConvert.DeserializeObject(Of JObject)(filtrosJson)
			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spAuxiliares_ObtenerAuxiliares"

			With objSql.Parametros
				Dim busqueda As String = If(filtros("FiltroBusqueda") IsNot Nothing, filtros("FiltroBusqueda").ToString().Trim(), Nothing)
				If Not String.IsNullOrEmpty(busqueda) Then .Add("@Busqueda", busqueda)
				Dim codigoRubro As String = If(filtros("CodigoRubro") IsNot Nothing, filtros("CodigoRubro").ToString().Trim(), Nothing)
				If Not String.IsNullOrEmpty(codigoRubro) Then .Add("@CodigoRubro", codigoRubro)
				Dim idTipoAuxiliar As Integer = 0
				If filtros("IdTipoAuxiliar") IsNot Nothing Then Integer.TryParse(filtros("IdTipoAuxiliar").ToString(), idTipoAuxiliar)
				If idTipoAuxiliar <> 0 Then .Add("@IdTipoAuxiliar", idTipoAuxiliar)
				Dim pageSize As Integer = 25
				Dim pageIndex As Integer = 0
				Dim sortColumn As Integer = 1
				Dim sortDirection As String = "desc"
				If filtros("PageSize") IsNot Nothing Then Integer.TryParse(filtros("PageSize").ToString(), pageSize)
				If filtros("PageIndex") IsNot Nothing Then Integer.TryParse(filtros("PageIndex").ToString(), pageIndex)
				If filtros("SortColumn") IsNot Nothing Then Integer.TryParse(filtros("SortColumn").ToString(), sortColumn)
				If filtros("SortDirection") IsNot Nothing Then sortDirection = filtros("SortDirection").ToString()
				If pageSize < 1 Then pageSize = 25
				If pageIndex < 0 Then pageIndex = 0
				If sortColumn < 1 OrElse sortColumn > 11 Then sortColumn = 1
				If String.IsNullOrEmpty(sortDirection) OrElse (sortDirection <> "asc" AndAlso sortDirection <> "desc") Then sortDirection = "desc"
				.Add("@PageSize", pageSize)
				.Add("@PageIndex", pageIndex)
				.Add("@SortColumn", sortColumn)
				.Add("@SortDirection", sortDirection)
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener auxiliares: " & objSql.MensajeError)
				Dim resultError As New Dictionary(Of String, Object)
				resultError("Success") = False
				resultError("Message") = objSql.MensajeError
				resultError("TotalRegistros") = 0
				resultError("Data") = New List(Of Object)
				Return New JavaScriptSerializer().Serialize(resultError)
			End If

			Dim totalRegistros As Integer = 0
			If dt.Rows.Count > 0 AndAlso dt.Columns.Contains("TotalRegistros") Then
				Integer.TryParse(dt.Rows(0)("TotalRegistros").ToString(), totalRegistros)
			End If

			Dim jsonData As New List(Of Dictionary(Of String, Object))
			For Each row As DataRow In dt.Rows
				Dim item As New Dictionary(Of String, Object)
				For Each col As DataColumn In dt.Columns
					If col.ColumnName <> "TotalRegistros" Then
						item(col.ColumnName) = If(row(col) Is DBNull.Value, Nothing, row(col))
					End If
				Next
				jsonData.Add(item)
			Next

			Dim result As New Dictionary(Of String, Object)
			result("Success") = True
			result("Message") = ""
			result("TotalRegistros") = totalRegistros
			result("Data") = jsonData
			Return New JavaScriptSerializer().Serialize(result)
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ObtenerAuxiliares: " & ex.Message)
			Dim result As New Dictionary(Of String, Object)
			result("Success") = False
			result("Message") = ex.Message
			result("TotalRegistros") = 0
			result("Data") = New List(Of Object)
			Return New JavaScriptSerializer().Serialize(result)
		End Try
	End Function

	''' <summary>
	''' Obtiene un auxiliar por ID para edición. Usa el mismo SP spAuxiliares_ObtenerAuxiliares con @IDAuxiliar.
	''' </summary>
	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerAuxiliar(idAuxiliar As Integer) As String
		Try
			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spAuxiliares_ObtenerAuxiliares"
			objSql.Parametros.Add("@IDAuxiliar", idAuxiliar)

			ModGlobal.EscribirLog($"Ejecutando ObtenerAuxiliar ID={idAuxiliar}: {sSql}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener auxiliar: " & objSql.MensajeError)
				Dim resultError As New Dictionary(Of String, Object)
				resultError("Success") = False
				resultError("Message") = objSql.MensajeError
				resultError("Data") = Nothing
				Return New JavaScriptSerializer().Serialize(resultError)
			End If

			If dt.Rows.Count = 0 Then
				Dim resultNotFound As New Dictionary(Of String, Object)
				resultNotFound("Success") = False
				resultNotFound("Message") = "No se encontró el auxiliar."
				resultNotFound("Data") = Nothing
				Return New JavaScriptSerializer().Serialize(resultNotFound)
			End If

			Dim row As DataRow = dt.Rows(0)
			Dim item As New Dictionary(Of String, Object)
			For Each col As DataColumn In dt.Columns
				If col.ColumnName <> "TotalRegistros" Then
					item(col.ColumnName) = If(row(col) Is DBNull.Value, Nothing, row(col))
				End If
			Next

			Dim result As New Dictionary(Of String, Object)
			result("Success") = True
			result("Message") = ""
			result("Data") = item
			Return New JavaScriptSerializer().Serialize(result)
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ObtenerAuxiliar: " & ex.Message)
			Dim result As New Dictionary(Of String, Object)
			result("Success") = False
			result("Message") = ex.Message
			result("Data") = Nothing
			Return New JavaScriptSerializer().Serialize(result)
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function BuscarAsociados(busqueda As String) As Object
		Try
			ModGlobal.EscribirLog("BuscarAsociados iniciado. Búsqueda: " & busqueda)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))

			' Detectar si es un número (ID) o texto
			Dim esNumero As Boolean = False
			Dim numeroAsociado As Integer = 0

			If Integer.TryParse(busqueda, numeroAsociado) Then
				esNumero = True
				ModGlobal.EscribirLog("Búsqueda por ID detectada: " & numeroAsociado)
			Else
				ModGlobal.EscribirLog("Búsqueda por texto detectada: " & busqueda)
			End If

			Dim sSql As String
			If esNumero Then
				sSql = "Exec spBuscarAsociadoPorID"
				ModGlobal.EscribirLog("Ejecutando SQL por ID: " & sSql)
				With objSql.Parametros
					.Add("@NumeroAsociado", numeroAsociado)
				End With
			Else
				sSql = "Exec spBuscarAsociados"
				ModGlobal.EscribirLog("Ejecutando SQL por texto: " & sSql)
				With objSql.Parametros
					.Add("@Busqueda", busqueda)
				End With
			End If

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al buscar asociados: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Data = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			ModGlobal.EscribirLog("Resultados encontrados: " & dt.Rows.Count & " registros")

			' Crear lista de objetos simples para evitar referencias circulares
			Dim asociados As New List(Of Object)

			If dt.Rows.Count > 0 Then
				' Log de columnas disponibles para debugging
				Dim columnasDisponibles As String = String.Join(", ", dt.Columns.Cast(Of DataColumn)().Select(Function(c) c.ColumnName))
				ModGlobal.EscribirLog("📋 Columnas disponibles en DataTable: " & columnasDisponibles)

				For i As Integer = 0 To dt.Rows.Count - 1
					Dim row As DataRow = dt.Rows(i)
					Dim cantidadAuxiliares As Integer = 0

					' Verificar si la columna existe antes de leerla
					If dt.Columns.Contains("CantAuxiliares") Then
						If Not IsDBNull(row("CantAuxiliares")) Then
							Integer.TryParse(row("CantAuxiliares").ToString(), cantidadAuxiliares)
							ModGlobal.EscribirLog("CantAuxiliares leído para asociado " & row("NumeroAsociado").ToString() & ": " & cantidadAuxiliares)
						Else
							ModGlobal.EscribirLog("CantAuxiliares es NULL para asociado " & row("NumeroAsociado").ToString())
						End If
					Else
						ModGlobal.EscribirLog("Columna 'CantAuxiliares' no existe en el DataTable")
					End If

					Dim asociado As New With {
						.NumeroAsociado = row("NumeroAsociado").ToString(),
						.NombreCompleto = row("NombreCompleto").ToString(),
						.NumeroIdentificacion = row("NumeroIdentificacion").ToString(),
						.TipoAsociado = row("TipoAsociado").ToString(),
						.CodTipoDoc = If(row("CodTipoDoc") Is DBNull.Value, "", row("CodTipoDoc").ToString()),
						.CantidadAuxiliares = cantidadAuxiliares
					}
					asociados.Add(asociado)

					If i < 5 Then
						ModGlobal.EscribirLog("👤 Asociado #" & (i + 1) & ": " & row("NombreCompleto").ToString() & " - " & row("NumeroAsociado").ToString() & " - Auxiliares: " & cantidadAuxiliares)
					End If
				Next
			End If

			Dim jsonData As String = New JavaScriptSerializer().Serialize(asociados)
			ModGlobal.EscribirLog("JSON generado (primeros 200 chars): " & jsonData.Substring(0, Math.Min(200, jsonData.Length)))

			Return New With {
				.Resultado = "SUCCESS",
				.Data = jsonData,
				.Mensaje = ""
			}
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en BuscarAsociados: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Data = "",
				.Mensaje = "Error al buscar asociados: " & ex.Message
			}
		End Try
	End Function

	' FUNCIÓN NO UTILIZADA - Comentada porque no se usa (se usa CDbl directamente en GuardarAuxiliar)
	' Función para normalizar valores numéricos en el servidor
	'Private Shared Function NormalizarValorNumerico(valor As Object) As Decimal
	'	If valor Is Nothing Then Return 0

	'	Dim valorStr As String = valor.ToString()
	'	If String.IsNullOrEmpty(valorStr) Then Return 0

	'	' Convertir coma a punto para formato decimal
	'	valorStr = valorStr.Replace(",", ".")

	'	' Intentar parsear como decimal
	'	Dim resultado As Decimal = 0
	'	If Decimal.TryParse(valorStr, resultado) Then
	'		Return resultado
	'	Else
	'		Return 0
	'	End If
	'End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GuardarAuxiliar(auxiliar As Object) As Object
		Try
			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim auxiliarDict As Dictionary(Of String, Object) = DirectCast(auxiliar, Dictionary(Of String, Object))

			' Log de los valores recibidos
			ModGlobal.EscribirLog("GuardarAuxiliar - Valores recibidos:")
			ModGlobal.EscribirLog($"  TasaInteres: {auxiliarDict("TasaInteres")} (Tipo: {auxiliarDict("TasaInteres").GetType().Name})")
			ModGlobal.EscribirLog($"  PagoMes: {auxiliarDict("PagoMes")} (Tipo: {auxiliarDict("PagoMes").GetType().Name})")
			ModGlobal.EscribirLog($"  Saldo: {auxiliarDict("Saldo")} (Tipo: {auxiliarDict("Saldo").GetType().Name})")

			' Normalizar valores numéricos
			Dim cuotaNormalizada As Decimal = CDbl(auxiliarDict("Cuota")) 'NormalizarValorNumerico(auxiliarDict("Cuota"))
			Dim saldoNormalizado As Decimal = CDbl(auxiliarDict("Saldo")) ' NormalizarValorNumerico(auxiliarDict("Saldo"))
			Dim montoOriginalNormalizado As Decimal = CDbl(auxiliarDict("MontoOriginal")) 'NormalizarValorNumerico(auxiliarDict("MontoOriginal"))
			Dim montoPignoradoNormalizado As Decimal = CDbl(auxiliarDict("MontoPignorado"))
			Dim tasaInteresNormalizada As Decimal = CDbl(auxiliarDict("TasaInteres")) 'NormalizarValorNumerico(auxiliarDict("TasaInteres"))
			Dim pagoMesNormalizado As Decimal = auxiliarDict("PagoMes") 'NormalizarValorNumerico(auxiliarDict("PagoMes"))

			' Normalizar nuevos valores de manejo y capitalización
			Dim porcManejoNormalizado As Decimal = 0
			Dim porcCapNormalizado As Decimal = 0
			Dim montoManejoNormalizado As Decimal = 0
			Dim montoCapNormalizado As Decimal = 0

			If auxiliarDict.ContainsKey("PorcManejo") Then
				porcManejoNormalizado = CDbl(auxiliarDict("PorcManejo"))
			End If
			If auxiliarDict.ContainsKey("PorcCap") Then
				porcCapNormalizado = CDbl(auxiliarDict("PorcCap"))
			End If
			If auxiliarDict.ContainsKey("MontoManejo") Then
				montoManejoNormalizado = CDbl(auxiliarDict("MontoManejo"))
			End If
			If auxiliarDict.ContainsKey("MontoCap") Then
				montoCapNormalizado = CDbl(auxiliarDict("MontoCap"))
			End If

			ModGlobal.EscribirLog("GuardarAuxiliar - Valores normalizados:")
			ModGlobal.EscribirLog($"  Cuota: {cuotaNormalizada}")
			ModGlobal.EscribirLog($"  Saldo: {saldoNormalizado}")
			ModGlobal.EscribirLog($"  MontoOriginal: {montoOriginalNormalizado}")
			ModGlobal.EscribirLog($"  MontoPignorado: {montoPignoradoNormalizado}")
			ModGlobal.EscribirLog($"  TasaInteres: {tasaInteresNormalizada}")
			ModGlobal.EscribirLog($"  PagoMes: {pagoMesNormalizado}")
			ModGlobal.EscribirLog($"  PorcManejo: {porcManejoNormalizado}")
			ModGlobal.EscribirLog($"  PorcCap: {porcCapNormalizado}")
			ModGlobal.EscribirLog($"  MontoManejo: {montoManejoNormalizado}")
			ModGlobal.EscribirLog($"  MontoCap: {montoCapNormalizado}")

			Dim sSql As String = "Exec spAuxiliares_GuardarAuxiliar"

			With objSql.Parametros
				.Add("@ID", If(auxiliarDict("ID"), 0))
				.Add("@NumeroAsociado", auxiliarDict("NumeroAsociado"))
				.Add("@CodigoRubro", auxiliarDict("CodigoRubro"))
				.Add("@TipoAuxiliar", auxiliarDict("TipoAuxiliar"))
				.Add("@Cuota", cuotaNormalizada)
				.Add("@Saldo", saldoNormalizado)
				.Add("@MontoOriginal", montoOriginalNormalizado)
				.Add("@MontoPignorado", montoPignoradoNormalizado)

				If Not (String.IsNullOrEmpty(auxiliarDict("FechaOtorgado").ToString())) Then
					.Add("@FechaOtorgado", auxiliarDict("FechaOtorgado").ToString())
				End If


				.Add("@TasaInteres", tasaInteresNormalizada)
				.Add("@PagoMes", pagoMesNormalizado)
				.Add("@UsuarioID", HttpContext.Current.Session(VariablesSesion.UsuarioId))
				.Add("@PorcManejo", porcManejoNormalizado)
				.Add("@PorcCap", porcCapNormalizado)
				.Add("@MontoManejo", montoManejoNormalizado)
				.Add("@MontoCap", montoCapNormalizado)
				.Add("@IdSession", HttpContext.Current.Session(VariablesSesion.logID).ToString())
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al guardar auxiliar: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			If dt.Rows.Count > 0 Then
				Dim row As DataRow = dt.Rows(0)
				Return New With {
					.Resultado = row("Resultado").ToString(),
					.Mensaje = row("Mensaje").ToString()
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del procedimiento almacenado"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GuardarAuxiliar: " & ex.Message)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al guardar auxiliar: " & ex.Message
			}
		End Try
	End Function



	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function EliminarAuxiliar(id As Integer, numeroAsociado As Integer) As Object
		Try
			' Verificar nivel de acceso - solo permitir si el nivel es 0 o 1
			Dim nivelAcceso As Integer = 999
			If HttpContext.Current.Session("NivelAcceso") IsNot Nothing Then
				nivelAcceso = Convert.ToInt32(HttpContext.Current.Session("NivelAcceso"))
			End If

			If nivelAcceso <> 0 AndAlso nivelAcceso <> 1 Then
				ModGlobal.EscribirLog($"Intento de eliminación denegado. Usuario ID: {HttpContext.Current.Session(VariablesSesion.UsuarioId)}, NivelAcceso: {nivelAcceso}")
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No tiene permisos para eliminar auxiliares. Solo usuarios con nivel de acceso 0 o 1 pueden realizar esta acción."
				}
			End If

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spAuxiliares_EliminarAuxiliar"

			With objSql.Parametros
				.Add("@ID", id)
				.Add("@NumeroAsociado", numeroAsociado)
				.Add("@UsuarioID", HttpContext.Current.Session(VariablesSesion.UsuarioId))
				.Add("@IdSession", HttpContext.Current.Session(VariablesSesion.logID).ToString())
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al eliminar auxiliar: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			If dt.Rows.Count > 0 Then
				Dim row As DataRow = dt.Rows(0)
				Return New With {
					.Resultado = row("Resultado").ToString(),
					.Mensaje = row("Mensaje").ToString()
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del procedimiento almacenado"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en EliminarAuxiliar: " & ex.Message)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al eliminar auxiliar: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ActivarDesactivarAuxiliar(id As Integer, numeroAsociado As Integer, snActivo As Boolean) As Object
		Try
			' Verificar nivel de acceso - solo permitir si el nivel es 0 o 1
			Dim nivelAcceso As Integer = 999
			If HttpContext.Current.Session("NivelAcceso") IsNot Nothing Then
				nivelAcceso = Convert.ToInt32(HttpContext.Current.Session("NivelAcceso"))
			End If

			If nivelAcceso <> 0 AndAlso nivelAcceso <> 1 Then
				ModGlobal.EscribirLog($"Intento de activar/desactivar denegado. Usuario ID: {HttpContext.Current.Session(VariablesSesion.UsuarioId)}, NivelAcceso: {nivelAcceso}")
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No tiene permisos para activar/desactivar auxiliares. Solo usuarios con nivel de acceso 0 o 1 pueden realizar esta acción."
				}
			End If

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spAuxiliares_ActivarDesactivar"

			Dim idSession As String = ""
			If HttpContext.Current.Session(VariablesSesion.logID) IsNot Nothing Then
				idSession = HttpContext.Current.Session(VariablesSesion.logID).ToString()
			End If

			With objSql.Parametros
				.Add("@ID", id)
				.Add("@NumeroAsociado", numeroAsociado)
				.Add("@UsuarioID", HttpContext.Current.Session(VariablesSesion.UsuarioId))
				.Add("@snActivo", snActivo)
				.Add("@IdSession", idSession)
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al activar/desactivar auxiliar: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			If dt.Rows.Count > 0 Then
				Dim row As DataRow = dt.Rows(0)
				Return New With {
					.Resultado = row("Resultado").ToString(),
					.Mensaje = row("Mensaje").ToString()
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del procedimiento almacenado"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ActivarDesactivarAuxiliar: " & ex.Message)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al cambiar el estado del auxiliar: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ModificarMontoPignorado(auxiliarID As Integer, numeroAsociado As Integer, nuevoMonto As Decimal) As Object
		Try
			' Verificar nivel de acceso
			Dim nivelAcceso As Integer = Convert.ToInt32(HttpContext.Current.Session("NivelAcceso"))
			If nivelAcceso > 1 Then
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No tiene permisos para realizar esta acción"
				}
			End If

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spAuxiliares_ModificarMontoPignorado"

			With objSql.Parametros
				.Add("@AuxiliarID", auxiliarID)
				.Add("@NumeroAsociado", numeroAsociado)
				.Add("@NuevoMonto", nuevoMonto)
				.Add("@UsuarioModifica", HttpContext.Current.Session(VariablesSesion.UsuarioId))
				.Add("@IdSession", HttpContext.Current.Session(VariablesSesion.logID).ToString())
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al modificar monto pignorado: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			If dt.Rows.Count > 0 Then
				Dim row As DataRow = dt.Rows(0)
				Return New With {
					.Resultado = "OK",
					.Mensaje = row("Mensaje").ToString()
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del procedimiento almacenado"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ModificarMontoPignorado: " & ex.Message)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al modificar monto pignorado: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GenerarComprobanteAuxiliar(auxiliarID As Integer, numeroAsociado As Integer) As Object
		Try
			ModGlobal.EscribirLog($"GenerarComprobanteAuxiliar iniciado. AuxiliarID: {auxiliarID}, NumeroAsociado: {numeroAsociado}")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))

			' Obtener datos del auxiliar usando stored procedure específico para comprobante
			Dim sSql As String = "Exec spAuxiliares_ObtenerDatosComprobante"
			With objSql.Parametros
				.Clear()
				.Add("@AuxiliarID", auxiliarID)
				.Add("@NumeroAsociado", numeroAsociado)
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener datos del auxiliar: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			If dt.Rows.Count = 0 Then
				ModGlobal.EscribirLog("No se encontró el auxiliar con ID: " & auxiliarID & " y NumeroAsociado: " & numeroAsociado)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se encontró el auxiliar"
				}
			End If

			Dim auxiliarRow As DataRow = dt.Rows(0)

			' Formatear AuxiliarID con ceros a la izquierda
			Dim auxiliarIdFormateado As String = Right("000000000000" & auxiliarID.ToString(), 12)

			' Numero del auxiliar: DescripcionTipoAuxiliar + ' # ' + ID (solo ID en negrita, sin recuadro rojo)
			Dim descripcionTipoAuxiliar As String = auxiliarRow("DescripcionTipoAuxiliar").ToString()
			Dim auxiliarNumeroDisplay As String = descripcionTipoAuxiliar & " # <span class=""numero-cuenta"">" & auxiliarIdFormateado & "</span>"

			' Formatear Fecha Otorgado
			Dim fechaOtorgado As String = ""
			If Not IsDBNull(auxiliarRow("FechaOtorgado")) Then
				fechaOtorgado = Convert.ToDateTime(auxiliarRow("FechaOtorgado")).ToString("dd/MM/yyyy")
			End If

			' Obtener montos del SP (MontoTotal, MontoDesembolso vienen del SP)
			Dim montoTotal As Decimal = If(IsDBNull(auxiliarRow("MontoTotal")), 0, Convert.ToDecimal(auxiliarRow("MontoTotal")))
			Dim montoTotalFormateado As String = montoTotal.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)

			' Obtener montos y cuota
			Dim cuota As Decimal = If(IsDBNull(auxiliarRow("Cuota")), 0, Convert.ToDecimal(auxiliarRow("Cuota")))
			Dim porcManejo As Decimal = If(IsDBNull(auxiliarRow("PorcManejo")), 0, Convert.ToDecimal(auxiliarRow("PorcManejo")))
			Dim porcCapitalizacion As Decimal = If(IsDBNull(auxiliarRow("PorcCapitalizacion")), 0, Convert.ToDecimal(auxiliarRow("PorcCapitalizacion")))
			Dim montoManejo As Decimal = If(IsDBNull(auxiliarRow("MontoManejo")), 0, Convert.ToDecimal(auxiliarRow("MontoManejo")))
			Dim montoCapitalizacion As Decimal = If(IsDBNull(auxiliarRow("MontoCapitalizacion")), 0, Convert.ToDecimal(auxiliarRow("MontoCapitalizacion")))
			Dim montoDesembolso As Decimal = If(IsDBNull(auxiliarRow("MontoDesembolso")), 0, Convert.ToDecimal(auxiliarRow("MontoDesembolso")))

			Dim montoManejoFormateado As String = montoManejo.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)
			Dim montoCapitalizacionFormateado As String = montoCapitalizacion.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)
			Dim montoDesembolsoFormateado As String = montoDesembolso.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)
			Dim cuotaFormateada As String = cuota.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)

			' Tasa de interés
			Dim tasaInteres As Decimal = If(IsDBNull(auxiliarRow("TasaInteres")), 0, Convert.ToDecimal(auxiliarRow("TasaInteres")))
			Dim tasaInteresTexto As String = "Tasa Interés: " & tasaInteres.ToString("0.00") & "%"

			' DescripcionRubro para TOTAL
			Dim descripcionRubro As String = If(IsDBNull(auxiliarRow("DescripcionRubro")), "", auxiliarRow("DescripcionRubro").ToString())
			Dim descripcionTransaccionTotal As String = "TOTAL " & descripcionRubro

			' Leer el template HTML (plantilla específica para auxiliares)
			Dim templatePath As String = HttpContext.Current.Server.MapPath("~/Forms/Transacciones/ComprobanteAuxiliar.html")
			Dim htmlTemplate As String = System.IO.File.ReadAllText(templatePath)

			' Obtener nombre de usuario
			Dim usuarioNombre As String = ""
			If Not IsDBNull(auxiliarRow("UsuarioNombre")) Then
				usuarioNombre = auxiliarRow("UsuarioNombre").ToString()
			End If

			' Reemplazar placeholders
			htmlTemplate = htmlTemplate.Replace("@AuxiliarNumeroDisplay", auxiliarNumeroDisplay)
			htmlTemplate = htmlTemplate.Replace("@FechaOtorgado", fechaOtorgado)
			htmlTemplate = htmlTemplate.Replace("@Usuario", usuarioNombre)
			htmlTemplate = htmlTemplate.Replace("@NumeroAsociado", auxiliarRow("NumeroAsociado").ToString())
			htmlTemplate = htmlTemplate.Replace("@NombreAsociado", auxiliarRow("NombreAsociado").ToString())

			' Identificación del asociado
			Dim tipoIdentificacion As String = ""
			Dim numeroIdentificacion As String = ""
			If Not IsDBNull(auxiliarRow("TipoIdentificacion")) Then
				tipoIdentificacion = auxiliarRow("TipoIdentificacion").ToString()
			ElseIf Not IsDBNull(auxiliarRow("CodTipoDoc")) Then
				tipoIdentificacion = auxiliarRow("CodTipoDoc").ToString()
			End If
			If Not IsDBNull(auxiliarRow("NumeroIdentificacion")) Then
				numeroIdentificacion = auxiliarRow("NumeroIdentificacion").ToString()
			End If
			htmlTemplate = htmlTemplate.Replace("@TipoIdentificacion", tipoIdentificacion)
			htmlTemplate = htmlTemplate.Replace("@NumeroIdentificacion", numeroIdentificacion)

			' Sección Total: solo mostrar si MontoTotal > 0
			Dim seccionTotal As String = ""
			If montoTotal > 0 Then
				seccionTotal = "<div class=""descripcion-total"">" & descripcionTransaccionTotal & "</div>" &
					"<div class=""monto-total-grande"">" & montoTotalFormateado & "</div>"
			End If
			htmlTemplate = htmlTemplate.Replace("@SeccionTotal", seccionTotal)
			htmlTemplate = htmlTemplate.Replace("@TasaInteresTexto", tasaInteresTexto)

			' Construir sección de montos: Manejo, Capitalización, Monto Desembolso (solo si > 0), Cuota (siempre al final)
			Dim seccionMontos As New System.Text.StringBuilder()
			seccionMontos.AppendLine("            <div class=""monto-container"">")

			If montoManejo > 0 Then
				seccionMontos.AppendLine("                <div class=""monto-section intereses"">")
				seccionMontos.AppendLine("                    <div class=""monto-label"">Manejo (" & porcManejo.ToString("0.00") & "%)</div>")
				seccionMontos.AppendLine("                    <div class=""monto-value"">" & montoManejoFormateado & "</div>")
				seccionMontos.AppendLine("                </div>")
			End If

			If montoCapitalizacion > 0 Then
				seccionMontos.AppendLine("                <div class=""monto-section intereses"">")
				seccionMontos.AppendLine("                    <div class=""monto-label"">Capitalización (" & porcCapitalizacion.ToString("0.00") & "%)</div>")
				seccionMontos.AppendLine("                    <div class=""monto-value"">" & montoCapitalizacionFormateado & "</div>")
				seccionMontos.AppendLine("                </div>")
			End If

			If montoDesembolso > 0 Then
				seccionMontos.AppendLine("                <div class=""monto-section desembolso"">")
				seccionMontos.AppendLine("                    <div class=""monto-label"">Monto Desembolso</div>")
				seccionMontos.AppendLine("                    <div class=""monto-value"">" & montoDesembolsoFormateado & "</div>")
				seccionMontos.AppendLine("                </div>")
			End If

			' Cuota siempre al final (obligatorio)
			seccionMontos.AppendLine("                <div class=""monto-section intereses"">")
			seccionMontos.AppendLine("                    <div class=""monto-label"">Cuota</div>")
			seccionMontos.AppendLine("                    <div class=""monto-value"">" & cuotaFormateada & "</div>")
			seccionMontos.AppendLine("                </div>")

			seccionMontos.Append("            </div>")

			htmlTemplate = htmlTemplate.Replace("@SeccionMontos", seccionMontos.ToString())

			ModGlobal.EscribirLog("Comprobante generado exitosamente para auxiliar: " & auxiliarID)

			Dim resultado As New Dictionary(Of String, Object)
			resultado("Resultado") = "SUCCESS"
			resultado("Html") = htmlTemplate
			Return New With {
				.Resultado = "SUCCESS",
				.Html = htmlTemplate,
				.Mensaje = ""
			}

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GenerarComprobanteAuxiliar: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al generar comprobante: " & ex.Message
			}
		End Try
	End Function


End Class
