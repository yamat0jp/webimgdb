unit WebModuleUnit1;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, Web.Stencils, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TWebModule1 = class(TWebModule)
    WebStencilsEngine1: TWebStencilsEngine;
    WebStencilsProcessor1: TWebStencilsProcessor;
    FDMemTable1: TFDMemTable;
    FDMemTable1Name: TStringField;
    FDMemTable1Index: TIntegerField;
    FDMemTable1filename: TStringField;
    WebStencilsProcessor2: TWebStencilsProcessor;
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1WebActionItem1Action(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses System.IOUtils;

procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  user: string;
  datas: TArray<string>;
begin
  FDMemTable1.Open;
  datas:=TDirectory.GetDirectories('.\img\');
  for var i := 0 to High(datas) do
  begin
    user:=TPath.GetFileName(datas[i]);
    FDMemTable1.AppendRecord([user,i,nil]);
  end;
  WebStencilsProcessor1.AddVar('Users',FDMemTable1,false);
  Response.ContentType:='text/html;charset=utf8';
  Response.Content := WebStencilsProcessor1.Content;
  FDMemTable1.Close;
end;

procedure TWebModule1.WebModule1WebActionItem1Action(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  datas: TArray<string>;
  user, filename: string;
  id: integer;
begin
  datas:=Request.PathInfo.Split(['/']);
  if High(datas) >= 2 then
    user:=datas[2]
  else
    Exit;
  if (High(datas) = 3) and not datas[3].IsEmpty then
  begin
    id:=datas[3].ToInteger;
    datas:=TDirectory.GetFiles('.\img\'+user,'*.jpg');
    if High(datas) < id then
      Exit;
    filename:=datas[id];
    Response.ContentType:='image/jpeg';
    Response.ContentStream:=TFileStream.Create(filename,fmOpenRead or fmShareDenyWrite);
  end
  else if TPath.Exists('.\img\'+user) then
  begin
    FDMemTable1.Open;
    Response.ContentType:='text/html;charset=utf8';
    datas := TDirectory.GetFiles('.\img\'+user);
    for var i := 0 to High(datas) do
      FDMemTable1.AppendRecord([user,i,TPath.GetFileName(datas[i])]);
    WebStencilsProcessor2.AddVar('Images',FDMemTable1,false);
    Response.Content:=WebStencilsProcessor2.Content;
    FDMemTable1.Close;
  end;
end;

end.
