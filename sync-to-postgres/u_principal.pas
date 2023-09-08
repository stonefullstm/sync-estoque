unit u_principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, LCLType, fpjson, jsonparser, fphttpclient, opensslsockets;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    btnConsultar: TButton;
    btnSincronizar: TButton;
    btnLogin: TButton;
    edUserName: TEdit;
    edPassword: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    lblAguarde: TLabel;
    lbxVisualizacao: TListBox;
    pgbProgresso: TProgressBar;
    procedure btnLoginClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnSincronizarClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;
  token: string;
  tokenType: string;

implementation

uses u_dmdados;

{$R *.lfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.btnConsultarClick(Sender: TObject);
const url = 'https://sync-estoque.onrender.com/estoque/';
var
  rawJson: AnsiString;
  people: TJSONArray;
  person: TJSONObject;
  personEnum: TJSONEnum;
  httpClient: TFPHttpClient;
begin
  httpClient := TFPHttpClient.Create(Nil);
  httpClient.AddHeader('Content-Type', 'application/json');
  httpClient.AddHeader('Authorization', tokenType + ' ' + token);
  rawJson := httpClient.Get(url);
  people := TJSONArray(GetJSON(rawJson).FindPath('products'));
  for personEnum in people do begin
    person := TJSONObject(personEnum.Value);
    lbxVisualizacao.Items.Add(person.FindPath('controle').AsString + ', ' + person.FindPath('produto').AsString );
  end;
  httpClient.Free;
end;

procedure TfrmPrincipal.btnLoginClick(Sender: TObject);
//const url = 'https://sync-estoque.onrender.com/user/token';
const url = 'https://sync-estoque.onrender.com/user/login';
var
  postJson: TJSONObject;
  httpClient: TFPHttpClient;
  Response: TStringStream;
  rawJson: AnsiString;
  params: TStrings;
begin
  postJson := TJSONObject.Create;
  {*
  postJson.Clear;
  postJson.Add('username', edUserName.Text);
  postJson.Add('password', edPassword.Text);
  Response := TStringStream.Create('');
  httpClient := TFPHttpClient.Create(Nil);
  httpClient.AddHeader('Content-Type', 'application/json');
  httpClient.RequestBody := TStringStream.Create(postJson.AsJSON);
  *}
  lblAguarde.Visible := True;
  lblAguarde.Repaint;
  Response := TStringStream.Create('');
  httpClient := TFPHttpClient.Create(Nil);
  params := TStringList.Create;
  params.add('username='+edUserName.Text);
  params.add('password='+edPassword.Text);
  //httpClient.AddHeader('Content-Type', 'application/x-www-form-urlencoded');
  try
    try
      //httpClient.Post(url, Response);
      httpClient.FormPost(url, params, Response);
      rawJson := Response.DataString;
      lblAguarde.Visible := False;
      lblAguarde.Repaint;
      if httpClient.ResponseStatusCode = 200 then
      begin
        token := GetJSON(rawJson).FindPath('access_token').AsString;
        tokenType := GetJSON(rawJson).FindPath('token_type').AsString;
        btnConsultar.Enabled := True;
        btnSincronizar.Enabled := True;
      end
      else
        MessageDlg('Informação', 'Usuário ou senha inválidos', mtInformation, [mbOk], 0);
    except on E: Exception do
      MessageDlg('Erro', E.Message, mtInformation, [mbOk], 0);
    end;
  finally
     httpClient.RequestBody.Free;
     httpClient.Free;
     Response.Free;
  end;
end;

procedure TfrmPrincipal.btnSincronizarClick(Sender: TObject);
const url = 'https://sync-estoque.onrender.com/estoque/lista';
var
  postJson: TJSONObject;
  estoqueJson: TJSONArray;
  produtoArray: array of TJSONObject;
  responseData: String;
  httpClient: TFPHttpClient;
  controle: integer;
  tamanho: integer;
  Response: TStringStream;
begin
  dmDados.queEstoque.Open;
  dmDados.queEstoque.First;
  pgbProgresso.Max := dmDados.queEstoque.RecordCount;
  setLength(produtoArray, 2);
  estoqueJson := TJSONArray.Create;
  controle := 0;

  while not dmDados.queEstoque.EOF do
  begin
    postJson := TJSONObject.Create;
     postJson.Clear;
     postJson.Add('controle', dmDados.queEstoque.FieldByName('controle').AsInteger);
     postJson.Add('produto', dmDados.queEstoque.FieldByName('produto').AsString);
     postJson.Add('unidade', dmDados.queEstoque.FieldByName('unidade').AsString);
     postJson.Add('qtde', dmDados.queEstoque.FieldByName('qtde').AsFloat);
     postJson.Add('precocusto', dmDados.queEstoque.FieldByName('precocusto').AsFloat);
     postJson.Add('precovenda', dmDados.queEstoque.FieldByName('precovenda').AsFloat);
     postJson.Add('grupo', dmDados.queEstoque.FieldByName('grupo').AsString);
     postJson.Add('fornecedor', dmDados.queEstoque.FieldByName('fornecedor').AsString);
     postJson.Add('ativo', dmDados.queEstoque.FieldByName('ativo').AsString);

     estoqueJson.Add(postJson);
     pgbProgresso.Position := controle;
     pgbProgresso.Repaint;
     dmDados.queEstoque.Next;
  end;
  postJson := TJSONObject.Create;
  postJson.Clear;
  postJson.Add('products', estoqueJson);
  Response := TStringStream.Create('');
  httpClient := TFPHttpClient.Create(Nil);
  httpClient.AddHeader('Content-Type', 'application/json');
  httpClient.AddHeader('Authorization', tokenType + ' ' + token);
  httpClient.AllowRedirect := true;
  httpClient.RequestBody := TStringStream.Create(postJson.AsJSON);
  httpClient.Post(url, Response);
  httpClient.Free;
  if httpClient.ResponseStatusCode = 200 then
     MessageDlg('Informação', 'Sincronização concluída com sucesso', mtInformation, [mbOk], 0)
  else
     MessageDlg('Informação', 'Algo saiu errado', mtInformation, [mbOk], 0);
end;

end.

