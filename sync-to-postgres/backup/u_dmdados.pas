unit u_dmdados;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset, IBConnection, SQLDB;

type

  { TdmDados }

  TdmDados = class(TDataModule)
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
  private

  public

  end;

var
  dmDados: TdmDados;

implementation

{$R *.lfm}

end.

