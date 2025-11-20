Imports System
Imports System.Data
Imports System.Data.SqlClient

Module AnalyzeDatabase
    Sub Main()
        ' Cadena de conexión
        Dim connectionString As String = "Password=gilberto;Persist Security Info=True;User ID=sa;Initial Catalog=SegmaDB;Data Source=GIL-MAIN-PC;"
        
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Console.WriteLine("✅ Conexión exitosa a SegmaDB")
                
                ' Analizar tablas
                Console.WriteLine(vbCrLf & "📊 TABLAS:")
                AnalyzeTables(connection)
                
                ' Analizar vistas
                Console.WriteLine(vbCrLf & "📋 VISTAS:")
                AnalyzeViews(connection)
                
                ' Analizar stored procedures
                Console.WriteLine(vbCrLf & "⚙️ PROCEDIMIENTOS ALMACENADOS:")
                AnalyzeProcedures(connection)
                
                ' Analizar funciones
                Console.WriteLine(vbCrLf & "🔧 FUNCIONES:")
                AnalyzeFunctions(connection)
                
                ' Analizar triggers
                Console.WriteLine(vbCrLf & "🎯 TRIGGERS:")
                AnalyzeTriggers(connection)
                
            End Using
            
        Catch ex As Exception
            Console.WriteLine($"❌ Error: {ex.Message}")
        End Try
        
        Console.WriteLine(vbCrLf & "Presione cualquier tecla para salir...")
        Console.ReadKey()
    End Sub
    
    Sub AnalyzeTables(connection As SqlConnection)
        Dim query As String = "SELECT TABLE_SCHEMA, TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' ORDER BY TABLE_SCHEMA, TABLE_NAME"
        
        Using cmd As New SqlCommand(query, connection)
            Using reader As SqlDataReader = cmd.ExecuteReader()
                While reader.Read()
                    Console.WriteLine($"  - {reader("TABLE_SCHEMA")}.{reader("TABLE_NAME")}")
                End While
            End Using
        End Using
    End Sub
    
    Sub AnalyzeViews(connection As SqlConnection)
        Dim query As String = "SELECT TABLE_SCHEMA, TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS ORDER BY TABLE_SCHEMA, TABLE_NAME"
        
        Using cmd As New SqlCommand(query, connection)
            Using reader As SqlDataReader = cmd.ExecuteReader()
                Dim count As Integer = 0
                While reader.Read()
                    Console.WriteLine($"  - {reader("TABLE_SCHEMA")}.{reader("TABLE_NAME")}")
                    count += 1
                End While
                If count = 0 Then
                    Console.WriteLine("  No hay vistas")
                End If
            End Using
        End Using
    End Sub
    
    Sub AnalyzeProcedures(connection As SqlConnection)
        Dim query As String = "SELECT ROUTINE_SCHEMA, ROUTINE_NAME FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' ORDER BY ROUTINE_SCHEMA, ROUTINE_NAME"
        
        Using cmd As New SqlCommand(query, connection)
            Using reader As SqlDataReader = cmd.ExecuteReader()
                Dim count As Integer = 0
                While reader.Read()
                    Console.WriteLine($"  - {reader("ROUTINE_SCHEMA")}.{reader("ROUTINE_NAME")}")
                    count += 1
                End While
                Console.WriteLine($"  Total: {count} procedimientos")
            End Using
        End Using
    End Sub
    
    Sub AnalyzeFunctions(connection As SqlConnection)
        Dim query As String = "SELECT ROUTINE_SCHEMA, ROUTINE_NAME FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'FUNCTION' ORDER BY ROUTINE_SCHEMA, ROUTINE_NAME"
        
        Using cmd As New SqlCommand(query, connection)
            Using reader As SqlDataReader = cmd.ExecuteReader()
                Dim count As Integer = 0
                While reader.Read()
                    Console.WriteLine($"  - {reader("ROUTINE_SCHEMA")}.{reader("ROUTINE_NAME")}")
                    count += 1
                End While
                Console.WriteLine($"  Total: {count} funciones")
            End Using
        End Using
    End Sub
    
    Sub AnalyzeTriggers(connection As SqlConnection)
        Dim query As String = "SELECT OBJECT_SCHEMA_NAME(parent_id) AS SchemaName, OBJECT_NAME(parent_id) AS TableName, name AS TriggerName FROM sys.triggers ORDER BY OBJECT_SCHEMA_NAME(parent_id), OBJECT_NAME(parent_id)"
        
        Using cmd As New SqlCommand(query, connection)
            Using reader As SqlDataReader = cmd.ExecuteReader()
                Dim count As Integer = 0
                While reader.Read()
                    Console.WriteLine($"  - {reader("SchemaName")}.{reader("TableName")}.{reader("TriggerName")}")
                    count += 1
                End While
                Console.WriteLine($"  Total: {count} triggers")
            End Using
        End Using
    End Sub
End Module














