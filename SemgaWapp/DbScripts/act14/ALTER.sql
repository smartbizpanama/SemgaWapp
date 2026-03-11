ALTER TABLE tbAuxiliares
ADD FechaVencimiento date;

ALTER TABLE tbCuentas
ADD snImputable bit;

Update tbCuentas set snImputable = 1 where snImputable is null;