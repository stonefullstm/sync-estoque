unit u_principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, fpjson, jsonparser, fphttpclient, opensslsockets;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    Button1: TButton;
    Button2: TButton;
    btnLogin: TButton;
    edUserName: TEdit;
    edPassword: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    pgbProgresso: TProgressBar;
    procedure btnLoginClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;
  token: string;

implementation

uses u_dmdados;

{$R *.lfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.Button1Click(Sender: TObject);
const url = 'https://sync-estoque.onrender.com/estoque/';
var
  rawJson: AnsiString;
  people: TJSONArray;
  person: TJSONObject;
  personEnum: TJSONEnum;
begin
  // Get the JSON data
  rawJson := TFPHTTPClient.SimpleGet(url);
  // Convert to TJSONData and cast as TJSONArray
  people := TJSONArray(GetJSON(rawJson).FindPath('products'));
  // Loop using the TJSONEnumerator
  for personEnum in people do begin
    // Cast the enum value to person
    person := TJSONObject(personEnum.Value);
    // Output a few pieces of data as example.
    ListBox1.Items.Add(person.FindPath('controle').AsString + ', ' + person.FindPath('produto').AsString );
    // WriteLn(person.FindPath('name').AsString);
    //WriteLn(person.FindPath('id').AsString);
    //WriteLn(person.FindPath('address.street').AsString);
    //WriteLn(person.FindPath('company.name').AsString);
    //WriteLn('');
  end;
end;

procedure TfrmPrincipal.btnLoginClick(Sender: TObject);
const url = 'https://sync-estoque.onrender.com/user/login';
var
  postJson: TJSONObject;
  httpClient: TFPHttpClient;
  Response: TStringStream;
begin
  postJson := TJSONObject.Create;
  postJson.Clear;
  postJson.Add('username', edUserName.Text);
  postJson.Add('password', edPassword.Text);
  Response := TStringStream.Create('');
  httpClient := TFPHttpClient.Create(Nil);
  httpClient.AddHeader('Content-Type', 'application/x-www-form-urlencoded');
  //httpClient.AllowRedirect := true;
  httpClient.RequestBody := TStringStream.Create(postJson.AsJSON);
  ListBox1.Items.Add(postJson.AsJSON);

  httpClient.FormPost(url, Response);
  httpClient.Free;
  ListBox1.Items.Add(Response.DataString);
end;

procedure TfrmPrincipal.Button2Click(Sender: TObject);
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
  //postJson := TJSONObject.Create;
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

     //httpClient := TFPHttpClient.Create(Nil);
     //With httpClient do
     //begin
     //    RequestBody := TStringStream.Create(postJson.AsJSON);
     //    responseData := Post(url);
         //httpClient.Free;
     //end;
     //ListBox1.Items.Add(dmDados.SQLQuery1.FieldByName('produto').AsString);
     controle := controle + 1;
     //produtoArray[controle] := postJson;
     //if controle = 10 then break;
     estoqueJson.Add(postJson);
     pgbProgresso.Position := controle;
     dmDados.ZQuery1.Next;
  end;
  postJson := TJSONObject.Create;
  postJson.Clear;
  postJson.Add('products', estoqueJson);
  //ListBox1.Items.Add(postJson.AsJSON);
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

