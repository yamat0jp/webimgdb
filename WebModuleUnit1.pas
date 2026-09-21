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
    procedure WebStencilsProcessor2Value(Sender: TObject; const AObjectName,
        APropName: string; var AValue: string; var AHandled: Boolean);
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

uses System.IOUtils, Jpeg, System.Types, System.RegularExpressions;

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
    FDMemTable1.AppendRecord([i,user,nil]);
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
  user, filename, url: string;
  id: integer;
  jpg: TJpegImage;
  stream: TStream;
begin
  datas:=Request.PathInfo.Split(['/']);
  if High(datas) >= 2 then
    user:=datas[2]
  else
    Handled:=false;
  if High(datas) = 3 then
  begin
    filename:=TPath.Combine('.\img',user,datas[3]);
    if not TPath.Exists(filename) then
      Exit;
    stream:=TFileStream.Create(filename,fmOpenRead or fmShareDenyWrite);
    jpg:=TJpegImage.Create;
    try
      jpg.LoadFromStream(stream);
      if Request.QueryFields.Values['thmb'].ToLower = 'yes' then
        jpg.Scale:=jsEighth;
      stream.Position:=0;
      jpg.SaveToStream(stream);
    finally
      jpg.Free;
    end;
    Response.ContentType:='image/jpeg';
    Response.ContentStream:=stream;
  end
  else if TPath.Exists('.\img\'+user) then
  begin
    FDMemTable1.Open;
    datas := TDirectory.GetFiles('.\img\'+user,'*',TSearchOption.soTopDirectoryOnly,
      function(const Path:string;const SearchRec: TSearchRec): Boolean
      begin
        result:=TRegEx.IsMatch(SearchRec.Name,'\.jpe?g$',[roIgnoreCase]);
      end);
    for var i := 0 to High(datas) do
    begin
      url:=Format('/users/%s/%s',[user,TPath.GetFileName(datas[i])]);
      FDMemTable1.AppendRecord([i,user,url]);
    end;
    WebStencilsProcessor2.AddVar('Images',FDMemTable1,false);
    Response.ContentType:='text/html;charset=utf8';
    Response.Content:=WebStencilsProcessor2.Content;
    FDMemTable1.Close;
  end
  else
    Handled:=false;
end;

procedure TWebModule1.WebStencilsProcessor2Value(Sender: TObject; const
    AObjectName, APropName: string; var AValue: string; var AHandled: Boolean);
begin
  if AObjectName = 'Cnt' then
    AValue:=FDMemTable1.RecordCount.ToString;
end;

end.
