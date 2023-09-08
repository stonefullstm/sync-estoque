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
    ListBox1: TListBox;
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
    ListBox1.Items.Add(person.FindPath('controle').AsString + ', ' + person.FindPath('produto').AsString );
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
  ListBox1.Items.Add(DateTimeToStr(Now));
  dmDados.ZQuery1.Open;
  dmDados.ZQuery1.First;
  pgbProgresso.Max := dmDados.ZQuery1.RecordCount;
  setLength(produtoArray, 2);
  estoqueJson := TJSONArray.Create;
  controle := 0;

  while not dmDados.ZQuery1.EOF do
  begin
    postJson := TJSONObject.Create;
     postJson.Clear;
     postJson.Add('controle', dmDados.ZQuery1.FieldByName('controle').AsInteger);
     postJson.Add('produto', dmDados.ZQuery1.FieldByName('produto').AsString);
     postJson.Add('unidade', dmDados.ZQuery1.FieldByName('unidade').AsString);
     postJson.Add('qtde', dmDados.ZQuery1.FieldByName('qtde').AsFloat);
     postJson.Add('precocusto', dmDados.ZQuery1.FieldByName('precocusto').AsFloat);
     postJson.Add('precovenda', dmDados.ZQuery1.FieldByName('precovenda').AsFloat);
     postJson.Add('grupo', dmDados.ZQuery1.FieldByName('grupo').AsString);
     postJson.Add('fornecedor', dmDados.ZQuery1.FieldByName('fornecedor').AsString);
     postJson.Add('ativo', dmDados.ZQuery1.FieldByName('ativo').AsString);

     estoqueJson.Add(postJson);
     pgbProgresso.Position := controle;
     dmDados.ZQuery1.Next;
  end;
  postJson := TJSONObject.Create;
  postJson.Clear;
  postJson.Add('products', estoqueJson);
  Response := TStringStream.Create('');
  httpClient := TFPHttpClient.Create(Nil);
  httpClient.AddHeader('Content-Type', 'application/json');
  httpClient.AllowRedirect := true;
  httpClient.RequestBody := TStringStream.Create(postJson.AsJSON);
  httpClient.Post(url, Response);
  httpClient.Free;
  ListBox1.Items.Add(Response.DataString);
  ListBox1.Items.Add(DateTimeToStr(Now));
end;

end.

