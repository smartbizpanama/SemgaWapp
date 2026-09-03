Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Web.Script.Serialization
Imports SBSqlClient
Imports SBUtility
Imports System.Data

Public Class SaldosContables
	Inherits BasePage

	Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
		If Session(VariablesSesion.UsuarioId) Is Nothing Then
			Response.Redirect("~/Login.aspx")
			Return
		End If
		If ModGlobal.ValidarYRedirigirSiSinPermiso(HttpContext.Current) Then Return
	End Sub

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerGruposCuenta() As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ObtenerGruposCuenta (SaldosContables)")
			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spGrupoCuenta_ListarParaDropdown"
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)
			If objSql.MensajeError <> "" Then
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				})
			End If
			Dim grupos As New List(Of Object)
			For Each row As DataRow In dt.Rows
				grupos.Add(New With {
					.IDGrupo = row("IDGrupo").ToString(),
					.Descripcion = row("GrupoCuenta").ToString()
				})
			Next
			Return serializer.Serialize(New With {
				.Resultado = "SUCCESS",
				.Datos = serializer.Serialize(grupos),
				.Mensaje = ""
			})
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ObtenerGruposCuenta (SaldosContables): " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al obtener grupos: " & ex.Message
			})
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ListarCuentas(filtros As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ListarCuentas (SaldosContables)")
			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spCuentas_Listar"
			If filtros IsNot Nothing Then
				Dim filtrosDict As Dictionary(Of String, Object) = TryCast(filtros, Dictionary(Of String, Object))
				If filtrosDict IsNot Nothing Then
					If Not String.IsNullOrEmpty(filtrosDict("IDGrupo")?.ToString()) Then
						objSql.Parametros.Add("@IDGrupo", Convert.ToInt32(filtrosDict("IDGrupo")))
					End If
					If Not String.IsNullOrEmpty(filtrosDict("Codigo")?.ToString()) Then
						objSql.Parametros.Add("@Codigo", filtrosDict("Codigo").ToString())
					End If
					If filtrosDict.ContainsKey("Nombre") AndAlso Not String.IsNullOrEmpty(filtrosDict("Nombre")?.ToString()) Then
						objSql.Parametros.Add("@Nombre", filtrosDict("Nombre").ToString())
					End If
					If filtrosDict.ContainsKey("OrderBy") AndAlso Not String.IsNullOrEmpty(filtrosDict("OrderBy")?.ToString()) Then
						objSql.Parametros.Add("@OrderBy", filtrosDict("OrderBy").ToString())
					End If
					If filtrosDict.ContainsKey("OrderDir") AndAlso Not String.IsNullOrEmpty(filtrosDict("OrderDir")?.ToString()) Then
						objSql.Parametros.Add("@OrderDir", filtrosDict("OrderDir").ToString())
					End If
				End If
			End If
			ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)
			If objSql.MensajeError <> "" Then
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				})
			End If
			Dim cuentas As New List(Of Object)
			For Each row As DataRow In dt.Rows
				Dim snImputable As Boolean = False
				If row.Table.Columns.Contains("snImputable") AndAlso Not row.IsNull("snImputable") Then
					snImputable = Convert.ToBoolean(row("snImputable"))
				End If
				cuentas.Add(New With {
					.ID = row("ID").ToString(),
					.Codigo = row("Cuenta").ToString(),
					.Nombre = If(row.Table.Columns.Contains("Nombre") AndAlso Not row.IsNull("Nombre"), row("Nombre").ToString(), ""),
					.IDGrupo = row("IDGrupo").ToString(),
					.GrupoDescripcion = If(row.Table.Columns.Contains("GrupoDescripcion") AndAlso Not row.IsNull("GrupoDescripcion"), row("GrupoDescripcion").ToString(), ""),
					.Saldo = If(row.Table.Columns.Contains("Saldo") AndAlso Not row.IsNull("Saldo"), Convert.ToDecimal(row("Saldo")), 0),
					.snImputable = snImputable
				})
			Next
			Return serializer.Serialize(New With {
				.Resultado = "SUCCESS",
				.Datos = serializer.Serialize(cuentas),
				.Mensaje = "Cuentas obtenidas exitosamente"
			})
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ListarCuentas (SaldosContables): " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al obtener cuentas: " & ex.Message
			})
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function CambiarSaldoCuenta(id As Integer, nuevoSaldo As Decimal, motivo As String) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO CambiarSaldoCuenta")
			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spCuentas_CambiarSaldo"
			Dim usuarioId As Integer = If(HttpContext.Current.Session(VariablesSesion.UsuarioId) IsNot Nothing, Convert.ToInt32(HttpContext.Current.Session(VariablesSesion.UsuarioId)), 0)
			Dim idSession As String = If(HttpContext.Current.Session(VariablesSesion.logID) IsNot Nothing, HttpContext.Current.Session(VariablesSesion.logID).ToString(), "")
			With objSql.Parametros
				.Add("@ID", id)
				.Add("@NuevoSaldo", nuevoSaldo)
				.Add("@UsuarioID", usuarioId)
				.Add("@SysLastSessionID", idSession)
				If Not String.IsNullOrEmpty(motivo) Then
					.Add("@Motivo", motivo)
				End If
			End With
			ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al cambiar saldo: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				})
			End If
			If dt.Rows.Count > 0 Then
				Return serializer.Serialize(New With {
					.Resultado = dt.Rows(0)("Resultado").ToString(),
					.Mensaje = dt.Rows(0)("Mensaje").ToString()
				})
			Else
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				})
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en CambiarSaldoCuenta: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al cambiar saldo: " & ex.Message
			})
		End Try
	End Function

End Class
