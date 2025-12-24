-- EJEMPLO de INSERT con HTML formateado en DescripcionLogica
-- El HTML está en una sola línea dentro de las comillas simples
-- Este es solo un ejemplo para referencia visual

INSERT INTO [dbo].[tbObjetosBD_Descripciones] ([NombreObjeto], [TipoObjeto], [DescripcionLogica], [SPsLlamados], [TablasUtilizadas], [FechaCreacion], [snEliminado])
VALUES
('spAuxiliares_GuardarAuxiliar', 'SP', 
'<div style="line-height: 1.9; font-size: 15px; color: #333;">
    <p style="margin-bottom: 14px; text-align: justify;">
        Guarda o actualiza un auxiliar asociado en la base de datos.
    </p>
    
    <p style="margin-bottom: 14px;">
        <strong style="color: #2c3e50;">Realiza 6 validaciones:</strong>
    </p>
    
    <div style="margin-bottom: 10px; padding-left: 24px; position: relative; padding-top: 2px;">
        <span style="position: absolute; left: 8px; color: #007bff; font-weight: bold; font-size: 18px; line-height: 1.2;">•</span>
        <span>Verifica que número de asociado, código de rubro y tipo de auxiliar sean requeridos</span>
    </div>
    
    <div style="margin-bottom: 10px; padding-left: 24px; position: relative; padding-top: 2px;">
        <span style="position: absolute; left: 8px; color: #007bff; font-weight: bold; font-size: 18px; line-height: 1.2;">•</span>
        <span>Valida que el asociado exista en 
            <code style="background-color: #f8f9fa; padding: 2px 6px; border-radius: 3px; color: #e83e8c; font-size: 14px; font-weight: 500;">tbAsociados</code>
        </span>
    </div>
    
    <div style="margin-bottom: 10px; padding-left: 24px; position: relative; padding-top: 2px;">
        <span style="position: absolute; left: 8px; color: #007bff; font-weight: bold; font-size: 18px; line-height: 1.2;">•</span>
        <span>Valida que el rubro exista en 
            <code style="background-color: #f8f9fa; padding: 2px 6px; border-radius: 3px; color: #e83e8c; font-size: 14px; font-weight: 500;">tbRubros</code>
        </span>
    </div>
    
    <div style="margin-bottom: 10px; padding-left: 24px; position: relative; padding-top: 2px;">
        <span style="position: absolute; left: 8px; color: #007bff; font-weight: bold; font-size: 18px; line-height: 1.2;">•</span>
        <span>Valida que el tipo de auxiliar sea válido para el rubro en 
            <code style="background-color: #f8f9fa; padding: 2px 6px; border-radius: 3px; color: #e83e8c; font-size: 14px; font-weight: 500;">tbTiposAuxiliares</code>
        </span>
    </div>
    
    <p style="margin-bottom: 14px; text-align: justify;">
        Si <code style="background-color: #fff3cd; padding: 2px 6px; border-radius: 3px; color: #856404; font-size: 14px; font-weight: 500;">@ID = 0</code>, crea un nuevo auxiliar:
    </p>
    
    <div style="margin-bottom: 10px; padding-left: 24px; position: relative; padding-top: 2px;">
        <span style="position: absolute; left: 8px; color: #007bff; font-weight: bold; font-size: 18px; line-height: 1.2;">•</span>
        <span>Genera un consecutivo automático desde 
            <code style="background-color: #f8f9fa; padding: 2px 6px; border-radius: 3px; color: #e83e8c; font-size: 14px; font-weight: 500;">tbControlConsecutivos</code>
        </span>
    </div>
    
    <div style="margin-bottom: 10px; padding-left: 24px; position: relative; padding-top: 2px;">
        <span style="position: absolute; left: 8px; color: #007bff; font-weight: bold; font-size: 18px; line-height: 1.2;">•</span>
        <span>Realiza un <strong style="color: #dc3545; font-weight: 600;">INSERT</strong> en 
            <code style="background-color: #f8f9fa; padding: 2px 6px; border-radius: 3px; color: #e83e8c; font-size: 14px; font-weight: 500;">tbAuxiliares</code> 
            con todos los campos (Cuota, Saldo, MontoOriginal, TasaInteres, etc.)
        </span>
    </div>
    
    <div style="margin-bottom: 10px; padding-left: 24px; position: relative; padding-top: 2px;">
        <span style="position: absolute; left: 8px; color: #007bff; font-weight: bold; font-size: 18px; line-height: 1.2;">•</span>
        <span>Retorna el nuevo ID</span>
    </div>
    
    <p style="margin-bottom: 14px; text-align: justify;">
        Si <code style="background-color: #fff3cd; padding: 2px 6px; border-radius: 3px; color: #856404; font-size: 14px; font-weight: 500;">@ID &gt; 0</code>, 
        actualiza el auxiliar existente con un <strong style="color: #dc3545; font-weight: 600;">UPDATE</strong> en 
        <code style="background-color: #f8f9fa; padding: 2px 6px; border-radius: 3px; color: #e83e8c; font-size: 14px; font-weight: 500;">tbAuxiliares</code>.
    </p>
    
    <p style="margin-bottom: 14px; text-align: justify;">
        Utiliza transacciones (
        <strong style="color: #dc3545; font-weight: 600;">BEGIN TRANSACTION</strong>/<strong style="color: #dc3545; font-weight: 600;">COMMIT</strong>) 
        para garantizar la integridad de los datos. Incluye manejo de excepciones con 
        <strong style="color: #dc3545; font-weight: 600;">TRY-CATCH</strong>. 
        Retorna ''SUCCESS'' o ''ERROR'' con mensaje descriptivo.
    </p>
</div>',
NULL, 'tbAuxiliares, tbAsociados, tbRubros, tbTiposAuxiliares, tbControlConsecutivos', GETDATE(), 0);

-- NOTA: En el archivo real tbObjetosBD_Descripciones.sql, el HTML debe estar en UNA SOLA LÍNEA
-- sin saltos de línea, dentro de las comillas simples. SQL Server acepta cadenas largas en una sola línea.
-- Este ejemplo con formato es solo para visualización y referencia.

