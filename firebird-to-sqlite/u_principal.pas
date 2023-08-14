unit u_principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, IniFiles;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    btnConverter: TButton;
    Label1: TLabel;
    pgbProgresso: TProgressBar;
    procedure btnConverterClick(Sender: TObject);
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
  dmDados.dbSqlite.Connect;
end;

procedure TfrmPrincipal.btnConverterClick(Sender: TObject);
var
  registros: integer;
begin
  dmDados.zqFEstoque.Open;
  dmDados.zqSEstoque.Open;
  registros := dmDados.zqFEstoque.RecordCount;
  dmDados.zqFEstoque.First;
  pgbProgresso.Position := 0;
  while not dmDados.zqFEstoque.EOF do
  begin
    dmDados.zqSEstoque.Insert;
    dmDados.zqSEstoquecontrole.Value := dmDados.zqFEstoque.FieldByName('controle').Value;
    dmDados.zqSEstoqueproduto.Value := dmDados.zqFEstoque.FieldByName('produto').Value;
    dmDados.zqSEstoqueunidade.Value := dmDados.zqFEstoque.FieldByName('unidade').Value;
    dmDados.zqSEstoqueqtde.Value := dmDados.zqFEstoque.FieldByName('qtde').Value;
    dmDados.zqSEstoque.Post;
    pgbProgresso.Position := pgbProgresso.Position + (100 div registros);
    dmDados.zqFEstoque.Next;
  end;
  dmDados.zqSEstoque.CommitUpdates;
  dmDados.zqSEstoque.Close;
  dmDados.zqFEstoque.Close;
  ShowMessage('Conversão concluída com sucesso');
end;

end.

