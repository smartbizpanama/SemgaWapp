Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Web.Script.Serialization
Imports SBSqlClient
Imports SBUtility
Imports System.Data

Public Class comprobanteText
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
	Public Shared Function GenerarComprobante(movimientoId As String) As Object
		Try
			ModGlobal.EscribirLog("🖨️ GenerarComprobante iniciado. MovimientoID: " & movimientoId)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))

			' Obtener datos del movimiento usando stored procedure
			Dim sSql As String = "Exec spMovimientos_ObtenerDatosComprobante"

			With objSql.Parametros
				.Add("@MovimientoID", Integer.Parse(movimientoId))
			End With

			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener datos del comprobante: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			If dt.Rows.Count = 0 Then
				ModGlobal.EscribirLog("No se encontró el movimiento con ID: " & movimientoId)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se encontró el movimiento con ID: " & movimientoId
				}
			End If

			Dim row As DataRow = dt.Rows(0)

			' Formatear MovimientoID con ceros a la izquierda
			Dim movimientoIdFormateado As String = Right("000000000000" & movimientoId, 12)

			' Formatear fecha y hora
			Dim fechaHora As String = Convert.ToDateTime(row("FechaMovimiento")).ToString("dd/MM/yyyy HH:mm")

			' Formatear monto con punto decimal
			Dim montoFormateado As String = Convert.ToDecimal(row("Monto")).ToString("###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)

			' Leer el template HTML
			Dim templatePath As String = HttpContext.Current.Server.MapPath("~/Forms/Transacciones/ComprobanteTransaccion.html")
			Dim htmlTemplate As String = System.IO.File.ReadAllText(templatePath)

			' Reemplazar placeholders
			htmlTemplate = htmlTemplate.Replace("@MovimientoID", movimientoIdFormateado)
			htmlTemplate = htmlTemplate.Replace("@FechaHora", fechaHora)
			htmlTemplate = htmlTemplate.Replace("@Usuario", row("UsuarioNombre").ToString())
			htmlTemplate = htmlTemplate.Replace("@NumeroAsociado", row("NumeroAsociado").ToString())
			htmlTemplate = htmlTemplate.Replace("@NombreAsociado", row("NombreAsociado").ToString())
			htmlTemplate = htmlTemplate.Replace("@DescripcionAuxiliar", row("DescripcionTipoAuxiliar").ToString())
			htmlTemplate = htmlTemplate.Replace("@Cuenta", row("Cuenta").ToString())
			htmlTemplate = htmlTemplate.Replace("@DescripcionTransaccion", row("DescripcionTransaccion").ToString())
			htmlTemplate = htmlTemplate.Replace("@Monto", montoFormateado)

			ModGlobal.EscribirLog("Comprobante generado exitosamente para movimiento: " & movimientoId)

			Return New With {
				.Resultado = "SUCCESS",
				.Html = htmlTemplate
			}

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GenerarComprobante: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al generar comprobante: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function MarcarComprobanteImpreso(movimientoId As String) As Object
		Try
			ModGlobal.EscribirLog("🖨️ MarcarComprobanteImpreso iniciado. MovimientoID: " & movimientoId)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))

			' Actualizar el campo snImpreso usando stored procedure
			Dim sSql As String = "Exec spMovimientos_MarcarImpreso"

			With objSql.Parametros
				.Add("@MovimientoID", Integer.Parse(movimientoId))
			End With

			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al marcar como impreso: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			Dim filasAfectadas As Integer = 0
			If dt.Rows.Count > 0 Then
				filasAfectadas = Convert.ToInt32(dt.Rows(0)("FilasAfectadas"))
			End If

			If filasAfectadas > 0 Then
				ModGlobal.EscribirLog("Comprobante marcado como impreso para movimiento: " & movimientoId)
				Return New With {
					.Resultado = "SUCCESS",
					.Mensaje = "Comprobante marcado como impreso"
				}
			Else
				ModGlobal.EscribirLog("No se encontró el movimiento con ID: " & movimientoId)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se encontró el movimiento"
				}
			End If

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en MarcarComprobanteImpreso: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al marcar comprobante como impreso: " & ex.Message
			}
		End Try
	End Function
End Class


