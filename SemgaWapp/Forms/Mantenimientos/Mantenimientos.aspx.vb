Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Web.Script.Serialization
Imports SBSqlClient
Imports SBUtility
Imports System.Data

Public Class Mantenimientos
	Inherits System.Web.UI.Page

	Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
		' Verificar sesión
		If Session(VariablesSesion.UsuarioId) Is Nothing Then
			Response.Redirect("~/Login.aspx")
			Return
		End If
	End Sub

#Region "CÓDIGOS DE TRANSACCIÓN"
	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerRubros() As Object
		Try
			ModGlobal.EscribirLog("ObtenerRubros iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spRubros_ListarParaDropdown"

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener rubros: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Datos = "",
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
				.Datos = New JavaScriptSerializer().Serialize(rubros),
				.Mensaje = ""
			}
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ObtenerRubros: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al obtener rubros: " & ex.Message
			}
		End Try
	End Function
	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerCuentasParaDropdown() As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ObtenerCuentasParaDropdown")
			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spCuentas_ListarParaDropdown"
			ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener cuentas: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
						.Resultado = "ERROR",
						.Datos = "",
						.Mensaje = "Error en la base de datos: " & objSql.MensajeError
					})
			End If
			ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Registros obtenidos: " & dt.Rows.Count.ToString())
			Dim cuentas As New List(Of Object)
			For Each row As DataRow In dt.Rows
				Dim cuenta As New With {
						.Cuenta = row("Cuenta").ToString(),
						.NombreCuenta = row("NombreCuenta").ToString(),
						.Saldo = If(row.Table.Columns.Contains("Saldo") AndAlso Not row.IsNull("Saldo"), Convert.ToDecimal(row("Saldo")), 0D)
					}
				cuentas.Add(cuenta)
			Next
			ModGlobal.EscribirLog("Metodo ObtenerCuentasParaDropdown completado exitosamente")
			Return serializer.Serialize(New With {
					.Resultado = "SUCCESS",
					.Datos = serializer.Serialize(cuentas),
					.Mensaje = ""
				})
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ObtenerCuentasParaDropdown: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error al obtener cuentas: " & ex.Message
				})
		End Try
	End Function
	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ListarCodigosTransaccion(filtros As Object) As Object
		Try
			ModGlobal.EscribirLog("ListarCodigosTransaccion iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spCodigosTransaccion_Listar"

			With objSql.Parametros
				If filtros.ContainsKey("CodigoRubro") AndAlso Not String.IsNullOrEmpty(filtros("CodigoRubro").ToString()) Then
					.Add("@CodigoRubro", filtros("CodigoRubro"))
				End If
				If filtros.ContainsKey("CodigoTransaccion") AndAlso Not String.IsNullOrEmpty(filtros("CodigoTransaccion").ToString()) Then
					.Add("@CodigoTransaccion", filtros("CodigoTransaccion"))
				End If
				If filtros.ContainsKey("Descripcion") AndAlso Not String.IsNullOrEmpty(filtros("Descripcion").ToString()) Then
					.Add("@Descripcion", filtros("Descripcion"))
				End If
				If filtros.ContainsKey("SnActivo") AndAlso filtros("SnActivo") IsNot Nothing Then
					.Add("@SnActivo", filtros("SnActivo"))
				End If
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al listar códigos: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Crear lista de objetos simples para evitar referencias circulares
			Dim codigos As New List(Of Object)

			For Each row As DataRow In dt.Rows
				Dim codigo As New With {
					.ID = row("ID").ToString(),
					.CodigoRubro = row("CodigoRubro").ToString(),
					.DescripcionRubro = row("DescripcionRubro").ToString(),
					.CodigoTransaccion = row("CodigoTransaccion").ToString(),
					.Descripcion = row("Descripcion").ToString(),
					.DebCred = row("DebCred").ToString(),
					.DescripcionDebCred = row("DescripcionDebCred").ToString(),
					.CuentaContable = row("CuentaContable").ToString(),
					.ContraCuenta = row("ContraCuenta").ToString(),
					.SnActivo = CBool(row("SnActivo")),
					.DescripcionEstado = row("DescripcionEstado").ToString(),
					.SnEliminado = CBool(row("SnEliminado"))
				}
				codigos.Add(codigo)
			Next

			Return New With {
				.Resultado = "SUCCESS",
				.Datos = New JavaScriptSerializer().Serialize(codigos),
				.Mensaje = ""
			}
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ListarCodigosTransaccion: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al listar códigos de transacción: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerCodigoTransaccion(id As Integer) As Object
		Try
			ModGlobal.EscribirLog("ObtenerCodigoTransaccion iniciado. ID: " & id)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spCodigosTransaccion_Listar"

			' No agregar parámetros para obtener todos los registros

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener código: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Buscar el código específico
			Dim codigoEncontrado As DataRow = Nothing
			For Each row As DataRow In dt.Rows
				If CInt(row("ID")) = id Then
					codigoEncontrado = row
					Exit For
				End If
			Next

			If codigoEncontrado IsNot Nothing Then
				Dim codigo As New With {
					.ID = codigoEncontrado("ID").ToString(),
					.CodigoRubro = codigoEncontrado("CodigoRubro").ToString(),
					.DescripcionRubro = codigoEncontrado("DescripcionRubro").ToString(),
					.CodigoTransaccion = codigoEncontrado("CodigoTransaccion").ToString(),
					.Descripcion = codigoEncontrado("Descripcion").ToString(),
					.DebCred = codigoEncontrado("DebCred").ToString(),
					.DescripcionDebCred = codigoEncontrado("DescripcionDebCred").ToString(),
					.CuentaContable = codigoEncontrado("CuentaContable").ToString(),
					.ContraCuenta = codigoEncontrado("ContraCuenta").ToString(),
					.SnActivo = CBool(codigoEncontrado("SnActivo")),
					.DescripcionEstado = codigoEncontrado("DescripcionEstado").ToString(),
					.SnEliminado = CBool(codigoEncontrado("SnEliminado"))
				}

				Return New With {
					.Resultado = "SUCCESS",
					.Datos = New JavaScriptSerializer().Serialize(codigo),
					.Mensaje = ""
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "No se encontró el código de transacción"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ObtenerCodigoTransaccion: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al obtener código de transacción: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GuardarCodigoTransaccion(codigoData As Object) As Object
		Try
			ModGlobal.EscribirLog("GuardarCodigoTransaccion iniciado")
			ModGlobal.EscribirLog("Datos recibidos: " & New JavaScriptSerializer().Serialize(codigoData))

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spCodigosTransaccion_Guardar"

			Dim id As Integer = If(codigoData.ContainsKey("ID"), Convert.ToInt32(codigoData("ID")), 0)
			Dim codigoRubro As String = codigoData("CodigoRubro").ToString()
			Dim codigoTransaccion As String = codigoData("CodigoTransaccion").ToString()
			Dim descripcion As String = codigoData("Descripcion").ToString()
			Dim debCred As String = codigoData("DebCred").ToString()
			Dim cuentaContable As String = If(codigoData.ContainsKey("CuentaContable"), codigoData("CuentaContable").ToString(), "")
			Dim contraCuenta As String = If(codigoData.ContainsKey("ContraCuenta"), codigoData("ContraCuenta").ToString(), "")
			Dim snActivo As Boolean = If(codigoData.ContainsKey("SnActivo"), Convert.ToBoolean(codigoData("SnActivo")), True)

			ModGlobal.EscribirLog($"Valores extraídos - ID: {id}, CodigoRubro: {codigoRubro}, CodigoTransaccion: {codigoTransaccion}, Descripcion: {descripcion}, DebCred: {debCred}, CuentaContable: {cuentaContable}, ContraCuenta: {contraCuenta}, SnActivo: {snActivo}")

			With objSql.Parametros
				If id > 0 Then
					.Add("@ID", id)
				End If
				.Add("@CodigoRubro", codigoRubro)
				.Add("@CodigoTransaccion", codigoTransaccion)
				.Add("@Descripcion", descripcion)
				.Add("@DebCred", debCred)
				If Not String.IsNullOrEmpty(cuentaContable) Then
					.Add("@CuentaContable", cuentaContable)
				End If
				If Not String.IsNullOrEmpty(contraCuenta) Then
					.Add("@ContraCuenta", contraCuenta)
				End If
				.Add("@SnActivo", snActivo)
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al guardar código: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Obtener resultado del stored procedure
			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()

				Return New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GuardarCodigoTransaccion: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al guardar código de transacción: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function EliminarCodigoTransaccion(id As Integer) As Object
		Try
			ModGlobal.EscribirLog("EliminarCodigoTransaccion iniciado. ID: " & id)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spCodigosTransaccion_Eliminar"

			With objSql.Parametros
				.Add("@ID", id)
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al eliminar código: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Obtener resultado del stored procedure
			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()

				Return New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en EliminarCodigoTransaccion: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al eliminar código de transacción: " & ex.Message
			}
		End Try
	End Function
#End Region

#Region "DEPARTAMENTOS"
	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ListarDepartamentos(filtros As Object) As Object
		Try
			ModGlobal.EscribirLog("ListarDepartamentos iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spDepartamentos_Listar"

			With objSql.Parametros
				If filtros.ContainsKey("Nombre") AndAlso Not String.IsNullOrEmpty(filtros("Nombre").ToString()) Then
					.Add("@Nombre", filtros("Nombre"))
				End If
				If filtros.ContainsKey("Responsable") AndAlso Not String.IsNullOrEmpty(filtros("Responsable").ToString()) Then
					.Add("@Responsable", filtros("Responsable"))
				End If
				If filtros.ContainsKey("Activo") AndAlso filtros("Activo") IsNot Nothing Then
					.Add("@Activo", filtros("Activo"))
				End If
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al listar departamentos: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Crear lista de objetos simples para evitar referencias circulares
			Dim departamentos As New List(Of Object)

			For Each row As DataRow In dt.Rows
				Dim departamento As New With {
					.Id = row("Id").ToString(),
					.Nombre = row("Nombre").ToString(),
					.Descripcion = row("Descripcion").ToString(),
					.Responsable = row("Responsable").ToString(),
					.Telefono = row("Telefono").ToString(),
					.Email = row("Email").ToString(),
					.Activo = CBool(row("Activo")),
					.DescripcionEstado = row("DescripcionEstado").ToString(),
					.FechaCreacion = row("FechaCreacion").ToString(),
					.FechaModificacion = If(IsDBNull(row("FechaModificacion")), "", row("FechaModificacion").ToString()),
					.snEliminado = CBool(row("snEliminado"))
				}
				departamentos.Add(departamento)
			Next

			Return New With {
				.Resultado = "SUCCESS",
				.Datos = New JavaScriptSerializer().Serialize(departamentos),
				.Mensaje = ""
			}
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ListarDepartamentos: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al listar departamentos: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerDepartamento(id As Integer) As Object
		Try
			ModGlobal.EscribirLog("ObtenerDepartamento iniciado. ID: " & id)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spDepartamentos_Listar"

			' No agregar parámetros para obtener todos los registros

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener departamento: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Buscar el departamento específico
			Dim departamentoEncontrado As DataRow = Nothing
			For Each row As DataRow In dt.Rows
				If CInt(row("Id")) = id Then
					departamentoEncontrado = row
					Exit For
				End If
			Next

			If departamentoEncontrado IsNot Nothing Then
				Dim departamento As New With {
					.Id = departamentoEncontrado("Id").ToString(),
					.Nombre = departamentoEncontrado("Nombre").ToString(),
					.Descripcion = departamentoEncontrado("Descripcion").ToString(),
					.Responsable = departamentoEncontrado("Responsable").ToString(),
					.Telefono = departamentoEncontrado("Telefono").ToString(),
					.Email = departamentoEncontrado("Email").ToString(),
					.Activo = CBool(departamentoEncontrado("Activo")),
					.DescripcionEstado = departamentoEncontrado("DescripcionEstado").ToString(),
					.FechaCreacion = departamentoEncontrado("FechaCreacion").ToString(),
					.FechaModificacion = If(IsDBNull(departamentoEncontrado("FechaModificacion")), "", departamentoEncontrado("FechaModificacion").ToString()),
					.snEliminado = CBool(departamentoEncontrado("snEliminado"))
				}

				Return New With {
					.Resultado = "SUCCESS",
					.Datos = New JavaScriptSerializer().Serialize(departamento),
					.Mensaje = ""
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "No se encontró el departamento"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ObtenerDepartamento: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al obtener departamento: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GuardarDepartamento(departamentoData As Object) As Object
		Try
			ModGlobal.EscribirLog("GuardarDepartamento iniciado")
			ModGlobal.EscribirLog("Datos recibidos: " & New JavaScriptSerializer().Serialize(departamentoData))

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spDepartamentos_Guardar"

			Dim id As Integer = If(departamentoData.ContainsKey("Id"), Convert.ToInt32(departamentoData("Id")), 0)
			Dim nombre As String = departamentoData("Nombre").ToString()
			Dim descripcion As String = If(departamentoData.ContainsKey("Descripcion"), departamentoData("Descripcion").ToString(), "")
			Dim responsable As String = If(departamentoData.ContainsKey("Responsable"), departamentoData("Responsable").ToString(), "")
			Dim telefono As String = If(departamentoData.ContainsKey("Telefono"), departamentoData("Telefono").ToString(), "")
			Dim email As String = If(departamentoData.ContainsKey("Email"), departamentoData("Email").ToString(), "")
			Dim activo As Boolean = If(departamentoData.ContainsKey("Activo"), Convert.ToBoolean(departamentoData("Activo")), True)

			ModGlobal.EscribirLog($"Valores extraídos - ID: {id}, Nombre: {nombre}, Descripcion: {descripcion}, Responsable: {responsable}, Telefono: {telefono}, Email: {email}, Activo: {activo}")

			With objSql.Parametros
				If id > 0 Then
					.Add("@Id", id)
				End If
				.Add("@Nombre", nombre)
				If Not String.IsNullOrEmpty(descripcion) Then
					.Add("@Descripcion", descripcion)
				End If
				If Not String.IsNullOrEmpty(responsable) Then
					.Add("@Responsable", responsable)
				End If
				If Not String.IsNullOrEmpty(telefono) Then
					.Add("@Telefono", telefono)
				End If
				If Not String.IsNullOrEmpty(email) Then
					.Add("@Email", email)
				End If
				.Add("@Activo", activo)
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al guardar departamento: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Obtener resultado del stored procedure
			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()

				Return New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GuardarDepartamento: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al guardar departamento: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function EliminarDepartamento(id As Integer) As Object
		Try
			ModGlobal.EscribirLog("EliminarDepartamento iniciado. ID: " & id)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spDepartamentos_Eliminar"

			With objSql.Parametros
				.Add("@Id", id)
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al eliminar departamento: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Obtener resultado del stored procedure
			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()

				Return New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en EliminarDepartamento: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al eliminar departamento: " & ex.Message
			}
		End Try
	End Function
#End Region

#Region "PARENTEZCOS"
	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ListarParentezcos(filtros As Object) As Object
		Try
			ModGlobal.EscribirLog("ListarParentezcos iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spParentezcos_Listar"

			With objSql.Parametros
				If filtros.ContainsKey("Parentezco") AndAlso Not String.IsNullOrEmpty(filtros("Parentezco").ToString()) Then
					.Add("@Parentezco", filtros("Parentezco"))
				End If
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al listar parentezcos: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Crear lista de objetos simples para evitar referencias circulares
			Dim parentezcos As New List(Of Object)

			For Each row As DataRow In dt.Rows
				Dim parentezco As New With {
					.IDParentezco = row("IDParentezco").ToString(),
					.Parentezco = row("Parentezco").ToString(),
					.snEliminado = CBool(row("snEliminado"))
				}
				parentezcos.Add(parentezco)
			Next

			Return New With {
				.Resultado = "SUCCESS",
				.Datos = New JavaScriptSerializer().Serialize(parentezcos),
				.Mensaje = ""
			}
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ListarParentezcos: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al listar parentezcos: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerParentezco(id As Integer) As Object
		Try
			ModGlobal.EscribirLog("ObtenerParentezco iniciado. ID: " & id)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spParentezcos_Listar"

			' No agregar parámetros para obtener todos los registros

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener parentezco: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Buscar el parentezco específico
			Dim parentezcoEncontrado As DataRow = Nothing
			For Each row As DataRow In dt.Rows
				If CInt(row("IDParentezco")) = id Then
					parentezcoEncontrado = row
					Exit For
				End If
			Next

			If parentezcoEncontrado IsNot Nothing Then
				Dim parentezco As New With {
					.IDParentezco = parentezcoEncontrado("IDParentezco").ToString(),
					.Parentezco = parentezcoEncontrado("Parentezco").ToString(),
					.snEliminado = CBool(parentezcoEncontrado("snEliminado"))
				}

				Return New With {
					.Resultado = "SUCCESS",
					.Datos = New JavaScriptSerializer().Serialize(parentezco),
					.Mensaje = ""
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "No se encontró el parentezco"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ObtenerParentezco: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al obtener parentezco: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GuardarParentezco(parentezcoData As Object) As Object
		Try
			ModGlobal.EscribirLog("GuardarParentezco iniciado")
			ModGlobal.EscribirLog("Datos recibidos: " & New JavaScriptSerializer().Serialize(parentezcoData))

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spParentezcos_Guardar"

			Dim id As Integer = If(parentezcoData.ContainsKey("IDParentezco"), Convert.ToInt32(parentezcoData("IDParentezco")), 0)
			Dim parentezco As String = parentezcoData("Parentezco").ToString()

			ModGlobal.EscribirLog($"Valores extraídos - ID: {id}, Parentezco: {parentezco}")

			With objSql.Parametros
				If id > 0 Then
					.Add("@IDParentezco", id)
				End If
				.Add("@Parentezco", parentezco)
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al guardar parentezco: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Obtener resultado del stored procedure
			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()

				Return New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GuardarParentezco: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al guardar parentezco: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function EliminarParentezco(id As Integer) As Object
		Try
			ModGlobal.EscribirLog("EliminarParentezco iniciado. ID: " & id)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spParentezcos_Eliminar"

			With objSql.Parametros
				.Add("@IDParentezco", id)
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al eliminar parentezco: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Obtener resultado del stored procedure
			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()

				Return New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en EliminarParentezco: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al eliminar parentezco: " & ex.Message
			}
		End Try
	End Function
#End Region

#Region "ROLES"
	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ListarRoles(filtros As Object) As Object
		Try
			ModGlobal.EscribirLog("ListarRoles iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spRoles_Listar"

			With objSql.Parametros
				If filtros.ContainsKey("Nombre") AndAlso Not String.IsNullOrEmpty(filtros("Nombre").ToString()) Then
					.Add("@Nombre", filtros("Nombre"))
				End If
				If filtros.ContainsKey("NivelAcceso") AndAlso filtros("NivelAcceso") IsNot Nothing Then
					.Add("@NivelAcceso", filtros("NivelAcceso"))
				End If
				If filtros.ContainsKey("Activo") AndAlso filtros("Activo") IsNot Nothing Then
					.Add("@Activo", filtros("Activo"))
				End If
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al listar roles: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Crear lista de objetos simples para evitar referencias circulares
			Dim roles As New List(Of Object)

			For Each row As DataRow In dt.Rows
				Dim rol As New With {
					.Id = row("Id").ToString(),
					.Nombre = row("Nombre").ToString(),
					.Descripcion = row("Descripcion").ToString(),
					.NivelAcceso = CInt(row("NivelAcceso")),
					.DescripcionNivelAcceso = row("DescripcionNivelAcceso").ToString(),
					.Activo = CBool(row("Activo")),
					.DescripcionEstado = row("DescripcionEstado").ToString(),
					.FechaCreacion = row("FechaCreacion").ToString(),
					.FechaModificacion = If(IsDBNull(row("FechaModificacion")), "", row("FechaModificacion").ToString()),
					.snEliminado = CBool(row("snEliminado"))
				}
				roles.Add(rol)
			Next

			Return New With {
				.Resultado = "SUCCESS",
				.Datos = New JavaScriptSerializer().Serialize(roles),
				.Mensaje = ""
			}
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ListarRoles: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al listar roles: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerRol(id As Integer) As Object
		Try
			ModGlobal.EscribirLog("ObtenerRol iniciado. ID: " & id)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spRoles_Listar"

			' No agregar parámetros para obtener todos los registros

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener rol: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Buscar el rol específico
			Dim rolEncontrado As DataRow = Nothing
			For Each row As DataRow In dt.Rows
				If CInt(row("Id")) = id Then
					rolEncontrado = row
					Exit For
				End If
			Next

			If rolEncontrado IsNot Nothing Then
				Dim rol As New With {
					.Id = rolEncontrado("Id").ToString(),
					.Nombre = rolEncontrado("Nombre").ToString(),
					.Descripcion = rolEncontrado("Descripcion").ToString(),
					.NivelAcceso = CInt(rolEncontrado("NivelAcceso")),
					.DescripcionNivelAcceso = rolEncontrado("DescripcionNivelAcceso").ToString(),
					.Activo = CBool(rolEncontrado("Activo")),
					.DescripcionEstado = rolEncontrado("DescripcionEstado").ToString(),
					.FechaCreacion = rolEncontrado("FechaCreacion").ToString(),
					.FechaModificacion = If(IsDBNull(rolEncontrado("FechaModificacion")), "", rolEncontrado("FechaModificacion").ToString()),
					.snEliminado = CBool(rolEncontrado("snEliminado"))
				}

				Return New With {
					.Resultado = "SUCCESS",
					.Datos = New JavaScriptSerializer().Serialize(rol),
					.Mensaje = ""
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "No se encontró el rol"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ObtenerRol: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al obtener rol: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GuardarRol(rolData As Object) As Object
		Try
			ModGlobal.EscribirLog("GuardarRol iniciado")
			ModGlobal.EscribirLog("Datos recibidos: " & New JavaScriptSerializer().Serialize(rolData))

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spRoles_Guardar"

			Dim id As Integer = If(rolData.ContainsKey("Id"), Convert.ToInt32(rolData("Id")), 0)
			Dim nombre As String = rolData("Nombre").ToString()
			Dim descripcion As String = If(rolData.ContainsKey("Descripcion"), rolData("Descripcion").ToString(), "")
			Dim nivelAcceso As Integer = Convert.ToInt32(rolData("NivelAcceso"))
			Dim activo As Boolean = If(rolData.ContainsKey("Activo"), Convert.ToBoolean(rolData("Activo")), True)

			ModGlobal.EscribirLog($"Valores extraídos - ID: {id}, Nombre: {nombre}, Descripcion: {descripcion}, NivelAcceso: {nivelAcceso}, Activo: {activo}")

			With objSql.Parametros
				If id > 0 Then
					.Add("@Id", id)
				End If
				.Add("@Nombre", nombre)
				If Not String.IsNullOrEmpty(descripcion) Then
					.Add("@Descripcion", descripcion)
				End If
				.Add("@NivelAcceso", nivelAcceso)
				.Add("@Activo", activo)
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al guardar rol: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Obtener resultado del stored procedure
			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()

				Return New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GuardarRol: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al guardar rol: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function EliminarRol(id As Integer) As Object
		Try
			ModGlobal.EscribirLog("EliminarRol iniciado. ID: " & id)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spRoles_Eliminar"

			With objSql.Parametros
				.Add("@Id", id)
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al eliminar rol: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Obtener resultado del stored procedure
			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()

				Return New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en EliminarRol: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al eliminar rol: " & ex.Message
			}
		End Try
	End Function
#End Region

#Region "RUBROS"
	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ListarRubros(filtros As Object) As Object
		Try
			ModGlobal.EscribirLog("ListarRubros iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spRubros_Listar"

			With objSql.Parametros
				If filtros.ContainsKey("CodigoRubro") AndAlso Not String.IsNullOrEmpty(filtros("CodigoRubro").ToString()) Then
					.Add("@CodigoRubro", filtros("CodigoRubro"))
				End If
				If filtros.ContainsKey("Descripcion") AndAlso Not String.IsNullOrEmpty(filtros("Descripcion").ToString()) Then
					.Add("@Descripcion", filtros("Descripcion"))
				End If
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al listar rubros: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Crear lista de objetos simples para evitar referencias circulares
			Dim rubros As New List(Of Object)

			For Each row As DataRow In dt.Rows
				Dim rubro As New With {
					.IDRubro = row("IDRubro").ToString(),
					.CodigoRubro = row("CodigoRubro").ToString(),
					.Descripcion = row("Descripcion").ToString(),
					.snEliminado = CBool(row("snEliminado"))
				}
				rubros.Add(rubro)
			Next

			Return New With {
				.Resultado = "SUCCESS",
				.Datos = New JavaScriptSerializer().Serialize(rubros),
				.Mensaje = ""
			}
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ListarRubros: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al listar rubros: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerRubro(id As Integer) As Object
		Try
			ModGlobal.EscribirLog("ObtenerRubro iniciado. ID: " & id)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spRubros_Listar"

			' No agregar parámetros para obtener todos los registros

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener rubro: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Buscar el rubro específico
			Dim rubroEncontrado As DataRow = Nothing
			For Each row As DataRow In dt.Rows
				If CInt(row("IDRubro")) = id Then
					rubroEncontrado = row
					Exit For
				End If
			Next

			If rubroEncontrado IsNot Nothing Then
				Dim rubro As New With {
					.IDRubro = rubroEncontrado("IDRubro").ToString(),
					.CodigoRubro = rubroEncontrado("CodigoRubro").ToString(),
					.Descripcion = rubroEncontrado("Descripcion").ToString(),
					.snEliminado = CBool(rubroEncontrado("snEliminado"))
				}

				Return New With {
					.Resultado = "SUCCESS",
					.Datos = New JavaScriptSerializer().Serialize(rubro),
					.Mensaje = ""
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "No se encontró el rubro"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ObtenerRubro: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al obtener rubro: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GuardarRubro(rubroData As Object) As Object
		Try
			ModGlobal.EscribirLog("GuardarRubro iniciado")
			ModGlobal.EscribirLog("Datos recibidos: " & New JavaScriptSerializer().Serialize(rubroData))

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spRubros_Guardar"

			Dim id As Integer = If(rubroData.ContainsKey("IDRubro"), Convert.ToInt32(rubroData("IDRubro")), 0)
			Dim codigoRubro As String = rubroData("CodigoRubro").ToString()
			Dim descripcion As String = rubroData("Descripcion").ToString()

			ModGlobal.EscribirLog($"Valores extraídos - ID: {id}, CodigoRubro: {codigoRubro}, Descripcion: {descripcion}")

			With objSql.Parametros
				If id > 0 Then
					.Add("@IDRubro", id)
				End If
				.Add("@CodigoRubro", codigoRubro)
				.Add("@Descripcion", descripcion)
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al guardar rubro: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Obtener resultado del stored procedure
			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()

				Return New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GuardarRubro: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al guardar rubro: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function EliminarRubro(id As Integer) As Object
		Try
			ModGlobal.EscribirLog("EliminarRubro iniciado. ID: " & id)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spRubros_Eliminar"

			With objSql.Parametros
				.Add("@IDRubro", id)
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al eliminar rubro: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Obtener resultado del stored procedure
			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()

				Return New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en EliminarRubro: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al eliminar rubro: " & ex.Message
			}
		End Try
	End Function
#End Region

#Region "ESTATUS ASOCIADOS"
	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ListarStatusAsociados(filtros As Object) As Object
		Try
			ModGlobal.EscribirLog("ListarStatusAsociados iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spStatusAsociado_Listar"

			With objSql.Parametros
				If filtros.ContainsKey("CodStatusAsociado") AndAlso Not String.IsNullOrEmpty(filtros("CodStatusAsociado").ToString()) Then
					.Add("@CodStatusAsociado", filtros("CodStatusAsociado"))
				End If
				If filtros.ContainsKey("StatusAsociado") AndAlso Not String.IsNullOrEmpty(filtros("StatusAsociado").ToString()) Then
					.Add("@StatusAsociado", filtros("StatusAsociado"))
				End If
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al listar estatus: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Crear lista de objetos simples para evitar referencias circulares
			Dim statusList As New List(Of Object)

			For Each row As DataRow In dt.Rows
				Dim status As New With {
					.IDStatus = row("IDStatus").ToString(),
					.CodStatusAsociado = row("CodStatusAsociado").ToString(),
					.StatusAsociado = row("StatusAsociado").ToString(),
					.snEliminado = CBool(row("snEliminado"))
				}
				statusList.Add(status)
			Next

			Return New With {
				.Resultado = "SUCCESS",
				.Datos = New JavaScriptSerializer().Serialize(statusList),
				.Mensaje = ""
			}
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ListarStatusAsociados: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al listar estatus: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerStatusAsociado(id As Integer) As Object
		Try
			ModGlobal.EscribirLog("ObtenerStatusAsociado iniciado. ID: " & id)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spStatusAsociado_Listar"

			' No agregar parámetros para obtener todos los registros

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener estatus: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Buscar el estatus específico
			Dim statusEncontrado As DataRow = Nothing
			For Each row As DataRow In dt.Rows
				If CInt(row("IDStatus")) = id Then
					statusEncontrado = row
					Exit For
				End If
			Next

			If statusEncontrado IsNot Nothing Then
				Dim status As New With {
					.IDStatus = statusEncontrado("IDStatus").ToString(),
					.CodStatusAsociado = statusEncontrado("CodStatusAsociado").ToString(),
					.StatusAsociado = statusEncontrado("StatusAsociado").ToString(),
					.snEliminado = CBool(statusEncontrado("snEliminado"))
				}

				Return New With {
					.Resultado = "SUCCESS",
					.Datos = New JavaScriptSerializer().Serialize(status),
					.Mensaje = ""
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "No se encontró el estatus"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ObtenerStatusAsociado: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al obtener estatus: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GuardarStatusAsociado(statusData As Object) As Object
		Try
			ModGlobal.EscribirLog("GuardarStatusAsociado iniciado")
			ModGlobal.EscribirLog("Datos recibidos: " & New JavaScriptSerializer().Serialize(statusData))

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spStatusAsociado_Guardar"

			Dim id As Integer = If(statusData.ContainsKey("IDStatus"), Convert.ToInt32(statusData("IDStatus")), 0)
			Dim codStatusAsociado As String = statusData("CodStatusAsociado").ToString()
			Dim statusAsociado As String = statusData("StatusAsociado").ToString()

			ModGlobal.EscribirLog($"Valores extraídos - ID: {id}, CodStatusAsociado: {codStatusAsociado}, StatusAsociado: {statusAsociado}")

			With objSql.Parametros
				If id > 0 Then
					.Add("@IDStatus", id)
				End If
				.Add("@CodStatusAsociado", codStatusAsociado)
				.Add("@StatusAsociado", statusAsociado)
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al guardar estatus: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Obtener resultado del stored procedure
			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()

				Return New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GuardarStatusAsociado: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al guardar estatus: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function EliminarStatusAsociado(id As Integer) As Object
		Try
			ModGlobal.EscribirLog("EliminarStatusAsociado iniciado. ID: " & id)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spStatusAsociado_Eliminar"

			With objSql.Parametros
				.Add("@IDStatus", id)
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al eliminar estatus: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Obtener resultado del stored procedure
			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()

				Return New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en EliminarStatusAsociado: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al eliminar estatus: " & ex.Message
			}
		End Try
	End Function
#End Region

#Region "TIPO ASOCIADO"
	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ListarTipoAsociados(filtros As Object) As Object
		Try
			ModGlobal.EscribirLog("ListarTipoAsociados iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spTipoAsociado_Listar"

			With objSql.Parametros
				If filtros.ContainsKey("CodTipoAsociado") AndAlso Not String.IsNullOrEmpty(filtros("CodTipoAsociado").ToString()) Then
					.Add("@CodTipoAsociado", filtros("CodTipoAsociado"))
				End If
				If filtros.ContainsKey("TipoAsociado") AndAlso Not String.IsNullOrEmpty(filtros("TipoAsociado").ToString()) Then
					.Add("@TipoAsociado", filtros("TipoAsociado"))
				End If
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al listar tipos de asociado: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Crear lista de objetos simples para evitar referencias circulares
			Dim tipoAsociados As New List(Of Object)

			For Each row As DataRow In dt.Rows
				Dim tipoAsociado As New With {
					.IdTipoAsociado = row("IdTipoAsociado").ToString(),
					.CodTipoAsociado = row("CodTipoAsociado").ToString(),
					.TipoAsociado = row("TipoAsociado").ToString(),
					.snEliminado = CBool(row("snEliminado"))
				}
				tipoAsociados.Add(tipoAsociado)
			Next

			Return New With {
				.Resultado = "SUCCESS",
				.Datos = New JavaScriptSerializer().Serialize(tipoAsociados),
				.Mensaje = ""
			}
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ListarTipoAsociados: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al listar tipos de asociado: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerTipoAsociado(id As Integer) As Object
		Try
			ModGlobal.EscribirLog("ObtenerTipoAsociado iniciado. ID: " & id)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spTipoAsociado_Listar"

			' No agregar parámetros para obtener todos los registros

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener tipo de asociado: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Buscar el tipo de asociado específico
			Dim tipoAsociadoEncontrado As DataRow = Nothing
			For Each row As DataRow In dt.Rows
				If CInt(row("IdTipoAsociado")) = id Then
					tipoAsociadoEncontrado = row
					Exit For
				End If
			Next

			If tipoAsociadoEncontrado IsNot Nothing Then
				Dim tipoAsociado As New With {
					.IdTipoAsociado = tipoAsociadoEncontrado("IdTipoAsociado").ToString(),
					.CodTipoAsociado = tipoAsociadoEncontrado("CodTipoAsociado").ToString(),
					.TipoAsociado = tipoAsociadoEncontrado("TipoAsociado").ToString(),
					.snEliminado = CBool(tipoAsociadoEncontrado("snEliminado"))
				}

				Return New With {
					.Resultado = "SUCCESS",
					.Datos = New JavaScriptSerializer().Serialize(tipoAsociado),
					.Mensaje = ""
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "No se encontró el tipo de asociado"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ObtenerTipoAsociado: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al obtener tipo de asociado: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GuardarTipoAsociado(tipoAsociadoData As Object) As Object
		Try
			ModGlobal.EscribirLog("GuardarTipoAsociado iniciado")
			ModGlobal.EscribirLog("Datos recibidos: " & New JavaScriptSerializer().Serialize(tipoAsociadoData))

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spTipoAsociado_Guardar"

			Dim id As Integer = If(tipoAsociadoData.ContainsKey("IdTipoAsociado"), Convert.ToInt32(tipoAsociadoData("IdTipoAsociado")), 0)
			Dim codTipoAsociado As String = tipoAsociadoData("CodTipoAsociado").ToString()
			Dim tipoAsociado As String = tipoAsociadoData("TipoAsociado").ToString()

			ModGlobal.EscribirLog($"Valores extraídos - ID: {id}, CodTipoAsociado: {codTipoAsociado}, TipoAsociado: {tipoAsociado}")

			With objSql.Parametros
				If id > 0 Then
					.Add("@IdTipoAsociado", id)
				End If
				.Add("@CodTipoAsociado", codTipoAsociado)
				.Add("@TipoAsociado", tipoAsociado)
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al guardar tipo de asociado: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Obtener resultado del stored procedure
			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()

				Return New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GuardarTipoAsociado: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al guardar tipo de asociado: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function EliminarTipoAsociado(id As Integer) As Object
		Try
			ModGlobal.EscribirLog("EliminarTipoAsociado iniciado. ID: " & id)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spTipoAsociado_Eliminar"

			With objSql.Parametros
				.Add("@IdTipoAsociado", id)
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al eliminar tipo de asociado: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Obtener resultado del stored procedure
			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()

				Return New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en EliminarTipoAsociado: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al eliminar tipo de asociado: " & ex.Message
			}
		End Try
	End Function
#End Region

#Region "TIPOS DE DOCUMENTOS"
	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ListarTipoDocumentos(filtros As Object) As Object
		Try
			ModGlobal.EscribirLog("ListarTipoDocumentos iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spTipoDocumentos_Listar"

			With objSql.Parametros
				If filtros.ContainsKey("CodTipoDoc") AndAlso Not String.IsNullOrEmpty(filtros("CodTipoDoc").ToString()) Then
					.Add("@CodTipoDoc", filtros("CodTipoDoc"))
				End If
				If filtros.ContainsKey("TipoDocumento") AndAlso Not String.IsNullOrEmpty(filtros("TipoDocumento").ToString()) Then
					.Add("@TipoDocumento", filtros("TipoDocumento"))
				End If
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al listar tipos de documento: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Crear lista de objetos simples para evitar referencias circulares
			Dim tipoDocumentos As New List(Of Object)

			For Each row As DataRow In dt.Rows
				Dim tipoDocumento As New With {
					.IDTipoDoc = row("IDTipoDoc").ToString(),
					.CodTipoDoc = row("CodTipoDoc").ToString(),
					.TipoDocumento = row("TipoDocumento").ToString(),
					.snEliminado = CBool(row("snEliminado"))
				}
				tipoDocumentos.Add(tipoDocumento)
			Next

			Return New With {
				.Resultado = "SUCCESS",
				.Datos = New JavaScriptSerializer().Serialize(tipoDocumentos),
				.Mensaje = ""
			}
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ListarTipoDocumentos: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al listar tipos de documento: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerTipoDocumento(id As Integer) As Object
		Try
			ModGlobal.EscribirLog("ObtenerTipoDocumento iniciado. ID: " & id)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spTipoDocumentos_Listar"

			' No agregar parámetros para obtener todos los registros

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener tipo de documento: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Buscar el tipo de documento específico
			Dim tipoDocumentoEncontrado As DataRow = Nothing
			For Each row As DataRow In dt.Rows
				If CInt(row("IDTipoDoc")) = id Then
					tipoDocumentoEncontrado = row
					Exit For
				End If
			Next

			If tipoDocumentoEncontrado IsNot Nothing Then
				Dim tipoDocumento As New With {
					.IDTipoDoc = tipoDocumentoEncontrado("IDTipoDoc").ToString(),
					.CodTipoDoc = tipoDocumentoEncontrado("CodTipoDoc").ToString(),
					.TipoDocumento = tipoDocumentoEncontrado("TipoDocumento").ToString(),
					.snEliminado = CBool(tipoDocumentoEncontrado("snEliminado"))
				}

				Return New With {
					.Resultado = "SUCCESS",
					.Datos = New JavaScriptSerializer().Serialize(tipoDocumento),
					.Mensaje = ""
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "No se encontró el tipo de documento"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ObtenerTipoDocumento: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al obtener tipo de documento: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GuardarTipoDocumento(tipoDocumentoData As Object) As Object
		Try
			ModGlobal.EscribirLog("GuardarTipoDocumento iniciado")
			ModGlobal.EscribirLog("Datos recibidos: " & New JavaScriptSerializer().Serialize(tipoDocumentoData))

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spTipoDocumentos_Guardar"

			Dim id As Integer = If(tipoDocumentoData.ContainsKey("IDTipoDoc"), Convert.ToInt32(tipoDocumentoData("IDTipoDoc")), 0)
			Dim codTipoDoc As String = tipoDocumentoData("CodTipoDoc").ToString()
			Dim tipoDocumento As String = tipoDocumentoData("TipoDocumento").ToString()

			ModGlobal.EscribirLog($"Valores extraídos - ID: {id}, CodTipoDoc: {codTipoDoc}, TipoDocumento: {tipoDocumento}")

			With objSql.Parametros
				If id > 0 Then
					.Add("@IDTipoDoc", id)
				End If
				.Add("@CodTipoDoc", codTipoDoc)
				.Add("@TipoDocumento", tipoDocumento)
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al guardar tipo de documento: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Obtener resultado del stored procedure
			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()

				Return New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GuardarTipoDocumento: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al guardar tipo de documento: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function EliminarTipoDocumento(id As Integer) As Object
		Try
			ModGlobal.EscribirLog("EliminarTipoDocumento iniciado. ID: " & id)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spTipoDocumentos_Eliminar"

			With objSql.Parametros
				.Add("@IDTipoDoc", id)
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al eliminar tipo de documento: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Obtener resultado del stored procedure
			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()

				Return New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en EliminarTipoDocumento: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al eliminar tipo de documento: " & ex.Message
			}
		End Try
	End Function
#End Region

#Region "TIPOS AUXILIARES"
	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ListarTiposAuxiliares(filtros As Dictionary(Of String, Object)) As String
		Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
		Dim serializer As New JavaScriptSerializer()

		Try
			ModGlobal.EscribirLog("Iniciando ListarTiposAuxiliares")

			' Agregar parámetros solo si no están vacíos
			If filtros.ContainsKey("CodigoRubro") AndAlso Not String.IsNullOrEmpty(filtros("CodigoRubro").ToString()) Then
				objSql.Parametros.Add("@CodigoRubro", filtros("CodigoRubro").ToString())
				ModGlobal.EscribirLog($"Agregado parámetro CodigoRubro: {filtros("CodigoRubro").ToString()}")
			End If

			If filtros.ContainsKey("TipoAuxiliar") AndAlso Not String.IsNullOrEmpty(filtros("TipoAuxiliar").ToString()) Then
				objSql.Parametros.Add("@TipoAuxiliar", Convert.ToInt32(filtros("TipoAuxiliar")))
				ModGlobal.EscribirLog($"Agregado parámetro TipoAuxiliar: {filtros("TipoAuxiliar").ToString()}")
			End If

			If filtros.ContainsKey("Descripcion") AndAlso Not String.IsNullOrEmpty(filtros("Descripcion").ToString()) Then
				objSql.Parametros.Add("@Descripcion", filtros("Descripcion").ToString())
				ModGlobal.EscribirLog($"Agregado parámetro Descripcion: {filtros("Descripcion").ToString()}")
			End If

			Dim sSql As String = "Exec spTiposAuxiliares_Listar"
			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")

			Dim dt As DataTable = objSql.GetDataTableSql(sSql)
			ModGlobal.EscribirLog($"DataTable obtenido con {dt.Rows.Count} filas")

			If String.IsNullOrEmpty(objSql.MensajeError) Then
				ModGlobal.EscribirLog("No hay errores en la consulta, procesando datos...")
				Dim tiposAuxiliares As New List(Of Object)
				For Each row As DataRow In dt.Rows
					Dim tipoAuxiliar As New With {
						.ID = row("ID").ToString(),
						.CodigoRubro = row("CodigoRubro").ToString(),
						.RubroDescripcion = row("RubroDescripcion").ToString(),
						.TipoAuxiliar = row("TipoAuxiliar").ToString(),
						.Descripcion = row("Descripcion").ToString(),
						.Tasa = If(row("Tasa") Is DBNull.Value, Nothing, row("Tasa").ToString()),
						.Plazo = If(row("Plazo") Is DBNull.Value, Nothing, row("Plazo").ToString()),
						.MontoMaximo = If(row("MontoMaximo") Is DBNull.Value, Nothing, row("MontoMaximo").ToString()),
						.MontoMinimo = If(row("MontoMinimo") Is DBNull.Value, Nothing, row("MontoMinimo").ToString()),
						.PorManejo = If(row("PorManejo") Is DBNull.Value, Nothing, row("PorManejo").ToString()),
						.PorCapitalizacion = If(row("PorCapitalizacion") Is DBNull.Value, Nothing, row("PorCapitalizacion").ToString()),
						.PorProteccion = If(row("PorProteccion") Is DBNull.Value, Nothing, row("PorProteccion").ToString()),
						.snEliminado = CBool(row("snEliminado"))
					}
					tiposAuxiliares.Add(tipoAuxiliar)
				Next

				ModGlobal.EscribirLog($"Procesados {tiposAuxiliares.Count} tipos auxiliares")
				Dim resultado As New Dictionary(Of String, Object)
				resultado("Resultado") = "SUCCESS"
				resultado("Datos") = serializer.Serialize(tiposAuxiliares)
				resultado("Mensaje") = "Datos cargados exitosamente"
				ModGlobal.EscribirLog($"Respuesta serializada: {serializer.Serialize(resultado)}")
				Return serializer.Serialize(resultado)
			Else
				ModGlobal.EscribirLog($"Error en la consulta: {objSql.MensajeError}")
				Dim resultado As New Dictionary(Of String, Object)
				resultado("Resultado") = "ERROR"
				resultado("Mensaje") = objSql.MensajeError
				Return serializer.Serialize(resultado)
			End If

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ListarTiposAuxiliares: " & ex.Message)
			Dim resultado As New Dictionary(Of String, Object)
			resultado("Resultado") = "ERROR"
			resultado("Mensaje") = "Error al cargar tipos auxiliares: " & ex.Message
			Return serializer.Serialize(resultado)
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerTipoAuxiliar(id As Integer) As String
		Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
		Dim serializer As New JavaScriptSerializer()

		Try
			objSql.Parametros.Add("@ID", id)

			Dim sSql As String = "Exec spTiposAuxiliares_Obtener"
			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")

			Dim dt As DataTable = objSql.GetDataTableSql(sSql)
			ModGlobal.EscribirLog($"DataTable obtenido con {dt.Rows.Count} filas para ID {id}")

			If String.IsNullOrEmpty(objSql.MensajeError) Then
				Dim resultado As New Dictionary(Of String, Object)
				If dt.Rows.Count > 0 Then
					Dim row As DataRow = dt.Rows(0)
					Dim tipoAuxiliar As New With {
						.ID = row("ID").ToString(),
						.CodigoRubro = row("CodigoRubro").ToString(),
						.RubroDescripcion = row("RubroDescripcion").ToString(),
						.TipoAuxiliar = row("TipoAuxiliar").ToString(),
						.Descripcion = row("Descripcion").ToString(),
						.Tasa = If(row("Tasa") Is DBNull.Value, Nothing, row("Tasa").ToString()),
						.Plazo = If(row("Plazo") Is DBNull.Value, Nothing, row("Plazo").ToString()),
						.MontoMaximo = If(row("MontoMaximo") Is DBNull.Value, Nothing, row("MontoMaximo").ToString()),
						.MontoMinimo = If(row("MontoMinimo") Is DBNull.Value, Nothing, row("MontoMinimo").ToString()),
						.PorManejo = If(row("PorManejo") Is DBNull.Value, Nothing, row("PorManejo").ToString()),
						.PorCapitalizacion = If(row("PorCapitalizacion") Is DBNull.Value, Nothing, row("PorCapitalizacion").ToString()),
						.PorProteccion = If(row("PorProteccion") Is DBNull.Value, Nothing, row("PorProteccion").ToString()),
						.snEliminado = CBool(row("snEliminado"))
					}
					resultado("Resultado") = "SUCCESS"
					resultado("Datos") = serializer.Serialize(tipoAuxiliar)
					resultado("Mensaje") = "Tipo auxiliar obtenido exitosamente"
					ModGlobal.EscribirLog($"Tipo auxiliar encontrado: ID={tipoAuxiliar.ID}, CodigoRubro={tipoAuxiliar.CodigoRubro}")
				Else
					resultado("Resultado") = "ERROR"
					resultado("Mensaje") = "Tipo auxiliar no encontrado"
					ModGlobal.EscribirLog($"No se encontró tipo auxiliar con ID {id}")
				End If
				Return serializer.Serialize(resultado)
			Else
				Dim resultado As New Dictionary(Of String, Object)
				resultado("Resultado") = "ERROR"
				resultado("Mensaje") = objSql.MensajeError
				Return serializer.Serialize(resultado)
			End If

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ObtenerTipoAuxiliar: " & ex.Message)
			Dim resultado As New Dictionary(Of String, Object)
			resultado("Resultado") = "ERROR"
			resultado("Mensaje") = "Error al obtener tipo auxiliar: " & ex.Message
			Return serializer.Serialize(resultado)
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GuardarTipoAuxiliar(tipoAuxiliarData As Dictionary(Of String, Object)) As String
		Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
		Dim serializer As New JavaScriptSerializer()

		Try
			ModGlobal.EscribirLog("Iniciando GuardarTipoAuxiliar")

			' Validar que tipoAuxiliarData no sea Nothing
			If tipoAuxiliarData Is Nothing Then
				ModGlobal.EscribirLog("Error: tipoAuxiliarData es Nothing")
				Dim resultado As New Dictionary(Of String, Object)
				resultado("Resultado") = "ERROR"
				resultado("Mensaje") = "No se recibieron datos del tipo auxiliar"
				Return serializer.Serialize(resultado)
			End If

			ModGlobal.EscribirLog($"Datos recibidos: {serializer.Serialize(tipoAuxiliarData)}")

			' Agregar parámetros
			If tipoAuxiliarData.ContainsKey("ID") AndAlso Not String.IsNullOrEmpty(tipoAuxiliarData("ID").ToString()) Then
				objSql.Parametros.Add("@ID", Convert.ToInt32(tipoAuxiliarData("ID")))
			End If

			objSql.Parametros.Add("@CodigoRubro", tipoAuxiliarData("CodigoRubro").ToString())
			' TipoAuxiliar se maneja automáticamente en el stored procedure
			objSql.Parametros.Add("@Descripcion", tipoAuxiliarData("Descripcion").ToString())

			' Parámetros opcionales con validación de conversión mejorada
			If tipoAuxiliarData.ContainsKey("Tasa") AndAlso tipoAuxiliarData("Tasa") IsNot Nothing AndAlso Not String.IsNullOrEmpty(tipoAuxiliarData("Tasa").ToString()) Then
				Try
					objSql.Parametros.Add("@Tasa", Convert.ToDecimal(tipoAuxiliarData("Tasa")))
				Catch ex As Exception
					ModGlobal.EscribirLog($"Error convirtiendo Tasa: {ex.Message}")
					Throw New Exception("Error en el formato de la tasa: " & ex.Message)
				End Try
			End If

			If tipoAuxiliarData.ContainsKey("Plazo") AndAlso tipoAuxiliarData("Plazo") IsNot Nothing AndAlso Not String.IsNullOrEmpty(tipoAuxiliarData("Plazo").ToString()) Then
				Try
					objSql.Parametros.Add("@Plazo", Convert.ToInt32(tipoAuxiliarData("Plazo")))
				Catch ex As Exception
					ModGlobal.EscribirLog($"Error convirtiendo Plazo: {ex.Message}")
					Throw New Exception("Error en el formato del plazo: " & ex.Message)
				End Try
			End If

			If tipoAuxiliarData.ContainsKey("MontoMaximo") AndAlso tipoAuxiliarData("MontoMaximo") IsNot Nothing AndAlso Not String.IsNullOrEmpty(tipoAuxiliarData("MontoMaximo").ToString()) Then
				Try
					objSql.Parametros.Add("@MontoMaximo", Convert.ToDecimal(tipoAuxiliarData("MontoMaximo")))
				Catch ex As Exception
					ModGlobal.EscribirLog($"Error convirtiendo MontoMaximo: {ex.Message}")
					Throw New Exception("Error en el formato del monto máximo: " & ex.Message)
				End Try
			End If

			If tipoAuxiliarData.ContainsKey("MontoMinimo") AndAlso tipoAuxiliarData("MontoMinimo") IsNot Nothing AndAlso Not String.IsNullOrEmpty(tipoAuxiliarData("MontoMinimo").ToString()) Then
				Try
					objSql.Parametros.Add("@MontoMinimo", Convert.ToDecimal(tipoAuxiliarData("MontoMinimo")))
				Catch ex As Exception
					ModGlobal.EscribirLog($"Error convirtiendo MontoMinimo: {ex.Message}")
					Throw New Exception("Error en el formato del monto mínimo: " & ex.Message)
				End Try
			End If

			If tipoAuxiliarData.ContainsKey("PorManejo") AndAlso tipoAuxiliarData("PorManejo") IsNot Nothing AndAlso Not String.IsNullOrEmpty(tipoAuxiliarData("PorManejo").ToString()) Then
				Try
					objSql.Parametros.Add("@PorManejo", Convert.ToDecimal(tipoAuxiliarData("PorManejo")))
				Catch ex As Exception
					ModGlobal.EscribirLog($"Error convirtiendo PorManejo: {ex.Message}")
					Throw New Exception("Error en el formato del porcentaje de manejo: " & ex.Message)
				End Try
			End If

			If tipoAuxiliarData.ContainsKey("PorCapitalizacion") AndAlso tipoAuxiliarData("PorCapitalizacion") IsNot Nothing AndAlso Not String.IsNullOrEmpty(tipoAuxiliarData("PorCapitalizacion").ToString()) Then
				Try
					Dim valorPorCapitalizacion As String = tipoAuxiliarData("PorCapitalizacion").ToString()
					ModGlobal.EscribirLog($"PorCapitalizacion recibido: '{valorPorCapitalizacion}'")
					Dim valorDecimal As Decimal = Convert.ToDecimal(valorPorCapitalizacion)
					ModGlobal.EscribirLog($"PorCapitalizacion convertido a decimal: {valorDecimal}")
					objSql.Parametros.Add("@PorCapitalizacion", valorDecimal)
				Catch ex As Exception
					ModGlobal.EscribirLog($"Error convirtiendo PorCapitalizacion: {ex.Message}")
					Throw New Exception("Error en el formato del porcentaje de capitalización: " & ex.Message)
				End Try
			End If

			If tipoAuxiliarData.ContainsKey("PorProteccion") AndAlso tipoAuxiliarData("PorProteccion") IsNot Nothing AndAlso Not String.IsNullOrEmpty(tipoAuxiliarData("PorProteccion").ToString()) Then
				Try
					objSql.Parametros.Add("@PorProteccion", Convert.ToDecimal(tipoAuxiliarData("PorProteccion")))
				Catch ex As Exception
					ModGlobal.EscribirLog($"Error convirtiendo PorProteccion: {ex.Message}")
					Throw New Exception("Error en el formato del porcentaje de protección: " & ex.Message)
				End Try
			End If

			Dim sSql As String = "Exec spTiposAuxiliares_Guardar"
			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")

			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If String.IsNullOrEmpty(objSql.MensajeError) Then
				Dim resultado As New Dictionary(Of String, Object)
				If dt.Rows.Count > 0 Then
					resultado("Resultado") = dt.Rows(0)("Resultado").ToString()
					resultado("Mensaje") = dt.Rows(0)("Mensaje").ToString()
					If dt.Rows(0)("NuevoID") IsNot DBNull.Value Then
						resultado("NuevoID") = Convert.ToInt32(dt.Rows(0)("NuevoID"))
					End If
				Else
					resultado("Resultado") = "ERROR"
					resultado("Mensaje") = "Error desconocido al guardar tipo auxiliar"
				End If
				Return serializer.Serialize(resultado)
			Else
				Dim resultado As New Dictionary(Of String, Object)
				resultado("Resultado") = "ERROR"
				resultado("Mensaje") = objSql.MensajeError
				Return serializer.Serialize(resultado)
			End If

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GuardarTipoAuxiliar: " & ex.Message)
			Dim resultado As New Dictionary(Of String, Object)
			resultado("Resultado") = "ERROR"
			resultado("Mensaje") = "Error al guardar tipo auxiliar: " & ex.Message
			Return serializer.Serialize(resultado)
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function EliminarTipoAuxiliar(id As Integer) As String
		Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
		Dim serializer As New JavaScriptSerializer()

		Try
			objSql.Parametros.Add("@ID", id)

			Dim sSql As String = "Exec spTiposAuxiliares_Eliminar"
			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")

			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If String.IsNullOrEmpty(objSql.MensajeError) Then
				Dim resultado As New Dictionary(Of String, Object)
				If dt.Rows.Count > 0 Then
					resultado("Resultado") = dt.Rows(0)("Resultado").ToString()
					resultado("Mensaje") = dt.Rows(0)("Mensaje").ToString()
				Else
					resultado("Resultado") = "ERROR"
					resultado("Mensaje") = "Error desconocido al eliminar tipo auxiliar"
				End If
				Return serializer.Serialize(resultado)
			Else
				Dim resultado As New Dictionary(Of String, Object)
				resultado("Resultado") = "ERROR"
				resultado("Mensaje") = objSql.MensajeError
				Return serializer.Serialize(resultado)
			End If

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en EliminarTipoAuxiliar: " & ex.Message)
			Dim resultado As New Dictionary(Of String, Object)
			resultado("Resultado") = "ERROR"
			resultado("Mensaje") = "Error al eliminar tipo auxiliar: " & ex.Message
			Return serializer.Serialize(resultado)
		End Try
	End Function
#End Region

#Region "Usuarios"
	<WebMethod()>
	Public Shared Function ListarUsuarios(filtros As Dictionary(Of String, Object)) As String
		Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
		Dim serializer As New JavaScriptSerializer()

		Try
			ModGlobal.EscribirLog("Iniciando ListarUsuarios")

			' Agregar parámetros opcionales
			If filtros.ContainsKey("Rol") AndAlso Not String.IsNullOrEmpty(filtros("Rol").ToString()) Then
				objSql.Parametros.Add("@Rol", Convert.ToInt32(filtros("Rol")))
			End If

			If filtros.ContainsKey("Departamento") AndAlso Not String.IsNullOrEmpty(filtros("Departamento").ToString()) Then
				objSql.Parametros.Add("@Departamento", Convert.ToInt32(filtros("Departamento")))
			End If

			If filtros.ContainsKey("Estado") AndAlso Not String.IsNullOrEmpty(filtros("Estado").ToString()) Then
				objSql.Parametros.Add("@Estado", filtros("Estado").ToString())
			End If

			If filtros.ContainsKey("Buscar") AndAlso Not String.IsNullOrEmpty(filtros("Buscar").ToString()) Then
				objSql.Parametros.Add("@Buscar", filtros("Buscar").ToString())
			End If

			Dim sSql As String = "Exec spUsuarios_Listar"
			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")

			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If String.IsNullOrEmpty(objSql.MensajeError) Then
				Dim usuarios As New List(Of Object)
				For Each row As DataRow In dt.Rows
					Dim usuario As New With {
						.Id = row("Id").ToString(),
						.Nombre = row("Nombre").ToString(),
						.Apellido = row("Apellido").ToString(),
						.Usuario = row("Usuario").ToString(),
						.Email = row("Email").ToString(),
						.Telefono = If(row("Telefono") Is DBNull.Value, Nothing, row("Telefono").ToString()),
						.Rol = row("Rol").ToString(),
						.RolNombre = If(row("RolNombre") Is DBNull.Value, Nothing, row("RolNombre").ToString()),
						.Departamento = If(row("Departamento") Is DBNull.Value, Nothing, row("Departamento").ToString()),
						.DepartamentoNombre = If(row("DepartamentoNombre") Is DBNull.Value, Nothing, row("DepartamentoNombre").ToString()),
						.Estado = row("Estado").ToString(),
						.UltimoAcceso = If(row("UltimoAcceso") Is DBNull.Value, Nothing, row("UltimoAcceso").ToString()),
						.IntentosFallidos = Convert.ToInt32(row("IntentosFallidos")),
						.BloqueadoHasta = If(row("BloqueadoHasta") Is DBNull.Value, Nothing, row("BloqueadoHasta").ToString()),
						.FechaCreacion = row("FechaCreacion").ToString(),
						.FechaModificacion = If(row("FechaModificacion") Is DBNull.Value, Nothing, row("FechaModificacion").ToString()),
						.snEliminado = CBool(row("snEliminado"))
					}
					usuarios.Add(usuario)
				Next

				Dim resultado As New Dictionary(Of String, Object)
				resultado("Resultado") = "SUCCESS"
				resultado("Mensaje") = "Usuarios obtenidos exitosamente"
				resultado("Datos") = serializer.Serialize(usuarios)
				Return serializer.Serialize(resultado)
			Else
				Dim resultado As New Dictionary(Of String, Object)
				resultado("Resultado") = "ERROR"
				resultado("Mensaje") = objSql.MensajeError
				Return serializer.Serialize(resultado)
			End If

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ListarUsuarios: " & ex.Message)
			Dim resultado As New Dictionary(Of String, Object)
			resultado("Resultado") = "ERROR"
			resultado("Mensaje") = "Error al listar usuarios: " & ex.Message
			Return serializer.Serialize(resultado)
		End Try
	End Function

	<WebMethod()>
	Public Shared Function ObtenerUsuario(id As Integer) As String
		Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
		Dim serializer As New JavaScriptSerializer()

		Try
			ModGlobal.EscribirLog("Iniciando ObtenerUsuario")

			objSql.Parametros.Add("@ID", id)

			Dim sSql As String = "Exec spUsuarios_Obtener"
			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")

			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If String.IsNullOrEmpty(objSql.MensajeError) Then
				If dt.Rows.Count > 0 Then
					Dim row As DataRow = dt.Rows(0)
					Dim usuario As New With {
						.Id = row("Id").ToString(),
						.Nombre = row("Nombre").ToString(),
						.Apellido = row("Apellido").ToString(),
						.Usuario = row("Usuario").ToString(),
						.Email = row("Email").ToString(),
						.Telefono = If(row("Telefono") Is DBNull.Value, Nothing, row("Telefono").ToString()),
						.Rol = row("Rol").ToString(),
						.Departamento = If(row("Departamento") Is DBNull.Value, Nothing, row("Departamento").ToString()),
						.Estado = row("Estado").ToString(),
						.UltimoAcceso = If(row("UltimoAcceso") Is DBNull.Value, Nothing, row("UltimoAcceso").ToString()),
						.IntentosFallidos = Convert.ToInt32(row("IntentosFallidos")),
						.BloqueadoHasta = If(row("BloqueadoHasta") Is DBNull.Value, Nothing, row("BloqueadoHasta").ToString()),
						.FechaCreacion = row("FechaCreacion").ToString(),
						.FechaModificacion = If(row("FechaModificacion") Is DBNull.Value, Nothing, row("FechaModificacion").ToString()),
						.snEliminado = CBool(row("snEliminado"))
					}

					Dim resultado As New Dictionary(Of String, Object)
					resultado("Resultado") = "SUCCESS"
					resultado("Mensaje") = "Usuario obtenido exitosamente"
					resultado("Datos") = serializer.Serialize(usuario)
					Return serializer.Serialize(resultado)
				Else
					Dim resultado As New Dictionary(Of String, Object)
					resultado("Resultado") = "ERROR"
					resultado("Mensaje") = "Usuario no encontrado"
					Return serializer.Serialize(resultado)
				End If
			Else
				Dim resultado As New Dictionary(Of String, Object)
				resultado("Resultado") = "ERROR"
				resultado("Mensaje") = objSql.MensajeError
				Return serializer.Serialize(resultado)
			End If

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ObtenerUsuario: " & ex.Message)
			Dim resultado As New Dictionary(Of String, Object)
			resultado("Resultado") = "ERROR"
			resultado("Mensaje") = "Error al obtener usuario: " & ex.Message
			Return serializer.Serialize(resultado)
		End Try
	End Function

	<WebMethod()>
	Public Shared Function GuardarUsuario(usuarioData As Dictionary(Of String, Object)) As String
		Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
		Dim serializer As New JavaScriptSerializer()

		Try
			ModGlobal.EscribirLog("Iniciando GuardarUsuario")

			' Validar que usuarioData no sea Nothing
			If usuarioData Is Nothing Then
				ModGlobal.EscribirLog("Error: usuarioData es Nothing")
				Dim resultado As New Dictionary(Of String, Object)
				resultado("Resultado") = "ERROR"
				resultado("Mensaje") = "No se recibieron datos del usuario"
				Return serializer.Serialize(resultado)
			End If

			ModGlobal.EscribirLog($"Datos recibidos: {serializer.Serialize(usuarioData)}")

			' Agregar parámetros
			If usuarioData.ContainsKey("ID") AndAlso Not String.IsNullOrEmpty(usuarioData("ID").ToString()) Then
				objSql.Parametros.Add("@ID", Convert.ToInt32(usuarioData("ID")))
			End If

			objSql.Parametros.Add("@Nombre", usuarioData("Nombre").ToString())
			objSql.Parametros.Add("@Apellido", usuarioData("Apellido").ToString())
			objSql.Parametros.Add("@Usuario", usuarioData("Usuario").ToString())
			objSql.Parametros.Add("@Email", usuarioData("Email").ToString())
			objSql.Parametros.Add("@Rol", Convert.ToInt32(usuarioData("Rol")))
			objSql.Parametros.Add("@Estado", usuarioData("Estado").ToString())

			' Parámetros opcionales
			If usuarioData.ContainsKey("Clave") AndAlso Not String.IsNullOrEmpty(usuarioData("Clave").ToString()) Then
				objSql.Parametros.Add("@Clave", usuarioData("Clave").ToString())
			End If

			If usuarioData.ContainsKey("Telefono") AndAlso Not String.IsNullOrEmpty(usuarioData("Telefono").ToString()) Then
				objSql.Parametros.Add("@Telefono", usuarioData("Telefono").ToString())
			End If

			If usuarioData.ContainsKey("Departamento") AndAlso Not String.IsNullOrEmpty(usuarioData("Departamento").ToString()) Then
				objSql.Parametros.Add("@Departamento", Convert.ToInt32(usuarioData("Departamento")))
			End If

			Dim sSql As String = "Exec spUsuarios_Guardar"
			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")

			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If String.IsNullOrEmpty(objSql.MensajeError) Then
				Dim resultado As New Dictionary(Of String, Object)
				If dt.Rows.Count > 0 Then
					resultado("Resultado") = dt.Rows(0)("Resultado").ToString()
					resultado("Mensaje") = dt.Rows(0)("Mensaje").ToString()
					If dt.Rows(0)("NuevoID") IsNot DBNull.Value Then
						resultado("NuevoID") = Convert.ToInt32(dt.Rows(0)("NuevoID"))
					End If
				Else
					resultado("Resultado") = "ERROR"
					resultado("Mensaje") = "Error desconocido al guardar usuario"
				End If
				Return serializer.Serialize(resultado)
			Else
				Dim resultado As New Dictionary(Of String, Object)
				resultado("Resultado") = "ERROR"
				resultado("Mensaje") = objSql.MensajeError
				Return serializer.Serialize(resultado)
			End If

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GuardarUsuario: " & ex.Message)
			Dim resultado As New Dictionary(Of String, Object)
			resultado("Resultado") = "ERROR"
			resultado("Mensaje") = "Error al guardar usuario: " & ex.Message
			Return serializer.Serialize(resultado)
		End Try
	End Function

	<WebMethod()>
	Public Shared Function EliminarUsuario(id As Integer) As String
		Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
		Dim serializer As New JavaScriptSerializer()

		Try
			ModGlobal.EscribirLog("Iniciando EliminarUsuario")

			objSql.Parametros.Add("@ID", id)

			Dim sSql As String = "Exec spUsuarios_Eliminar"
			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")

			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If String.IsNullOrEmpty(objSql.MensajeError) Then
				Dim resultado As New Dictionary(Of String, Object)
				If dt.Rows.Count > 0 Then
					resultado("Resultado") = dt.Rows(0)("Resultado").ToString()
					resultado("Mensaje") = dt.Rows(0)("Mensaje").ToString()
				Else
					resultado("Resultado") = "ERROR"
					resultado("Mensaje") = "Error desconocido al eliminar usuario"
				End If
				Return serializer.Serialize(resultado)
			Else
				Dim resultado As New Dictionary(Of String, Object)
				resultado("Resultado") = "ERROR"
				resultado("Mensaje") = objSql.MensajeError
				Return serializer.Serialize(resultado)
			End If

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en EliminarUsuario: " & ex.Message)
			Dim resultado As New Dictionary(Of String, Object)
			resultado("Resultado") = "ERROR"
			resultado("Mensaje") = "Error al eliminar usuario: " & ex.Message
			Return serializer.Serialize(resultado)
		End Try
	End Function
#End Region

#Region "NIVELES DE ESTUDIO"
	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ListarNivelesEstudio(filtros As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ListarNivelesEstudio iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "SELECT ID, Code, Descripcion FROM tbNivelesEstudio WHERE snEliminado = 0"

			' Aplicar filtros si existen
			If filtros IsNot Nothing Then
				Dim filtrosDict As Dictionary(Of String, Object) = TryCast(filtros, Dictionary(Of String, Object))
				If filtrosDict IsNot Nothing Then
					If Not String.IsNullOrEmpty(filtrosDict("Codigo")?.ToString()) Then
						sSql += " AND Code = " & filtrosDict("Codigo").ToString()
					End If
					If Not String.IsNullOrEmpty(filtrosDict("Descripcion")?.ToString()) Then
						sSql += " AND Descripcion LIKE '%" & filtrosDict("Descripcion").ToString() & "%'"
					End If
				End If
			End If

			sSql += " ORDER BY Code"

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener niveles de estudio: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				})
			End If

			' Crear lista de objetos
			Dim niveles As New List(Of Object)
			For Each row As DataRow In dt.Rows
				Dim nivel As New With {
					.ID = row("ID").ToString(),
					.Code = row("Code").ToString(),
					.Descripcion = row("Descripcion").ToString()
				}
				niveles.Add(nivel)
			Next

			ModGlobal.EscribirLog($"Niveles de estudio obtenidos: {niveles.Count} registros")
			Return serializer.Serialize(New With {
				.Resultado = "SUCCESS",
				.Datos = serializer.Serialize(niveles),
				.Mensaje = "Niveles de estudio obtenidos exitosamente"
			})

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ListarNivelesEstudio: " & ex.Message)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al obtener niveles de estudio: " & ex.Message
			})
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GuardarNivelEstudio(nivelData As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("GuardarNivelEstudio iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim nivelDict As Dictionary(Of String, Object) = TryCast(nivelData, Dictionary(Of String, Object))

			If nivelDict Is Nothing Then
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Datos de nivel inválidos"
				})
			End If

			Dim id As String = nivelDict("ID")?.ToString()
			Dim codigo As String = nivelDict("Code")?.ToString()
			Dim descripcion As String = nivelDict("Descripcion")?.ToString()

			' Validaciones
			If String.IsNullOrEmpty(codigo) Or String.IsNullOrEmpty(descripcion) Then
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Código y descripción son requeridos"
				})
			End If

			' Verificar si el código ya existe (excluyendo el registro actual si es actualización)
			Dim sSqlVerificar As String
			If String.IsNullOrEmpty(id) Then
				' Para inserción: verificar si el código ya existe
				sSqlVerificar = "SELECT COUNT(*) FROM tbNivelesEstudio WHERE Code = @Code AND snEliminado = 0"
				objSql.Parametros.Add("@Code", codigo)
			Else
				' Para actualización: verificar si el código ya existe en otros registros
				sSqlVerificar = "SELECT COUNT(*) FROM tbNivelesEstudio WHERE Code = @Code AND ID <> @ID AND snEliminado = 0"
				objSql.Parametros.Add("@Code", codigo)
				objSql.Parametros.Add("@ID", id)
			End If

			ModGlobal.EscribirLog($"Verificando código duplicado: {sSqlVerificar} {objSql.getParamList()}")
			Dim existeCodigo As Integer = Convert.ToInt32(objSql.ExecuteQuerySingleValue(sSqlVerificar))

			If existeCodigo > 0 Then
				ModGlobal.EscribirLog("Código duplicado detectado")
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "El código ingresado ya existe. Por favor, ingrese un código diferente."
				})
			End If

			' Limpiar parámetros para la operación principal
			objSql.Parametros.Clear()

			Dim sSql As String
			If String.IsNullOrEmpty(id) Then
				' Insertar nuevo nivel
				sSql = "INSERT INTO tbNivelesEstudio (Code, Descripcion, snEliminado) VALUES (@Code, @Descripcion, 0)"
				objSql.Parametros.Add("@Code", codigo)
				objSql.Parametros.Add("@Descripcion", descripcion)
			Else
				' Actualizar nivel existente
				sSql = "UPDATE tbNivelesEstudio SET Code = @Code, Descripcion = @Descripcion WHERE ID = @ID"
				objSql.Parametros.Add("@Code", codigo)
				objSql.Parametros.Add("@Descripcion", descripcion)
				objSql.Parametros.Add("@ID", id)
			End If

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			objSql.ExecuteNonQuerySql(sSql)

			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al guardar nivel: " & objSql.MensajeError)

				' Verificar si es un error de clave única duplicada
				If objSql.MensajeError.Contains("UNIQUE KEY constraint") Or objSql.MensajeError.Contains("duplicate key") Then
					Return serializer.Serialize(New With {
						.Resultado = "ERROR",
						.Mensaje = "El código ingresado ya existe. Por favor, ingrese un código diferente."
					})
				End If

				' Otros errores de base de datos
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				})
			End If

			ModGlobal.EscribirLog("Nivel de estudio guardado exitosamente")
			Return serializer.Serialize(New With {
				.Resultado = "SUCCESS",
				.Mensaje = "Nivel de estudio guardado exitosamente"
			})

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GuardarNivelEstudio: " & ex.Message)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al guardar nivel de estudio: " & ex.Message
			})
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function EliminarNivelEstudio(id As Integer) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog($"EliminarNivelEstudio iniciado para ID: {id}")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "UPDATE tbNivelesEstudio SET snEliminado = 1 WHERE ID = @ID"

			objSql.Parametros.Add("@ID", id)

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			objSql.ExecuteNonQuerySql(sSql)

			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al eliminar nivel: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				})
			End If

			ModGlobal.EscribirLog("Nivel de estudio eliminado exitosamente")
			Return serializer.Serialize(New With {
				.Resultado = "SUCCESS",
				.Mensaje = "Nivel de estudio eliminado exitosamente"
			})

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en EliminarNivelEstudio: " & ex.Message)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al eliminar nivel de estudio: " & ex.Message
			})
		End Try
	End Function
#End Region

#Region "PROFESIONES"
	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ListarProfesiones(filtros As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ListarProfesiones iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "SELECT ID, Code, Descripcion FROM tbProfesiones WHERE snEliminado = 0"

			' Aplicar filtros si existen
			If filtros IsNot Nothing Then
				Dim filtrosDict As Dictionary(Of String, Object) = TryCast(filtros, Dictionary(Of String, Object))
				If filtrosDict IsNot Nothing Then
					If Not String.IsNullOrEmpty(filtrosDict("Codigo")?.ToString()) Then
						sSql += " AND Code = " & filtrosDict("Codigo").ToString()
					End If
					If Not String.IsNullOrEmpty(filtrosDict("Descripcion")?.ToString()) Then
						sSql += " AND Descripcion LIKE '%" & filtrosDict("Descripcion").ToString() & "%'"
					End If
				End If
			End If

			sSql += " ORDER BY Code"

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener profesiones: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				})
			End If

			' Crear lista de objetos
			Dim profesiones As New List(Of Object)
			For Each row As DataRow In dt.Rows
				Dim profesion As New With {
					.ID = row("ID").ToString(),
					.Code = row("Code").ToString(),
					.Descripcion = row("Descripcion").ToString()
				}
				profesiones.Add(profesion)
			Next

			ModGlobal.EscribirLog($"Profesiones obtenidas: {profesiones.Count} registros")
			Return serializer.Serialize(New With {
				.Resultado = "SUCCESS",
				.Datos = serializer.Serialize(profesiones),
				.Mensaje = "Profesiones obtenidas exitosamente"
			})

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ListarProfesiones: " & ex.Message)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al obtener profesiones: " & ex.Message
			})
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GuardarProfesion(profesionData As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("GuardarProfesion iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim profesionDict As Dictionary(Of String, Object) = TryCast(profesionData, Dictionary(Of String, Object))

			If profesionDict Is Nothing Then
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Datos de profesión inválidos"
				})
			End If

			Dim id As String = profesionDict("ID")?.ToString()
			Dim codigo As String = profesionDict("Code")?.ToString()
			Dim descripcion As String = profesionDict("Descripcion")?.ToString()

			' Validaciones
			If String.IsNullOrEmpty(codigo) Or String.IsNullOrEmpty(descripcion) Then
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Código y descripción son requeridos"
				})
			End If

			' Verificar si el código ya existe (excluyendo el registro actual si es actualización)
			Dim sSqlVerificar As String
			If String.IsNullOrEmpty(id) Then
				' Para inserción: verificar si el código ya existe
				sSqlVerificar = "SELECT COUNT(*) FROM tbProfesiones WHERE Code = @Code AND snEliminado = 0"
				objSql.Parametros.Add("@Code", codigo)
			Else
				' Para actualización: verificar si el código ya existe en otros registros
				sSqlVerificar = "SELECT COUNT(*) FROM tbProfesiones WHERE Code = @Code AND ID <> @ID AND snEliminado = 0"
				objSql.Parametros.Add("@Code", codigo)
				objSql.Parametros.Add("@ID", id)
			End If

			ModGlobal.EscribirLog($"Verificando código duplicado: {sSqlVerificar} {objSql.getParamList()}")
			Dim existeCodigo As Integer = Convert.ToInt32(objSql.ExecuteQuerySingleValue(sSqlVerificar))

			If existeCodigo > 0 Then
				ModGlobal.EscribirLog("Código duplicado detectado")
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "El código ingresado ya existe. Por favor, ingrese un código diferente."
				})
			End If

			' Limpiar parámetros para la operación principal
			objSql.Parametros.Clear()

			Dim sSql As String
			If String.IsNullOrEmpty(id) Then
				' Insertar nueva profesión
				sSql = "INSERT INTO tbProfesiones (Code, Descripcion, snEliminado) VALUES (@Code, @Descripcion, 0)"
				objSql.Parametros.Add("@Code", codigo)
				objSql.Parametros.Add("@Descripcion", descripcion)
			Else
				' Actualizar profesión existente
				sSql = "UPDATE tbProfesiones SET Code = @Code, Descripcion = @Descripcion WHERE ID = @ID"
				objSql.Parametros.Add("@Code", codigo)
				objSql.Parametros.Add("@Descripcion", descripcion)
				objSql.Parametros.Add("@ID", id)
			End If

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			objSql.ExecuteNonQuerySql(sSql)

			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al guardar profesión: " & objSql.MensajeError)

				' Verificar si es un error de clave única duplicada
				If objSql.MensajeError.Contains("UNIQUE KEY constraint") Or objSql.MensajeError.Contains("duplicate key") Then
					Return serializer.Serialize(New With {
						.Resultado = "ERROR",
						.Mensaje = "El código ingresado ya existe. Por favor, ingrese un código diferente."
					})
				End If

				' Otros errores de base de datos
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				})
			End If

			ModGlobal.EscribirLog("Profesión guardada exitosamente")
			Return serializer.Serialize(New With {
				.Resultado = "SUCCESS",
				.Mensaje = "Profesión guardada exitosamente"
			})

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GuardarProfesion: " & ex.Message)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al guardar profesión: " & ex.Message
			})
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function EliminarProfesion(id As Integer) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog($"EliminarProfesion iniciado para ID: {id}")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "UPDATE tbProfesiones SET snEliminado = 1 WHERE ID = @ID"

			objSql.Parametros.Add("@ID", id)

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			objSql.ExecuteNonQuerySql(sSql)

			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al eliminar profesión: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				})
			End If

			ModGlobal.EscribirLog("Profesión eliminada exitosamente")
			Return serializer.Serialize(New With {
				.Resultado = "SUCCESS",
				.Mensaje = "Profesión eliminada exitosamente"
			})

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en EliminarProfesion: " & ex.Message)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al eliminar profesión: " & ex.Message
			})
		End Try
	End Function
#End Region

#Region "EMPRESAS"
	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ListarEmpresas(filtros As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ListarEmpresas iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "SELECT ID, Code, Descripcion FROM tbEmpresas WHERE snEliminado = 0"

			' Aplicar filtros si existen
			If filtros IsNot Nothing Then
				Dim filtrosDict As Dictionary(Of String, Object) = TryCast(filtros, Dictionary(Of String, Object))
				If filtrosDict IsNot Nothing Then
					If Not String.IsNullOrEmpty(filtrosDict("Codigo")?.ToString()) Then
						sSql += " AND Code = " & filtrosDict("Codigo").ToString()
					End If
					If Not String.IsNullOrEmpty(filtrosDict("Descripcion")?.ToString()) Then
						sSql += " AND Descripcion LIKE '%" & filtrosDict("Descripcion").ToString() & "%'"
					End If
				End If
			End If

			sSql += " ORDER BY Code"

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener empresas: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				})
			End If

			' Crear lista de objetos
			Dim empresas As New List(Of Object)
			For Each row As DataRow In dt.Rows
				Dim empresa As New With {
					.ID = row("ID").ToString(),
					.Code = row("Code").ToString(),
					.Descripcion = row("Descripcion").ToString()
				}
				empresas.Add(empresa)
			Next

			ModGlobal.EscribirLog($"Empresas obtenidas: {empresas.Count} registros")
			Return serializer.Serialize(New With {
				.Resultado = "SUCCESS",
				.Datos = serializer.Serialize(empresas),
				.Mensaje = "Empresas obtenidas exitosamente"
			})

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ListarEmpresas: " & ex.Message)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al obtener empresas: " & ex.Message
			})
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GuardarEmpresa(empresaData As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("GuardarEmpresa iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim empresaDict As Dictionary(Of String, Object) = TryCast(empresaData, Dictionary(Of String, Object))

			If empresaDict Is Nothing Then
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Datos de empresa inválidos"
				})
			End If

			Dim id As String = empresaDict("ID")?.ToString()
			Dim codigo As String = empresaDict("Code")?.ToString()
			Dim descripcion As String = empresaDict("Descripcion")?.ToString()

			' Validaciones
			If String.IsNullOrEmpty(codigo) Or String.IsNullOrEmpty(descripcion) Then
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Código y descripción son requeridos"
				})
			End If

			' Convertir código a entero
			Dim codigoInt As Integer
			If Not Integer.TryParse(codigo, codigoInt) Or codigoInt <= 0 Then
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "El código debe ser un número entero mayor a cero"
				})
			End If

			' Usar stored procedure
			Dim sSql As String = "Exec spEmpresas_Guardar"
			With objSql.Parametros
				.Clear()
				If Not String.IsNullOrEmpty(id) Then
					.Add("@ID", Convert.ToInt32(id))
				End If
				.Add("@Code", codigoInt)
				.Add("@Descripcion", descripcion)
			End With

			Dim dt As DataTable = objSql.GetDataTableSql(sSql)
			If objSql.MensajeError <> "" Then
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Error al guardar empresa: " & objSql.MensajeError
				})
			End If

			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()
				Return serializer.Serialize(New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				})
			Else
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				})
			End If

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GuardarEmpresa: " & ex.Message)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al guardar empresa: " & ex.Message
			})
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function EliminarEmpresa(id As Integer) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog($"EliminarEmpresa iniciado para ID: {id}")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spEmpresas_Eliminar"

			With objSql.Parametros
				.Clear()
				.Add("@ID", id)
			End With

			ModGlobal.EscribirLog($"EliminarEmpresa - Ejecutando SP: {sSql} con parámetro @ID = {id}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)
			ModGlobal.EscribirLog($"EliminarEmpresa - Resultado: Filas={dt.Rows.Count}, Error={objSql.MensajeError}")

			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog($"EliminarEmpresa - Error al eliminar empresa: {objSql.MensajeError}")
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Error al eliminar empresa: " & objSql.MensajeError
				})
			End If

			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()
				ModGlobal.EscribirLog($"EliminarEmpresa - Respuesta SP: Resultado={resultado}, Mensaje={mensaje}")
				Return serializer.Serialize(New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				})
			Else
				ModGlobal.EscribirLog("EliminarEmpresa - ERROR: No se recibió respuesta del servidor (dt.Rows.Count = 0)")
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				})
			End If

		Catch ex As Exception
			ModGlobal.EscribirLog($"EliminarEmpresa - Error en EliminarEmpresa: {ex.Message} | StackTrace: {ex.StackTrace}")
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al eliminar empresa: " & ex.Message
			})
		End Try
	End Function
#End Region

#Region "OCUPACIONES"
	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ListarOcupaciones(filtros As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ListarOcupaciones iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "SELECT ID, Code, Descripcion FROM tbOcupaciones WHERE snEliminado = 0"

			' Aplicar filtros si existen
			If filtros IsNot Nothing Then
				Dim filtrosDict As Dictionary(Of String, Object) = TryCast(filtros, Dictionary(Of String, Object))
				If filtrosDict IsNot Nothing Then
					If Not String.IsNullOrEmpty(filtrosDict("Codigo")?.ToString()) Then
						sSql += " AND Code = " & filtrosDict("Codigo").ToString()
					End If
					If Not String.IsNullOrEmpty(filtrosDict("Descripcion")?.ToString()) Then
						sSql += " AND Descripcion LIKE '%" & filtrosDict("Descripcion").ToString() & "%'"
					End If
				End If
			End If

			sSql += " ORDER BY Code"

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener ocupaciones: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				})
			End If

			' Crear lista de objetos
			Dim ocupaciones As New List(Of Object)
			For Each row As DataRow In dt.Rows
				Dim ocupacion As New With {
					.ID = row("ID").ToString(),
					.Code = row("Code").ToString(),
					.Descripcion = row("Descripcion").ToString()
				}
				ocupaciones.Add(ocupacion)
			Next

			ModGlobal.EscribirLog($"Ocupaciones obtenidas: {ocupaciones.Count} registros")
			Return serializer.Serialize(New With {
				.Resultado = "SUCCESS",
				.Datos = serializer.Serialize(ocupaciones),
				.Mensaje = "Ocupaciones obtenidas exitosamente"
			})

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ListarOcupaciones: " & ex.Message)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al obtener ocupaciones: " & ex.Message
			})
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GuardarOcupacion(ocupacionData As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("GuardarOcupacion iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim ocupacionDict As Dictionary(Of String, Object) = TryCast(ocupacionData, Dictionary(Of String, Object))

			If ocupacionDict Is Nothing Then
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Datos de ocupación no válidos"
				})
			End If

			Dim id As String = ocupacionDict("ID")?.ToString()
			Dim codigo As Integer = Convert.ToInt32(ocupacionDict("Code"))
			Dim descripcion As String = ocupacionDict("Descripcion").ToString()

			' Usar stored procedure
			Dim sSql As String = "Exec spOcupaciones_Guardar"
			With objSql.Parametros
				.Clear()
				If Not String.IsNullOrEmpty(id) Then
					.Add("@ID", Convert.ToInt32(id))
				End If
				.Add("@Code", codigo)
				.Add("@Descripcion", descripcion)
			End With

			Dim dt As DataTable = objSql.GetDataTableSql(sSql)
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error al guardar ocupación: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Error al guardar ocupación: " & objSql.MensajeError
				})
			End If

			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()
				ModGlobal.EscribirLog("Ocupación guardada: " & mensaje)
				Return serializer.Serialize(New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				})
			Else
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				})
			End If

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GuardarOcupacion: " & ex.Message)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al guardar ocupación: " & ex.Message
			})
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function EliminarOcupacion(id As Integer) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("EliminarOcupacion iniciado para ID: " & id)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spOcupaciones_Eliminar"

			With objSql.Parametros
				.Clear()
				.Add("@ID", id)
			End With

			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error al eliminar ocupación: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Error al eliminar ocupación: " & objSql.MensajeError
				})
			End If

			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()
				ModGlobal.EscribirLog("Ocupación eliminada: " & mensaje)
				Return serializer.Serialize(New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				})
			Else
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				})
			End If

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en EliminarOcupacion: " & ex.Message)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al eliminar ocupación: " & ex.Message
			})
		End Try
	End Function
#End Region

#Region "PAÍSES"
	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ListarPaises(filtros As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ListarPaises iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "SELECT ID, Code, Descripcion FROM tbPaises WHERE snEliminado = 0"

			' Aplicar filtros si existen
			If filtros IsNot Nothing Then
				Dim filtrosDict As Dictionary(Of String, Object) = TryCast(filtros, Dictionary(Of String, Object))
				If filtrosDict IsNot Nothing Then
					If filtrosDict.ContainsKey("CodigoISO") AndAlso Not String.IsNullOrEmpty(filtrosDict("CodigoISO")?.ToString()) Then
						sSql += " AND Code LIKE '%" & filtrosDict("CodigoISO").ToString().Replace("'", "''") & "%'"
					End If
					If filtrosDict.ContainsKey("Descripcion") AndAlso Not String.IsNullOrEmpty(filtrosDict("Descripcion")?.ToString()) Then
						sSql += " AND Descripcion LIKE '%" & filtrosDict("Descripcion").ToString().Replace("'", "''") & "%'"
					End If
				End If
			End If

			sSql += " ORDER BY Code"

			ModGlobal.EscribirLog($"Ejecutando: {sSql}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener países: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				})
			End If

			' Crear lista de objetos
			Dim paises As New List(Of Object)
			For Each row As DataRow In dt.Rows
				Dim pais As New With {
					.ID = Convert.ToInt32(row("ID")),
					.Code = row("Code").ToString(),
					.Descripcion = row("Descripcion").ToString()
				}
				paises.Add(pais)
			Next

			ModGlobal.EscribirLog($"Países obtenidos: {paises.Count} registros")
			Return serializer.Serialize(New With {
				.Resultado = "SUCCESS",
				.Datos = serializer.Serialize(paises),
				.Mensaje = "Países obtenidos exitosamente"
			})

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ListarPaises: " & ex.Message)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al obtener países: " & ex.Message
			})
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GuardarPais(paisData As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("GuardarPais iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim paisDict As Dictionary(Of String, Object) = TryCast(paisData, Dictionary(Of String, Object))

			If paisDict Is Nothing Then
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Datos de país inválidos"
				})
			End If

			Dim id As String = paisDict("ID")?.ToString()
			Dim codigo As String = paisDict("Code")?.ToString().Trim().ToUpper()
			Dim descripcion As String = paisDict("Descripcion")?.ToString().Trim()

			' Validaciones
			If String.IsNullOrEmpty(codigo) Or String.IsNullOrEmpty(descripcion) Then
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Código ISO y descripción son requeridos"
				})
			End If

			' Usar stored procedure
			Dim sSql As String = "Exec spPaises_Guardar"
			With objSql.Parametros
				.Clear()
				If Not String.IsNullOrEmpty(id) Then
					.Add("@ID", Convert.ToInt32(id))
				End If
				.Add("@Code", codigo)
				.Add("@Descripcion", descripcion)
			End With

			Dim dt As DataTable = objSql.GetDataTableSql(sSql)
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error al guardar país: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Error al guardar país: " & objSql.MensajeError
				})
			End If

			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()
				ModGlobal.EscribirLog("País guardado: " & mensaje)
				Return serializer.Serialize(New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				})
			Else
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				})
			End If

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GuardarPais: " & ex.Message)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al guardar país: " & ex.Message
			})
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function EliminarPais(id As Integer) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("EliminarPais iniciado para ID: " & id)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spPaises_Eliminar"

			With objSql.Parametros
				.Clear()
				.Add("@ID", id)
			End With

			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error al eliminar país: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Error al eliminar país: " & objSql.MensajeError
				})
			End If

			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()
				ModGlobal.EscribirLog("País eliminado: " & mensaje)
				Return serializer.Serialize(New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				})
			Else
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				})
			End If

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en EliminarPais: " & ex.Message)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al eliminar país: " & ex.Message
			})
		End Try
	End Function
#End Region

#Region "PROVINCIAS"
	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ListarProvincias(filtros As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ListarProvincias iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "SELECT p.ID, p.Code, p.CodePais, p.Descripcion, pa.Descripcion AS PaisDescripcion " &
								"FROM tbProvincias p " &
								"LEFT JOIN tbPaises pa ON p.CodePais = pa.Code " &
								"WHERE p.snEliminado = 0"

			' Aplicar filtros si existen
			If filtros IsNot Nothing Then
				Dim filtrosDict As Dictionary(Of String, Object) = TryCast(filtros, Dictionary(Of String, Object))
				If filtrosDict IsNot Nothing Then
					If filtrosDict.ContainsKey("Code") AndAlso Not String.IsNullOrEmpty(filtrosDict("Code")?.ToString()) Then
						sSql += " AND p.Code = " & filtrosDict("Code").ToString()
					End If
					If filtrosDict.ContainsKey("CodePais") AndAlso Not String.IsNullOrEmpty(filtrosDict("CodePais")?.ToString()) Then
						sSql += " AND p.CodePais = '" & filtrosDict("CodePais").ToString().Replace("'", "''") & "'"
					End If
					If filtrosDict.ContainsKey("Descripcion") AndAlso Not String.IsNullOrEmpty(filtrosDict("Descripcion")?.ToString()) Then
						sSql += " AND p.Descripcion LIKE '%" & filtrosDict("Descripcion").ToString().Replace("'", "''") & "%'"
					End If
				End If
			End If

			sSql += " ORDER BY p.CodePais, p.Code"

			ModGlobal.EscribirLog($"Ejecutando: {sSql}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener provincias: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				})
			End If

			' Crear lista de objetos
			Dim provincias As New List(Of Object)
			For Each row As DataRow In dt.Rows
				Dim provincia As New With {
					.ID = Convert.ToInt32(row("ID")),
					.Code = Convert.ToInt32(row("Code")),
					.CodePais = row("CodePais").ToString(),
					.Descripcion = row("Descripcion").ToString(),
					.PaisDescripcion = If(row("PaisDescripcion") IsNot DBNull.Value, row("PaisDescripcion").ToString(), "")
				}
				provincias.Add(provincia)
			Next

			ModGlobal.EscribirLog($"Provincias obtenidas: {provincias.Count} registros")
			Return serializer.Serialize(New With {
				.Resultado = "SUCCESS",
				.Datos = serializer.Serialize(provincias),
				.Mensaje = "Provincias obtenidas exitosamente"
			})

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ListarProvincias: " & ex.Message)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al obtener provincias: " & ex.Message
			})
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GuardarProvincia(provinciaData As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("GuardarProvincia iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim provinciaDict As Dictionary(Of String, Object) = TryCast(provinciaData, Dictionary(Of String, Object))

			If provinciaDict Is Nothing Then
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Datos de provincia inválidos"
				})
			End If

			Dim id As String = provinciaDict("ID")?.ToString()
			Dim codigo As Integer = Convert.ToInt32(provinciaDict("Code"))
			Dim codigoPais As String = provinciaDict("CodePais")?.ToString().Trim().ToUpper()
			Dim descripcion As String = provinciaDict("Descripcion")?.ToString().Trim()

			ModGlobal.EscribirLog($"GuardarProvincia - ID recibido: '{id}' (IsNullOrEmpty: {String.IsNullOrEmpty(id)})")
			ModGlobal.EscribirLog($"GuardarProvincia - Code: {codigo}, CodePais: {codigoPais}, Descripcion: {descripcion}")

			' Validaciones
			If codigo <= 0 Or String.IsNullOrEmpty(codigoPais) Or String.IsNullOrEmpty(descripcion) Then
				ModGlobal.EscribirLog("GuardarProvincia - Error de validación: Código, país y descripción son requeridos")
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Código, país y descripción son requeridos"
				})
			End If

			' Usar stored procedure
			Dim sSql As String = "Exec spProvincias_Guardar"
			With objSql.Parametros
				.Clear()
				If Not String.IsNullOrEmpty(id) Then
					Dim idInt As Integer = Convert.ToInt32(id)
					ModGlobal.EscribirLog($"GuardarProvincia - Agregando parámetro @ID = {idInt}")
					.Add("@ID", idInt)
				Else
					ModGlobal.EscribirLog("GuardarProvincia - No se agrega parámetro @ID (es NULL/vacío)")
				End If
				ModGlobal.EscribirLog($"GuardarProvincia - Agregando parámetros: @Code={codigo}, @CodePais={codigoPais}, @Descripcion={descripcion}")
				.Add("@Code", codigo)
				.Add("@CodePais", codigoPais)
				.Add("@Descripcion", descripcion)
			End With

			ModGlobal.EscribirLog($"GuardarProvincia - Ejecutando SP: {sSql} con parámetros: {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)
			ModGlobal.EscribirLog($"GuardarProvincia - Resultado: Filas={dt.Rows.Count}, Error={objSql.MensajeError}")
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error al guardar provincia: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Error al guardar provincia: " & objSql.MensajeError
				})
			End If

			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()
				ModGlobal.EscribirLog($"GuardarProvincia - Respuesta SP: Resultado={resultado}, Mensaje={mensaje}")
				Return serializer.Serialize(New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				})
			Else
				ModGlobal.EscribirLog("GuardarProvincia - ERROR: No se recibió respuesta del servidor (dt.Rows.Count = 0)")
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				})
			End If

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GuardarProvincia: " & ex.Message)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al guardar provincia: " & ex.Message
			})
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function EliminarProvincia(id As Integer) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("EliminarProvincia iniciado para ID: " & id)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spProvincias_Eliminar"

			With objSql.Parametros
				.Clear()
				.Add("@ID", id)
			End With

			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error al eliminar provincia: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Error al eliminar provincia: " & objSql.MensajeError
				})
			End If

			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()
				ModGlobal.EscribirLog("Provincia eliminada: " & mensaje)
				Return serializer.Serialize(New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				})
			Else
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				})
			End If

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en EliminarProvincia: " & ex.Message)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al eliminar provincia: " & ex.Message
			})
		End Try
	End Function
#End Region

#Region "DISTRITOS"
	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ListarDistritos(filtros As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ListarDistritos iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "SELECT d.ID, d.Code, d.CodePais, d.CodeProvincia, d.Descripcion, " &
								"pa.Descripcion AS PaisDescripcion, pr.Descripcion AS ProvinciaDescripcion " &
								"FROM tbDistritos d " &
								"LEFT JOIN tbPaises pa ON d.CodePais = pa.Code " &
								"LEFT JOIN tbProvincias pr ON d.CodeProvincia = pr.Code AND d.CodePais = pr.CodePais " &
								"WHERE d.snEliminado = 0"

			' Aplicar filtros si existen
			If filtros IsNot Nothing Then
				Dim filtrosDict As Dictionary(Of String, Object) = TryCast(filtros, Dictionary(Of String, Object))
				If filtrosDict IsNot Nothing Then
					If filtrosDict.ContainsKey("Code") AndAlso Not String.IsNullOrEmpty(filtrosDict("Code")?.ToString()) Then
						sSql += " AND d.Code = " & filtrosDict("Code").ToString()
					End If
					If filtrosDict.ContainsKey("CodePais") AndAlso Not String.IsNullOrEmpty(filtrosDict("CodePais")?.ToString()) Then
						sSql += " AND d.CodePais = '" & filtrosDict("CodePais").ToString().Replace("'", "''") & "'"
					End If
					If filtrosDict.ContainsKey("CodeProvincia") AndAlso Not String.IsNullOrEmpty(filtrosDict("CodeProvincia")?.ToString()) Then
						sSql += " AND d.CodeProvincia = " & filtrosDict("CodeProvincia").ToString()
					End If
					If filtrosDict.ContainsKey("Descripcion") AndAlso Not String.IsNullOrEmpty(filtrosDict("Descripcion")?.ToString()) Then
						sSql += " AND d.Descripcion LIKE '%" & filtrosDict("Descripcion").ToString().Replace("'", "''") & "%'"
					End If
				End If
			End If

			sSql += " ORDER BY d.CodePais, d.CodeProvincia, d.Code"

			ModGlobal.EscribirLog($"Ejecutando: {sSql}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener distritos: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				})
			End If

			' Crear lista de objetos
			Dim distritos As New List(Of Object)
			For Each row As DataRow In dt.Rows
				Dim distrito As New With {
					.ID = Convert.ToInt32(row("ID")),
					.Code = Convert.ToInt32(row("Code")),
					.CodePais = row("CodePais").ToString(),
					.CodeProvincia = Convert.ToInt32(row("CodeProvincia")),
					.Descripcion = row("Descripcion").ToString(),
					.PaisDescripcion = If(row("PaisDescripcion") IsNot DBNull.Value, row("PaisDescripcion").ToString(), ""),
					.ProvinciaDescripcion = If(row("ProvinciaDescripcion") IsNot DBNull.Value, row("ProvinciaDescripcion").ToString(), "")
				}
				distritos.Add(distrito)
			Next

			ModGlobal.EscribirLog($"Distritos obtenidos: {distritos.Count} registros")
			Return serializer.Serialize(New With {
				.Resultado = "SUCCESS",
				.Datos = serializer.Serialize(distritos),
				.Mensaje = "Distritos obtenidos exitosamente"
			})

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ListarDistritos: " & ex.Message)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al obtener distritos: " & ex.Message
			})
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GuardarDistrito(distritoData As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("GuardarDistrito iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim distritoDict As Dictionary(Of String, Object) = TryCast(distritoData, Dictionary(Of String, Object))

			If distritoDict Is Nothing Then
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Datos de distrito inválidos"
				})
			End If

			Dim id As String = distritoDict("ID")?.ToString()
			Dim codigo As Integer? = Nothing
			If distritoDict.ContainsKey("Code") AndAlso distritoDict("Code") IsNot Nothing Then
				codigo = Convert.ToInt32(distritoDict("Code"))
			End If
			Dim codigoPais As String = distritoDict("CodePais")?.ToString().Trim().ToUpper()
			Dim codigoProvincia As Integer = Convert.ToInt32(distritoDict("CodeProvincia"))
			Dim descripcion As String = distritoDict("Descripcion")?.ToString().Trim()

			ModGlobal.EscribirLog($"GuardarDistrito - ID recibido: '{id}' (IsNullOrEmpty: {String.IsNullOrEmpty(id)})")
			ModGlobal.EscribirLog($"GuardarDistrito - Code: {If(codigo.HasValue, codigo.Value.ToString(), "NULL")}, CodePais: {codigoPais}, CodeProvincia: {codigoProvincia}, Descripcion: {descripcion}")

			' Validaciones
			If String.IsNullOrEmpty(codigoPais) Or codigoProvincia <= 0 Or String.IsNullOrEmpty(descripcion) Then
				ModGlobal.EscribirLog("GuardarDistrito - Error de validación: País, provincia y descripción son requeridos")
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "País, provincia y descripción son requeridos"
				})
			End If

			' Usar stored procedure
			Dim sSql As String = "Exec spDistritos_Guardar"
			With objSql.Parametros
				.Clear()
				If Not String.IsNullOrEmpty(id) Then
					Dim idInt As Integer = Convert.ToInt32(id)
					ModGlobal.EscribirLog($"GuardarDistrito - Agregando parámetro @ID = {idInt}")
					.Add("@ID", idInt)
				Else
					ModGlobal.EscribirLog("GuardarDistrito - No se agrega parámetro @ID (es NULL/vacío)")
				End If
				If codigo.HasValue AndAlso codigo.Value > 0 Then
					ModGlobal.EscribirLog($"GuardarDistrito - Agregando parámetro @Code = {codigo.Value}")
					.Add("@Code", codigo.Value)
				Else
					ModGlobal.EscribirLog("GuardarDistrito - No se agrega parámetro @Code (es NULL o <= 0)")
				End If
				ModGlobal.EscribirLog($"GuardarDistrito - Agregando parámetros: @CodePais={codigoPais}, @CodeProvincia={codigoProvincia}, @Descripcion={descripcion}")
				.Add("@CodePais", codigoPais)
				.Add("@CodeProvincia", codigoProvincia)
				.Add("@Descripcion", descripcion)
			End With

			ModGlobal.EscribirLog($"GuardarDistrito - Ejecutando SP: {sSql} con parámetros: {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)
			ModGlobal.EscribirLog($"GuardarDistrito - Resultado: Filas={dt.Rows.Count}, Error={objSql.MensajeError}")
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error al guardar distrito: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Error al guardar distrito: " & objSql.MensajeError
				})
			End If

			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()
				ModGlobal.EscribirLog($"GuardarDistrito - Respuesta SP: Resultado={resultado}, Mensaje={mensaje}")
				Return serializer.Serialize(New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				})
			Else
				ModGlobal.EscribirLog("GuardarDistrito - ERROR: No se recibió respuesta del servidor (dt.Rows.Count = 0)")
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				})
			End If

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GuardarDistrito: " & ex.Message)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al guardar distrito: " & ex.Message
			})
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function EliminarDistrito(id As Integer) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("EliminarDistrito iniciado para ID: " & id)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spDistritos_Eliminar"

			With objSql.Parametros
				.Clear()
				.Add("@ID", id)
			End With

			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error al eliminar distrito: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Error al eliminar distrito: " & objSql.MensajeError
				})
			End If

			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()
				ModGlobal.EscribirLog("Distrito eliminado: " & mensaje)
				Return serializer.Serialize(New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				})
			Else
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				})
			End If

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en EliminarDistrito: " & ex.Message)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al eliminar distrito: " & ex.Message
			})
		End Try
	End Function
#End Region

#Region "CORREGIMIENTOS"
	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ListarCorregimientos(filtros As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ListarCorregimientos iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spCorregimientos_Listar"

			' Aplicar filtros si existen
			With objSql.Parametros
				.Clear()
				If filtros IsNot Nothing Then
					Dim filtrosDict As Dictionary(Of String, Object) = TryCast(filtros, Dictionary(Of String, Object))
					If filtrosDict IsNot Nothing Then
						If filtrosDict.ContainsKey("Code") AndAlso Not String.IsNullOrEmpty(filtrosDict("Code")?.ToString()) Then
							.Add("@Code", Convert.ToInt32(filtrosDict("Code")))
						End If
						If filtrosDict.ContainsKey("CodePais") AndAlso Not String.IsNullOrEmpty(filtrosDict("CodePais")?.ToString()) Then
							.Add("@CodePais", filtrosDict("CodePais").ToString())
						End If
						If filtrosDict.ContainsKey("CodeProvincia") AndAlso Not String.IsNullOrEmpty(filtrosDict("CodeProvincia")?.ToString()) Then
							.Add("@CodeProvincia", Convert.ToInt32(filtrosDict("CodeProvincia")))
						End If
						If filtrosDict.ContainsKey("CodeDistrito") AndAlso Not String.IsNullOrEmpty(filtrosDict("CodeDistrito")?.ToString()) Then
							.Add("@CodeDistrito", Convert.ToInt32(filtrosDict("CodeDistrito")))
						End If
						If filtrosDict.ContainsKey("Descripcion") AndAlso Not String.IsNullOrEmpty(filtrosDict("Descripcion")?.ToString()) Then
							.Add("@Descripcion", filtrosDict("Descripcion").ToString())
						End If
					End If
				End If
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener corregimientos: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				})
			End If

			' Crear lista de objetos
			Dim corregimientos As New List(Of Object)
			For Each row As DataRow In dt.Rows
				Dim corregimiento As New With {
					.ID = Convert.ToInt32(row("ID")),
					.Code = Convert.ToInt32(row("Code")),
					.CodePais = row("CodePais").ToString(),
					.CodeProvincia = Convert.ToInt32(row("CodeProvincia")),
					.CodeDistrito = Convert.ToInt32(row("CodeDistrito")),
					.Descripcion = row("Descripcion").ToString(),
					.PaisDescripcion = If(row("PaisDescripcion") IsNot DBNull.Value, row("PaisDescripcion").ToString(), ""),
					.ProvinciaDescripcion = If(row("ProvinciaDescripcion") IsNot DBNull.Value, row("ProvinciaDescripcion").ToString(), ""),
					.DistritoDescripcion = If(row("DistritoDescripcion") IsNot DBNull.Value, row("DistritoDescripcion").ToString(), "")
				}
				corregimientos.Add(corregimiento)
			Next

			ModGlobal.EscribirLog($"Corregimientos obtenidos: {corregimientos.Count} registros")
			Return serializer.Serialize(New With {
				.Resultado = "SUCCESS",
				.Datos = serializer.Serialize(corregimientos),
				.Mensaje = "Corregimientos obtenidos exitosamente"
			})

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ListarCorregimientos: " & ex.Message)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al obtener corregimientos: " & ex.Message
			})
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GuardarCorregimiento(corregimientoData As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("GuardarCorregimiento iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim corregimientoDict As Dictionary(Of String, Object) = TryCast(corregimientoData, Dictionary(Of String, Object))

			If corregimientoDict Is Nothing Then
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Datos de corregimiento inválidos"
				})
			End If

			Dim id As String = corregimientoDict("ID")?.ToString()
			Dim codigo As Integer? = Nothing
			If corregimientoDict.ContainsKey("Code") AndAlso corregimientoDict("Code") IsNot Nothing Then
				codigo = Convert.ToInt32(corregimientoDict("Code"))
			End If
			Dim codigoPais As String = corregimientoDict("CodePais")?.ToString().Trim().ToUpper()
			Dim codigoProvincia As Integer = Convert.ToInt32(corregimientoDict("CodeProvincia"))
			Dim codigoDistrito As Integer = Convert.ToInt32(corregimientoDict("CodeDistrito"))
			Dim descripcion As String = corregimientoDict("Descripcion")?.ToString().Trim()

			ModGlobal.EscribirLog($"GuardarCorregimiento - ID recibido: '{id}' (IsNullOrEmpty: {String.IsNullOrEmpty(id)})")
			ModGlobal.EscribirLog($"GuardarCorregimiento - Code: {If(codigo.HasValue, codigo.Value.ToString(), "NULL")}, CodePais: {codigoPais}, CodeProvincia: {codigoProvincia}, CodeDistrito: {codigoDistrito}, Descripcion: {descripcion}")

			' Validaciones
			If String.IsNullOrEmpty(codigoPais) Or codigoProvincia <= 0 Or codigoDistrito <= 0 Or String.IsNullOrEmpty(descripcion) Then
				ModGlobal.EscribirLog("GuardarCorregimiento - Error de validación: País, provincia, distrito y descripción son requeridos")
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "País, provincia, distrito y descripción son requeridos"
				})
			End If

			' Usar stored procedure
			Dim sSql As String = "Exec spCorregimientos_Guardar"
			With objSql.Parametros
				.Clear()
				If Not String.IsNullOrEmpty(id) Then
					Dim idInt As Integer = Convert.ToInt32(id)
					ModGlobal.EscribirLog($"GuardarCorregimiento - Agregando parámetro @ID = {idInt}")
					.Add("@ID", idInt)
				Else
					ModGlobal.EscribirLog("GuardarCorregimiento - No se agrega parámetro @ID (es NULL/vacío)")
				End If
				If codigo.HasValue AndAlso codigo.Value > 0 Then
					ModGlobal.EscribirLog($"GuardarCorregimiento - Agregando parámetro @Code = {codigo.Value}")
					.Add("@Code", codigo.Value)
				Else
					ModGlobal.EscribirLog("GuardarCorregimiento - No se agrega parámetro @Code (es NULL o <= 0)")
				End If
				ModGlobal.EscribirLog($"GuardarCorregimiento - Agregando parámetros: @CodePais={codigoPais}, @CodeProvincia={codigoProvincia}, @CodeDistrito={codigoDistrito}, @Descripcion={descripcion}")
				.Add("@CodePais", codigoPais)
				.Add("@CodeProvincia", codigoProvincia)
				.Add("@CodeDistrito", codigoDistrito)
				.Add("@Descripcion", descripcion)
			End With

			ModGlobal.EscribirLog($"GuardarCorregimiento - Ejecutando SP: {sSql} con parámetros: {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)
			ModGlobal.EscribirLog($"GuardarCorregimiento - Resultado: Filas={dt.Rows.Count}, Error={objSql.MensajeError}")
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error al guardar corregimiento: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Error al guardar corregimiento: " & objSql.MensajeError
				})
			End If

			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()
				ModGlobal.EscribirLog($"GuardarCorregimiento - Respuesta SP: Resultado={resultado}, Mensaje={mensaje}")
				Return serializer.Serialize(New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				})
			Else
				ModGlobal.EscribirLog("GuardarCorregimiento - ERROR: No se recibió respuesta del servidor (dt.Rows.Count = 0)")
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				})
			End If

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GuardarCorregimiento: " & ex.Message)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al guardar corregimiento: " & ex.Message
			})
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function EliminarCorregimiento(id As Integer) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("EliminarCorregimiento iniciado para ID: " & id)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spCorregimientos_Eliminar"

			With objSql.Parametros
				.Clear()
				.Add("@ID", id)
			End With

			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error al eliminar corregimiento: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Error al eliminar corregimiento: " & objSql.MensajeError
				})
			End If

			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()
				ModGlobal.EscribirLog("Corregimiento eliminado: " & mensaje)
				Return serializer.Serialize(New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				})
			Else
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				})
			End If

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en EliminarCorregimiento: " & ex.Message)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al eliminar corregimiento: " & ex.Message
			})
		End Try
	End Function
#End Region


#Region "CUENTAS"
	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerGruposCuenta() As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ObtenerGruposCuenta")
			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spGrupoCuenta_ListarParaDropdown"
			ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener grupos de cuenta: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				})
			End If
			ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Registros obtenidos: " & dt.Rows.Count.ToString())
			Dim grupos As New List(Of Object)
			For Each row As DataRow In dt.Rows
				Dim grupo As New With {
					.IDGrupo = row("IDGrupo").ToString(),
					.Descripcion = row("GrupoCuenta").ToString()
				}
				grupos.Add(grupo)
			Next
			ModGlobal.EscribirLog("Metodo ObtenerGruposCuenta completado exitosamente")
			Return serializer.Serialize(New With {
				.Resultado = "SUCCESS",
				.Datos = serializer.Serialize(grupos),
				.Mensaje = ""
			})
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ObtenerGruposCuenta: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al obtener grupos de cuenta: " & ex.Message
			})
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ListarCuentas(filtros As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ListarCuentas")
			ModGlobal.EscribirLog("Parametros recibidos: " & New JavaScriptSerializer().Serialize(filtros))
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
				End If
			End If
			ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener cuentas: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				})
			End If
			ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Registros obtenidos: " & dt.Rows.Count.ToString())
			Dim cuentas As New List(Of Object)
			For Each row As DataRow In dt.Rows
				Dim cuenta As New With {
					.ID = row("ID").ToString(),
					.Codigo = row("Cuenta").ToString(),
					.Nombre = If(row.Table.Columns.Contains("Nombre") AndAlso Not row.IsNull("Nombre"), row("Nombre").ToString(), ""),
					.IDGrupo = row("IDGrupo").ToString(),
					.GrupoDescripcion = If(row.Table.Columns.Contains("GrupoDescripcion") AndAlso Not row.IsNull("GrupoDescripcion"), row("GrupoDescripcion").ToString(), ""),
					.Saldo = If(row.Table.Columns.Contains("Saldo") AndAlso Not row.IsNull("Saldo"), Convert.ToDecimal(row("Saldo")), 0)
				}
				cuentas.Add(cuenta)
			Next
			ModGlobal.EscribirLog("Metodo ListarCuentas completado exitosamente")
			Return serializer.Serialize(New With {
				.Resultado = "SUCCESS",
				.Datos = serializer.Serialize(cuentas),
				.Mensaje = "Cuentas obtenidas exitosamente"
			})
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ListarCuentas: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al obtener cuentas: " & ex.Message
			})
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerCuenta(id As Integer) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ObtenerCuenta")
			ModGlobal.EscribirLog("Parametros recibidos: ID=" & id.ToString())
			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spCuentas_Obtener"
			objSql.Parametros.Add("@ID", id)
			ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener cuenta: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				})
			End If
			If dt.Rows.Count > 0 Then
				Dim row As DataRow = dt.Rows(0)
				Dim cuenta As New With {
					.ID = row("ID").ToString(),
					.Codigo = row("Cuenta").ToString(),
					.Nombre = If(row.Table.Columns.Contains("Nombre") AndAlso Not row.IsNull("Nombre"), row("Nombre").ToString(), ""),
					.IDGrupo = row("IDGrupo").ToString(),
					.Saldo = If(row.Table.Columns.Contains("Saldo") AndAlso Not row.IsNull("Saldo"), Convert.ToDecimal(row("Saldo")), 0)
				}
				ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Cuenta obtenida exitosamente")
				ModGlobal.EscribirLog("Metodo ObtenerCuenta completado exitosamente")
				Return serializer.Serialize(New With {
					.Resultado = "SUCCESS",
					.Datos = serializer.Serialize(cuenta),
					.Mensaje = ""
				})
			Else
				ModGlobal.EscribirLog("Validacion: No se encontró la cuenta con ID=" & id.ToString())
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "No se encontró la cuenta"
				})
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ObtenerCuenta: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Datos = "",
				.Mensaje = "Error al obtener cuenta: " & ex.Message
			})
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GuardarCuenta(cuentaData As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO GuardarCuenta")
			ModGlobal.EscribirLog("Parametros recibidos: " & New JavaScriptSerializer().Serialize(cuentaData))
			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spCuentas_Guardar"
			Dim cuentaDict As Dictionary(Of String, Object) = TryCast(cuentaData, Dictionary(Of String, Object))
			If cuentaDict Is Nothing Then
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Datos de cuenta inválidos"
				})
			End If
			Dim id As Integer = If(cuentaDict.ContainsKey("ID") AndAlso cuentaDict("ID") IsNot Nothing, Convert.ToInt32(cuentaDict("ID")), 0)
			Dim cuenta As String = cuentaDict("Codigo").ToString()
			Dim nombre As String = cuentaDict("Nombre").ToString()
			Dim idGrupo As Integer = Convert.ToInt32(cuentaDict("IDGrupo"))
			Dim idSession As String = HttpContext.Current.Session(VariablesSesion.logID).ToString()
			ModGlobal.EscribirLog($"Valores extraídos - ID: {id}, Cuenta: {cuenta}, Nombre: {nombre}, IDGrupo: {idGrupo}, IdSession: {idSession}")
			With objSql.Parametros
				If id > 0 Then
					.Add("@ID", id)
				End If
				.Add("@Cuenta", cuenta)
				.Add("@Nombre", nombre)
				.Add("@IDGrupo", idGrupo)
				.Add("@IdSession", idSession)
			End With
			ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al guardar cuenta: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				})
			End If
			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()
				ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Resultado: " & resultado)
				ModGlobal.EscribirLog("Metodo GuardarCuenta completado exitosamente")
				Return serializer.Serialize(New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				})
			Else
				ModGlobal.EscribirLog("Validacion: No se recibió respuesta del servidor")
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				})
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GuardarCuenta: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al guardar cuenta: " & ex.Message
			})
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function EliminarCuenta(id As Integer) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO EliminarCuenta")
			ModGlobal.EscribirLog("Parametros recibidos: ID=" & id.ToString())
			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spCuentas_Eliminar"
			Dim idSession As String = HttpContext.Current.Session(VariablesSesion.logID).ToString()
			Dim usuarioId As Integer = If(HttpContext.Current.Session(VariablesSesion.UsuarioId) IsNot Nothing, Convert.ToInt32(HttpContext.Current.Session(VariablesSesion.UsuarioId)), 0)
			ModGlobal.EscribirLog($"Usuario que elimina: {usuarioId}, SessionID: {idSession}")
			With objSql.Parametros
				.Add("@ID", id)
				.Add("@IdSession", idSession)
				.Add("@UsuarioElimina", usuarioId)
			End With
			ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al eliminar cuenta: " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				})
			End If
			If dt.Rows.Count > 0 Then
				Dim resultado As String = dt.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()
				ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Resultado: " & resultado)
				ModGlobal.EscribirLog("Metodo EliminarCuenta completado exitosamente")
				Return serializer.Serialize(New With {
					.Resultado = resultado,
					.Mensaje = mensaje
				})
			Else
				ModGlobal.EscribirLog("Validacion: No se recibió respuesta del servidor")
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del servidor"
				})
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en EliminarCuenta: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al eliminar cuenta: " & ex.Message
			})
		End Try
	End Function
#End Region

End Class