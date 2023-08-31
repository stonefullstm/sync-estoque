unit u_dados;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, ZConnection, ZDataset;

type

  { TdmDados }

  TdmDados = class(TDataModule)
    dbFirebird: TZConnection;
    dbSqlite: TZConnection;
    zqSEstoque: TZQuery;
    zqFEstoque: TZQuery;
    zqSEstoquecontrole: TLargeintField;
    zqSEstoqueproduto: TStringField;
    zqSEstoqueqtde: TFloatField;
    zqSEstoqueunidade: TStringField;
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

