unit u_principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, IniFiles;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;
  IniFile: TIniFile;

implementation

uses u_dados;

{$R *.lfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.FormShow(Sender: TObject);
var
  caminhoBanco, caminhoLib: string;
begin
  IniFile := TIniFile.Create('config.ini');
  caminhoBanco := IniFile.ReadString('BANCO', 'BancoDados', '');
  caminhoLib := IniFile.ReadString('LIB', 'Library', '');
  dmDados.dbFirebird.Database := caminhoBanco;
  dmDados.dbFirebird.LibraryLocation := caminhoLib;
  dmDados.dbFirebird.Connect;
end;

end.

