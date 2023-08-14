unit u_dados;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ZConnection;

type

  { TdmDados }

  TdmDados = class(TDataModule)
    dbFirebird: TZConnection;
    dbSqlite: TZConnection;
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

