unit u_dmdados;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset, IBConnection, SQLDB;

type

  { TdmDados }

  TdmDados = class(TDataModule)
    dbConnection: TZConnection;
    queEstoque: TZQuery;
  private

  public

  end;

var
  dmDados: TdmDados;

implementation

{$R *.lfm}

end.

