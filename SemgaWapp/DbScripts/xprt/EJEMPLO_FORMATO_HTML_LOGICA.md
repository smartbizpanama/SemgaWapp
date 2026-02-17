# Formato HTML para DescripcionLogica en tbObjetosBD_Descripciones

La columna `DescripcionLogica` debe contener HTML formateado que se renderizará directamente en la pestaña "Lógica" del modal.

## Estructura Base

```html
<div style="line-height: 1.9; font-size: 15px; color: #333;">
    <!-- Contenido aquí -->
</div>
```

## Elementos Disponibles

### Párrafos
```html
<p style="margin-bottom: 14px; text-align: justify;">
    Texto del párrafo aquí.
</p>
```

### Listas con Viñetas
```html
<div style="margin-bottom: 10px; padding-left: 24px; position: relative; padding-top: 2px;">
    <span style="position: absolute; left: 8px; color: #007bff; font-weight: bold; font-size: 18px; line-height: 1.2;">•</span>
    <span>Texto del item de la lista</span>
</div>
```

### Resaltar Tablas
```html
<code style="background-color: #f8f9fa; padding: 2px 6px; border-radius: 3px; color: #e83e8c; font-size: 14px; font-weight: 500;">tbNombreTabla</code>
```

### Resaltar Stored Procedures
```html
<code style="background-color: #fff3cd; padding: 2px 6px; border-radius: 3px; color: #856404; font-size: 14px; font-weight: 500;">spNombreSP</code>
```

### Resaltar Palabras Clave SQL
```html
<strong style="color: #dc3545; font-weight: 600;">INSERT</strong>
<strong style="color: #dc3545; font-weight: 600;">UPDATE</strong>
<strong style="color: #dc3545; font-weight: 600;">DELETE</strong>
<strong style="color: #dc3545; font-weight: 600;">SELECT</strong>
<strong style="color: #dc3545; font-weight: 600;">BEGIN TRANSACTION</strong>
<strong style="color: #dc3545; font-weight: 600;">COMMIT</strong>
<strong style="color: #dc3545; font-weight: 600;">ROLLBACK</strong>
<strong style="color: #dc3545; font-weight: 600;">TRY-CATCH</strong>
```

### Títulos/Subtítulos
```html
<p style="margin-bottom: 14px; text-align: justify;">
    <strong style="color: #2c3e50;">Título o Subtítulo:</strong>
</p>
```

## Ejemplo Completo

```html
<div style="line-height: 1.9; font-size: 15px; color: #333;">
    <p style="margin-bottom: 14px; text-align: justify;">
        Descripción general del stored procedure.
    </p>
    
    <p style="margin-bottom: 14px; text-align: justify;">
        <strong style="color: #2c3e50;">Validaciones realizadas:</strong>
    </p>
    
    <div style="margin-bottom: 10px; padding-left: 24px; position: relative; padding-top: 2px;">
        <span style="position: absolute; left: 8px; color: #007bff; font-weight: bold; font-size: 18px; line-height: 1.2;">•</span>
        <span>Valida que el asociado exista en <code style="background-color: #f8f9fa; padding: 2px 6px; border-radius: 3px; color: #e83e8c; font-size: 14px; font-weight: 500;">tbAsociados</code></span>
    </div>
    
    <p style="margin-bottom: 14px; text-align: justify;">
        Realiza un <strong style="color: #dc3545; font-weight: 600;">INSERT</strong> en <code style="background-color: #f8f9fa; padding: 2px 6px; border-radius: 3px; color: #e83e8c; font-size: 14px; font-weight: 500;">tbAuxiliares</code>.
    </p>
</div>
```

## Notas Importantes

1. **Escape de caracteres especiales**: Usar `&gt;` en lugar de `>`, `&lt;` en lugar de `<`, `&amp;` en lugar de `&`
2. **Comillas simples**: En SQL usar comillas simples dobles `''` para escapar comillas simples dentro del string
3. **Mantener consistencia**: Usar los mismos estilos para elementos similares
4. **Legibilidad**: Usar párrafos y listas para mejorar la legibilidad


