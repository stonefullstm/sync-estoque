unit u_dados;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ZConnection, ZDataset;

type

  { TdmDados }

  TdmDados = class(TDataModule)
    dbFirebird: TZConnection;
    dbSqlite: TZConnection;
    zqSEstoque: TZQuery;
    zqFEstoque: TZQuery;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  dmDados: TdmDados;

implementation

{$R *.lfm}

end.

