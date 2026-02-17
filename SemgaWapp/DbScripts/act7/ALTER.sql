ALTER TABLE tbMovimientos
ADD IDTransaccion INT NULL;

insert into tbParamsKeys
Select 'CANT_TRANS_LOTE', 'Cantidad de transacciones máxima por lote', 'TRANSACCIONES', '5';
