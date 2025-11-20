-- Script para analizar la estructura de la base de datos SegmaDB

USE SegmaDB;
GO

-- ============================================
-- 1. LISTAR TODAS LAS TABLAS
-- ============================================
PRINT '==================== TABLAS ====================';
SELECT 
    t.TABLE_SCHEMA AS SchemaName,
    t.TABLE_NAME AS TableName,
    obj.create_date AS CreatedDate,
    obj.modify_date AS ModifiedDate
FROM INFORMATION_SCHEMA.TABLES t
INNER JOIN sys.objects obj ON obj.name = t.TABLE_NAME AND obj.type = 'U'
WHERE t.TABLE_TYPE = 'BASE TABLE'
ORDER BY t.TABLE_SCHEMA, t.TABLE_NAME;

-- ============================================
-- 2. LISTAR TODAS LAS VISTAS
-- ============================================
PRINT '==================== VISTAS ====================';
SELECT 
    TABLE_SCHEMA AS SchemaName,
    TABLE_NAME AS ViewName
FROM INFORMATION_SCHEMA.VIEWS
ORDER BY TABLE_SCHEMA, TABLE_NAME;

-- ============================================
-- 3. LISTAR TODOS LOS PROCEDIMIENTOS ALMACENADOS
-- ============================================
PRINT '==================== PROCEDIMIENTOS ALMACENADOS ====================';
SELECT 
    ROUTINE_SCHEMA AS SchemaName,
    ROUTINE_NAME AS ProcedureName,
    ROUTINE_TYPE AS RoutineType,
    CREATED AS CreatedDate,
    LAST_ALTERED AS LastModifiedDate
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE'
ORDER BY ROUTINE_SCHEMA, ROUTINE_NAME;

-- ============================================
-- 4. LISTAR TODAS LAS FUNCIONES
-- ============================================
PRINT '==================== FUNCIONES ====================';
SELECT 
    ROUTINE_SCHEMA AS SchemaName,
    ROUTINE_NAME AS FunctionName,
    ROUTINE_TYPE AS RoutineType,
    CREATED AS CreatedDate,
    LAST_ALTERED AS LastModifiedDate
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'FUNCTION'
ORDER BY ROUTINE_SCHEMA, ROUTINE_NAME;

-- ============================================
-- 5. DETALLES DE COLUMNAS PARA CADA TABLA
-- ============================================
PRINT '==================== COLUMNAS DE TABLAS ====================';
SELECT 
    TABLE_SCHEMA AS SchemaName,
    TABLE_NAME AS TableName,
    COLUMN_NAME AS ColumnName,
    DATA_TYPE AS DataType,
    CHARACTER_MAXIMUM_LENGTH AS MaxLength,
    IS_NULLABLE AS IsNullable,
    COLUMN_DEFAULT AS DefaultValue
FROM INFORMATION_SCHEMA.COLUMNS
ORDER BY TABLE_SCHEMA, TABLE_NAME, ORDINAL_POSITION;

-- ============================================
-- 6. RELACIONES (FOREIGN KEYS)
-- ============================================
PRINT '==================== RELACIONES (FOREIGN KEYS) ====================';
SELECT 
    FK.TABLE_SCHEMA AS SchemaName,
    FK.TABLE_NAME AS TableName,
    FK.CONSTRAINT_NAME AS ConstraintName,
    FK.COLUMN_NAME AS ColumnName,
    PK.TABLE_SCHEMA AS ReferencedSchema,
    PK.TABLE_NAME AS ReferencedTable,
    PK.COLUMN_NAME AS ReferencedColumn
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS RC
INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE FK 
    ON RC.CONSTRAINT_NAME = FK.CONSTRAINT_NAME
INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE PK 
    ON RC.UNIQUE_CONSTRAINT_NAME = PK.CONSTRAINT_NAME
ORDER BY FK.TABLE_SCHEMA, FK.TABLE_NAME;

-- ============================================
-- 7. TRIGGERS
-- ============================================
PRINT '==================== TRIGGERS ====================';
SELECT 
    OBJECT_SCHEMA_NAME(parent_id) AS SchemaName,
    OBJECT_NAME(parent_id) AS TableName,
    name AS TriggerName,
    type_desc AS TriggerType,
    create_date AS CreatedDate,
    modify_date AS ModifiedDate
FROM sys.triggers
ORDER BY OBJECT_SCHEMA_NAME(parent_id), OBJECT_NAME(parent_id), name;

-- ============================================
-- 8. ÍNDICES
-- ============================================
PRINT '==================== ÍNDICES ====================';
SELECT 
    SCHEMA_NAME(t.schema_id) AS SchemaName,
    OBJECT_NAME(i.object_id) AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    i.is_unique AS IsUnique,
    i.is_primary_key AS IsPrimaryKey
FROM sys.indexes i
INNER JOIN sys.tables t ON i.object_id = t.object_id
WHERE i.name IS NOT NULL
ORDER BY SCHEMA_NAME(t.schema_id), OBJECT_NAME(i.object_id), i.name;

GO














