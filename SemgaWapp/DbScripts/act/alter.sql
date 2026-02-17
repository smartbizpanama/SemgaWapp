

  alter table tbAuxiliares
  Add 
    [PorcManejo] numeric (19,6),
    [MontoManejo] numeric (19,6),
    [PorcCapitalizacion] numeric (19,6),
    [MontoCapitalizacion] numeric (19,6);



  alter table tbmovimientos
  Add 
    [Ref1] nvarchar(100),
    [Ref2] nvarchar(100);


  alter table tbAsientos
  Add 
    BaseType nvarchar(100);